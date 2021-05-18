package events
{
    public class UIEvent extends PayloadEvent
    {
        public static const ZOOM_IN:String = "zoomIn";
        public static const ZOOM_OUT:String = "zoomOut";
        public static const MOVE_MAP_TO_CENTER:String = "moveMapToCenter";

        public function UIEvent(type:String, payload:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, payload, bubbles, cancelable);
        }
    }
}
