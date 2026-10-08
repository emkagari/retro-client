class dofus.datacenter.TutorialBloc extends Object
{
   var _nType;
   var _sID;
   static var TYPE_ACTION = 0;
   static var TYPE_WAITING = 1;
   static var TYPE_IF = 2;
   function TutorialBloc(sID, nType)
   {
      super();
      this._sID = sID;
      this._nType = nType;
   }
   function get id()
   {
      return this._sID;
   }
   function get type()
   {
      return this._nType;
   }
}
