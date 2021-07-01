package logic.tasks
{
    import logic.Layer;
    import logic.modules.TectonicsModule;

    import ui.dynamicOverlays.DynamicOverlayTectonics;

    import ui.staticOverlays.StaticOverlay;
    import ui.staticOverlays.StaticOverlayPoints;
    import ui.staticOverlays.StaticOverlayTectonics;
    import ui.toolbars.TectonicsToolbar;

    public class TectonicsTask extends Task
    {
        public function TectonicsTask()
        {
            id = TECTONICS;
            toolbar = TectonicsToolbar;
            staticOverlay = StaticOverlayTectonics;
            dynamicOverlay = DynamicOverlayTectonics;
            name = "task_tectonics";
            module = TectonicsModule;
            _layerIds = [Layer.DEEP_TECTONIC_PLATES, Layer.TECTONIC_PLATES, Layer.TECTONIC_BORDERS, Layer.VORONOI];

            resetLayers();
        }
    }
}
