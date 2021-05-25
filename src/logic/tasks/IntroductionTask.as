package logic.tasks
{
    import ui.staticOverlays.StaticOverlay;
    import ui.staticOverlays.StaticOverlayIntroduction;
    import ui.toolbars.IntroductionToolbar;

    public class IntroductionTask extends Task
    {
        public function IntroductionTask()
        {
            id = INTRODUCTION;
            toolbar = IntroductionToolbar;
            staticOverlay = StaticOverlayIntroduction;
            name = "task_introduction";
            //module = ModuleIntroduction;
            layers = [];
        }
    }
}
