package logic.modules
{
    import logic.Model;

    public class Module
    {
        public static var model:Model;

        public function Module()
        {
            model = Model.instance;
        }

        public function run():void
        {

        }
    }
}
