package events
{
    public class MapEvent extends PayloadEvent
    {
        public static const MAP_MOVED:String = "mapMoved";
        public static const MOUSE_MOVE:String = "mapMoved";
        public static const MAP_ZOOM:String = "mapZoomIn";
        public static const MAP_CENTER:String = "mapCenter";
        public static const PICK_CELL:String = "pickCell";

        public function MapEvent(type:String, payload:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, payload, bubbles, cancelable);
        }
    }
}
