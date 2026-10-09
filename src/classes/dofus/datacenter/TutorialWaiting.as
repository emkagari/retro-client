class dofus.datacenter.TutorialWaiting extends dofus.datacenter.TutorialBloc
{
   var _nTimeout;
   var _oCases;
   function TutorialWaiting(sID, nTimeout, aCases)
   {
      super(sID,dofus.datacenter.TutorialBloc.TYPE_WAITING);
      this._nTimeout = nTimeout;
      this.setCases(aCases);
   }
   function get timeout()
   {
      return this._nTimeout != undefined ? this._nTimeout : 0;
   }
   function get cases()
   {
      return this._oCases;
   }
   function setCases(aCases)
   {
      this._oCases = {};
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      while(_loc3_ < aCases.length)
      {
         _loc4_ = aCases[_loc3_];
         _loc5_ = _loc4_[0];
         _loc6_ = _loc4_[1];
         _loc7_ = _loc4_[2];
         _loc8_ = new dofus.datacenter.TutorialWaitingCase(_loc5_,_loc6_,_loc7_);
         this._oCases[_loc5_] = _loc8_;
         _loc3_ = _loc3_ + 1;
      }
   }
}
