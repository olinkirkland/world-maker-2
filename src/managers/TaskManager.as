package managers
{
    import events.PayloadEvent;

    import global.Signal;

    import logic.tasks.*;

    import mx.events.CollectionEvent;

    public class TaskManager
    {
        private static var _instance:TaskManager;

        private var signal:Signal;

        public var tasks:Array = [];

        private var _currentTask:Task;

        public function TaskManager()
        {
            if (_instance)
                throw new Error("Singletons can only have one instance");
            _instance = this;

            signal = Signal.instance;

            tasks.push(new IntroductionTask());
            tasks.push(new PointsTask());
            tasks.push(new TectonicsTask());

            for (var i:int = 0; i < tasks.length; i++)
                tasks[i].index = i;

            // Default
            _currentTask = tasks[0];
        }

        public function get currentTask():Task
        {
            return _currentTask;
        }

        public function set currentTask(task:Task):void
        {
            if (_currentTask)
                _currentTask.layers.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onLayersChanged);

            _currentTask = task;
            _currentTask.layers.addEventListener(CollectionEvent.COLLECTION_CHANGE, onLayersChanged);

            signal.dispatchEvent(new PayloadEvent(PayloadEvent.TASK_CHANGED));
        }

        private function onLayersChanged(event:CollectionEvent):void
        {
            Signal.instance.dispatchEvent(new PayloadEvent(PayloadEvent.LAYERS_CHANGED));
        }

        public function setCurrentTaskByIndex(index:int):void
        {
            currentTask = tasks[index];
        }

        public function setCurrentTaskById(id:String):void
        {
            for each (var task:Task in tasks)
                if (task.id == id)
                    currentTask = task;
        }

        public function goToNextTask():void
        {
            trace("TaskManager:goToNextTask");
            setCurrentTaskByIndex(currentTask.index + 1);
        }

        public static function get instance():TaskManager
        {
            if (!_instance)
                new TaskManager();
            return _instance;
        }
    }
}
