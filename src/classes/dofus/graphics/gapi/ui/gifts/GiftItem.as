class dofus.graphics.gapi.ui.gifts.GiftItem extends ank.gapi.core.UIBasicComponent
{
   var _btnAttribution;
   var _cgGifts;
   var _lblDate;
   var _lblName;
   var _mcList;
   var _oItem;
   var _txtDescription;
   var addToQueue;
   var gapi;
   function GiftItem()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      var _loc5_;
      if(bUsed)
      {
         this._oItem = oItem;
         _loc5_ = this._mcList._parent._parent.api;
         this._lblName.text = oItem.items[0].name;
         this._lblDate.text = oItem.date != "" ? _loc5_.lang.getText("EXPIRATION_DATE",[oItem.date]) : "";
         this._cgGifts.dataProvider = oItem.items;
         this._cgGifts._visible = true;
         this._btnAttribution.enabled = true;
         this._btnAttribution.selected = oItem.playerWantsAttribution;
         this._btnAttribution._visible = true;
         this._txtDescription.text = oItem.items[0].description;
      }
      else if(this._lblName.text != undefined)
      {
         this._lblName.text = "";
         this._txtDescription.text = "";
         this._cgGifts._visible = false;
         this._btnAttribution._visible = false;
         this._lblDate.text = "";
      }
   }
   function init()
   {
      super.init(false);
      this._btnAttribution._visible = false;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._btnAttribution.addEventListener("click",this);
      this._btnAttribution.addEventListener("over",this);
      this._btnAttribution.addEventListener("out",this);
      this._cgGifts.addEventListener("overItem",this);
      this._cgGifts.addEventListener("outItem",this);
      this._lblDate.addEventListener("over",this);
      this._lblDate.addEventListener("out",this);
      this._lblDate.enableOverEvents = true;
   }
   function click(oEvent)
   {
      var _loc3_ = this._mcList._parent._parent.api;
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._btnAttribution)
      {
         this._oItem.playerWantsAttribution = this._btnAttribution.selected;
         this._oItem.onAttributionStateChanged();
      }
   }
   function over(oEvent)
   {
      var _loc3_ = this._mcList._parent._parent.api;
      switch(oEvent.target)
      {
         case this._btnAttribution:
            _loc3_.ui.showTooltip(_loc3_.lang.getText("GIFT_UI_CHECK_TO_ATTRIBUTE"));
            break;
         case this._lblDate:
            _loc3_.ui.showTooltip(_loc3_.lang.getText("EXPIRATION_GIFT",[this._oItem.date]));
         default:
            return;
      }
   }
   function out(oEvent)
   {
      var _loc3_ = this._mcList._parent._parent.api;
      switch(oEvent.target)
      {
         case this._btnAttribution:
         case this._lblDate:
            _loc3_.ui.hideTooltip();
         default:
            return;
      }
   }
   function overItem(oEvent)
   {
      var _loc3_ = oEvent.target;
      var _loc4_ = dofus.datacenter.Item(_loc3_.contentData);
      _loc4_.showStatsTooltip(_loc4_.style);
   }
   function outItem(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
