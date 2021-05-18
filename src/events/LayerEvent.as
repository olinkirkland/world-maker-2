package events
{
    import flash.events.Event;

    import game.Layer;

    import logic.Layer;

    public class LayerEvent extends Event
    {
        public static const UP:String = "layerUp";
        public static const DOWN:String = "layerDown";
        public static const TOGGLE:String = "layerToggle";

        public var layer:Layer;

        public function LayerEvent(type:String, layer:Layer)
        {
            super(type, true, false);
            this.layer = layer;
        }
    }
}
