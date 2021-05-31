package logic.modules
{
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import global.Rand;
    import global.Util;

    import logic.graph.QuadTree;

    public class PointsModule extends Module
    {
        // Options
        public var spacing:int;
        public var precision:int;

        public function PointsModule()
        {
            super();

            spacing = 10;
            precision = 20;

            model.points = new Vector.<Point>();
            model.quad = new QuadTree(model.bounds);
        }

        override public function run():void
        {
            trace("PointsModule:run");

            makePoints();
            model.makeGraphFromPoints();
        }

        private function makePoints():void
        {
            trace("PointsModule:makePoints");

            var rand:Rand = new Rand(Util.stringToSeed(model.pointsSeed));

            // The active point queue
            var queue:Vector.<Point> = new Vector.<Point>();

            var point:Point = new Point(int(model.bounds.width / 2),
                    int(model.bounds.height / 2));

            var doubleSpacing:Number = spacing * 2;
            var doublePI:Number = 2 * Math.PI;

            var box:Rectangle = new Rectangle(0,
                    0,
                    2 * spacing,
                    2 * spacing);

            // Make border points
            var gap:int = spacing;
            for (var i:int = gap; i < model.bounds.width; i += 2 * gap)
            {
                model.addPoint(new Point(i, gap));
                model.addPoint(new Point(i, model.bounds.height - gap));
            }

            for (i = 2 * gap; i < model.bounds.height - gap; i += 2 * gap)
            {
                model.addPoint(new Point(gap, i));
                model.addPoint(new Point(model.bounds.width - gap, i));
            }

            // Initial point
            model.addPoint(point);
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
                    if (model.quad.isRangePopulated(box))
                    {
                        candidate = null;
                    } else
                    {
                        // Valid candidate
                        if (!model.bounds.contains(candidate.x, candidate.y))
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
                    model.addPoint(candidate);
                    queue.push(candidate);
                } else
                {
                    // Remove the first point in queue
                    queue.shift();
                }
            }
        }
    }
}