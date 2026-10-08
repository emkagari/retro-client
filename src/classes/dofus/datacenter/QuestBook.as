class dofus.datacenter.QuestBook
{
   var _eaQuests;
   function QuestBook()
   {
      this.initialize();
   }
   function get quests()
   {
      return this._eaQuests;
   }
   function getQuest(nID)
   {
      var _loc3_ = this._eaQuests.findFirstItem("id",nID);
      if(_loc3_.index != -1)
      {
         return _loc3_.item;
      }
      return null;
   }
   function initialize()
   {
      this._eaQuests = new ank.utils.ExtendedArray();
   }
}
