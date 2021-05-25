package logic.modules
{
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import global.Rand;

    import global.Util;

    import logic.graph.Cell;
    import logic.graph.Corner;
    import logic.graph.QuadTree;
    import logic.graph.Edge;

    public class PointsModule extends Module
    {
        // Options
        public var seed:String;
        public var spacing:int;
        public var precision:int;
        public var bounds:Rectangle;

        // Graph
        public var points:Vector.<Point>;
        public var cells:Vector.<Cell>;
        public var corners:Vector.<Corner>;
        public var edges:Vector.<Edge>;

        // Point Mapping
        public var cellsByPoints:Object;
        private var quad:QuadTree;

        public function PointsModule()
        {
            spacing = 15;
            precision = 5;
            bounds = new Rectangle(0,
                    0,
                    2000,
                    1000);

            points = new Vector.<Point>();
            quad = new QuadTree(bounds);
        }

        override public function run():void
        {
            trace("PointsModule:run");

            makePoints();
        }

        private function makePoints():void
        {
            trace("PointsModule:makePoints");

            var rand:Rand = new Rand(Util.stringToSeed(seed));

            // The active point queue
            var queue:Vector.<Point> = new Vector.<Point>();

            var point:Point = new Point(int(bounds.width / 2),
                    int(bounds.height / 2));

            var doubleSpacing:Number = spacing * 2;
            var doublePI:Number = 2 * Math.PI;

            var box:Rectangle = new Rectangle(0,
                    0,
                    2 * spacing,
                    2 * spacing);

            // Make border points
            var gap:int = spacing;
            for (var i:int = gap; i < bounds.width; i += 2 * gap)
            {
                addPoint(new Point(i, gap));
                addPoint(new Point(i, bounds.height - gap));
            }

            for (i = 2 * gap; i < bounds.height - gap; i += 2 * gap)
            {
                addPoint(new Point(gap, i));
                addPoint(new Point(bounds.width - gap, i));
            }

            // Initial point
            addPoint(point);
            queue.push(point);

            var candidate:Point = null;
            var angle:Number;
            var distance:int;

            while (queue.length > 0)
            {
                point = queue[0];

                for (i = 0; i < precision; i++)
                {
                    angle = rand.next() * doublePI;
                    distance = rand.between(spacing, doubleSpacing);

                    candidate = new Point(point.x + distance * Math.cos(angle),
                            point.y + distance * Math.sin(angle));

                    // Check point distance to nearby points
                    box.x = candidate.x - spacing;
                    box.y = candidate.y - spacing;
                    if (quad.isRangePopulated(box))
                    {
                        candidate = null;
                    } else
                    {
                        // Valid candidate
                        if (!bounds.contains(candidate.x, candidate.y))
                        {
                            // Candidate is outside the area, so don't include it
                            candidate = null;
                            continue;
                        }
                        break;
                    }
                }

                if (candidate)
                {
                    addPoint(candidate);
                    queue.push(candidate);
                } else
                {
                    // Remove the first point in queue
                    queue.shift();
                }
            }
        }

        public function loadPoints(arr:Array):void
        {
            trace("PointsModule:loadPoints");
            bounds = new Rectangle(0,
                    0,
                    2000,
                    1000);

            points = new Vector.<Point>();
            quad = new QuadTree(bounds);

            trace("Adding " + arr.length + " points");

            for each (var u:Object in arr)
                addPoint(new Point(u.x, u.y));
        }

        public function addPoint(p:Point):void
        {
            p.x = Util.fixed(p.x, 2);
            p.y = Util.fixed(p.y, 2);

            points.push(p);
            quad.insert(p);
        }

        public function applyRandomSeed():void
        {
            seed = Util.randomSeed();
        }
    }
}