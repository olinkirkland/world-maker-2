package logic.tasks
{
    public class Task
    {
        public static const INTRODUCTION:String = "taskReadIntroduction";
        public static const POINTS:String = "taskMakeVoronoiPoints";
        public static const TECTONICS:String = "taskMakeTectonicPlates";

        public static var tasks:Array;

        public var id:String;
        public var name:String;
        public var index:int;

        public var module:Class;
        public var toolbar:Class;
        public var staticOverlay:Class;
        public var layers:Array;

        public function Task()
        {
        }
    }
}
