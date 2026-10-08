class dofus.graphics.gapi.ui.gameresult.GameResultPlayerLightPVP extends ank.gapi.core.UIBasicComponent
{
   var _lblCurrentHonour;
   var _lblKama;
   var _lblRank;
   var _lblWinHonour;
   var _ldrAllDrop;
   var _mcAlignment;
   var _mcList;
   var _oItems;
   var _pbXP;
   var _sDisgrace;
   var _sHonour;
   var addToQueue;
   var api;
   var gapi;
   static var MAX_DROPS_DISPLAYED = 5;
   function GameResultPlayerLightPVP()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      this._oItems = oItem;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      if(bUsed)
      {
         if(oItem.rank == 0 && !this.api.datacenter.Basics.aks_current_server.isHardcore())
         {
            this._lblWinHonour._visible = false;
            this._lblRank._visible = false;
            this._pbXP._visible = false;
         }
         else
         {
            this._lblWinHonour._visible = true;
            this._lblRank._visible = true;
            this._pbXP._visible = true;
            if(oItem.winhonour >= 0)
            {
               this._lblCurrentHonour.text = "" + (oItem.honour - oItem.winhonour);
               this._lblWinHonour.text = !_global.isNaN(oItem.winhonour) ? " + " + new ank.utils.ExtendedString(oItem.winhonour).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "";
            }
            else
            {
               _loc5_ = Math.abs(oItem.winhonour);
               this._lblCurrentHonour.text = "" + (oItem.honour - oItem.winhonour);
               this._lblWinHonour.text = !_global.isNaN(_loc5_) ? " - " + new ank.utils.ExtendedString(_loc5_).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "";
            }
            this._lblRank.text = !_global.isNaN(oItem.rank) ? oItem.rank : "";
            this._lblKama.text = !_global.isNaN(oItem.kama) ? new ank.utils.ExtendedString(oItem.kama).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "0";
            this._sDisgrace = !_global.isNaN(oItem.disgrace) ? new ank.utils.ExtendedString(oItem.disgrace).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "";
            this._sHonour = !_global.isNaN(oItem.honour) ? new ank.utils.ExtendedString(oItem.honour).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "";
            this._pbXP.minimum = this._pbXP.uberMinimum = oItem.minhonour;
            this._pbXP.maximum = this._pbXP.uberMaximum = oItem.maxhonour;
            if(oItem.winhonour >= 0)
            {
               this._pbXP.value = oItem.honour;
               this._pbXP.uberValue = oItem.honour - oItem.winhonour;
            }
            else
            {
               this._pbXP.value = oItem.honour - oItem.winhonour;
               this._pbXP.styleName = "BrownProgressBarLoss";
               this._pbXP.uberValue = oItem.honour;
            }
            _loc6_ = oItem.alignment;
            if(this._lblRank._visible && _loc6_ > 0)
            {
               this._mcAlignment.gotoAndStop(_loc6_ + 1);
            }
            _loc7_ = 0;
            while(_loc7_ < dofus.graphics.gapi.ui.gameresult.GameResultPlayerLightPVP.MAX_DROPS_DISPLAYED)
            {
               _loc8_ = this["_ctr" + _loc7_];
               _loc8_.contentData = oItem.items[_loc7_];
               _loc8_._visible = _loc8_.contentData != undefined;
               _loc7_ = _loc7_ + 1;
            }
            this._ldrAllDrop._visible = oItem.items.length > dofus.graphics.gapi.ui.gameresult.GameResultPlayerLightPVP.MAX_DROPS_DISPLAYED;
         }
      }
   }
   function init()
   {
      super.init(false);
      this.addToQueue({object:this,method:this.addListeners});
      this.api = _global.API;
   }
   function size()
   {
      super.size();
   }
   function addListeners()
   {
      var _loc2_ = this;
      this._ldrAllDrop.addEventListener("over",this);
      this._ldrAllDrop.addEventListener("out",this);
      this._pbXP.addEventListener("over",this);
      this._pbXP.addEventListener("out",this);
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < dofus.graphics.gapi.ui.gameresult.GameResultPlayerLightPVP.MAX_DROPS_DISPLAYED)
      {
         _loc4_ = this["_ctr" + _loc3_];
         _loc4_.addEventListener("over",this);
         _loc4_.addEventListener("out",this);
         _loc4_.addEventListener("click",this);
         _loc3_ = _loc3_ + 1;
      }
   }
   function over(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      switch(oEvent.target)
      {
         case this._pbXP:
            this.gapi.showTooltip(this.api.lang.getText("HONOUR_POINTS") + " : " + this._sHonour + "\n" + this.api.lang.getText("DISGRACE_POINTS") + " : " + this._sDisgrace);
            return;
         case this._ldrAllDrop:
            _loc3_ = this._oItems.items;
            _loc4_ = "";
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc6_ = _loc3_[_loc5_];
               if(_loc5_ > 0)
               {
                  _loc4_ += "\n";
               }
               _loc4_ += _loc6_.Quantity + " x " + _loc6_.name;
               _loc5_ = _loc5_ + 1;
            }
            if(_loc4_ != "")
            {
               this._mcList.gapi.showTooltip(_loc4_);
            }
            return;
         default:
            _loc7_ = oEvent.target.contentData;
            _loc8_ = _loc7_.style + "ToolTip";
            this._mcList.gapi.showTooltip(_loc7_.Quantity + " x " + _loc7_.name,_loc8_);
            return;
      }
   }
   function out(oEvent)
   {
      this._mcList.gapi.hideTooltip();
   }
   function click(oEvent)
   {
      var _loc3_ = oEvent.target.contentData;
      if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY) && _loc3_ != undefined)
      {
         this._mcList._parent.gapi.api.kernel.GameManager.insertItemInChat(_loc3_);
      }
   }
}
