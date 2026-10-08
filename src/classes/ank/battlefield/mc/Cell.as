class ank.battlefield.mc.Cell extends MovieClip
{
   var _mcBattlefield;
   var data;
   function Cell()
   {
      super();
   }
   function get num()
   {
      return this.data.num;
   }
   function initialize(b)
   {
      this._mcBattlefield = b;
   }
   function _release(Void)
   {
      this._mcBattlefield.onCellRelease(this);
   }
   function _rollOver(Void)
   {
      this._mcBattlefield.onCellRollOver(this);
   }
   function _rollOut(Void)
   {
      this._mcBattlefield.onCellRollOut(this);
   }
}
