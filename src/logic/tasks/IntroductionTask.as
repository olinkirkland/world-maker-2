package logic.tasks
{
    import logic.modules.Module;

    import ui.staticOverlays.StaticOverlayIntroduction;
    import ui.toolbars.IntroductionToolbar;

    public class IntroductionTask extends Task
    {
        public function IntroductionTask()
        {
            id = INTRODUCTION;
            toolbar = IntroductionToolbar;
            staticOverlay = StaticOverlayIntroduction;
            //dynamicOverlay
            name = "task_introduction";
            module = Module;
            _layerIds = [];

            resetLayers();
        }
    }
}
