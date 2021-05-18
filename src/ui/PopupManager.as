package ui
{
    import events.PopupEvent;

    import flash.events.EventDispatcher;

    import global.Signal;

    import ui.popups.Popup;

    public class PopupManager extends EventDispatcher
    {
        private static var _instance:PopupManager;

        public function PopupManager()
        {
            if (_instance)
                throw new Error("Singletons can only have one instance");
            _instance = this;
        }

        public static function get instance():PopupManager
        {
            if (!_instance)
                new PopupManager();
            return _instance;
        }

        public static function open(popup:Popup):void
        {
            PopupManager.instance.dispatchEvent(new PopupEvent(PopupEvent.OPEN, popup));
        }

        public static function close():void
        {
            PopupManager.instance.dispatchEvent(new PopupEvent(PopupEvent.CLOSE));
        }
    }
}
