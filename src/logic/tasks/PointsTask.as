package logic.tasks
{
    import logic.Layer;
    import logic.tasks.Task;

    import ui.staticOverlays.StaticOverlay;
    import ui.staticOverlays.StaticOverlayPoints;

    import ui.toolbars.ToolbarPoints;

    public class PointsTask extends Task
    {
        public function PointsTask()
        {
            id = POINTS;
            toolbar = ToolbarPoints;
            staticOverlay = StaticOverlayPoints;
            name = "task_points";
            //module = ModuleIntroduction;
            layers = [Layer.POINTS, Layer.VORONOI, Layer.DELAUNAY];
        }
    }
}
