package logic.modules
{
    public class TectonicsModule extends Module
    {
        public function TectonicsModule()
        {
        }

        public static function addPlate():TectonicPlate
        {
            var t:TectonicPlate = new TectonicPlate();
            return t;
        }
    }
}
