class dofus.graphics.gapi.controls.ConquestJoinViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bNoUnsubscribe;
   var _btnAttackers;
   var _btnPlayer;
   var _btnReservist;
   var _lblAttackersCount;
   var _lblAttackersTitle;
   var _lblJoinFight;
   var _lblJoinFightDetails;
   var _lblReservists;
   var _lblTeam;
   var _mcErrorBackground;
   var _nMaxPlayerCount;
   var _vcTimer;
   var addToQueue;
   static var CLASS_NAME = "ConquestJoinViewer";
   static var TEAM_COUNT = 7;
   static var RESERVIST_COUNT = 35;
   var _nTimer = -1;
   var _nMaxTimer = -1;
   var _nTimerReference = -1;
   function ConquestJoinViewer()
   {
      super();
   }
   function set error(value)
   {
      if(value != 0 && this._mcErrorBackground.text == undefined)
      {
         return;
      }
      var _loc0_;
      switch(Number(value))
      {
         case 0:
            var _temp_4 = this._lblJoinFightDetails;
            var _temp_3 = "_visible";
            var _temp_2 = this._lblJoinFight;
            var _temp_1 = "_visible";
            this._mcErrorBackground._visible = _loc0_ = false;
            _temp_2[_temp_1] = _loc0_;
            _temp_4[_temp_3] = _loc0_;
            break;
         case -1:
            this._mcErrorBackground.text = this.api.lang.getText("CONQUEST_JOIN_FIGHT_NOFIGHT");
            var _temp_8 = this._lblJoinFightDetails;
            var _temp_7 = "_visible";
            var _temp_6 = this._lblJoinFight;
            var _temp_5 = "_visible";
            this._mcErrorBackground._visible = _loc0_ = true;
            _temp_6[_temp_5] = _loc0_;
            _temp_8[_temp_7] = _loc0_;
            this._bNoUnsubscribe = true;
            break;
         case -2:
            this._mcErrorBackground.text = this.api.lang.getText("CONQUEST_JOIN_FIGHT_INFIGHT");
            var _temp_12 = this._lblJoinFightDetails;
            var _temp_11 = "_visible";
            var _temp_10 = this._lblJoinFight;
            var _temp_9 = "_visible";
            this._mcErrorBackground._visible = _loc0_ = true;
            _temp_10[_temp_9] = _loc0_;
            _temp_12[_temp_11] = _loc0_;
            this._bNoUnsubscribe = true;
            break;
         case -3:
            this._mcErrorBackground.text = this.api.lang.getText("CONQUEST_JOIN_FIGHT_NONE");
            var _temp_16 = this._lblJoinFightDetails;
            var _temp_15 = "_visible";
            var _temp_14 = this._lblJoinFight;
            var _temp_13 = "_visible";
            this._mcErrorBackground._visible = _loc0_ = true;
            _temp_14[_temp_13] = _loc0_;
            _temp_16[_temp_15] = _loc0_;
            this._bNoUnsubscribe = true;
      }
   }
   function set timer(value)
   {
      this._nTimer = value;
      this.updateTimer();
   }
   function set maxTimer(value)
   {
      this._nMaxTimer = value;
      this.updateTimer();
   }
   function set timerReference(value)
   {
      this._nTimerReference = value;
      this.updateTimer();
   }
   function set maxTeamPositions(value)
   {
      this._nMaxPlayerCount = value;
      this.showButtonsJoin(value);
   }
   function set noUnsubscribe(value)
   {
      this._bNoUnsubscribe = value;
   }
   function get noUnsubscribe()
   {
      return this._bNoUnsubscribe;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.ConquestJoinViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      var _loc2_ = 0;
      while(_loc2_ < dofus.graphics.gapi.controls.ConquestJoinViewer.TEAM_COUNT)
      {
         this._btnPlayer._visible = false;
         _loc2_ = _loc2_ + 1;
      }
      var _loc3_ = 0;
      while(_loc3_ < dofus.graphics.gapi.controls.ConquestJoinViewer.RESERVIST_COUNT)
      {
         this._btnReservist._visible = false;
         _loc3_ = _loc3_ + 1;
      }
   }
   function addListeners()
   {
      this.api.datacenter.Conquest.players.removeEventListener("modelChanged",this);
      this.api.datacenter.Conquest.attackers.removeEventListener("modelChanged",this);
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < dofus.graphics.gapi.controls.ConquestJoinViewer.TEAM_COUNT)
      {
         _loc3_ = ank.gapi.controls.Button(this["_btnPlayer" + _loc2_]);
         _loc3_.addEventListener("click",this);
         _loc3_.addEventListener("over",this);
         _loc3_.addEventListener("out",this);
         _loc2_ = _loc2_ + 1;
      }
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < dofus.graphics.gapi.controls.ConquestJoinViewer.RESERVIST_COUNT)
      {
         _loc5_ = ank.gapi.controls.Button(this["_btnReservist" + _loc4_]);
         _loc5_.addEventListener("click",this);
         _loc5_.addEventListener("over",this);
         _loc5_.addEventListener("out",this);
         _loc4_ = _loc4_ + 1;
      }
      this._btnAttackers.addEventListener("over",this);
      this._btnAttackers.addEventListener("out",this);
      this.api.datacenter.Conquest.players.addEventListener("modelChanged",this);
      this.api.datacenter.Conquest.attackers.addEventListener("modelChanged",this);
      this._vcTimer.addEventListener("endTimer",this);
   }
   function initTexts()
   {
      this._lblAttackersTitle.text = this.api.lang.getText("CONQUEST_JOIN_FIGHTERS");
      this._lblTeam.text = this.api.lang.getText("CONQUEST_JOIN_RESERVISTS");
      this._lblJoinFight.text = this.api.lang.getText("CONQUEST_JOIN_FIGHT");
      this._lblReservists.text = this.api.lang.getText("ATTACKERS");
   }
   function initData()
   {
      this._lblAttackersCount.text = String(this.api.datacenter.Conquest.attackers.length);
      this.updatePlayers();
   }
   function updatePlayers()
   {
      var _loc2_ = this.api.datacenter.Conquest.players;
      var _loc3_ = 0;
      var _loc4_ = 0;
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      while(_loc5_ < _loc2_.length)
      {
         _loc6_ = _loc2_[_loc5_];
         _loc7_ = null;
         if(_loc6_.reservist)
         {
            _loc7_ = this["_btnReservist" + _loc4_++];
         }
         else
         {
            _loc7_ = this["_btnPlayer" + _loc3_++];
         }
         _loc7_.iconClip.data = _loc6_;
         _loc7_.params = {player:_loc6_};
         _loc5_ = _loc5_ + 1;
      }
      var _loc8_ = _loc3_;
      var _loc9_;
      while(_loc8_ < dofus.graphics.gapi.controls.ConquestJoinViewer.TEAM_COUNT)
      {
         _loc9_ = this["_btnPlayer" + _loc8_];
         _loc9_.iconClip.data = null;
         _loc9_.params = {};
         _loc8_ = _loc8_ + 1;
      }
      var _loc10_ = _loc4_;
      var _loc11_;
      while(_loc10_ < dofus.graphics.gapi.controls.ConquestJoinViewer.RESERVIST_COUNT)
      {
         _loc11_ = this["_btnReservist" + _loc10_];
         _loc11_.iconClip.data = null;
         _loc11_.params = {};
         _loc10_ = _loc10_ + 1;
      }
   }
   function updateAttackers()
   {
      var _loc2_ = this.api.datacenter.Conquest.attackers.length;
      this._lblAttackersCount.text = String(_loc2_);
      this._btnAttackers._visible = _loc2_ > 0;
   }
   function updateTimer()
   {
      var _loc2_;
      var _loc3_;
      if(!_global.isNaN(this._nTimer) && (this._nTimer > 0 && (!_global.isNaN(this._nMaxTimer) && (this._nMaxTimer > 0 && (!_global.isNaN(this._nTimerReference) && this._nTimerReference > 0)))))
      {
         _loc2_ = this._nTimer - (getTimer() - this._nTimerReference);
         _loc3_ = this._nMaxTimer / 1000;
         if(_loc2_ > 0)
         {
            this._vcTimer.startTimer(_loc2_ / 1000,_loc3_);
            this.showButtonsJoin(!_global.isNaN(this._nMaxPlayerCount) ? this._nMaxPlayerCount : 0);
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
   }
   function showButtonsJoin(nPlayerCount)
   {
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
   function click(oEvent)
   {
      if(this.api.datacenter.Player.cantInteractWithPrism)
      {
         return undefined;
      }
      var _loc3_ = oEvent.target.params.player;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if(_loc3_ != undefined)
      {
         if(_loc3_.id == this.api.datacenter.Player.ID)
         {
            this.api.network.Conquest.prismFightLeave();
         }
         else
         {
            _loc4_ = this.api.datacenter.Conquest.players.findFirstItem("id",this.api.datacenter.Player.ID);
            if(_loc4_.index == -1)
            {
               return undefined;
            }
            if(_loc3_.reservist)
            {
               if(_loc4_.item.reservist)
               {
                  return undefined;
               }
               _loc5_ = this.api.ui.createPopupMenu();
               _loc5_.addStaticItem(_loc3_.name);
               _loc5_.addItem(this.api.lang.getText("CONQUEST_SWITCH_AS_RESERVIST"),this.api.network.Conquest,this.api.network.Conquest.switchPlaces,[_loc3_.id]);
               _loc5_.show(_root._xmouse,_root._ymouse);
            }
            else
            {
               if(!_loc4_.item.reservist)
               {
                  return undefined;
               }
               _loc6_ = this.api.ui.createPopupMenu();
               _loc6_.addStaticItem(_loc3_.name);
               _loc6_.addItem(this.api.lang.getText("CONQUEST_SWITCH_AS_PLAYER"),this.api.network.Conquest,this.api.network.Conquest.switchPlaces,[_loc3_.id]);
               _loc6_.show(_root._xmouse,_root._ymouse);
            }
         }
      }
      else
      {
         this.api.network.Conquest.prismFightJoin();
      }
   }
   function modelChanged(event)
   {
      this.api.ui.hideTooltip();
      this.updateAttackers();
      this.updatePlayers();
   }
   function over(oEvent)
   {
      var _loc0_;
      var _loc7_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if((_loc0_ = oEvent.target) !== this._btnAttackers)
      {
         _loc7_ = oEvent.target.params.player;
         if(_loc7_ != undefined)
         {
            this.api.ui.showTooltip(_loc7_.name + " (" + _loc7_.level + ")");
         }
      }
      else
      {
         _loc3_ = this.api.datacenter.Conquest.attackers.length;
         if(_loc3_ == 0)
         {
            return undefined;
         }
         _loc4_ = new String();
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = this.api.datacenter.Conquest.attackers[_loc5_];
            _loc4_ += "\n" + _loc6_.name + " (" + _loc6_.level + ")";
            _loc5_ = _loc5_ + 1;
         }
         this.api.ui.showTooltip("<b>" + this.api.lang.getText("ATTACKERS") + " :</b>\n " + _loc4_);
      }
   }
   function out(oEvent)
   {
      this.api.ui.hideTooltip();
   }
   function endTimer(oEvent)
   {
      this._vcTimer.stopTimer();
      this.showButtonsJoin(0);
      this.updateAttackers();
   }
}
