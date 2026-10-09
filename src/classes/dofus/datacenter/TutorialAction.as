class dofus.datacenter.TutorialAction extends dofus.datacenter.TutorialBloc
{
   var _aParams;
   var _bKeepLastWaitingBloc;
   var _mNextBlocID;
   var _sActionCode;
   function TutorialAction(sID, sActionCode, aParams, mNextBlocID, bKeepLastWaitingBloc)
   {
      super(sID,dofus.datacenter.TutorialBloc.TYPE_ACTION);
      this._sActionCode = sActionCode;
      this._aParams = aParams;
      this._mNextBlocID = mNextBlocID;
      this._bKeepLastWaitingBloc = bKeepLastWaitingBloc;
   }
   function get actionCode()
   {
      return this._sActionCode;
   }
   function get params()
   {
      return this._aParams;
   }
   function get nextBlocID()
   {
      return this._mNextBlocID;
   }
   function get keepLastWaitingBloc()
   {
      return this._bKeepLastWaitingBloc == true;
   }
}
