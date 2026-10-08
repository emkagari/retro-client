class dofus.graphics.gapi.ui.gameresult.GameResultPlayerPVP extends ank.gapi.core.UIBasicComponent
{
   var _lblKama;
   var _lblLevel;
   var _lblName;
   var _lblRank;
   var _lblWinDisgrace;
   var _lblWinHonour;
   var _ldrAllDrop;
   var _ldrGuild;
   var _mcAlignment;
   var _mcItemPlacer;
   var _mcList;
   var _oItems;
   var _pbDisgrace;
   var _pbHonour;
   var addToQueue;
   var api;
   static var MAX_DROPS_DISPLAYED = 6;
   function GameResultPlayerPVP()
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
      var _loc9_;
      if(bUsed)
      {
         switch(oItem.type)
         {
            case "monster":
            case "taxcollector":
            case "player":
               this._lblName.text = oItem.name;
               if(oItem.rank == 0 && !this.api.datacenter.Basics.aks_current_server.isHardcore())
               {
                  this._pbHonour._visible = false;
                  this._lblWinHonour._visible = false;
                  this._pbDisgrace._visible = false;
                  this._lblWinDisgrace._visible = false;
                  this._lblRank._visible = false;
               }
               else
               {
                  this._pbHonour._visible = true;
                  this._pbDisgrace._visible = true;
                  this._lblWinDisgrace._visible = true;
                  this._lblWinHonour._visible = true;
                  this._lblRank._visible = true;
                  if(this.api.datacenter.Basics.aks_current_server.isHardcore())
                  {
                     if(_global.isNaN(oItem.minxp))
                     {
                        this._pbDisgrace._visible = false;
                     }
                     this._pbDisgrace.minimum = oItem.minxp;
                     this._pbDisgrace.maximum = oItem.maxxp;
                     this._pbDisgrace.value = oItem.xp;
                  }
                  else
                  {
                     var _temp_2 = this._pbDisgrace;
                     var _temp_1 = "minimum";
                     this._pbDisgrace.uberMinimum = _loc0_ = oItem.mindisgrace;
                     _temp_2[_temp_1] = _loc0_;
                     var _temp_4 = this._pbDisgrace;
                     var _temp_3 = "maximum";
                     this._pbDisgrace.uberMaximum = _loc0_ = oItem.maxdisgrace;
                     _temp_4[_temp_3] = _loc0_;
                     this._pbDisgrace.value = oItem.disgrace;
                     this._pbDisgrace.uberValue = oItem.disgrace - (!_global.isNaN(oItem.windisgrace) ? oItem.windisgrace : 0);
                  }
                  var _temp_6 = this._pbHonour;
                  var _temp_5 = "minimum";
                  this._pbHonour.uberMinimum = _loc0_ = oItem.minhonour;
                  _temp_6[_temp_5] = _loc0_;
                  var _temp_8 = this._pbHonour;
                  var _temp_7 = "maximum";
                  this._pbHonour.uberMaximum = _loc0_ = oItem.maxhonour;
                  _temp_8[_temp_7] = _loc0_;
                  if(oItem.winhonour >= 0)
                  {
                     this._pbHonour.value = oItem.honour;
                     this._pbHonour.uberValue = oItem.honour - oItem.winhonour;
                  }
                  else
                  {
                     this._pbHonour.value = oItem.honour - oItem.winhonour;
                     this._pbHonour.styleName = "BrownProgressBarLoss";
                     this._pbHonour.uberValue = oItem.honour;
                  }
               }
               this._lblWinHonour.text = !_global.isNaN(oItem.winhonour) ? new ank.utils.ExtendedString(oItem.winhonour).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "";
               if(!this.api.datacenter.Basics.aks_current_server.isHardcore())
               {
                  this._lblWinDisgrace.text = !_global.isNaN(oItem.windisgrace) ? oItem.windisgrace : "";
               }
               else
               {
                  this._lblWinDisgrace.text = !_global.isNaN(oItem.winxp) ? new ank.utils.ExtendedString(oItem.winxp).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "";
               }
               this._lblRank.text = !_global.isNaN(oItem.rank) ? oItem.rank : "";
               this._lblKama.text = !_global.isNaN(oItem.kama) ? oItem.kama : "";
               this._lblLevel.text = oItem.level;
               _loc5_ = oItem.alignment;
               if(this._lblRank._visible && _loc5_ > 0)
               {
                  this._mcAlignment.gotoAndStop(_loc5_ + 1);
               }
               this._ldrGuild.contentPath = oItem.bDead != false ? "" : dofus.Constants.GUILDS_MINI_PATH + oItem.gfx + ".swf";
               this._mcItemPlacer._visible = oItem.bDead;
               _loc6_ = 0;
               while(_loc6_ < dofus.graphics.gapi.ui.gameresult.GameResultPlayerPVP.MAX_DROPS_DISPLAYED)
               {
                  _loc7_ = this["_ctr" + _loc6_];
                  _loc7_.contentData = oItem.items[_loc6_];
                  _loc7_._visible = _loc7_.contentData != undefined;
                  _loc6_ = _loc6_ + 1;
               }
               this._ldrAllDrop._visible = oItem.items.length > dofus.graphics.gapi.ui.gameresult.GameResultPlayerPVP.MAX_DROPS_DISPLAYED;
         }
      }
      else if(this._lblName.text != undefined)
      {
         this._pbHonour._visible = false;
         this._lblName.text = "";
         this._pbHonour.minimum = 0;
         this._pbHonour.maximum = 100;
         this._pbHonour.value = 0;
         this._pbHonour.uberValue = 0;
         this._pbDisgrace.minimum = 0;
         this._pbDisgrace.maximum = 100;
         this._pbDisgrace.value = 0;
         this._pbDisgrace.uberValue = 0;
         this._lblWinHonour.text = "";
         this._lblWinDisgrace.text = "";
         this._lblKama.text = "";
         this._mcItemPlacer._visible = false;
         _loc8_ = 0;
         while(_loc8_ < dofus.graphics.gapi.ui.gameresult.GameResultPlayerPVP.MAX_DROPS_DISPLAYED)
         {
            _loc9_ = this["_ctr" + _loc8_];
            _loc9_.contentData = undefined;
            _loc8_ = _loc8_ + 1;
         }
      }
   }
   function init()
   {
      super.init(false);
      this._pbHonour._visible = false;
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
      this._pbHonour.addEventListener("over",this);
      this._pbHonour.addEventListener("out",this);
      this._pbDisgrace.addEventListener("over",this);
      this._pbDisgrace.addEventListener("out",this);
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < dofus.graphics.gapi.ui.gameresult.GameResultPlayerPVP.MAX_DROPS_DISPLAYED)
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
         case this._pbHonour:
            this._mcList.gapi.showTooltip(this._oItems.honour + " / " + this._oItems.maxhonour);
            return;
         case this._pbDisgrace:
            this._mcList.gapi.showTooltip(this._oItems.disgrace + " / " + this._oItems.maxdisgrace);
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
