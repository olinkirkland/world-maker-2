package logic.modules
{
    import flash.geom.Point;
    import flash.utils.Dictionary;

    import global.Color;
    import global.Rand;
    import global.Util;

    import logic.graph.Cell;

    import mx.utils.UIDUtil;

    import ui.Map;

    public class TectonicsModule extends Module
    {
        public function TectonicsModule()
        {
            super();
        }

        override public function canRun():Boolean
        {
            for each (var tectonicPlate:TectonicPlate in model.tectonicPlates)
                if (!tectonicPlate.origin)
                    return false;
            return true;
        }

        public static function quickStart():void
        {
            // Remove all tectonic plates
            while (model.tectonicPlates.length > 0)
                removePlate(model.tectonicPlates[0]);

            var plate:TectonicPlate;
            var p:Point;

            // West/East Oceans
            for (var i:int = 0; i < 3; i++)
            {
                plate = addPlate();
                p = new Point(Map.mapWidth * .05, Map.mapHeight * (i + 1) / 4);
                plate.origin = model.getCellByPoint(model.getClosestPoint(p));
                plate.type = TectonicPlate.DEEP;

                plate = addPlate();
                p = new Point(Map.mapWidth * .95, Map.mapHeight * (i + 1) / 4);
                plate.origin = model.getCellByPoint(model.getClosestPoint(p));
                plate.type = TectonicPlate.DEEP;
            }

            // North/South Oceans
            plate = addPlate();
            p = new Point(Map.mapWidth * (1 / 3), Map.mapHeight * .95);
            plate.origin = model.getCellByPoint(model.getClosestPoint(p));
            plate.type = TectonicPlate.DEEP;

            plate = addPlate();
            p = new Point(Map.mapWidth * (2 / 3), Map.mapHeight * .95);
            plate.origin = model.getCellByPoint(model.getClosestPoint(p));
            plate.type = TectonicPlate.DEEP;

            plate = addPlate();
            p = new Point(Map.mapWidth * (1 / 3), Map.mapHeight * .05);
            plate.origin = model.getCellByPoint(model.getClosestPoint(p));
            plate.type = TectonicPlate.DEEP;

            plate = addPlate();
            p = new Point(Map.mapWidth * (2 / 3), Map.mapHeight * .05);
            plate.origin = model.getCellByPoint(model.getClosestPoint(p));
            plate.type = TectonicPlate.DEEP;

            var rand:Rand = new Rand(Math.random() * 99);
            var plateCount:int = 12;
            for (i = 0; i < plateCount; i++)
            {
                plate = addPlate();
                var cell:Cell = null;
                while (!cell)
                {
                    p = new Point(rand.between(Map.mapWidth * .1, Map.mapWidth * .9),
                            rand.between(Map.mapHeight * .3, Map.mapHeight * .7));
                    cell = model.getCellByPoint(model.getClosestPoint(p));
                }

                plate.origin = cell;
                plate.strength = 0.8;
            }

            var directions:Array = [0, 45, 90, 135, 180, 225, 270, 315];
            for each (plate in model.tectonicPlates)
                plate.direction = directions[int(Math.random() * directions.length)];

            model.tectonicPlates.refresh();
            model.build();
        }

        override protected function calculate():void
        {
            trace("TectonicsModule:calculate");

            // Set initial cell values
            for each (var cell:Cell in model.cells)
            {
                cell.tectonicPlate = null;
                cell.tectonicStrength = 0;
            }

            // Setup the plate origins for use
            for each (var plate:TectonicPlate in model.tectonicPlates)
            {
                plate.cells = [];
                plate.addCell(plate.origin);
                plate.origin.tectonicStrength = plate.strength;
            }

            expandPlates();
            assignCellsWithoutPlates();
            removeFragments();
            determineBorders();
        }

        private function assignCellsWithoutPlates():void
        {
            // Some plates may not have cells assigned to them, so assign the plate that they touch the most
            while (getCellsWithoutPlates().length > 0)
                for each (var cell:Cell in getCellsWithoutPlates())
                    assignCellToNearbyPlates(cell);
        }

        private function getCellsWithoutPlates():Array
        {
            var arr:Array = [];
            for each (var cell:Cell in model.cells)
                if (!cell.tectonicPlate)
                    arr.push(cell);

            return arr;
        }

        private function assignCellToNearbyPlates(cell:Cell):void
        {
            // todo
            // Assign this cell to the tectonic plate found in the highest number of neighbors

            // Current (replace with todo)
            // Assign this cell to the tectonic plate found in the first neighbor with a plate
            for each (var neighbor:Cell in cell.neighbors)
                if (neighbor.tectonicPlate)
                {
                    cell.tectonicPlate = neighbor.tectonicPlate;
                    return;
                }
        }

        private function expandPlates():void
        {
            for each (var tectonicPlate:TectonicPlate in model.tectonicPlates)
            {
                // Do each plate at a time
                model.unuseCells();

                var queue:Vector.<Cell> = new Vector.<Cell>();

                // There's only one cell in here right now
                if (tectonicPlate.cells.length > 0)
                    queue.push(tectonicPlate.cells[0]);

                // Flood fill
                var rand:Rand = new Rand(Util.stringToSeed(model.seed));
                while (queue.length > 0)
                {
                    var cell:Cell = queue.shift();
                    for each (var neighbor:Cell in cell.neighbors)
                    {
                        if (!neighbor.used && neighbor.tectonicPlate != cell.tectonicPlate && neighbor.tectonicStrength < cell.tectonicStrength)
                        {
                            neighbor.tectonicStrength = cell.tectonicStrength - (rand.next() < model.tectonicJitter ? rand.next() * .1 : .05);
                            if (neighbor.tectonicPlate)
                                neighbor.tectonicPlate.removeCell(neighbor);

                            tectonicPlate.addCell(neighbor);
                            queue.push(neighbor);
                            neighbor.used = true;
                        }
                    }
                }
            }
        }

        private function removeFragments():void
        {
            // Fragments are Cells that are not connected to the largest plate body with the same index
            // Ensure there are no tectonic plate fragments
            var rand:Rand = new Rand(Util.stringToSeed(model.seed));
            var pass:int = 0;
            do
            {
                var fragments:Vector.<Cell> = getPlateFragments();
                for (var i:int = 0; i < fragments.length; i++)
                {
                    var cell:Cell = fragments[i];
                    var neighbors:Vector.<Cell> = cell.neighbors.concat();
                    while (neighbors.length > 0)
                    {
                        var neighbor:Cell = Cell(neighbors.removeAt(int(rand.next() * neighbors.length)));
                        if (cell.tectonicPlate != neighbor.tectonicPlate)
                        {
                            cell.tectonicPlate.removeCell(cell);
                            neighbor.tectonicPlate.addCell(cell);
                            fragments.removeAt(i--);
                            break;
                        }
                    }
                }

                pass++;
            } while (getPlateFragments().length > 0 && pass < 10);
        }

        private function getPlateFragments():Vector.<Cell>
        {
            // Determine plate bodies
            model.unuseCells();
            var bodies:Array = [];
            var queue:Vector.<Cell> = new Vector.<Cell>();
            var cell:Cell = model.cells[0];
            cell.used = true;
            queue.push(model.cells[0]);
            var currentTectonicPlate:TectonicPlate = cell.tectonicPlate;
            var currentBody:Vector.<Cell> = new Vector.<Cell>();

            while (queue.length > 0)
            {
                cell = queue.shift();
                currentBody.push(cell);

                for each (var neighbor:Cell in cell.neighbors)
                {
                    if (!neighbor.used && neighbor.tectonicPlate == cell.tectonicPlate)
                    {
                        neighbor.used = true;
                        queue.push(neighbor);
                    }
                }

                if (queue.length == 0)
                {
                    // Empty
                    bodies.push(currentBody);
                    currentBody = new Vector.<Cell>();
                    cell = model.getNextUnusedCell();
                    if (cell)
                    {
                        currentTectonicPlate = cell.tectonicPlate;
                        queue.push(cell);
                        cell.used = true;
                    }
                }
            }

            // Determine the fragments by identifying the smallest bodies with a corresponding body belonging to the same tectonic plate
            var fragments:Vector.<Cell> = new Vector.<Cell>();
            var bodiesDictionary:Dictionary = new Dictionary();
            for each (var body:Vector.<Cell> in bodies)
            {
                var t:TectonicPlate = Cell(body[0]).tectonicPlate;

                // Largest body is the largest body of that tectonic plate
                if (!bodiesDictionary[t])
                {
                    bodiesDictionary[t] = body;
                } else
                {
                    var bodyInDictionary:Vector.<Cell> = bodiesDictionary[t];
                    if (body.length > bodyInDictionary.length)
                    {
                        fragments = fragments.concat(bodyInDictionary);
                        bodiesDictionary[t] = body;
                    } else
                    {
                        fragments = fragments.concat(body);
                    }
                }
            }

            return fragments;
        }

        private function determineBorders():void
        {
            // For each cell, if it has a neighbor with a different plate, consider it a border cell
            for each (var cell:Cell in model.cells)
            {
                cell.isTectonicPlateBorder = false;
                for each (var neighbor:Cell in cell.neighbors)
                    if (cell.tectonicPlate != neighbor.tectonicPlate)
                        cell.isTectonicPlateBorder = true;
            }
        }

        public static function addPlate():TectonicPlate
        {
            var t:TectonicPlate = new TectonicPlate();
            t.id = UIDUtil.createUID();
            var color:uint;
            var i:int = 0;
            do
            {
                color = Color.lighten(Color.randomColorFromPalette().color);
                i++;
            } while (i < 3 && colorIsUsed(color))

            t.color = color;
            t.strength = 1.2;
            model.tectonicPlates.addItemAt(t, 0);
            model.tectonicPlates.itemUpdated(t);
            return t;
        }

        private static function colorIsUsed(color:uint):Boolean
        {
            for each (var t:TectonicPlate in model.tectonicPlates)
                if (t.color == color)
                    return true;

            return false;
        }

        public static function removePlate(plate:TectonicPlate):void
        {
            model.tectonicPlates.removeItem(plate);
            model.tectonicPlates.itemUpdated(plate);
        }

        public static function loadPlate(u:Object):void
        {
            var t:TectonicPlate = new TectonicPlate();
            t.id = u.id;
            t.origin = u.originIndex >= 0 ? model.cells[u.originIndex] : null;
            t.color = u.color;
            t.strength = u.strength;
            t.direction = u.direction;
            t.type = u.type;
            model.tectonicPlates.addItem(t);
            model.tectonicPlates.itemUpdated(t);
        }
    }
}
