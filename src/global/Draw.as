package global
{
    import flash.display.Graphics;
    import flash.geom.Point;

    import game.graph.*;

    public class Draw
    {
        public static function drawLine(graphics:Graphics, point1:Point, point2:Point, color:uint, weight:Number = 1):void
        {
            graphics.lineStyle(weight, color);
            graphics.moveTo(point1.x, point1.y);
            graphics.lineTo(point2.x, point2.y);
            graphics.lineStyle();
        }

        public static function fillCell(graphics:Graphics, cell:Cell, color:uint, alpha:Number = 1):void
        {
            graphics.beginFill(color, alpha);
            for each (var edge:Edge in cell.edges)
            {
                if (!edge.v0 || !edge.v1)
                    continue;

                graphics.moveTo(edge.v0.point.x, edge.v0.point.y);
                graphics.lineTo(cell.point.x, cell.point.y);
                graphics.lineTo(edge.v1.point.x, edge.v1.point.y);
            }
            graphics.endFill();
        }
    }
}
