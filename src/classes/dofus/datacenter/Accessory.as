class dofus.datacenter.Accessory extends Object
{
   var _bCanBeHide;
   var _nFrame;
   var _nType;
   var _nUnicID;
   var _oItemText;
   var api;
   function Accessory(nUnicID, nType, nFrame, bCanBeHide)
   {
      super();
      this.api = _global.API;
      this.initialize(nUnicID,nType,nFrame,bCanBeHide);
   }
   function get unicID()
   {
      return this._nUnicID;
   }
   function get type()
   {
      if(this._nType != undefined)
      {
         return this._nType;
      }
      return this._oItemText.t;
   }
   function get gfxID()
   {
      return this._oItemText.g;
   }
   function get gfx()
   {
      return this.type + "_" + this.gfxID;
   }
   function get frame()
   {
      return this._nFrame;
   }
   function get canBeHide()
   {
      return this._bCanBeHide;
   }
   function initialize(nUnicID, nType, nFrame, bCanBeHide)
   {
      this._nUnicID = nUnicID;
      if(nFrame != undefined)
      {
         this._nFrame = nFrame;
      }
      if(nType != undefined)
      {
         this._nType = nType;
      }
      this._bCanBeHide = bCanBeHide != undefined ? bCanBeHide : false;
      this._oItemText = this.api.lang.getItemUnicText(nUnicID);
   }
}
