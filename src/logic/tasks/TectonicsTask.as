package logic.tasks
{
    import logic.Layer;

    import ui.staticOverlays.StaticOverlay;
    import ui.toolbars.ToolbarTectonics;

    public class TectonicsTask extends Task
    {
        public function TectonicsTask()
        {
            id = TECTONICS;
            toolbar = ToolbarTectonics;
            staticOverlay = StaticOverlay;
            name = "task_tectonics";
            //module = ModuleIntroduction;
            layers = [Layer.POINTS, Layer.VORONOI, Layer.DELAUNAY, Layer.TECTONIC_PLATES];
        }
    }
}
