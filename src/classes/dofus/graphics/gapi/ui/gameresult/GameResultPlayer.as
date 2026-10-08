class dofus.graphics.gapi.ui.gameresult.GameResultPlayer extends ank.gapi.core.UIBasicComponent
{
   var _lblGuildXP;
   var _lblKama;
   var _lblLevel;
   var _lblMountXP;
   var _lblName;
   var _lblWinXP;
   var _ldrAllDrop;
   var _ldrGuild;
   var _ldrLockXp;
   var _ldrXP;
   var _mcItemPlacer;
   var _mcList;
   var _oItems;
   var _pbXP;
   var _sXP;
   var addToQueue;
   var api;
   static var MAX_DROPS_DISPLAYED = 10;
   function GameResultPlayer()
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
      var _loc0_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      if(bUsed)
      {
         switch(oItem.type)
         {
            case "monster":
            case "taxcollector":
            case "player":
               this._lblName.text = oItem.name;
               if(_global.isNaN(oItem.xp))
               {
                  var _temp_2 = this._pbXP;
                  var _temp_1 = "_visible";
                  this._pbXP.enabled = _loc0_ = !_global.isNaN(oItem.winxp);
                  _temp_2[_temp_1] = _loc0_;
                  this._ldrXP._visible = false;
                  this._ldrLockXp._visible = false;
               }
               else if(oItem.xpLocked)
               {
                  this._ldrLockXp._visible = true;
                  this._pbXP._visible = false;
               }
               else
               {
                  this._ldrLockXp._visible = false;
                  var _temp_4 = this._pbXP;
                  var _temp_3 = "_visible";
                  this._pbXP.enabled = _loc0_ = true;
                  _temp_4[_temp_3] = _loc0_;
                  var _temp_6 = this._pbXP;
                  var _temp_5 = "minimum";
                  this._pbXP.uberMinimum = _loc0_ = oItem.minxp;
                  _temp_6[_temp_5] = _loc0_;
                  var _temp_8 = this._pbXP;
                  var _temp_7 = "maximum";
                  this._pbXP.uberMaximum = _loc0_ = oItem.level != 200 ? oItem.maxxp : -1;
                  _temp_8[_temp_7] = _loc0_;
                  this._pbXP.value = oItem.xp;
                  this._pbXP.uberValue = oItem.xp - (!_global.isNaN(oItem.winxp) ? oItem.winxp : 0);
                  if(oItem.xpMultiplicator > 1)
                  {
                     this._ldrXP.contentPath = "BonusXPx" + oItem.xpMultiplicator;
                     this._ldrXP._visible = true;
                     this._lblName.width = 99;
                  }
                  else
                  {
                     this._ldrXP.contentPath = "";
                     this._ldrXP._visible = false;
                     this._lblName.width = 115;
                  }
               }
               this._lblWinXP.text = !(_global.isNaN(oItem.winxp) || !!oItem.xpLocked) ? new ank.utils.ExtendedString(oItem.winxp).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "";
               this._lblGuildXP.text = !_global.isNaN(oItem.guildxp) ? new ank.utils.ExtendedString(oItem.guildxp).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "";
               this._lblMountXP.text = !_global.isNaN(oItem.mountxp) ? new ank.utils.ExtendedString(oItem.mountxp).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "";
               this._lblKama.text = !_global.isNaN(oItem.kama) ? new ank.utils.ExtendedString(oItem.kama).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "";
               this._lblLevel.text = oItem.level;
               this._ldrGuild.contentPath = oItem.bDead != false ? "" : dofus.Constants.GUILDS_MINI_PATH + oItem.gfx + ".swf";
               this._mcItemPlacer._visible = oItem.bDead;
               _loc5_ = 0;
               while(_loc5_ < dofus.graphics.gapi.ui.gameresult.GameResultPlayer.MAX_DROPS_DISPLAYED)
               {
                  _loc6_ = this["_ctr" + _loc5_];
                  _loc6_.contentData = oItem.items[_loc5_];
                  _loc6_._visible = _loc6_.contentData != undefined;
                  _loc5_ = _loc5_ + 1;
               }
               this._ldrAllDrop._visible = oItem.items.length > dofus.graphics.gapi.ui.gameresult.GameResultPlayer.MAX_DROPS_DISPLAYED;
         }
      }
      else if(this._lblName.text != undefined)
      {
         this._pbXP._visible = false;
         this._lblName.text = "";
         this._lblName._width = 115;
         this._pbXP.minimum = 0;
         this._pbXP.maximum = 100;
         this._pbXP.value = 0;
         this._pbXP.uberValue = 0;
         this._lblWinXP.text = "";
         this._lblKama.text = "";
         this._ldrXP._visible = false;
         this._ldrXP.contentPath = "";
         this._mcItemPlacer._visible = false;
         this._ldrAllDrop._visible = false;
         _loc7_ = 0;
         while(_loc7_ < dofus.graphics.gapi.ui.gameresult.GameResultPlayer.MAX_DROPS_DISPLAYED)
         {
            _loc8_ = this["_ctr" + _loc7_];
            _loc8_.contentData = undefined;
            _loc7_ = _loc7_ + 1;
         }
      }
   }
   function init()
   {
      super.init(false);
      this._mcItemPlacer._visible = false;
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
      this._ldrXP.addEventListener("over",this);
      this._ldrXP.addEventListener("out",this);
      this._ldrLockXp.addEventListener("over",this);
      this._ldrLockXp.addEventListener("out",this);
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < dofus.graphics.gapi.ui.gameresult.GameResultPlayer.MAX_DROPS_DISPLAYED)
      {
         _loc4_ = this["_ctr" + _loc3_];
         _loc4_.addEventListener("over",this);
         _loc4_.addEventListener("out",this);
         _loc4_.addEventListener("click",this);
         _loc3_ = _loc3_ + 1;
      }
   }
   function click(oEvent)
   {
      var _loc3_ = oEvent.target.contentData;
      if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY) && _loc3_ != undefined)
      {
         this._mcList._parent.gapi.api.kernel.GameManager.insertItemInChat(_loc3_);
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
         case this._pbXP:
            this._mcList.gapi.showTooltip(this._oItems.id != this.api.datacenter.Player.ID ? new ank.utils.ExtendedString(this._oItems.xp).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this._oItems.level != 200 ? this._oItems.maxxp : -1).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " <b>" + this.api.lang.getText("WORD_XP") + "</b>" : this.getFormattedXPString());
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
   function getFormattedXPString()
   {
      if(this._sXP != undefined)
      {
         return this._sXP;
      }
      this._sXP = new ank.utils.ExtendedString(this._oItems.xp).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this._oItems.level != 200 ? this._oItems.maxxp : -1).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " <b>" + this.api.lang.getText("WORD_XP") + "</b>";
      if(this.api.datacenter.Player.Level < 200)
      {
         this._sXP += "</b>\n\n" + this.api.lang.getText("NEXT_LEVEL") + " " + this.api.kernel.Console.getcurrentXPPercentText() + "\n" + this.api.lang.getText("REQUIRED") + " " + new ank.utils.ExtendedString(this.api.datacenter.Player.XPhigh - this.api.datacenter.Player.XP).addMiddleChar(" ",3);
      }
      return this._sXP;
   }
}
