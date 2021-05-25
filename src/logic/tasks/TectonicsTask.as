package logic.tasks
{
    import logic.Layer;
    import logic.modules.TectonicsModule;

    import ui.staticOverlays.StaticOverlay;
    import ui.toolbars.TectonicsToolbar;

    public class TectonicsTask extends Task
    {
        public function TectonicsTask()
        {
            id = TECTONICS;
            toolbar = TectonicsToolbar;
            staticOverlay = StaticOverlay;
            name = "task_tectonics";
            module = TectonicsModule;
            layers = [Layer.POINTS, Layer.VORONOI, Layer.DELAUNAY, Layer.TECTONIC_PLATES];
        }
    }
}
