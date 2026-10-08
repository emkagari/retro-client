class dofus.datacenter.Quest extends Object
{
   var _bAccountQuest;
   var _bFinished;
   var _bRepeatableQuest;
   var _eoSteps;
   var _nID;
   var _oCurrentStep;
   var api;
   var sortOrder;
   function Quest(nID, bFinished, nSortOrder, bAccountQuest, bRepeatableQuest)
   {
      super();
      this.initialize(nID,bFinished,nSortOrder,bAccountQuest,bRepeatableQuest);
   }
   function get id()
   {
      return this._nID;
   }
   function get isFinished()
   {
      return this._bFinished;
   }
   function get isAccountQuest()
   {
      return this._bAccountQuest;
   }
   function get isRepeatableQuest()
   {
      return this._bRepeatableQuest;
   }
   function get name()
   {
      var _loc2_ = this.api.lang.getQuestText(this._nID);
      if(_loc2_ != null && dofus.Constants.DEBUG)
      {
         _loc2_ = _loc2_ + " (" + this._nID + ")";
      }
      return _loc2_;
   }
   function get currentStep()
   {
      return this._oCurrentStep;
   }
   function addStep(oStep)
   {
      this._eoSteps.addItemAt(oStep.id,oStep);
      if(oStep.isCurrent)
      {
         this._oCurrentStep = oStep;
      }
   }
   function getStep(nStepID)
   {
      return dofus.datacenter.QuestStep(this._oCurrentStep.allSteps.findFirstItem("id",nStepID).item);
   }
   function get allSteps()
   {
      return this.currentStep.allSteps;
   }
   function initialize(nID, bFinished, nSortOrder, bAccountQuest, bRepeatableQuest)
   {
      this.api = _global.API;
      this._eoSteps = new ank.utils.ExtendedObject();
      this._nID = nID;
      this._bFinished = bFinished;
      this.sortOrder = nSortOrder;
      this._bAccountQuest = bAccountQuest;
      this._bRepeatableQuest = bRepeatableQuest;
   }
}
