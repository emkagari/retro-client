class dofus.datacenter.modreport.ModReportObject
{
   var _aStatesChanges;
   var _bArchived;
   var _nCategoryID;
   var _nScore;
   var _reporterPlayerEntityInfos;
   var _sChatConversation;
   var _sReporterCustomNote;
   var _sUUID;
   function ModReportObject(sUUID, nCategoryID, reporterPlayerEntityInfos, sChatConversation, sReporterCustomNote, nScore, bArchived, aStatesChanges)
   {
      this._sUUID = sUUID;
      this._nCategoryID = nCategoryID;
      this._reporterPlayerEntityInfos = reporterPlayerEntityInfos;
      this._sChatConversation = this.formatChatConversation(sChatConversation);
      this._sReporterCustomNote = sReporterCustomNote;
      this._nScore = nScore;
      this._bArchived = bArchived;
      this._aStatesChanges = aStatesChanges;
   }
   function formatChatConversation(sChatConversation)
   {
      var _loc3_ = _global.API;
      var _loc4_ = sChatConversation.split("\n");
      var _loc5_ = [];
      var _loc6_ = 0;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      while(_loc6_ < _loc4_.length)
      {
         _loc7_ = _loc4_[_loc6_];
         _loc8_ = _loc7_.split("|");
         if(_loc8_.length < 2)
         {
            _loc5_.push(_loc7_);
         }
         else
         {
            _loc9_ = _loc8_[0];
            _loc10_ = _loc8_[1];
            _loc11_ = _loc8_[2];
            if(_loc11_ != undefined && _loc11_.length > 0)
            {
               _loc12_ = _loc11_.split("!");
               _loc10_ = _loc3_.kernel.ChatManager.parseInlineItems(_loc10_,_loc12_,true);
            }
            _loc5_.push(_loc9_ + " : " + _loc10_);
         }
         _loc6_ = _loc6_ + 1;
      }
      return _loc5_.join("\n");
   }
   function getStatesChangesString()
   {
      var _loc2_ = "";
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < this._aStatesChanges.length)
      {
         _loc4_ = this._aStatesChanges[_loc3_];
         _loc2_ += "- " + _loc4_.creationInstantString + " " + _loc4_.state;
         if(_loc4_.issuerAccountPseudo != undefined)
         {
            _loc2_ += " by " + _loc4_.issuerAccountPseudo;
            if(_loc4_.issuerCustomNote != undefined && _loc4_.issuerCustomNote.length > 0)
            {
               _loc2_ += " : " + _loc4_.issuerCustomNote;
            }
         }
         _loc2_ += "\n";
         _loc3_ = _loc3_ + 1;
      }
      _loc2_ = _loc2_.substring(0,_loc2_.length - 1);
      return _loc2_;
   }
   function getTextForMakeReportUI(modReportCategory)
   {
      var _loc3_ = "=== PLAYER REPORT UUID " + this.UUID + " ===";
      _loc3_ += "\nReporter " + this._reporterPlayerEntityInfos.toString();
      _loc3_ += "\nCategory : " + modReportCategory.name + " (" + modReportCategory.categoryID + ")";
      _loc3_ += "\nCreation Date : " + this.creationInstantString;
      _loc3_ += "\nArchived : " + (!this._bArchived ? "No" : "Yes");
      _loc3_ += "\nScore : " + this._nScore;
      if(this._sReporterCustomNote != undefined && this._sReporterCustomNote.length > 0)
      {
         _loc3_ += "\nReporter Custom Note : " + this._sReporterCustomNote;
      }
      _loc3_ += "\nReport States Changes :\n" + this.getStatesChangesString();
      if(this._sChatConversation != undefined && this._sChatConversation.length > 0)
      {
         _loc3_ += "\nChat conversation :\n" + this._sChatConversation;
      }
      _loc3_ += "\n=== END PLAYER REPORT ===";
      return _loc3_;
   }
   function get UUID()
   {
      return this._sUUID;
   }
   function get categoryID()
   {
      return this._nCategoryID;
   }
   function get reporterPlayerEntityInfos()
   {
      return this._reporterPlayerEntityInfos;
   }
   function get creationInstant()
   {
      var _loc2_ = this._aStatesChanges[0];
      return _loc2_.creationInstant;
   }
   function get creationInstantString()
   {
      return new ank.utils.ExtendedDate(this.creationInstant).getFullDateTimeString();
   }
   function get chatConversation()
   {
      return this._sChatConversation;
   }
   function get reporterCustomNote()
   {
      return this._sReporterCustomNote;
   }
   function get lastStateChange()
   {
      return this._aStatesChanges[this._aStatesChanges.length - 1];
   }
   function get statesChanges()
   {
      return this._aStatesChanges;
   }
   function get isArchived()
   {
      return this._bArchived;
   }
   function get score()
   {
      return this._nScore;
   }
   function get dataGridObject()
   {
      return {UUID:this._sUUID,reporterName:this.reporterPlayerEntityInfos.characterName,score:this.score,hasCustomNote:this._sReporterCustomNote.length > 0,hasChatConversation:this._sChatConversation.length > 0,currentState:this.lastStateChange.state};
   }
}
