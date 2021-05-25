package events
{
    import flash.events.Event;

    public class ModelEvent extends Event
    {
        public static const TASK_CHANGED:String = "taskChanged";
        public static const VALIDITY_CHANGED:String = "validityChanged";

        public function ModelEvent(type:String, payload:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }
    }
}
