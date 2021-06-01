package logic.modules
{
    import global.Local;

    import logic.Model;

    import ui.PopupManager;

    import ui.popups.InfoPopup;

    public class Module
    {
        public static var model:Model;

        public function Module()
        {
            model = Model.instance;
        }

        public function canRun():Boolean
        {
            return true;
        }

        public function run():void
        {
            if (!canRun())
            {
                var p:InfoPopup = new InfoPopup();
                p.header = Local.text('error');
                p.description = Local.text('module_run_error');
                p.callback = model.invalidate;
                PopupManager.open(p);
            } else
            {
                calculate();
            }
        }

        protected function calculate():void
        {
        }
    }
}
