57482462 - 1;
class dofus.datacenter.OfflineCharacter extends ank.battlefield.datacenter.Sprite
{
   var __proto__;
   var _gfxID;
   var _oEmblem;
   var _sCharacterID;
   var _sGuildName;
   var _sName;
   var _sOfflineType;
   var api;
   var id;
   var xtraClipTopAnimations = {staticL:true,staticF:true,staticR:true};
   function OfflineCharacter(sID, clipClass, sGfxFile, cellNum, dir, gfxID)
   {
      super();
      if(this.__proto__ == dofus.datacenter.OfflineCharacter.prototype)
      {
         this.initialize(sID,clipClass,sGfxFile,cellNum,dir,gfxID);
      }
   }
   function set characterID(characterID)
   {
      this._sCharacterID = characterID;
   }
   function get characterID()
   {
      return this._sCharacterID;
   }
   function set name(sName)
   {
      this._sName = sName;
   }
   function get name()
   {
      return this._sName;
   }
   function get gfxID()
   {
      return this._gfxID;
   }
   function set gfxID(value)
   {
      this._gfxID = value;
   }
   function initialize(sID, clipClass, sGfxFile, cellNum, dir, gfxID)
   {
      super.initialize(sID,clipClass,sGfxFile,cellNum,dir);
      this._gfxID = gfxID;
   }
   function set guildName(sGuildName)
   {
      this._sGuildName = sGuildName;
   }
   function get guildName()
   {
      return this._sGuildName;
   }
   function set emblem(oEmblem)
   {
      this._oEmblem = oEmblem;
   }
   function get emblem()
   {
      return this._oEmblem;
   }
   function set offlineType(sOfflineType)
   {
      this._sOfflineType = sOfflineType;
   }
   function get offlineType()
   {
      return this._sOfflineType;
   }
   function onWindowFocusChanged(oEvent_)
   {
      if(this.api.datacenter.Game.isFight)
      {
         return undefined;
      }
      if(this.api.kernel.OptionsManager.getOption("AntiLagHideMerchants"))
      {
         this.api.gfx.hideSprite(this.id,!oEvent_.isFocused);
      }
   }
}
