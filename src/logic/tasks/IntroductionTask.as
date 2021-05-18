package logic.tasks
{
    import ui.staticOverlays.StaticOverlay;
    import ui.staticOverlays.StaticOverlayIntroduction;
    import ui.toolbars.ToolbarIntroduction;

    public class IntroductionTask extends Task
    {
        public function IntroductionTask()
        {
            id = INTRODUCTION;
            toolbar = ToolbarIntroduction;
            staticOverlay = StaticOverlayIntroduction;
            name = "task_introduction";
            //module = ModuleIntroduction;
            layers = [];
        }
    }
}
