class dofus.graphics.gapi.ui.GameResult extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnCross;
   var _btnMinimize;
   var _lblBonus;
   var _lblChallenges;
   var _lblDuration;
   var _mcChallengesPlacer;
   var _oData;
   var _sdStars;
   var _winBackground;
   var addToQueue;
   var attachMovie;
   var gapi;
   var getNextHighestDepth;
   var unloadThis;
   static var CLASS_NAME = "GameResult";
   static var MAX_PLAYERS = 11;
   static var MAX_VISIBLE_PLAYERS_IN_TEAM = 6;
   function GameResult()
   {
      super();
   }
   function set data(oData)
   {
      this._oData = oData;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.GameResult.CLASS_NAME);
      this._lblChallenges._visible = false;
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.gapi.unloadLastUIAutoHideComponent();
   }
   function initTexts()
   {
      this._winBackground.title = this.api.lang.getText("GAME_RESULTS") + " - " + this.api.lang.getText("TURNS_NUMBER") + " : " + this._oData.currentTableTurn;
      this._lblDuration.text = this.api.kernel.GameManager.getDurationString(this._oData.duration,true);
      this._lblBonus.text = this.api.lang.getText("GAME_RESULTS_BONUS") + " :";
      this._sdStars.value = this.api.datacenter.Basics.aks_game_end_bonus;
      if(this._oData.challenges && this._oData.challenges.length)
      {
         this._lblChallenges._visible = true;
         this._lblChallenges.text = this.api.lang.getText("FIGHT_CHALLENGE_BONUS") + " :";
      }
      this._btnClose.label = this.api.lang.getText("CLOSE");
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._sdStars.addEventListener("over",this);
      this._sdStars.addEventListener("out",this);
      this._btnMinimize.addEventListener("click",this);
      this._btnCross.addEventListener("click",this);
   }
   function initData()
   {
      var _loc2_ = this._oData.winners.length;
      var _loc3_ = this._oData.loosers.length;
      var _loc4_ = this._oData.collectors.length;
      var _loc5_ = _loc2_ + _loc3_ + _loc4_;
      var _loc6_ = Math.min(_loc2_,dofus.graphics.gapi.ui.GameResult.MAX_VISIBLE_PLAYERS_IN_TEAM) * 20 + 65 + Math.min(_loc3_,dofus.graphics.gapi.ui.GameResult.MAX_VISIBLE_PLAYERS_IN_TEAM) * 20 + 65;
      if(_loc4_ > 0)
      {
         _loc6_ += Math.min(_loc4_,dofus.graphics.gapi.ui.GameResult.MAX_VISIBLE_PLAYERS_IN_TEAM) * 20 + 65;
      }
      var _loc7_ = _loc6_ + 32;
      var _loc8_ = ((_loc5_ <= dofus.graphics.gapi.ui.GameResult.MAX_PLAYERS ? this.gapi.screenHeight : 550) - _loc7_) / 2;
      var _loc9_ = this._winBackground._x + 10;
      var _loc10_ = _loc8_ + 32;
      var _loc11_ = Math.min(_loc2_,dofus.graphics.gapi.ui.GameResult.MAX_VISIBLE_PLAYERS_IN_TEAM) * 20 + 55 + _loc10_;
      var _loc12_ = Math.min(_loc3_,dofus.graphics.gapi.ui.GameResult.MAX_VISIBLE_PLAYERS_IN_TEAM) * 20 + 55 + _loc11_;
      var _loc13_;
      switch(this._oData.fightType)
      {
         case 0:
            _loc13_ = "UI_GameResultTeam";
            if(this._sdStars.value == -1)
            {
               this._sdStars._visible = false;
               this._lblBonus._visible = false;
            }
            break;
         case 1:
            _loc13_ = "UI_GameResultTeamPVP";
            this._lblBonus._visible = false;
            this._mcChallengesPlacer._visible = false;
            this._sdStars._visible = false;
      }
      this.attachMovie(_loc13_,"_tWinners",10,{dataProvider:this._oData.winners,title:this.api.lang.getText("WINNERS"),_x:_loc9_,_y:_loc10_});
      this.attachMovie(_loc13_,"_tLoosers",20,{dataProvider:this._oData.loosers,title:this.api.lang.getText("LOOSERS"),_x:_loc9_,_y:_loc11_});
      if(_loc4_ > 0)
      {
         this.attachMovie(_loc13_,"_tCollectors",30,{dataProvider:this._oData.collectors,title:this.api.lang.getText("GUILD_TAXCOLLECTORS"),_x:_loc9_,_y:_loc12_});
      }
      this._winBackground._y = _loc8_;
      this._winBackground.setSize(undefined,_loc7_);
      this._lblDuration._y = _loc8_ + 5;
      this._btnCross._y = _loc8_ + 9;
      this._btnMinimize._y = _loc8_ + 9;
      this._btnClose._y = this._winBackground._y + this._winBackground._height;
      this._lblBonus._y = this._winBackground._y + 25;
      this._sdStars._y = this._winBackground._y + 30;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      var _loc17_;
      var _loc18_;
      var _loc19_;
      var _loc20_;
      var _loc0_;
      if(this._oData.challenges && this._oData.challenges.length)
      {
         this._lblChallenges._y = this._lblBonus._y + 17;
         this._mcChallengesPlacer._y = this._lblBonus._y + 18;
         _loc14_ = 17;
         _loc15_ = _loc14_ + 5;
         _loc16_ = Math.max(0,this._oData.challenges.length - 3);
         _loc17_ = _loc16_ * _loc15_;
         this._mcChallengesPlacer._x -= _loc17_;
         this._lblChallenges._x -= _loc17_;
         _loc18_ = 0;
         while(_loc18_ < this._oData.challenges.length)
         {
            _loc19_ = this._oData.challenges[_loc18_];
            _loc20_ = dofus.graphics.gapi.controls.FightChallengeIcon(this.attachMovie("FightChallengeIcon","fci" + _loc18_,this.getNextHighestDepth(),{challenge:_loc19_,displayUiOnClick:_loc19_.canOpenAchievement,displayTextField:false}));
            var _temp_2 = _loc20_;
            var _temp_1 = "_width";
            _loc20_._height = _loc0_ = _loc14_;
            _temp_2[_temp_1] = _loc0_;
            _loc20_._x = this._mcChallengesPlacer._x + _loc18_ * _loc15_;
            _loc20_._y = this._mcChallengesPlacer._y;
            _loc18_ = _loc18_ + 1;
         }
      }
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnClose:
         case this._btnCross:
            this.callClose();
            break;
         case this._btnMinimize:
            if(this._oData.currentPlayerInfos.length != 0)
            {
               this.api.ui.loadUIComponent("GameResultLight","GameResultLight",{data:this._oData},{bAlwaysOnTop:false});
               this.api.kernel.OptionsManager.setOption("UseLightEndFightUI",true);
               this.callClose();
            }
            else
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_248"),"ERROR_CHAT");
            }
         default:
            return;
      }
   }
   function over(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._sdStars)
      {
         this.gapi.showTooltip(this.api.lang.getText("GAME_RESULTS_BONUS_TOOLTIP",[this._sdStars.value]));
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
