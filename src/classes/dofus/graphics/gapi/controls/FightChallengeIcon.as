5689400 - 1;
class dofus.graphics.gapi.controls.FightChallengeIcon extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _ldr;
   var _ldrBackground;
   var _ldrState;
   var _nTotalBonus;
   var _nTotalDropBonus;
   var _nTotalXPBonus;
   var _parent;
   var _txtBonus;
   var addToQueue;
   var challenge;
   var createTextField;
   var gapi;
   var getNextHighestDepth;
   var onRelease;
   var onRollOut;
   var onRollOver;
   var width;
   var displayUiOnClick = true;
   var displayTextField = true;
   var _lastShowAsk = 0;
   function FightChallengeIcon()
   {
      super();
   }
   function update()
   {
      this._nTotalXPBonus = Number(this.challenge.teamXpBonus) + Number(this.challenge.basicXpBonus);
      this._nTotalDropBonus = Number(this.challenge.teamXpBonus) + Number(this.challenge.basicXpBonus);
      this._nTotalBonus = this._nTotalXPBonus;
      this.addToQueue({object:this,method:this.refreshStateIcon});
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initCpt});
   }
   function initCpt()
   {
      this._ldrBackground.contentPath = dofus.Constants.FIGHT_CHALLENGE_PATH + "0.swf";
      this._ldr.contentPath = this.challenge.iconPath;
      this.update();
      if(this.displayTextField)
      {
         this.addBonusTextfield();
      }
   }
   function addListeners()
   {
      if(this.displayUiOnClick)
      {
         this.onRelease = this.onEventRelease(this.api,this._parent,this,this.challenge);
      }
      this.onRollOver = this.virtualEvent(this,"over",this);
      this.onRollOut = this.virtualEvent(this,"out",this);
      this._ldrBackground.addEventListener("initialization",this);
   }
   function refreshStateIcon()
   {
      switch(this.challenge.state)
      {
         case 1:
            this._ldrState.contentPath = "ChallengeOK";
            break;
         case 2:
            this._ldrState.contentPath = "ChallengeKO";
         default:
            return;
      }
   }
   function onEventRelease(oApi, attachTarget, placer, challenge)
   {
      return function()
      {
         var _loc2_;
         switch(challenge.category)
         {
            case 0:
               if(attachTarget.FightChallengeViewer.challenge === challenge)
               {
                  MovieClip(attachTarget.FightChallengeViewer).removeMovieClip();
               }
               else
               {
                  MovieClip(attachTarget.FightChallengeViewer).removeMovieClip();
                  attachTarget.attachMovie("FightChallengeViewer","FightChallengeViewer",attachTarget.getNextHighestDepth(),{challenge:challenge});
               }
               break;
            case 1:
            case dofus.datacenter.FightChallengeData.ACHIEVEMENT_CATEGORY_INDEX:
               if(!challenge.canOpenAchievement)
               {
                  oApi.lang.getText("CANT_OPEN_ACHIEVEMENT_MERGED");
               }
               else
               {
                  _loc2_ = this.challenge.achievements[0];
                  oApi.ui.loadUIAutoHideComponent("Achievements","Achievements",{displayAchievement:_loc2_},{bStayIfPresent:true});
               }
            default:
               return;
         }
      };
   }
   function over(e)
   {
      var _loc3_ = this.api.lang.getFightChallenge(this.challenge.id);
      var _loc4_ = "<b>" + this.challenge.name + "</b>\n\n";
      if(this.challenge.targetId && (this.challenge.state == 0 && getTimer() - this._lastShowAsk >= 2400))
      {
         dofus.utils.Api(this.api).network.Game.showFightChallengeTarget(this.challenge.id);
         this._lastShowAsk = getTimer();
      }
      _loc4_ += this.challenge.description + "\n\n";
      switch(this.challenge.category)
      {
         case 0:
            _loc4_ += this.api.lang.getText("LOOT");
            _loc4_ += " : <b>+" + this._nTotalDropBonus + "%</b>\n";
            _loc4_ += this.api.lang.getText("WORD_XP");
            _loc4_ += " : <b>+" + this._nTotalXPBonus + "%</b>\n";
            break;
         case 1:
            _loc4_ += this.api.lang.getText("LOOT_TOKENS");
            _loc4_ += " : <b>+" + (Number(this.challenge.params[0]) + Number(this.challenge.params[1])) + "</b>\n";
            break;
         case dofus.datacenter.FightChallengeData.ACHIEVEMENT_CATEGORY_INDEX:
            if(this.challenge.canOpenAchievement)
            {
               _loc4_ += this.api.lang.getText("CLICK_TO_OPEN_THIS_CHALLENGE_ACHIEVEMENT") + "\n";
            }
      }
      _loc4_ += this.api.lang.getText("STATE") + " : ";
      switch(this.challenge.state)
      {
         case 0:
            _loc4_ += this.api.lang.getText("CURRENT_FIGHT_CHALLENGE");
            break;
         case 1:
            _loc4_ += this.api.lang.getText("FIGHT_CHALLENGE_DONE");
            break;
         case 2:
            _loc4_ += this.api.lang.getText("FIGHT_CHALLENGE_FAILED");
      }
      this.gapi.showTooltip(_loc4_);
   }
   function out(e)
   {
      this.gapi.hideTooltip();
   }
   function virtualEvent(context, callback, target)
   {
      return function()
      {
         context[callback]({target:target});
      };
   }
   function addBonusTextfield()
   {
      this.createTextField("_txtBonus",this.getNextHighestDepth(),0,36,this.width,14);
      this._txtBonus.embedFonts = true;
      this._txtBonus.text = this.challenge.category != 1 ? this._nTotalBonus + "%" : "+" + this._nTotalBonus;
      this._txtBonus.setTextFormat(new TextFormat("Font2",8,16777215,true,false,false,null,null,"center"));
      this._txtBonus.filters = [new flash.filters.GlowFilter(5391937,1,3,3,4,1)];
   }
   function setBackgroundColor()
   {
      var _loc2_ = this._ldrBackground.content.background;
      var _loc3_ = new Color(_loc2_);
      _loc3_.setRGB(dofus.Constants.CHALLENGE_BG_COLOR[this.challenge.category]);
   }
   function initialization(oEvent_)
   {
      this.setBackgroundColor();
   }
}
