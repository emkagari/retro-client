class dofus.datacenter.Question extends Object
{
   var _eaResponsesObjects;
   var _nQuestionID;
   var _sQuestionText;
   var api;
   function Question(nQuestionID, aResponsesID, aQuestionParams)
   {
      super();
      this.initialize(nQuestionID,aResponsesID,aQuestionParams);
   }
   function get id()
   {
      return this._nQuestionID;
   }
   function get label()
   {
      return this.api.lang.fetchString(this._sQuestionText);
   }
   function get responses()
   {
      return this._eaResponsesObjects;
   }
   function initialize(nQuestionID, aResponsesID, aQuestionParams)
   {
      this.api = _global.API;
      this._nQuestionID = nQuestionID;
      var _loc5_ = ank.utils.PatternDecoder.getDescription(this.api.lang.getDialogQuestionText(nQuestionID),aQuestionParams);
      if(dofus.Constants.DEBUG)
      {
         _loc5_ = _loc5_ + " (" + nQuestionID + ")";
      }
      this._sQuestionText = _loc5_;
      this._eaResponsesObjects = new ank.utils.ExtendedArray();
      var _loc6_ = 0;
      var _loc7_;
      while(_loc6_ < aResponsesID.length)
      {
         _loc7_ = Number(aResponsesID[_loc6_]);
         this._eaResponsesObjects.push({label:this.api.lang.fetchString(this.api.lang.getDialogResponseText(_loc7_)),id:_loc7_});
         _loc6_ = _loc6_ + 1;
      }
   }
}
