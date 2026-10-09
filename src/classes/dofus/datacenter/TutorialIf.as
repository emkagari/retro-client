class dofus.datacenter.TutorialIf extends dofus.datacenter.TutorialBloc
{
   var _mLeft;
   var _mNextBlocFalseID;
   var _mNextBlocTrueID;
   var _mRight;
   var _sOperator;
   function TutorialIf(sID, mLeft, sOperator, mRight, mNextBlocTrueID, mNextBlocFalseID)
   {
      super(sID,dofus.datacenter.TutorialBloc.TYPE_IF);
      this._mLeft = mLeft;
      this._sOperator = sOperator;
      this._mRight = mRight;
      this._mNextBlocTrueID = mNextBlocTrueID;
      this._mNextBlocFalseID = mNextBlocFalseID;
   }
   function get left()
   {
      return this._mLeft;
   }
   function get operator()
   {
      return this._sOperator;
   }
   function get right()
   {
      return this._mRight;
   }
   function get right_()
   {
      return this._mNextBlocTrueID;
   }
   function get nextBlocFalseID()
   {
      return this._mNextBlocFalseID;
   }
}
