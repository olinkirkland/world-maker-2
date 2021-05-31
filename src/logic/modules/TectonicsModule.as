package logic.modules
{
    import global.Color;
    import global.Util;

    import mx.utils.UIDUtil;

    public class TectonicsModule extends Module
    {
        public function TectonicsModule()
        {
            super();
        }

        public static function addPlate():TectonicPlate
        {
            var t:TectonicPlate = new TectonicPlate();
            t.id = UIDUtil.createUID();
            t.color = Color.stringToLightColor("" + Math.random() * 999);
            t.strength = 1;
            model.tectonicPlates.addItem(t);
            return t;
        }
    }
}
