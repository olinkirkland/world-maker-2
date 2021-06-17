package logic.tasks
{
    import logic.Layer;
    import logic.modules.TectonicsModule;

    import ui.dynamicOverlays.DynamicOverlayTectonics;

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
            dynamicOverlay = DynamicOverlayTectonics;
            name = "task_tectonics";
            module = TectonicsModule;
            _layerIds = [Layer.VORONOI, Layer.TECTONIC_PLATES];

            resetLayers();
        }
    }
}
