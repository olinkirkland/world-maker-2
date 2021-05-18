package ui.parts.components
{
    import flash.display.InteractiveObject;
    import flash.events.FocusEvent;
    import flash.geom.Point;

    import spark.components.TextInput;

    public class IconTextInput extends TextInput
    {
        public var icon:Class = null;

        public function IconTextInput()
        {
            super();

            addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, textInputMouseFocusChange, false, 0, true);
        }

        private function textInputMouseFocusChange(event:FocusEvent):void
        {

            dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));

            var focusPoint:Point = new Point();
            focusPoint.x = stage.mouseX;
            focusPoint.y = stage.mouseY;
            var i:int = (stage.getObjectsUnderPoint(focusPoint).length);
            stage.focus = InteractiveObject(stage.getObjectsUnderPoint(focusPoint)[i - 1].parent);
        }
    }
}
