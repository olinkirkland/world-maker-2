package logic.graph
{
    import flash.geom.Point;

    import global.Util;

    import logic.graph.Corner;

    import logic.modules.TectonicPlate;

    public class Cell
    {
        public var index:int;
        public var used:Boolean;

        // Graph
        public var point:Point;
        public var neighbors:Vector.<Cell>;
        public var edges:Vector.<Edge>;
        public var corners:Vector.<Corner>;
        public var area:Number;
        public var isBorder:Boolean;

        public var tectonicPlate:TectonicPlate;
        public var tectonicStrength:Number;
        public var isTectonicPlateBorder:Boolean;

        public function Cell()
        {
            neighbors = new Vector.<Cell>();
            edges = new Vector.<Edge>();
            corners = new Vector.<Corner>();
        }

        public function calculateArea():void
        {
            area = 0;
            for each (var edge:Edge in edges)
            {
                var triangleArea:Number = 0;
                if (edge.v0 && edge.v1)
                {
                    var a:Number = Point.distance(edge.v0.point, point);
                    var b:Number = Point.distance(point, edge.v1.point);
                    var c:Number = Point.distance(edge.v1.point, edge.v0.point);

                    // Use Heron's Formula to determine the triangle's area
                    var p:Number = (a + b + c) / 2;
                    triangleArea = Math.sqrt(p * (p - a) * (p - b) * (p - c));
                }
                area += triangleArea;
            }

            area = Number(area.toFixed(2));
        }

        public function defineBorder():void
        {
            isBorder = false;

            var arr:Array = [];
            for each (var edge:Edge in edges)
            {
                checkPoint(edge.v0.point);
                checkPoint(edge.v1.point);
            }

            if (arr.length > 0)
                isBorder = true;

            function checkPoint(p:Point):void
            {
                if (arr.indexOf(p) >= 0)
                    arr.removeAt(arr.indexOf(p));
                else
                    arr.push(p);
            }
        }

        public function sharedEdge(neighbor:Cell):Edge
        {
            for each (var edge:Edge in edges)
                if (edge.d0 == neighbor || edge.d1 == neighbor)
                    return edge;

            return null;
        }
    }
}
