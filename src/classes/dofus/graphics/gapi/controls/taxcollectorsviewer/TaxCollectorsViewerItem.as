class dofus.graphics.gapi.controls.taxcollectorsviewer.TaxCollectorsViewerItem extends ank.gapi.core.UIBasicComponent
{
   var _btnLocate;
   var _btnPlayer0;
   var _btnPlayer1;
   var _btnPlayer2;
   var _btnPlayer3;
   var _btnPlayer4;
   var _btnPlayer5;
   var _btnPlayer6;
   var _btnState;
   var _lblArea;
   var _lblAttackersCount;
   var _lblName;
   var _lblSubArea;
   var _mcBackButtons;
   var _mcCollect;
   var _mcEnterFight;
   var _mcFight;
   var _mcIsMyTaxCollector;
   var _mcList;
   var _oItem;
   var _vcTimer;
   var addToQueue;
   function TaxCollectorsViewerItem()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      this._oItem.players.removeEventListener("modelChanged",this);
      this._oItem.attackers.removeEventListener("modelChanged",this);
      this._oItem = oItem;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      if(bUsed)
      {
         this._lblName.text = oItem.name;
         this._lblArea.text = oItem.areaName;
         _loc5_ = new dofus.datacenter.DofusMap(oItem.id);
         _loc6_ = _loc5_.mapName;
         if(_loc6_ != undefined)
         {
            if(oItem.areaName == oItem.subareaName || oItem.areaName == oItem.subareaName.substring(0,oItem.subareaName.indexOf(" (")))
            {
               this._lblSubArea.text = _loc6_;
            }
            else
            {
               this._lblSubArea.text = oItem.subareaName + " - " + _loc6_;
            }
         }
         else
         {
            this._lblSubArea.text = oItem.subareaName;
         }
         this._btnLocate.label = "[" + oItem.coordinates + "]";
         this._btnLocate._visible = true;
         this._mcIsMyTaxCollector._visible = oItem.isMine;
         this.showStateIcon();
         if(!_global.isNaN(oItem.timer))
         {
            _loc7_ = oItem.timer - (getTimer() - oItem.timerReference);
            _loc8_ = oItem.maxTimer / 1000;
            if(_loc7_ > 0)
            {
               this._vcTimer.startTimer(_loc7_ / 1000,_loc8_);
               this.showButtonsJoin(!_global.isNaN(oItem.maxPlayerCount) ? oItem.maxPlayerCount : 0);
            }
            else
            {
               this._vcTimer.stopTimer();
               this.showButtonsJoin(0);
            }
         }
         else
         {
            this._vcTimer.stopTimer();
            this.showButtonsJoin(0);
         }
         oItem.players.addEventListener("modelChanged",this);
         oItem.attackers.addEventListener("modelChanged",this);
         this.updateAttackers();
         this.updatePlayers();
      }
      else if(this._lblName.text != undefined)
      {
         this._lblName.text = "";
         this._lblArea.text = "";
         this._lblSubArea.text = "";
         this._btnLocate._visible = false;
         this._mcFight._visible = false;
         this._mcEnterFight._visible = false;
         this._mcCollect._visible = false;
         this._btnState._visible = false;
         this._mcIsMyTaxCollector._visible = false;
         this.hideButtonsJoin();
         this._vcTimer.stopTimer();
         this._lblAttackersCount._visible = false;
      }
      else
      {
         this.hideButtonsJoin();
         this._vcTimer.stopTimer();
      }
   }
   function init()
   {
      super.init(false);
      this._mcFight._visible = false;
      this._mcEnterFight._visible = false;
      this._mcCollect._visible = false;
      this._btnState._visible = false;
      this._lblAttackersCount._visible = false;
      this._mcIsMyTaxCollector._visible = false;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this._btnPlayer0._visible = this._btnPlayer1._visible = this._btnPlayer2._visible = this._btnPlayer3._visible = this._btnPlayer4._visible = this._btnPlayer5._visible = this._btnPlayer6._visible = false;
   }
   function addListeners()
   {
      this._btnPlayer0.addEventListener("click",this);
      this._btnPlayer1.addEventListener("click",this);
      this._btnPlayer2.addEventListener("click",this);
      this._btnPlayer3.addEventListener("click",this);
      this._btnPlayer4.addEventListener("click",this);
      this._btnPlayer5.addEventListener("click",this);
      this._btnPlayer6.addEventListener("click",this);
      this._btnPlayer0.addEventListener("over",this);
      this._btnPlayer1.addEventListener("over",this);
      this._btnPlayer2.addEventListener("over",this);
      this._btnPlayer3.addEventListener("over",this);
      this._btnPlayer4.addEventListener("over",this);
      this._btnPlayer5.addEventListener("over",this);
      this._btnPlayer6.addEventListener("over",this);
      this._btnState.addEventListener("over",this);
      this._btnPlayer0.addEventListener("out",this);
      this._btnPlayer1.addEventListener("out",this);
      this._btnPlayer2.addEventListener("out",this);
      this._btnPlayer3.addEventListener("out",this);
      this._btnPlayer4.addEventListener("out",this);
      this._btnPlayer5.addEventListener("out",this);
      this._btnPlayer6.addEventListener("out",this);
      this._btnState.addEventListener("out",this);
      this._vcTimer.addEventListener("endTimer",this);
      this._btnLocate.addEventListener("click",this);
      this._btnLocate.addEventListener("over",this);
      this._btnLocate.addEventListener("out",this);
      this._lblAttackersCount.enableOverEvents = true;
      this._lblAttackersCount.addEventListener("over",this);
      this._lblAttackersCount.addEventListener("out",this);
   }
   function showButtonsJoin(nPlayerCount)
   {
      this._mcBackButtons._visible = true;
      var _loc3_ = 0;
      while(_loc3_ < nPlayerCount)
      {
         this["_btnPlayer" + _loc3_]._visible = true;
         _loc3_ = _loc3_ + 1;
      }
      var _loc4_ = _loc3_;
      while(_loc4_ < 7)
      {
         this["_btnPlayer" + _loc4_]._visible = false;
         _loc4_ = _loc4_ + 1;
      }
   }
   function hideButtonsJoin()
   {
      this._mcBackButtons._visible = false;
      var _loc2_ = 0;
      while(_loc2_ < 7)
      {
         this["_btnPlayer" + _loc2_]._visible = false;
         _loc2_ = _loc2_ + 1;
      }
   }
   function updatePlayers()
   {
      var _loc2_ = this._oItem.players;
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      while(_loc3_ < _loc2_.length)
      {
         _loc4_ = this["_btnPlayer" + _loc3_];
         _loc5_ = _loc2_[_loc3_];
         _loc4_.iconClip.data = _loc5_;
         if(_loc5_.prio)
         {
            _loc4_.iconClip.icon = "Exclamation";
         }
         else
         {
            _loc4_.iconClip.icon = "";
         }
         _loc4_.params = {player:_loc5_};
         _loc3_ = _loc3_ + 1;
      }
      var _loc6_ = _loc3_;
      var _loc7_;
      while(_loc6_ < 7)
      {
         _loc7_ = this["_btnPlayer" + _loc6_];
         _loc7_.iconClip.data = null;
         _loc7_.iconClip.icon = "";
         _loc7_.params = {};
         _loc6_ = _loc6_ + 1;
      }
   }
   function updateAttackers()
   {
      this._lblAttackersCount._visible = true;
      var _loc2_;
      if(this._oItem.state == 1)
      {
         _loc2_ = this._oItem.attackers.length;
         this._lblAttackersCount.text = String(_loc2_);
      }
      else
      {
         this._lblAttackersCount.text = "-";
      }
   }
   function showStateIcon()
   {
      this._btnState._visible = true;
      this._mcFight._visible = this._oItem.state == 2;
      this._mcEnterFight._visible = this._oItem.state == 1;
      this._mcCollect._visible = this._oItem.state == 0;
      if(this._oItem.isMine)
      {
         this._mcCollect._y = 3.2;
         this._mcEnterFight._y = 1.8;
         this._mcFight._y = 12;
      }
      else
      {
         this._mcCollect._y = 11.2;
         this._mcEnterFight._y = 9.8;
         this._mcFight._y = 20;
      }
   }
   function click(oEvent)
   {
      var _loc0_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if((_loc0_ = oEvent.target) !== this._btnLocate)
      {
         _loc3_ = this._mcList.gapi.api;
         if(_loc3_.datacenter.Player.cantInteractWithTaxCollector)
         {
            return undefined;
         }
         _loc4_ = oEvent.target.params.player;
         _loc5_ = _loc4_.id == undefined ? -1 : _loc4_.id;
         if(_loc4_.id == _loc3_.datacenter.Player.ID)
         {
            _loc3_.network.Guild.leaveTaxCollector(this._oItem.id);
         }
         else
         {
            _loc6_ = _loc3_.datacenter.Player.guildInfos;
            if(_loc6_.isLocalPlayerDefender && _loc6_.defendedTaxCollectorID != this._oItem.id)
            {
               _loc3_.network.Guild.leaveTaxCollector(_loc6_.defendedTaxCollectorID);
            }
            _loc3_.network.Guild.joinTaxCollector(this._oItem.id,_loc5_);
         }
      }
      else
      {
         this._mcList.gapi.loadUIComponent("MapExplorer","MapExplorer",{mapID:this._oItem.mapID});
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
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      switch(oEvent.target)
      {
         case this._btnLocate:
            this._mcList.gapi.showTooltip(this._mcList.gapi.api.lang.getText("LOCATE"));
            return;
         case this._lblAttackersCount:
            _loc3_ = this._oItem.attackers.length;
            if(_loc3_ == 0)
            {
               return undefined;
            }
            _loc4_ = new String();
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc6_ = this._oItem.attackers[_loc5_];
               _loc4_ += "\n" + _loc6_.name + " (" + _loc6_.level + ")";
               _loc5_ = _loc5_ + 1;
            }
            this._mcList.gapi.showTooltip("<b>" + this._mcList.gapi.api.lang.getText("ATTACKERS") + " :</b>\n" + _loc4_);
            return;
            break;
         case this._btnState:
            _loc7_ = new String();
            switch(this._oItem.state)
            {
               case 0:
                  _loc7_ = this._mcList.gapi.api.lang.getText("TAX_IN_COLLECT");
                  break;
               case 1:
                  _loc7_ = this._mcList.gapi.api.lang.getText("TAX_IN_ENTERFIGHT");
                  break;
               case 2:
                  _loc7_ = this._mcList.gapi.api.lang.getText("TAX_IN_FIGHT");
            }
            if(this._oItem.showMoreInfo)
            {
               if(this._oItem.callerName != "?")
               {
                  _loc7_ += "\n" + this._mcList.gapi.api.lang.getText("OWNER_WORD") + " : " + this._oItem.callerName;
               }
               _loc8_ = new ank.utils.ExtendedDate(this._oItem.startDate);
               if(_loc8_.getFullYear() != 1970)
               {
                  _loc7_ += "\n" + this._mcList.gapi.api.lang.getText("TAX_COLLECTOR_START_DATE",[_loc8_.getDatePadded(),_loc8_.getMonthPadded(),_loc8_.getDofusFullYear(this._mcList.gapi.api),_loc8_.getHoursPadded(),_loc8_.getMinutesPadded()]);
               }
               if(this._oItem.lastHarvesterName != "?")
               {
                  _loc7_ += "\n" + this._mcList.gapi.api.lang.getText("LAST_HARVESTER_NAME") + " : " + this._oItem.lastHarvesterName;
               }
               _loc8_ = new ank.utils.ExtendedDate(this._oItem.lastHarvestDate);
               if(_loc8_.getFullYear() != 1970)
               {
                  _loc7_ += "\n" + this._mcList.gapi.api.lang.getText("TAX_COLLECTOR_LAST_DATE",[_loc8_.getDatePadded(),_loc8_.getMonthPadded(),_loc8_.getDofusFullYear(this._mcList.gapi.api),_loc8_.getHoursPadded(),_loc8_.getMinutesPadded()]);
               }
               if(this._oItem.isMine)
               {
                  _loc7_ += "\n\n" + this._mcList.gapi.api.lang.getText("TAXCOLLECTOR_IS_MINE");
               }
               _loc9_ = new Date();
               _loc10_ = this._oItem.nextHarvestDate - _loc9_.valueOf();
            }
            this._mcList.gapi.showTooltip(_loc7_);
            return;
         default:
            _loc11_ = oEvent.target.params.player;
            if(_loc11_ != undefined)
            {
               _loc12_ = _loc11_.name + " (" + _loc11_.level + ")";
               if(_loc11_.prio)
               {
                  _loc12_ += "\n" + this._mcList.gapi.api.lang.getText("PRIORITY_DEFENDER");
               }
               this._mcList.gapi.showTooltip(_loc12_);
            }
            return;
      }
   }
   function out(oEvent)
   {
      this._mcList.gapi.hideTooltip();
   }
   function endTimer(oEvent)
   {
      this._vcTimer.stopTimer();
      this.showButtonsJoin(0);
      this._oItem.state = 2;
      this.showStateIcon();
      this.updateAttackers();
      this._mcList.gapi.api.datacenter.Player.guildInfos.defendedTaxCollectorID = undefined;
   }
   function modelChanged(oEvent)
   {
      this._mcList.gapi.hideTooltip();
      this.updateAttackers();
      this.updatePlayers();
   }
}
