package logic
{
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.geom.Point;

    import global.Util;

    import logic.graph.Cell;

    import managers.TaskManager;

    public class Model
    {
        private static var _instance:Model;

        // Singletons
        private var taskManager:TaskManager;

        public var loaded:Boolean = false;
        public var callbackSave:Function = standaloneSave;

        public function Model()
        {
            if (_instance)
                throw new Error("Singletons can only have one instance");
            _instance = this;

            taskManager = TaskManager.instance;
        }

        public static function get instance():Model
        {
            if (!_instance)
                new Model();
            return _instance;
        }

        public function save(u:Object = null):void
        {
            if (callbackSave != null)
                callbackSave.apply(null, [u != null ? u : serialize()]);
        }

        private static function standaloneSave(u:Object):void
        {
            Util.log("@Model: save (standalone)");

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
            Util.log("@Model: load (standalone)");

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
            var u:Object = {};
            u.currentTaskId = taskManager.currentTask.id;

            return u;
        }

        public function deserialize(u:Object):void
        {
            Util.log("@Model: deserialize");

            if (u.currentTaskId)
                TaskManager.instance.setCurrentTaskById(u.currentTaskId);

            loaded = true;
        }
    }
}
