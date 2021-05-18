package events
{
    import flash.events.Event;

    import ui.popups.Popup;

    public class PopupEvent extends Event
    {
        public static const OPEN:String = "openPopup";
        public static const CLOSE:String = "closePopup";

        public var popup:Popup;

        public function PopupEvent(type:String, popup:Popup = null)
        {
            super(type, false, false);
            this.popup = popup;
        }
    }
}
