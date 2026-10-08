437222597 - 1;
class dofus.graphics.gapi.ui.FightOptionButtons extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnBlockJoiner;
   var _btnBlockJoinerExceptParty;
   var _btnBlockSpectators;
   var _btnFlag;
   var _btnHelp;
   var _btnTactic;
   var _btnToggleSprites;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "FightOptionButtons";
   function FightOptionButtons()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.FightOptionButtons.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initOption});
      this.addToQueue({object:this,method:this.initData});
   }
   function addListeners()
   {
      this._btnTactic.addEventListener("click",this);
      this._btnTactic.addEventListener("over",this);
      this._btnTactic.addEventListener("out",this);
      this._btnFlag.addEventListener("click",this);
      this._btnFlag.addEventListener("over",this);
      this._btnFlag.addEventListener("out",this);
      this._btnBlockJoinerExceptParty.addEventListener("click",this);
      this._btnBlockJoinerExceptParty.addEventListener("over",this);
      this._btnBlockJoinerExceptParty.addEventListener("out",this);
      this._btnBlockJoiner.addEventListener("click",this);
      this._btnBlockJoiner.addEventListener("over",this);
      this._btnBlockJoiner.addEventListener("out",this);
      this._btnHelp.addEventListener("click",this);
      this._btnHelp.addEventListener("over",this);
      this._btnHelp.addEventListener("out",this);
      this._btnBlockSpectators.addEventListener("click",this);
      this._btnBlockSpectators.addEventListener("over",this);
      this._btnBlockSpectators.addEventListener("out",this);
      this._btnToggleSprites.addEventListener("click",this);
      this._btnToggleSprites.addEventListener("over",this);
      this._btnToggleSprites.addEventListener("out",this);
   }
   function initData()
   {
      if(!this.api.datacenter.Game.isSpectator)
      {
         if(this.api.datacenter.Game.isRunning)
         {
            this.onGameRunning();
            return undefined;
         }
         if(!this.api.datacenter.Player.inParty)
         {
            this._btnBlockJoinerExceptParty._visible = false;
            this._btnTactic._x = 642;
         }
         else
         {
            if(this._btnBlockJoinerExceptParty.selected)
            {
               this.api.network.Fights.blockJoinerExceptParty();
            }
            this._btnTactic._x = 622;
         }
      }
      else
      {
         this._btnBlockJoinerExceptParty._visible = false;
         this._btnBlockJoiner._visible = false;
         this._btnHelp._visible = false;
         this._btnBlockSpectators._visible = false;
         this._btnFlag._visible = false;
         this._btnTactic._x = 722;
      }
      this._btnTactic.selected = this.api.datacenter.Game.isTacticMode;
      this._btnToggleSprites._visible = this.api.datacenter.Game.isSpectator;
      if(this._btnBlockSpectators.selected)
      {
         this.api.network.Fights.blockSpectators();
      }
      if(this._btnBlockJoiner.selected)
      {
         this.api.network.Fights.blockJoiner();
      }
   }
   function initOption()
   {
      this._btnBlockJoinerExceptParty.selected = this.api.kernel.OptionsManager.getOption("FightGroupAutoLock");
      this._btnBlockSpectators.selected = this.api.datacenter.Game.isSpectatorBlocked;
      this._btnBlockJoiner.selected = this.api.datacenter.Game.isFightBlocked;
      this._btnToggleSprites.selected = this.api.datacenter.Game.isCreatureMode;
   }
   function refreshTacticButton()
   {
      this._btnTactic.backgroundUp = "UI_FightOptionTacticModeUp";
      this._btnTactic.backgroundDown = "UI_FightOptionTacticModeDown";
   }
   function onGameRunning()
   {
      this._btnBlockJoinerExceptParty._visible = false;
      this._btnBlockJoiner._visible = false;
      this._btnHelp._visible = false;
      this._btnToggleSprites._visible = true;
      this._btnTactic._x = 662;
   }
   function click(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      switch(oEvent.target)
      {
         case this._btnTactic:
            _loc3_ = !this.api.datacenter.Game.isTacticMode;
            this.api.datacenter.Game.isTacticMode = _loc3_;
            this.api.gfx.activateTacticMode(this.api,_loc3_);
            break;
         case this._btnFlag:
            this.api.kernel.GameManager.switchToFlagSet();
            break;
         case this._btnBlockJoinerExceptParty:
            this.api.network.Fights.blockJoinerExceptParty();
            break;
         case this._btnBlockJoiner:
            _loc4_ = !this.api.datacenter.Game.isFightBlocked;
            this.api.datacenter.Game.isFightBlocked = _loc4_;
            this.api.network.Fights.blockJoiner();
            break;
         case this._btnHelp:
            _loc5_ = !this.api.datacenter.Game.isNeedingHelp;
            this.api.datacenter.Game.isNeedingHelp = _loc5_;
            this.api.network.Fights.needHelp();
            break;
         case this._btnBlockSpectators:
            if(this.api.datacenter.Map.isTournament)
            {
               _loc6_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoDisableSpectator",{title:this.api.lang.getText("QUESTION"),text:this.api.lang.getText("FIGHT_OPTION_SPECTATOR") + " ?"});
               _loc6_.addEventListener("yes",this);
               _loc6_.addEventListener("no",this);
            }
            else
            {
               _loc7_ = !this.api.datacenter.Game.isSpectatorBlocked;
               this.api.datacenter.Game.isSpectatorBlocked = _loc7_;
               this.api.network.Fights.blockSpectators();
            }
            break;
         case this._btnToggleSprites:
            if(!this.api.datacenter.Game.isRunning || _global.CONFIG.isExpo)
            {
               return undefined;
            }
            _loc8_ = !this.api.datacenter.Game.isCreatureMode;
            this.api.datacenter.Game.isCreatureMode = _loc8_;
            this.api.kernel.GameManager.applyCreatureModeFight(_loc8_);
         default:
            return;
      }
   }
   function yes()
   {
      var _loc2_ = !this.api.datacenter.Game.isSpectatorBlocked;
      this.api.datacenter.Game.isSpectatorBlocked = _loc2_;
      this.api.network.Fights.blockSpectators();
   }
   function no()
   {
      this._btnBlockSpectators.selected = !this._btnBlockSpectators.selected;
   }
   function over(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnTactic:
            this.gapi.showTooltip(this.api.lang.getText("TACTIC_MODE"));
            break;
         case this._btnFlag:
            this.gapi.showTooltip(this.api.lang.getText("FLAG_INDICATOR_HELP"));
            break;
         case this._btnBlockJoinerExceptParty:
            this.gapi.showTooltip(this.api.lang.getText("FIGHT_OPTION_BLOCKJOINEREXCEPTPARTY"));
            break;
         case this._btnBlockJoiner:
            this.gapi.showTooltip(this.api.lang.getText("FIGHT_OPTION_BLOCKJOINER"));
            break;
         case this._btnHelp:
            this.gapi.showTooltip(this.api.lang.getText("FIGHT_OPTION_HELP"));
            break;
         case this._btnBlockSpectators:
            this.gapi.showTooltip(this.api.lang.getText("FIGHT_OPTION_SPECTATOR"));
            break;
         case this._btnToggleSprites:
            this.gapi.showTooltip(this.api.lang.getText("FIGHT_OPTION_CREATURE"));
         default:
            return;
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function moveButtons(nDistance)
   {
      this._btnTactic._y += nDistance;
      this._btnFlag._y += nDistance;
      this._btnBlockJoinerExceptParty._y += nDistance;
      this._btnBlockJoiner._y += nDistance;
      this._btnHelp._y += nDistance;
      this._btnBlockSpectators._y += nDistance;
      this._btnToggleSprites._y += nDistance;
   }
}
