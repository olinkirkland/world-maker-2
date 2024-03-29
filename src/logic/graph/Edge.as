package logic.graph
{
    import flash.geom.Point;

    public class Edge
    {
        public var index:int;

        // The polygons connected by the Delaunay edge
        public var d0:Cell, d1:Cell;

        // The corners connected by the Voronoi edge
        public var v0:Corner, v1:Corner;

        // Halfway between v0 and v1
        public var midpoint:Point;
    }
}
