package logic.tasks
{
    import logic.Layer;
    import logic.modules.PointsModule;
    import logic.tasks.Task;

    import ui.staticOverlays.StaticOverlay;
    import ui.staticOverlays.StaticOverlayStandard;

    import ui.toolbars.PointsToolbar;

    public class PointsTask extends Task
    {
        public function PointsTask()
        {
            id = POINTS;
            toolbar = PointsToolbar;
            staticOverlay = StaticOverlayStandard;
            name = "task_points";
            module = PointsModule;
            layers = [Layer.VORONOI];
        }
    }
}
