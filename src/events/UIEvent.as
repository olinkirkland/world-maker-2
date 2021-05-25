package events
{
    public class UIEvent extends PayloadEvent
    {
        // Map
        public static const ZOOM_IN:String = "zoomIn";
        public static const ZOOM_OUT:String = "zoomOut";
        public static const MOVE_MAP_TO_CENTER:String = "moveMapToCenter";

        // UI
        public static const INITIALIZE:String = "initialize";
        public static const OPEN_PANE:String = "openPane";
        public static const CLOSE_PANE:String = "closePane";
        
        public function UIEvent(type:String, payload:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, payload, bubbles, cancelable);
        }
    }
}
