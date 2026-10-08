class dofus.datacenter.QuestObjective
{
   var _bFinished;
   var _nID;
   var api;
   function QuestObjective(nID, bFinished)
   {
      this.initialize(nID,bFinished);
   }
   function get id()
   {
      return this._nID;
   }
   function get description()
   {
      var _loc2_ = this.api.lang.getQuestObjectiveText(this._nID);
      var _loc3_ = _loc2_.t;
      var _loc4_ = _loc2_.p;
      var _loc5_ = [];
      var _loc6_ = this.api.lang.getQuestObjectiveTypeText(_loc3_);
      var _loc7_;
      var _loc8_;
      var _loc9_;
      switch(_loc3_)
      {
         case 13:
         case 14:
         case 17:
            break;
         case 0:
         case 4:
         case 11:
            _loc5_ = [_loc4_[0]];
            break;
         case 1:
         case 9:
         case 10:
            _loc5_ = [this.api.lang.getNonPlayableCharactersText(_loc4_[0]).n];
            break;
         case 2:
         case 3:
            _loc5_[0] = this.api.lang.getNonPlayableCharactersText(_loc4_[0]).n;
            _loc5_[1] = this.api.lang.getItemUnicText(_loc4_[1]).n;
            _loc5_[2] = _loc4_[2];
            break;
         case 5:
            _loc5_[0] = this.api.lang.getMapSubAreaName(_loc4_[0]);
            break;
         case 6:
         case 7:
            _loc5_[0] = this.api.lang.getMonstersText(_loc4_[0]).n;
            _loc5_[1] = _loc4_[1];
            break;
         case 8:
            _loc5_[0] = this.api.lang.getItemUnicText(_loc4_[0]).n;
            break;
         case 12:
            _loc5_[0] = this.api.lang.getNonPlayableCharactersText(_loc4_[0]).n;
            _loc5_[1] = this.api.lang.getMonstersText(_loc4_[1]).n;
            _loc5_[2] = _loc4_[2];
            break;
         case 15:
            _loc5_[0] = this.api.lang.getItemUnicText(_loc4_[0]).n;
            _loc5_[1] = _loc4_[1];
            break;
         case 16:
            _loc5_[0] = this.api.lang.getMonstersRaceText(_loc4_[0]).n;
            _loc5_[1] = _loc4_[1];
            _loc7_ = Number(_loc4_[1]);
            break;
         case 18:
            _loc5_[0] = this.api.lang.getNonPlayableCharactersText(_loc4_[0]).n;
            _loc8_ = this.api.lang.getMapSubAreaName(_loc4_[1]);
            _loc9_ = this.api.lang.getMapAreaText(this.api.lang.getMapSubAreaText(_loc4_[1]).a).n;
            _loc5_[1] = _loc9_ != _loc8_ ? _loc8_ + " (" + _loc9_ + ")" : _loc9_;
            _loc5_[2] = this.api.lang.getItemUnicText(_loc4_[2]).n;
            _loc5_[3] = _loc4_[3];
      }
      if(_loc6_ != null && !_global.isNaN(_loc7_))
      {
         _loc6_ = ank.utils.PatternDecoder.combine(_loc6_,"n",_loc7_ < 2);
      }
      if(_loc6_ != null && dofus.Constants.DEBUG)
      {
         _loc6_ = _loc6_ + " (" + this._nID + ")";
      }
      return ank.utils.PatternDecoder.getDescription(_loc6_,_loc5_);
   }
   function get isFinished()
   {
      return this._bFinished;
   }
   function get x()
   {
      return this.api.lang.getQuestObjectiveText(this._nID).x;
   }
   function get y()
   {
      return this.api.lang.getQuestObjectiveText(this._nID).y;
   }
   function initialize(nID, bFinished)
   {
      this.api = _global.API;
      this._nID = nID;
      this._bFinished = bFinished;
   }
}
