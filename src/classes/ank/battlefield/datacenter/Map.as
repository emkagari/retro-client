844906709 - 1;
class ank.battlefield.datacenter.Map extends Object
{
   var _aLineOfSightCells;
   var _nTacticDecorFrequency;
   var api;
   var data;
   var id;
   var originalsCellsBackup;
   function Map(nID)
   {
      super();
      this.initialize(nID);
   }
   function initialize(nID)
   {
      this.id = nID;
      this.originalsCellsBackup = new ank.utils.ExtendedObject();
      this.api = _global.API;
   }
   function cleanSpritesOn()
   {
      if(this.data != undefined)
      {
         for(var k in this.data)
         {
            this.data[k].removeAllSpritesOnID();
         }
      }
   }
   function get lineOfSightCells()
   {
      return this._aLineOfSightCells;
   }
   function set lineOfSightCells(aCells)
   {
      this._aLineOfSightCells = aCells;
      this._nTacticDecorFrequency = Math.max(Math.floor(aCells.length / 9),3);
   }
   function get tacticDecorFrequency()
   {
      return this._nTacticDecorFrequency;
   }
}
