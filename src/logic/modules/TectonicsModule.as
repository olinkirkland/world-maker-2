package logic.modules
{
    import global.Color;

    import logic.graph.Cell;

    import mx.utils.UIDUtil;

    public class TectonicsModule extends Module
    {
        public function TectonicsModule()
        {
            super();
        }

        override public function canRun():Boolean
        {
            for each (var tectonicPlate:TectonicPlate in model.tectonicPlates)
                if (!tectonicPlate.origin)
                    return false;
            return true;
        }

        override protected function calculate():void
        {
            trace("TectonicsModule:calculate");

            // Set initial cell values
            for each (var cell:Cell in model.cells)
            {
                cell.tectonicPlate = null;
                cell.tectonicStrength = 0;
            }

            // Setup the plate origins for use
            for each (var plate:TectonicPlate in model.tectonicPlates)
            {
                plate.cells = [];
                plate.addCell(plate.origin);
                plate.origin.tectonicStrength = plate.strength;
            }

            expandPlates();
        }

        private function expandPlates():void
        {
            for each (var tectonicPlate:TectonicPlate in model.tectonicPlates)
            {
                // Do each plate at a time
                model.unuseCells();

                var queue:Vector.<Cell> = new Vector.<Cell>();

                // There's only one cell in here right now
                if (tectonicPlate.cells.length > 0)
                    queue.push(tectonicPlate.cells[0]);

                // Flood fill
                while (queue.length > 0)
                {
                    var cell:Cell = queue.shift();
                    for each (var neighbor:Cell in cell.neighbors)
                    {
                        if (!neighbor.used && neighbor.tectonicPlate != cell.tectonicPlate && neighbor.tectonicStrength < cell.tectonicStrength)
                        {
                            //neighbor.tectonicStrength = cell.tectonicStrength - (Rand.rand.next() < Settings.properties.tectonicJitter ? Rand.rand.next() * .1 : .05);
                            neighbor.tectonicStrength = cell.tectonicStrength - .05;
                            if (neighbor.tectonicPlate)
                                neighbor.tectonicPlate.removeCell(neighbor);

                            tectonicPlate.addCell(neighbor);
                            queue.push(neighbor);
                            neighbor.used = true;
                        }
                    }
                }
            }
        }

        public static function addPlate():TectonicPlate
        {
            var t:TectonicPlate = new TectonicPlate();
            t.id = UIDUtil.createUID();
            t.color = Color.stringToLightColor("" + Math.random() * 999);
            t.strength = 2;
            model.tectonicPlates.addItem(t);
            model.tectonicPlates.itemUpdated(t);
            return t;
        }

        public static function removePlate(plate:TectonicPlate):void
        {
            model.tectonicPlates.removeItem(plate);
            model.tectonicPlates.itemUpdated(plate);
        }

        public static function loadPlate(u:Object):void
        {
            var t:TectonicPlate = new TectonicPlate();
            t.id = u.id;
            t.origin = u.originIndex >= 0 ? model.cells[u.originIndex] : null;
            t.color = u.color;
            t.strength = u.strength;
            model.tectonicPlates.addItem(t);
            model.tectonicPlates.itemUpdated(t);
        }
    }
}
