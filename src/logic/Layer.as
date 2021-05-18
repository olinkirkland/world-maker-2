package logic
{
    public class Layer
    {
        public static const POINTS:String = "points";
        public static const VORONOI:String = "voronoi";
        public static const DELAUNAY:String = "delaunay";
        public static const TECTONIC_PLATES:String = "tectonicPlates";

        public var id:String;
        public var visible:Boolean = true;
        public var allowed:Boolean;
    }
}
