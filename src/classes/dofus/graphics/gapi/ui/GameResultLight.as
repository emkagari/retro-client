class dofus.graphics.gapi.ui.GameResultLight extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnCross;
   var _btnMaximize;
   var _lblBonus;
   var _lblChallenges;
   var _ldrChest;
   var _ldrCollector;
   var _mcChallengesPlacer;
   var _mcRollOver;
   var _oData;
   var _parent;
   var _sDrop;
   var _sdStars;
   var _winBackground;
   var addToQueue;
   var attachMovie;
   var gapi;
   var getNextHighestDepth;
   var unloadThis;
   static var CLASS_NAME = "GameResultLight";
   function GameResultLight()
   {
      super();
   }
   function set data(oData)
   {
      this._oData = oData;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.GameResultLight.CLASS_NAME);
      this._lblChallenges._visible = false;
      this._sdStars._visible = false;
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
      this._winBackground.title = this.api.lang.getText("GAME_RESULTS_SMALL");
      this._lblBonus.text = this.api.lang.getText("GAME_RESULTS_BONUS") + " :";
      this._sdStars.value = this.api.datacenter.Basics.aks_game_end_bonus;
      if(this._oData.challenges && this._oData.challenges.length)
      {
         this._lblChallenges._visible = true;
         this._lblChallenges.text = this.api.lang.getText("FIGHT_CHALLENGE_BONUS") + " :";
      }
   }
   function addListeners()
   {
      this._sdStars.addEventListener("over",this);
      this._sdStars.addEventListener("out",this);
      this._btnMaximize.addEventListener("click",this);
      this._btnCross.addEventListener("click",this);
      this._mcRollOver.onRollOver = function()
      {
         this._parent.over({target:this});
      };
      this._mcRollOver.onRollOut = function()
      {
         this._parent.out({target:this});
      };
   }
   function initData()
   {
      var _loc3_ = this._oData.currentPlayerInfosWithChest.length > 0;
      var _loc4_ = this._oData.collectors[0].items.length > 0;
      var _loc2_;
      switch(this._oData.fightType)
      {
         case 0:
            _loc2_ = "UI_GameResultTeamLight";
            if(this._sdStars.value > -1)
            {
               this._sdStars._visible = true;
               this._lblBonus._visible = true;
            }
            break;
         case 1:
            if(!this.api.datacenter.Player.rank.enable)
            {
               _loc2_ = "UI_GameResultTeamLight";
            }
            else
            {
               _loc2_ = "UI_GameResultTeamLightPVP";
            }
            this._lblBonus._visible = false;
            this._mcChallengesPlacer._visible = false;
      }
      !_loc3_ ? this.attachMovie(_loc2_,"_tCurrentPlayer",10,{dataProvider:this._oData.currentPlayerInfos}) : this.attachMovie(_loc2_,"_tCurrentPlayer",10,{dataProvider:this._oData.currentPlayerInfosWithChest});
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc0_;
      var _loc10_;
      if(this._oData.challenges && this._oData.challenges.length)
      {
         _loc5_ = 17 + 5;
         _loc6_ = this._oData.challenges.length;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = this._oData.challenges[_loc7_];
            _loc9_ = dofus.graphics.gapi.controls.FightChallengeIcon(this.attachMovie("FightChallengeIcon","fci" + _loc7_,this.getNextHighestDepth(),{challenge:_loc8_,displayUiOnClick:_loc8_.canOpenAchievement,displayTextField:false}));
            var _temp_2 = _loc9_;
            var _temp_1 = "_width";
            _loc9_._height = _loc0_ = 17;
            _temp_2[_temp_1] = _loc0_;
            _loc10_ = _loc6_ - 1 - _loc7_;
            _loc9_._x = this._mcChallengesPlacer._x - _loc10_ * _loc5_;
            _loc9_._y = this._mcChallengesPlacer._y;
            _loc7_ = _loc7_ + 1;
         }
      }
      if(_loc4_)
      {
         this._ldrCollector.enabled = true;
         this._ldrCollector.contentPath = dofus.Constants.GUILDS_MINI_PATH + "6000.swf";
         this._ldrCollector.addEventListener("over",this);
         this._ldrCollector.addEventListener("out",this);
      }
      if(_loc3_)
      {
         if(_loc4_)
         {
            this._ldrChest._x += 20;
         }
         this._ldrChest.enabled = true;
         this._ldrChest.contentPath = dofus.Constants.GUILDS_MINI_PATH + "1083.swf";
         this._ldrChest.addEventListener("over",this);
         this._ldrChest.addEventListener("out",this);
      }
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnCross:
            this.callClose();
            break;
         case this._btnMaximize:
            this.api.ui.loadUIComponent("GameResult","GameResult",{data:this._oData},{bAlwaysOnTop:true});
            this.api.kernel.OptionsManager.setOption("UseLightEndFightUI",false);
            this.callClose();
         default:
            return;
      }
   }
   function over(oEvent)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent.target)
      {
         case this._sdStars:
            this.gapi.showTooltip(this.api.lang.getText("GAME_RESULTS_BONUS_TOOLTIP",[this._sdStars.value]));
            break;
         case this._mcRollOver:
            this.gapi.showTooltip(this.api.lang.getText("TURNS_NUMBER") + " : <b>" + this._oData.currentTableTurn + "</b>\n" + this.api.lang.getText("DURATION") + " : " + this.api.kernel.GameManager.getDurationString(this._oData.duration,true));
            break;
         case this._ldrChest:
            this.gapi.showTooltip(this.api.lang.getText("INFOS_211"));
            break;
         case this._ldrCollector:
            if(this._sDrop == undefined)
            {
               this._sDrop = this.api.lang.getText("TAX_COLLECTOR_HAS_HARVEST") + " : \n\n";
               _loc3_ = 0;
               while(_loc3_ < this._oData.collectors[0].items.length)
               {
                  _loc4_ = this._oData.collectors[0].items[_loc3_];
                  if(_loc3_ > 0)
                  {
                     this._sDrop += "\n";
                  }
                  this._sDrop += _loc4_.Quantity + " x " + _loc4_.name;
                  _loc3_ = _loc3_ + 1;
               }
            }
            this.gapi.showTooltip(this._sDrop);
         default:
            return;
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
