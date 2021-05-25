package logic
{
    import events.AppEvent;

    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    import global.Local;
    import global.Signal;
    import global.Util;

    import logic.modules.Module;
    import logic.modules.PointsModule;
    import logic.tasks.Task;

    import managers.TaskManager;

    import ui.PopupManager;
    import ui.popups.BusyPopup;

    public class Model
    {
        private static var _instance:Model;

        public var loaded:Boolean = false;
        public var callbackSave:Function = standaloneSave;
        public var isValid:Boolean;

        // Singletons
        private var signal:Signal;
        private var taskManager:TaskManager;

        // Modules
        public var pointsModule:PointsModule;

        public function Model()
        {
            if (_instance)
                throw new Error("Singletons can only have one instance");
            _instance = this;

            signal = Signal.instance;
            taskManager = TaskManager.instance;

            // Module
            pointsModule = new PointsModule();
        }

        public static function get instance():Model
        {
            if (!_instance)
                new Model();
            return _instance;
        }

        public function invalidate():void
        {
            // Invalidate current model
            // If a model is invalidated, the model must rebuild the current task
            // before progressing to the next task

            isValid = false;
            signal.dispatchEvent(new AppEvent(AppEvent.VALIDITY_CHANGED));
        }

        public function build():void
        {
            // Builds the current task
            var task:Task = TaskManager.instance.currentTask;
            if (task.module)
            {
                var module:Module = new task.module;
                var p:BusyPopup = new BusyPopup();
                p.text = Local.text('building');
                p.calculation = module.run;
                PopupManager.open(p);
            } else
            {
                trace("Task " + task.name + " has no assigned module");
            }

            isValid = true;
            signal.dispatchEvent(new AppEvent(AppEvent.VALIDITY_CHANGED));
            signal.dispatchEvent(new AppEvent(AppEvent.DRAW));
        }

        public function save(u:Object = null):void
        {
            if (callbackSave != null)
                callbackSave.apply(null, [u != null ? u : serialize()]);
        }

        private static function standaloneSave(u:Object):void
        {
            Util.log("Model: save (standalone)");

            var fileStream:FileStream = new FileStream();
            fileStream.open(File.applicationStorageDirectory.resolvePath("localSave.json"), FileMode.WRITE);
            fileStream.writeUTFBytes(JSON.stringify(u));
            fileStream.close();
        }

        public function load(u:Object):void
        {
            deserialize(u);
        }

        public function standaloneLoad():void
        {
            Util.log("Model: load (standalone)");

            // Only triggered in standalone mode
            var file:File = File.applicationStorageDirectory.resolvePath("localSave.json");
            if (!file.exists)
            {
                deserialize({});
                save();
                return;
            }

            var fileStream:FileStream = new FileStream();
            fileStream.open(file, FileMode.READ);
            var json:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
            fileStream.close();

            deserialize(JSON.parse(json));
        }

        public function serialize():Object
        {
            Util.log("Model: serialize");

            var u:Object = {};
            u.currentTaskId = taskManager.currentTask.id;
            u.pointsSeed = pointsModule.seed;
            u.points = pointsModule.points;

            return u;
        }

        public function deserialize(u:Object):void
        {
            Util.log("Model: deserialize");

            if (u.pointsSeed)
                pointsModule.seed = u.pointsSeed;
            if (u.points)
                pointsModule.loadPoints(u.points);

            if (u.currentTaskId)
                TaskManager.instance.setCurrentTaskById(u.currentTaskId);
            else
                signal.dispatchEvent(new AppEvent(AppEvent.TASK_CHANGED));

            loaded = true;
        }
    }
}
