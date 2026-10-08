class dofus.datacenter.NonPlayableCharacter extends ank.battlefield.datacenter.Sprite
{
   var __proto__;
   var _gfxID;
   var _nCustomArtwork;
   var _nExtraClipID;
   var _nUnicID;
   var _oNpcText;
   var api;
   var id;
   function NonPlayableCharacter(sID, clipClass, sGfxFile, cellNum, dir, gfxID, customArtwork)
   {
      super();
      this.api = _global.API;
      if(this.__proto__ == dofus.datacenter.NonPlayableCharacter.prototype)
      {
         this.initialize(sID,clipClass,sGfxFile,cellNum,dir,gfxID,customArtwork);
      }
   }
   function get unicID()
   {
      return this._nUnicID;
   }
   function set unicID(value)
   {
      this._nUnicID = value;
      this._oNpcText = this.api.lang.getNonPlayableCharactersText(value);
   }
   function get name()
   {
      return this.api.lang.fetchString(this._oNpcText.n);
   }
   function get actions()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = this._oNpcText.a;
      var _loc4_ = _loc3_.length;
      var _loc5_;
      while(_loc4_-- > 0)
      {
         _loc5_ = _loc3_[_loc4_];
         _loc2_.push({name:this.api.lang.getNonPlayableCharactersActionText(_loc3_[_loc4_]),actionId:_loc5_,action:this.getActionFunction(_loc3_[_loc4_])});
      }
      return _loc2_;
   }
   function get gfxID()
   {
      return this._gfxID;
   }
   function set gfxID(value)
   {
      this._gfxID = value;
   }
   function get extraClipID()
   {
      return this._nExtraClipID;
   }
   function set extraClipID(nExtraClipID)
   {
      this._nExtraClipID = nExtraClipID;
   }
   function get customArtwork()
   {
      return this._nCustomArtwork;
   }
   function set customArtwork(nCustomArtwork)
   {
      this._nCustomArtwork = nCustomArtwork;
   }
   function initialize(sID, clipClass, sGfxFile, cellNum, dir, gfxID, customArtwork)
   {
      super.initialize(sID,clipClass,sGfxFile,cellNum,dir);
      this._gfxID = gfxID;
      this._nCustomArtwork = customArtwork;
   }
   function getActionFunction(nActionID)
   {
      switch(nActionID)
      {
         case 1:
            return {object:this.api.kernel.GameManager,method:this.api.kernel.GameManager.startExchange,params:[0,this.id]};
         case 2:
            return {object:this.api.kernel.GameManager,method:this.api.kernel.GameManager.startExchange,params:[2,this.id]};
         case 3:
            return {object:this.api.kernel.GameManager,method:this.api.kernel.GameManager.startDialog,params:[this.id]};
         case 4:
            return {object:this.api.kernel.GameManager,method:this.api.kernel.GameManager.startExchange,params:[9,this.id]};
         case 5:
            return {object:this.api.kernel.GameManager,method:this.api.kernel.GameManager.startExchange,params:[10,this.id]};
         case 6:
            return {object:this.api.kernel.GameManager,method:this.api.kernel.GameManager.startExchange,params:[11,this.id]};
         case 7:
            return {object:this.api.kernel.GameManager,method:this.api.kernel.GameManager.startExchange,params:[17,this.id]};
         case 8:
            return {object:this.api.kernel.GameManager,method:this.api.kernel.GameManager.startExchange,params:[18,this.id]};
         default:
            return {};
      }
   }
}
