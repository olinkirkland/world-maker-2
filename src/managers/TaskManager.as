package managers
{
    import events.AppEvent;

    import global.Signal;

    import logic.tasks.*;

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
            _currentTask = task;

            signal.dispatchEvent(new AppEvent(AppEvent.TASK_CHANGED));
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
