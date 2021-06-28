package events
{
    import flash.events.Event;

    public class PayloadEvent extends Event
    {
        // Events dispatched from the map
        public static const MAP_ZOOM:String = "mapZoom"; // Tells the UI that the map has been zoomed in or out
        public static const MAP_MOUSE_MOVE:String = "mapMouseMove"; // The user has moved their mouse over the map
        public static const MAP_CLICK:String = "mapClick"; // The user has clicked their mouse on the map, payload is a Point

        // Events dispatched from the UI (toolbar & overlays)
        public static const ZOOM_IN:String = "zoomIn"; // Tells the map to zoom in
        public static const ZOOM_OUT:String = "zoomOut"; // Tells the map to zoom out
        public static const MOVE_MAP_TO_CENTER:String = "moveMapToCenter"; // Tells the map to center itself
        public static const FIT_MAP_TO_VIEWPORT:String = "fitMapToViewport"; // Tells the map to fit itself to the viewport
        public static const PICK_CELL_START:String = "pickCellStart"; // Tells the model to return the next cell that's been clicked on with the callback function provided in the event
        public static const PICK_CELL_END:String = "pickCellEnd"; // Tells the model to stop cell picking mode
        public static const OPEN_PANE:String = "openPane"; // Tells the app to open a (left) pane
        public static const CLOSE_PANE:String = "closePane"; // Tells the map to close the currently open (left) pane
        public static const CHANGE_TECTONICS:String = "changeTectonics"; // Tells the dynamic overlay that a change has been made to the tectonics

        // Events dispatched from the Model
        public static const DRAW:String = "draw"; // Tells the map to perform a draw call
        public static const VALIDITY_CHANGED:String = "validityChanged"; // Tells the model that the validity of the state has changed (user changed something, will require a build call)

        // Misc
        public static const INITIALIZE:String = "initialize"; // Tells the map the UI needs initial values for real time display (like mouse location or a hovered cell)
        public static const TASK_CHANGED:String = "taskChanged"; // Tells the model that the current task has changed
        public static const LAYERS_CHANGED:String = "layersChanged"; // Tells the map that the current task's layers changed

        public var payload:*;

        public function PayloadEvent(type:String, payload:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this.payload = payload;
        }
    }
}
