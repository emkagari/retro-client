class ank.utils.datacenter.MouseClick
{
   var _bRightClick;
   var _nTime;
   var _nX;
   var _nY;
   function MouseClick(nTime, nX, nY, bRightClick)
   {
      this._nTime = nTime;
      this._nX = nX;
      this._nY = nY;
      this._bRightClick = bRightClick;
   }
   function get time()
   {
      return this._nTime;
   }
   function get nX()
   {
      return this._nX;
   }
   function get nY()
   {
      return this._nY;
   }
   function get rightClick()
   {
      return this._bRightClick;
   }
}
