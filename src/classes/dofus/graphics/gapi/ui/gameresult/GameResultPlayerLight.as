670451621 - 1;
class dofus.graphics.gapi.ui.gameresult.GameResultPlayerLight extends ank.gapi.core.UIBasicComponent
{
   var _lblKama;
   var _lblWinXP;
   var _ldrAllDrop;
   var _ldrLockXp;
   var _ldrXP;
   var _mcList;
   var _oItems;
   var _pbXP;
   var _sGuildXP;
   var _sMountXP;
   var _sXP;
   var addToQueue;
   var api;
   var gapi;
   static var MAX_DROPS_DISPLAYED = 8;
   function GameResultPlayerLight()
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
      if(bUsed)
      {
         _loc5_ = oItem.xpMultiplicator > 1;
         this._ldrXP.contentPath = !_loc5_ ? "UI_QuestXP" : "BonusXPx" + oItem.xpMultiplicator;
         this._ldrXP._visible = true;
         this._ldrXP.enabled = _loc5_;
         this._ldrLockXp._visible = false;
         if(_global.isNaN(oItem.xp) || _global.isNaN(oItem.winxp))
         {
            this._pbXP._visible = false;
         }
         else if(oItem.xpLocked)
         {
            this._ldrXP._visible = false;
            this._lblWinXP._visible = false;
            this._pbXP._visible = false;
            this._ldrLockXp._visible = true;
         }
         else
         {
            this._pbXP._visible = true;
            this._pbXP.minimum = this._pbXP.uberMinimum = oItem.minxp;
            this._pbXP.maximum = this._pbXP.uberMaximum = oItem.level != 200 ? oItem.maxxp : -1;
            this._pbXP.value = oItem.xp;
            this._pbXP.uberValue = oItem.xp - (!_global.isNaN(oItem.winxp) ? oItem.winxp : 0);
         }
         this._lblWinXP.text = !_global.isNaN(oItem.winxp) ? new ank.utils.ExtendedString(oItem.winxp).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "0";
         this._sGuildXP = !_global.isNaN(oItem.guildxp) ? new ank.utils.ExtendedString(oItem.guildxp).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "0";
         this._sMountXP = !_global.isNaN(oItem.mountxp) ? new ank.utils.ExtendedString(oItem.mountxp).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "0";
         this._lblKama.text = !_global.isNaN(oItem.kama) ? new ank.utils.ExtendedString(oItem.kama).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "0";
         _loc6_ = 0;
         while(_loc6_ < dofus.graphics.gapi.ui.gameresult.GameResultPlayerLight.MAX_DROPS_DISPLAYED)
         {
            _loc7_ = this["_ctr" + _loc6_];
            _loc7_.contentData = oItem.items[_loc6_];
            _loc7_._visible = _loc7_.contentData != undefined;
            _loc6_ = _loc6_ + 1;
         }
         this._ldrAllDrop._visible = oItem.items.length > dofus.graphics.gapi.ui.gameresult.GameResultPlayerLight.MAX_DROPS_DISPLAYED;
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
      this._ldrAllDrop.addEventListener("over",this);
      this._ldrAllDrop.addEventListener("out",this);
      this._pbXP.addEventListener("over",this);
      this._pbXP.addEventListener("out",this);
      this._ldrXP.addEventListener("over",this);
      this._ldrXP.addEventListener("out",this);
      this._ldrLockXp.addEventListener("over",this);
      this._ldrLockXp.addEventListener("out",this);
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < dofus.graphics.gapi.ui.gameresult.GameResultPlayerLight.MAX_DROPS_DISPLAYED)
      {
         _loc3_ = this["_ctr" + _loc2_];
         _loc3_.addEventListener("over",this);
         _loc3_.addEventListener("out",this);
         _loc3_.addEventListener("click",this);
         _loc2_ = _loc2_ + 1;
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
            this.gapi.showTooltip(this.getFormattedXPString());
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
         case this._ldrXP:
            this._mcList.gapi.showTooltip(this.api.lang.getText("EXPERIENCE_POINT_MULTIPLICATOR",[this._oItems.xpMultiplicator]));
            return;
         case this._ldrLockXp:
            this._mcList.gapi.showTooltip(this.api.lang.getText("XP_IS_LOCKED_TOOLTIP"));
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
   function getFormattedXPString()
   {
      if(this._sXP != undefined)
      {
         return this._sXP;
      }
      this._sXP = new ank.utils.ExtendedString(this._oItems.xp).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this._oItems.level != 200 ? this._oItems.maxxp : -1).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " <b>" + this.api.lang.getText("WORD_XP") + "</b>\n\n";
      if(this.api.datacenter.Player < 200)
      {
         this._sXP += this.api.lang.getText("NEXT_LEVEL") + " " + this.api.kernel.Console.getcurrentXPPercentText() + "\n" + this.api.lang.getText("REQUIRED") + " " + new ank.utils.ExtendedString(this.api.datacenter.Player.XPhigh - this.api.datacenter.Player.XP).addMiddleChar(" ",3) + "\n";
      }
      this._sXP += this.api.lang.getText("WORD_XP") + " " + this.api.lang.getText("XP_GUILD") + " : " + this._sGuildXP + "\n" + this.api.lang.getText("WORD_XP") + " " + this.api.lang.getText("XP_MOUNT") + " : " + this._sMountXP;
      return this._sXP;
   }
}
