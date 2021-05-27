package logic
{
    import events.PayloadEvent;

    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    import global.Local;
    import global.Signal;
    import global.Util;

    import logic.graph.Cell;
    import logic.graph.Corner;
    import logic.graph.Edge;
    import logic.graph.QuadTree;
    import logic.modules.Module;
    import logic.tasks.Task;

    import managers.TaskManager;

    import nodename.delaunay.Voronoi;
    import nodename.geom.*;

    import ui.PopupManager;
    import ui.popups.BusyPopup;

    public class Model
    {
        private static var _instance:Model;

        public var loaded:Boolean = false;
        public var callbackSave:Function = standaloneSave;
        public var isValid:Boolean;

        // Singletons
        private var signal:Signal;
        private var taskManager:TaskManager;

        // Map
        public var bounds:Rectangle;

        // Graph
        public var cells:Vector.<Cell>;

        public var corners:Vector.<Corner>;
        public var edges:Vector.<Edge>;

        // Cell Picker
        public var isPickingCell:Boolean = false;
        public var callbackPickCell:Function;

        // Point Mapping
        public var pointsSeed:String;
        public var points:Vector.<Point>;
        public var cellsByPoints:Object;
        public var quad:QuadTree;

        public function Model()
        {
            if (_instance)
                throw new Error("Singletons can only have one instance");
            _instance = this;

            signal = Signal.instance;
            taskManager = TaskManager.instance;

            // General use
            bounds = new Rectangle(0,
                    0,
                    2000,
                    1000);

            addEventListeners();
        }

        private function addEventListeners():void
        {
            signal.addEventListener(PayloadEvent.PICK_CELL_START, onStartPickCellMode);
            signal.addEventListener(PayloadEvent.MAP_CLICK, onMapClick);
        }

        private function onStartPickCellMode(event:PayloadEvent):void
        {
            isPickingCell = true;
            callbackPickCell = event.payload;
        }

        private function onMapClick(event:PayloadEvent):void
        {
            if (isPickingCell)
            {
                var p:Point = event.payload as Point;
                p = getClosestPoint(p);
                if (!p)
                    return;
                var cell:Cell = getCellByPoint(p);
                callbackPickCell.apply(this, [cell]);

                isPickingCell = false;
                signal.dispatchEvent(new PayloadEvent(PayloadEvent.PICK_CELL_END));
            }
        }

        public function getClosestPoint(p:Point):Point
        {
            if (!quad)
                return null;

            // Only return a point within a small radius
            var arr:Vector.<Point> = quad.queryFromPoint(p, 10);
            if (arr.length == 0)
                return null;
            if (arr.length == 1)
                return arr[0];

            var closest:Point = arr[0];
            var distance:Number = Number.POSITIVE_INFINITY;
            for each (var q:Point in arr)
            {
                var d:Number = Point.distance(p, q);
                if (d < distance)
                {
                    closest = q;
                    distance = d;
                }
            }

            return closest;
        }

        public function invalidate():void
        {
            // Invalidate current model
            // If a model is invalidated, the model must rebuild the current task
            // before progressing to the next task

            isValid = false;
            signal.dispatchEvent(new PayloadEvent(PayloadEvent.VALIDITY_CHANGED));
        }

        public function build():void
        {
            // Builds the current task
            var task:Task = TaskManager.instance.currentTask;
            if (task.module)
            {
                var module:Module = new task.module;
                var p:BusyPopup = new BusyPopup();
                p.text = Local.text('building');
                p.calculation = module.run;
                p.callbackComplete = onBuildComplete;
                PopupManager.open(p);
            } else
            {
                trace("Task " + task.name + " has no assigned module");
                isValid = true;
                signal.dispatchEvent(new PayloadEvent(PayloadEvent.VALIDITY_CHANGED));
            }
        }

        private function onBuildComplete():void
        {
            isValid = true;
            signal.dispatchEvent(new PayloadEvent(PayloadEvent.VALIDITY_CHANGED));
            signal.dispatchEvent(new PayloadEvent(PayloadEvent.DRAW));
        }

        public function loadPoints(arr:Array):void
        {
            trace("Model:loadPoints");
            points = new Vector.<Point>();
            quad = new QuadTree(bounds);

            for each (var u:Object in arr)
                addPoint(new Point(u.x, u.y));

            trace("...loaded " + points.length + " points");

            makeGraphFromPoints();
        }

        public function makeGraphFromPoints():void
        {
            trace("Model:makeGraphFromPoints");

            var voronoi:Voronoi = new Voronoi(points, bounds);

            cells = new Vector.<Cell>();
            corners = new Vector.<Corner>();
            edges = new Vector.<Edge>();

            // Make cell dictionary
            var cellsDictionary:Dictionary = new Dictionary();
            for each (var point:Point in points)
            {
                var cell:Cell = new Cell();
                cell.index = cells.length;
                cell.point = point;
                cells.push(cell);
                cellsDictionary[point] = cell;
            }

            for each (cell in cells)
                voronoi.region(cell.point);

            /**
             * Associative Mapping
             */

            cellsByPoints = {};
            for each (cell in cells)
                cellsByPoints[JSON.stringify(cell.point)] = cell;

            /**
             * Corners
             */

            var _cornerMap:Array = [];

            function makeCorner(point:Point):Corner
            {
                if (!point)
                {
                    return null;
                }
                for (var bucket:int = point.x - 1; bucket <= point.x + 1; bucket++)
                {
                    for each (var corner:Corner in _cornerMap[bucket])
                    {
                        var dx:Number = point.x - corner.point.x;
                        var dy:Number = point.y - corner.point.y;
                        if (dx * dx + dy * dy < 1e-6)
                        {
                            return corner;
                        }
                    }
                }

                bucket = int(point.x);

                if (!_cornerMap[bucket])
                {
                    _cornerMap[bucket] = [];
                }

                corner = new Corner();
                corner.index = corners.length;
                corners.push(corner);

                corner.point = point;
                corner.border = (point.x == 0 || point.x == bounds.width || point.y == 0 || point.y == bounds.height);

                _cornerMap[bucket].push(corner);
                return corner;
            }

            /**
             * Edges
             */

            var libEdges:Vector.<nodename.delaunay.Edge> = voronoi.edges();
            for each (var libEdge:nodename.delaunay.Edge in libEdges)
            {
                var dEdge:Segment = libEdge.delaunayLine();
                var vEdge:Segment = libEdge.voronoiEdge();

                var edge:Edge = new Edge();
                edge.index = edges.length;
                edges.push(edge);
                edge.midpoint = vEdge.p0 && vEdge.p1 && Point.interpolate(vEdge.p0,
                        vEdge.p1,
                        0.5);

                edge.v0 = makeCorner(vEdge.p0);
                edge.v1 = makeCorner(vEdge.p1);
                edge.d0 = cellsDictionary[dEdge.p0];
                edge.d1 = cellsDictionary[dEdge.p1];

                setupEdge(edge);
            }

            for each (cell in cells)
                cell.calculateArea();
        }

        private function setupEdge(edge:Edge):void
        {
            if (edge.d0 != null)
                edge.d0.edges.push(edge);

            if (edge.d1 != null)
                edge.d1.edges.push(edge);

            if (edge.v0 != null)
                edge.v0.protrudes.push(edge);

            if (edge.v1 != null)
                edge.v1.protrudes.push(edge);

            if (edge.d0 != null && edge.d1 != null)
            {
                addToCellList(edge.d0.neighbors,
                        edge.d1);
                addToCellList(edge.d1.neighbors,
                        edge.d0);
            }

            if (edge.v0 != null && edge.v1 != null)
            {
                addToCornerList(edge.v0.adjacent,
                        edge.v1);
                addToCornerList(edge.v1.adjacent,
                        edge.v0);
            }

            if (edge.d0 != null)
            {
                addToCornerList(edge.d0.corners,
                        edge.v0);
                addToCornerList(edge.d0.corners,
                        edge.v1);
            }

            if (edge.d1 != null)
            {
                addToCornerList(edge.d1.corners,
                        edge.v0);
                addToCornerList(edge.d1.corners,
                        edge.v1);
            }

            if (edge.v0 != null)
            {
                addToCellList(edge.v0.touches,
                        edge.d0);
                addToCellList(edge.v0.touches,
                        edge.d1);
            }

            if (edge.v1 != null)
            {
                addToCellList(edge.v1.touches,
                        edge.d0);
                addToCellList(edge.v1.touches,
                        edge.d1);
            }

            function addToCornerList(v:Vector.<Corner>,
                                     x:Corner):void
            {
                if (x != null && v.indexOf(x) < 0)
                {
                    v.push(x);
                }
            }

            function addToCellList(v:Vector.<Cell>,
                                   x:Cell):void
            {
                if (x != null && v.indexOf(x) < 0)
                {
                    v.push(x);
                }
            }
        }

        public function addPoint(p:Point):void
        {
            p.x = Util.fixed(p.x, 2);
            p.y = Util.fixed(p.y, 2);

            points.push(p);
            quad.insert(p);
        }

        public function save(u:Object = null):void
        {
            if (callbackSave != null)
                callbackSave.apply(null, [u != null ? u : serialize()]);
        }

        private static function standaloneSave(u:Object):void
        {
            Util.log("Model: save (standalone)");

            var fileStream:FileStream = new FileStream();
            fileStream.open(File.applicationStorageDirectory.resolvePath("localSave.json"), FileMode.WRITE);
            fileStream.writeUTFBytes(JSON.stringify(u));
            fileStream.close();
        }

        public function load(u:Object):void
        {
            deserialize(u);
        }

        public function standaloneLoad():void
        {
            Util.log("Model: load (standalone)");

            // Only triggered in standalone mode
            var file:File = File.applicationStorageDirectory.resolvePath("localSave.json");
            if (!file.exists)
            {
                deserialize({});
                save();
                return;
            }

            var fileStream:FileStream = new FileStream();
            fileStream.open(file, FileMode.READ);
            var json:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
            fileStream.close();

            deserialize(JSON.parse(json));
        }

        public function serialize():Object
        {
            Util.log("Model: serialize");

            var u:Object = {};
            u.currentTaskId = taskManager.currentTask.id;
            u.points = points;

            return u;
        }

        public function deserialize(u:Object):void
        {
            Util.log("Model: deserialize");

            if (u.points)
                loadPoints(u.points);

            if (u.currentTaskId)
                TaskManager.instance.setCurrentTaskById(u.currentTaskId);
            else
                signal.dispatchEvent(new PayloadEvent(PayloadEvent.TASK_CHANGED));

            loaded = true;
        }

        public function getCellByPoint(p:Point):Cell
        {
            return cellsByPoints[JSON.stringify(p)];
        }

        public static function get instance():Model
        {
            if (!_instance)
                new Model();
            return _instance;
        }
    }
}
