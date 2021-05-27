package logic.tasks
{
    import logic.Layer;
    import logic.modules.TectonicsModule;

    import ui.staticOverlays.StaticOverlay;
    import ui.staticOverlays.StaticOverlayStandard;
    import ui.toolbars.TectonicsToolbar;

    public class TectonicsTask extends Task
    {
        public function TectonicsTask()
        {
            id = TECTONICS;
            toolbar = TectonicsToolbar;
            staticOverlay = StaticOverlayStandard;
            name = "task_tectonics";
            module = TectonicsModule;
            layers = [Layer.VORONOI, Layer.TECTONIC_PLATES];
        }
    }
}
