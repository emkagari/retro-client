class dofus.graphics.gapi.controls.temporis.TemporisGeneral extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aQuests;
   var _cbCursedDungeonProgression;
   var _cbDungeonProgression;
   var _cbGeneralProgression;
   var _cbInvadeProgression;
   var _cbTempotons;
   var _circleCursedDungeonProgression;
   var _circleDungeonProgression;
   var _circleGeneralProgression;
   var _circleInvadeProgression;
   var _circleTempotons;
   var _lblProgressionTitle;
   var _lblRewards;
   var addToQueue;
   var api;
   var gapi;
   static var CLASS_NAME = "TemporisGeneral";
   static var TEMPOTON_ID = 20064;
   function TemporisGeneral()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.temporis.TemporisGeneral.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initText});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initProgressBars});
   }
   function addListeners()
   {
      var ref = this;
      this._circleGeneralProgression.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._circleGeneralProgression.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._circleTempotons.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._circleTempotons.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._circleInvadeProgression.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._circleInvadeProgression.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._circleDungeonProgression.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._circleDungeonProgression.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._circleCursedDungeonProgression.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._circleCursedDungeonProgression.onRollOut = function()
      {
         ref.out({target:this});
      };
   }
   function initText()
   {
      this._lblProgressionTitle.text = this.api.lang.getText("PROGRESSION_FOLLOWUP");
      this._lblRewards.text = this.api.lang.getText("THE_REWARDS");
   }
   function initData()
   {
      if(this.api.datacenter.Player.temporisInfos == undefined)
      {
         this.api.datacenter.Player.temporisInfos = new dofus.datacenter.TemporisInfos(10000);
      }
      else
      {
         this.api.datacenter.Player.temporisInfos.initialize(true,10000);
      }
      var _loc2_ = this.api.lang.getConfigText("TEMPORIS_3_INVADE_COMPLETION_QUEST_ID");
      var _loc3_ = this.api.lang.getConfigText("TEMPORIS_3_DUNGEON_COMPLETION_QUEST_ID");
      var _loc4_ = this.api.lang.getConfigText("TEMPORIS_3_CURSED_DUNGEON_COMPLETION_QUEST_ID");
      this.api.network.Quests.getList();
      this.api.network.Quests.getStep(_loc2_);
      this.api.network.Quests.getStep(_loc3_);
      this.api.network.Quests.getStep(_loc4_);
   }
   function initProgressBars()
   {
      this._cbTempotons.maximum = this.api.lang.getConfigText("TEMPORIS_3_TEMPOTONS_MAX_COUNT");
      this._cbTempotons.value = this.api.datacenter.Player.getInventoryItemQuantityByUnicID(dofus.graphics.gapi.controls.temporis.TemporisGeneral.TEMPOTON_ID);
      var _loc2_ = this.api.lang.getConfigText("TEMPORIS_3_INVADE_COMPLETION_QUEST_ID");
      var _loc3_ = this.getQuestObjectivesProgress(_loc2_);
      this._cbInvadeProgression.maximum = _loc3_[1];
      this._cbInvadeProgression.value = _loc3_[0];
      var _loc4_ = this.api.lang.getConfigText("TEMPORIS_3_DUNGEON_COMPLETION_QUEST_ID");
      var _loc5_ = this.getQuestObjectivesProgress(_loc4_);
      this._cbDungeonProgression.maximum = _loc5_[1];
      this._cbDungeonProgression.value = _loc5_[0];
      var _loc6_ = this.api.lang.getConfigText("TEMPORIS_3_CURSED_DUNGEON_COMPLETION_QUEST_ID");
      var _loc7_ = this.getQuestStepsProgress(_loc6_,1312,7);
      this._cbCursedDungeonProgression.maximum = _loc7_[1];
      this._cbCursedDungeonProgression.value = _loc7_[0];
      this._cbGeneralProgression.value = (this._cbTempotons.trueValue + this._cbInvadeProgression.trueValue + this._cbDungeonProgression.trueValue + this._cbCursedDungeonProgression.trueValue) / 4;
   }
   function getQuestStepsProgress(nQuestId, nFirstStepId, nbStep)
   {
      var _loc5_ = this.getQuestById(nQuestId);
      if(_loc5_.isFinished)
      {
         return [100,100];
      }
      if(_loc5_ == undefined)
      {
         return [0,100];
      }
      var _loc6_ = 0;
      while(_loc6_ <= nbStep)
      {
         if(nFirstStepId + _loc6_ == _loc5_.currentStep.id)
         {
            return [_loc6_,nbStep];
         }
         _loc6_ = _loc6_ + 1;
      }
      return [0,nbStep];
   }
   function getQuestObjectivesProgress(nQuestId)
   {
      var _loc3_ = this.getQuestById(nQuestId);
      if(_loc3_.isFinished)
      {
         return [100,100];
      }
      if(_loc3_ == undefined || _loc3_.allSteps == undefined)
      {
         return [0,100];
      }
      var _loc4_ = _loc3_.allSteps;
      var _loc5_ = 0;
      var _loc6_ = 0;
      var _loc7_ = 0;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      while(_loc7_ < _loc4_.length)
      {
         _loc8_ = _loc4_[_loc7_].objectives;
         if(_loc8_ != undefined)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc8_.length)
            {
               _loc10_ = _loc8_[_loc9_];
               _loc5_ = _loc5_ + 1;
               if(_loc10_.isFinished)
               {
                  _loc6_ = _loc6_ + 1;
               }
               _loc9_ = _loc9_ + 1;
            }
         }
         _loc7_ = _loc7_ + 1;
      }
      return [_loc6_,_loc5_];
   }
   function setQuests(aQuests)
   {
      this._aQuests = aQuests;
      this.initProgressBars();
   }
   function isQuestFinished(nQuestId)
   {
      var _loc3_ = this.getQuestById(nQuestId);
      if(_loc3_ == undefined)
      {
         return false;
      }
      return _loc3_.isFinished;
   }
   function getQuestById(nQuestId)
   {
      var _loc3_ = this._aQuests;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_];
         if(_loc5_.id == nQuestId)
         {
            return _loc5_;
         }
         _loc4_ = _loc4_ + 1;
      }
      return undefined;
   }
   function isQuestStepFinished(oQuest, nQuestStepID)
   {
      if(oQuest == undefined)
      {
         return false;
      }
      var _loc4_ = oQuest.getStep(nQuestStepID);
      if(_loc4_ == undefined || _loc4_ == null)
      {
         return false;
      }
      return _loc4_.isFinished;
   }
   function questUpdated()
   {
      this.initProgressBars();
   }
   function circleBarFormattedToolTip(label, cb)
   {
      this.gapi.showTooltip(this.api.lang.getText(label) + " - " + Math.floor(100 * cb.value / cb.maximum) + "%");
   }
   function over(oEvent)
   {
      switch(oEvent.target)
      {
         case this._circleGeneralProgression:
            this.circleBarFormattedToolTip("GLOBAL_PROGRESSION",this._cbGeneralProgression);
            break;
         case this._circleTempotons:
            this.circleBarFormattedToolTip("PROGRESSION_TEMPOTONS",this._cbTempotons);
            break;
         case this._circleInvadeProgression:
            this.circleBarFormattedToolTip("PROGRESSION_INVADES",this._cbInvadeProgression);
            break;
         case this._circleDungeonProgression:
            this.circleBarFormattedToolTip("PROGRESSION_DUNGEONS",this._cbDungeonProgression);
            break;
         case this._circleCursedDungeonProgression:
            this.circleBarFormattedToolTip("PROGRESSION_CURSED_DUNGEONS",this._cbCursedDungeonProgression);
         default:
            return;
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
