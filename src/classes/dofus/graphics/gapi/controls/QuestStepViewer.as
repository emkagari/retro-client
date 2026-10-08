class dofus.graphics.gapi.controls.QuestStepViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnDialog;
   var _lblObjectives;
   var _lblRewards;
   var _lblStep;
   var _ldrAccountQuest;
   var _ldrRepeatableQuest;
   var _lstObjectives;
   var _lstRewards;
   var _oStep;
   var _txtDescription;
   var addToQueue;
   var gapi;
   var initialized;
   static var CLASS_NAME = "QuestStepViewer";
   function QuestStepViewer()
   {
      super();
   }
   function set step(oStep)
   {
      this._oStep = oStep;
      if(this.initialized)
      {
         this.updateData();
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.QuestStepViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.updateData});
      this._btnDialog._visible = false;
   }
   function addListeners()
   {
      this._btnDialog.addEventListener("click",this);
      this._btnDialog.addEventListener("over",this);
      this._btnDialog.addEventListener("out",this);
      this._ldrAccountQuest.addEventListener("over",this);
      this._ldrAccountQuest.addEventListener("out",this);
      this._ldrRepeatableQuest.addEventListener("over",this);
      this._ldrRepeatableQuest.addEventListener("out",this);
      this._lstObjectives.addEventListener("itemSelected",this);
   }
   function initTexts()
   {
      this._lblStep.text = this.api.lang.getText("QUESTS_OBJECTIVES");
      this._lblObjectives.text = this.api.lang.getText("STEP");
      this._lblRewards.text = this.api.lang.getText("QUESTS_REWARDS");
   }
   function updateData()
   {
      if(this._oStep != undefined)
      {
         this._lblObjectives.text = this.api.lang.getText("STEP") + " : " + this._oStep.name;
         this._txtDescription.text = this._oStep.description;
         this._lstObjectives.dataProvider = this._oStep.objectives;
         this._lstRewards.dataProvider.removeAll();
         this._lstRewards.dataProvider = this._oStep.rewards;
         this._btnDialog._visible = this._oStep.dialogID != undefined;
         this._ldrAccountQuest._visible = !this._oStep.isAccountQuest ? false : true;
         this._ldrRepeatableQuest._visible = !this._oStep.isRepeatableQuest ? false : true;
      }
   }
   function over(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      switch(oEvent.target)
      {
         case this._btnDialog:
            _loc3_ = this._oStep.dialogID;
            _loc4_ = this._oStep.dialogParams;
            _loc5_ = new dofus.datacenter.Question(_loc3_,undefined,_loc4_);
            this.gapi.showTooltip(this.api.lang.getText("STEP_DIALOG") + " :\n\n" + _loc5_.label);
            break;
         case this._ldrAccountQuest:
            this.gapi.showTooltip(this.api.lang.getText("STEP_ACCOUNT_INFO"));
            break;
         case this._ldrRepeatableQuest:
            this.gapi.showTooltip(this.api.lang.getText("STEP_REPEATABLE_INFO"));
         default:
            return;
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function click(oEvent)
   {
      var _loc0_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if((_loc0_ = oEvent.target) === this._btnDialog)
      {
         _loc3_ = this._oStep.dialogID;
         _loc4_ = this._oStep.dialogParams;
         _loc5_ = new dofus.datacenter.Question(_loc3_,undefined,_loc4_);
         this.api.kernel.showMessage(this.api.lang.getText("STEP_DIALOG"),_loc5_.label,"ERROR_BOX");
      }
   }
   function itemSelected(oEvent)
   {
      var _loc3_ = oEvent.row.item;
      if(_loc3_.x != undefined && _loc3_.y != undefined)
      {
         this.api.kernel.GameManager.updateCompass(_loc3_.x,_loc3_.y);
      }
   }
}
