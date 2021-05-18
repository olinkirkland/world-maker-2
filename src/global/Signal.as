package global
{
    import flash.events.EventDispatcher;

    public class Signal extends EventDispatcher
    {
        private static var _instance:Signal;

        public function Signal()
        {
            if (_instance)
                throw new Error("Singletons can only have one instance");
            _instance = this;
        }

        public static function get instance():Signal
        {
            if (!_instance)
                new Signal();
            return _instance;
        }
    }
}
