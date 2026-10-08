class dofus.managers.DailyQuestsManager extends Object
{
   var _bCanCollectReward;
   var _bMissionFinished;
   var _nCompletedTask;
   var _nMissionType;
   var _nTimeReset;
   var _oQuestState;
   var api;
   var dispatchEvent;
   static var _oMissionNpcData = {mapId:7409,npc:{id:605,gfx:8007,c1:-1,c2:-1,c3:-1,a:"0,0,0,0,0"}};
   var _eaDailyQuests = new ank.utils.ExtendedArray();
   function DailyQuestsManager()
   {
      super();
      mx.events.EventDispatcher.initialize(this);
      this.api = _global.API;
   }
   function get dailyQuests()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      for(var id in this._oQuestState)
      {
         _loc2_.push(this.api.lang.getDailyQuestData(Number(id)));
      }
      return _loc2_;
   }
   function get questState()
   {
      return this._oQuestState;
   }
   function set questState(oQuestState)
   {
      this._oQuestState = oQuestState;
      this.dispatchEvent({type:"updateData"});
   }
   function get missionNpc()
   {
      return dofus.managers.DailyQuestsManager._oMissionNpcData;
   }
   function set completedTask(nTask)
   {
      this._nCompletedTask = nTask;
   }
   function get completedTask()
   {
      return this._nCompletedTask;
   }
   function set missionType(nMissionType)
   {
      this._nMissionType = nMissionType;
   }
   function get missionType()
   {
      return this._nMissionType;
   }
   function set missionFinished(bMissionFinished)
   {
      this._bMissionFinished = bMissionFinished;
   }
   function get missionFinished()
   {
      return this._bMissionFinished;
   }
   function set canCollectReward(bCanCollectReward)
   {
      this._bCanCollectReward = bCanCollectReward;
   }
   function get canCollectReward()
   {
      return this._bCanCollectReward;
   }
   function set timeReset(nTimeReset)
   {
      this._nTimeReset = nTimeReset;
   }
   function get timeReset()
   {
      return this._nTimeReset;
   }
   function hasFinishedQuest(nId_)
   {
      return this._oQuestState[nId_] == "2";
   }
   function hasStartedQuest(nId_)
   {
      return this._oQuestState[nId_] == "1";
   }
}
