package logic.tasks
{
    import logic.Layer;

    import mx.collections.ArrayCollection;

    import ui.dynamicOverlays.DynamicOverlay;
    import ui.staticOverlays.StaticOverlay;

    public class Task
    {
        public static const INTRODUCTION:String = "taskReadIntroduction";
        public static const POINTS:String = "taskMakeVoronoiPoints";
        public static const TECTONICS:String = "taskMakeTectonicPlates";

        public var id:String;
        public var name:String;
        public var index:int;

        public var module:Class;
        public var toolbar:Class;
        public var staticOverlay:Class = StaticOverlay;
        public var dynamicOverlay:Class = DynamicOverlay;

        protected var _layerIds:Array;
        public var layers:ArrayCollection = new ArrayCollection();

        public function Task()
        {
        }

        public function resetLayers():void
        {
            layers.removeAll();
            for each (var l:String in _layerIds)
            {
                var layer:Layer = new Layer();
                layer.id = l;
                layer.visible = true;
                layer.allowed = true;
                layers.addItem(layer);
            }
        }
    }
}
