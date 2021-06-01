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
            model.tectonicPlates.itemUpdated(t);
            return t;
        }

        public static function removePlate(plate:TectonicPlate):void
        {
            model.tectonicPlates.removeItem(plate);
            model.tectonicPlates.itemUpdated(plate);
        }

        public static function loadPlate(u:Object):void
        {
            var t:TectonicPlate = new TectonicPlate();
            t.id = u.id;
            t.origin = u.originIndex >= 0 ? model.cells[u.originIndex] : null;
            t.color = u.color;
            t.strength = u.strength;
            model.tectonicPlates.addItem(t);
            model.tectonicPlates.itemUpdated(t);
        }
    }
}
