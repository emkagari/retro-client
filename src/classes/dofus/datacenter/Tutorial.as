class dofus.datacenter.Tutorial extends Object
{
   var _bCanCancel;
   var _oBlocs;
   var _sRootBlocID;
   var _sRootExitBlocID;
   static var NORMAL_BLOC = 0;
   static var EXIT_BLOC = 1;
   function Tutorial(mcData)
   {
      super();
      this._oBlocs = {};
      this.setData(mcData.actions);
      this._sRootBlocID = mcData.rootBlocID;
      this._sRootExitBlocID = mcData.rootExitBlocID;
      this._bCanCancel = mcData.canCancel != undefined ? mcData.canCancel : true;
   }
   function get canCancel()
   {
      return this._bCanCancel;
   }
   function addBloc(oBloc)
   {
      this._oBlocs[oBloc.id] = oBloc;
   }
   function setData(aBlocs)
   {
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      var _loc17_;
      var _loc18_;
      var _loc19_;
      var _loc20_;
      var _loc21_;
      var _loc22_;
      while(_loc3_ < aBlocs.length)
      {
         _loc4_ = aBlocs[_loc3_];
         _loc5_ = Number(_loc4_[0]);
         switch(_loc5_)
         {
            case dofus.datacenter.TutorialBloc.TYPE_ACTION:
               _loc6_ = _loc4_[1];
               _loc7_ = _loc4_[2];
               _loc8_ = _loc4_[3];
               _loc9_ = _loc4_[4];
               _loc10_ = _loc4_[5];
               _loc11_ = new dofus.datacenter.TutorialAction(_loc6_,_loc7_,_loc8_,_loc9_,_loc10_);
               this.addBloc(_loc11_);
               break;
            case dofus.datacenter.TutorialBloc.TYPE_WAITING:
               _loc12_ = _loc4_[1];
               _loc13_ = Number(_loc4_[2]);
               _loc14_ = _loc4_[3];
               _loc15_ = new dofus.datacenter.TutorialWaiting(_loc12_,_loc13_,_loc14_);
               this.addBloc(_loc15_);
               break;
            case dofus.datacenter.TutorialBloc.TYPE_IF:
               _loc16_ = _loc4_[1];
               _loc17_ = _loc4_[2];
               _loc18_ = _loc4_[3];
               _loc19_ = _loc4_[4];
               _loc20_ = _loc4_[5];
               _loc21_ = _loc4_[6];
               _loc22_ = new dofus.datacenter.TutorialIf(_loc16_,_loc17_,_loc18_,_loc19_,_loc20_,_loc21_);
               this.addBloc(_loc22_);
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function getRootBloc()
   {
      return this._oBlocs[this._sRootBlocID];
   }
   function getRootExitBloc()
   {
      return this._oBlocs[this._sRootExitBlocID];
   }
   function getBloc(sBlocID)
   {
      return this._oBlocs[sBlocID];
   }
}
