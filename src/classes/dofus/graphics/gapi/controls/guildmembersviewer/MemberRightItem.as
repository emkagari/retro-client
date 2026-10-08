class dofus.graphics.gapi.controls.guildmembersviewer.MemberRightItem extends ank.gapi.core.UIBasicComponent
{
   var _bRightOriginalState;
   var _btnRight;
   var _lblRight;
   var _mcList;
   var _nRightValue;
   var _oItem;
   var addToQueue;
   var gapi;
   function MemberRightItem()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      var _loc5_ = _global.API;
      if(bUsed)
      {
         this._oItem = oItem;
         this._lblRight.text = _loc5_.lang.getText(oItem.name);
         this._btnRight.selected = oItem.hasRight;
         this._bRightOriginalState = oItem.hasRight;
         this._btnRight.enabled = oItem.canSetRight;
         this._btnRight._visible = true;
         this._nRightValue = oItem.rightValue;
      }
      else if(this._lblRight.text != undefined)
      {
         this._lblRight.text = "";
         this._btnRight.selected = false;
         this._btnRight.enabled = false;
         this._nRightValue = undefined;
      }
   }
   function init()
   {
      super.init(false);
      this._btnRight._visible = false;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._btnRight.addEventListener("click",this);
   }
   function click(oEvent)
   {
      var _loc3_ = _global.API;
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "_btnRight")
      {
         this._oItem.hasRight = this._btnRight.selected;
         this._oItem.needsUpdate = this._oItem.hasRight != this._bRightOriginalState;
         this.gapi.getUIComponent("GuildMemberInfos").updateData();
      }
   }
}
