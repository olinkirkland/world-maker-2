package logic.modules
{
    import logic.graph.Cell;

    public class TectonicPlate
    {
        public var id:String;
        public var origin:Cell;
        public var color:uint;
        public var strength:int;
        public var cells:Array = [];

        public function TectonicPlate()
        {
        }

        public function addCell(cell:Cell):void
        {
            cell.tectonicPlate = this;
            cells.push(cell);
        }

        public function removeCell(cell:Cell):void
        {
            cell.tectonicPlate = null;
            for (var i:int = 0; i < cells.length; i++)
                if (cells[i] == cell)
                    cells.removeAt(i);
        }
    }
}
