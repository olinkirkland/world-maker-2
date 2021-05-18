package events
{
    import flash.events.Event;

    public class PayloadEvent extends Event
    {
        public var payload:*;

        public function PayloadEvent(type:String, payload:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this.payload = payload;
        }
    }
}
