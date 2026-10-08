class ank.utils.MouseClicksMemorizer
{
   static var MAX_CAPACITY = 20;
   var _aMouseClicks = [];
   var _aMouseClicksForGather = [];
   function MouseClicksMemorizer()
   {
   }
   function storeCurrentMouseClick(bRightClick)
   {
      var _loc3_ = new ank.utils.datacenter.MouseClick(getTimer(),_root._xmouse,_root._ymouse,bRightClick);
      this._aMouseClicks.push(_loc3_);
      this._aMouseClicksForGather.push(_loc3_);
      if(this._aMouseClicks.length > ank.utils.MouseClicksMemorizer.MAX_CAPACITY)
      {
         this._aMouseClicks.shift();
      }
      if(this._aMouseClicksForGather.length > 2)
      {
         this._aMouseClicksForGather.shift();
      }
   }
   function getMouseClickForGather(nIndex)
   {
      if(this._aMouseClicksForGather.length < nIndex)
      {
         return undefined;
      }
      return this._aMouseClicksForGather[this._aMouseClicksForGather.length - nIndex];
   }
   function resetForGather()
   {
      if(this._aMouseClicksForGather.length == 0)
      {
         return undefined;
      }
      this._aMouseClicksForGather = [];
   }
}
