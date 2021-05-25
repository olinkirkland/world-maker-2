package events
{
    import flash.events.Event;

    public class AppEvent extends Event
    {
        // Events the Map listens for
        public static const ZOOM_IN:String = "zoomIn"; // Tells the map to zoom in
        public static const ZOOM_OUT:String = "zoomOut"; // Tells the map to zoom out
        public static const MOVE_MAP_TO_CENTER:String = "moveMapToCenter"; // Tells the map to center itself
        public static const DRAW:String = "draw"; // Tells the map to perform a draw call
        public static const INITIALIZE:String = "initialize"; // Tells the map the UI needs initial values for real time display (like mouse location or a hovered cell)

        // Events the App listens for
        public static const OPEN_PANE:String = "openPane"; // Tells the app to open a (left) pane
        public static const CLOSE_PANE:String = "closePane"; // Tells the map to close the currently open (left) pane

        // Events the Toolbar & Overlays listen for
        public static const MAP_ZOOM:String = "mapZoom"; // Tells the UI that the map has been zoomed in or out
        public static const MAP_MOUSE_MOVE:String = "mapMouseMove"; // Tells the UI that the user has moved their mouse over the map

        // Events the Model listens for
        public static const TASK_CHANGED:String = "taskChanged"; // Tells the model that the current task has changed
        public static const VALIDITY_CHANGED:String = "validityChanged"; // Tells the model that the validity of the state has changed (user changed something, will require a build call)

        public var payload:*;

        public function AppEvent(type:String, payload:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this.payload = payload;
        }
    }
}
