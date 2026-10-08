class dofus.datacenter.TutorialWaitingCase extends Object
{
   var _aParams;
   var _mNextBlocID;
   var _sCode;
   static var CASE_TIMEOUT = "TIMEOUT";
   static var CASE_DEFAULT = "DEFAULT";
   function TutorialWaitingCase(sCode, aParams, mNextBlocID)
   {
      super();
      this._sCode = sCode;
      this._aParams = aParams;
      this._mNextBlocID = mNextBlocID;
   }
   function get code()
   {
      return this._sCode;
   }
   function get params()
   {
      return this._aParams;
   }
   function get nextBlocID()
   {
      return this._mNextBlocID;
   }
}
