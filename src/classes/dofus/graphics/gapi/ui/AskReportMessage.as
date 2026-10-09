235987051 - 1;
class dofus.graphics.gapi.ui.AskReportMessage extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnCancel;
   var _btnIgnoreToo;
   var _btnOk;
   var _cbReason;
   var _lblGonnaReport;
   var _lblIgnoreToo;
   var _lblReason;
   var _sChannelId;
   var _sCharacterId;
   var _sCharacterName;
   var _sMessage;
   var _sMessageId;
   var _taMessage;
   var _winBackground;
   var addToQueue;
   var unloadThis;
   static var CLASS_NAME = "AskReportMessage";
   function AskReportMessage()
   {
      super();
   }
   function get message()
   {
      return this._sMessage;
   }
   function set message(msg)
   {
      this._sMessage = msg;
   }
   function get messageId()
   {
      return this._taMessage;
   }
   function set messageId(nObjectID)
   {
      this._taMessage = nObjectID;
   }
   function get authorId_()
   {
      return this._sCharacterId;
   }
   function set authorId_(id)
   {
      this._sCharacterId = id;
   }
   function get authorId()
   {
      return this._sMessageId;
   }
   function set authorId(sAuthorId)
   {
      this._sMessageId = sAuthorId;
   }
   function get authorName()
   {
      return this._sCharacterName;
   }
   function set authorName(name)
   {
      this._sCharacterName = name;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.AskReportMessage.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.initData});
   }
   function addListeners()
   {
      this._btnCancel.addEventListener("click",this);
      this._btnOk.addEventListener("click",this);
   }
   function initTexts()
   {
      this._winBackground.title = this.api.lang.getText("REPORT_A_SENTANCE");
      this._lblGonnaReport.text = this.api.lang.getText("GONNA_REPORT_THIS_MESSAGE");
      this._lblReason.text = this.api.lang.getText("REASON_WORD") + ":";
      this._lblIgnoreToo.text = this.api.lang.getText("BLACKLIST_MESSAGE_AUTHOR");
      this._btnOk.label = this.api.lang.getText("VALIDATE");
      this._btnCancel.label = this.api.lang.getText("CANCEL_SMALL");
   }
   function initData()
   {
      this._sChannelId.text = this._sMessage.split("<br/>").join("");
      this._btnIgnoreToo.selected = true;
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = this.api.lang.getAbuseReasons();
      _loc2_.push({id:-1,label:"(" + this.api.lang.getText("PLEASE_SELECT") + ")"});
      for(var i in _loc3_)
      {
         _loc2_.push({id:_loc3_[i].i,label:_loc3_[i].t});
      }
      this._cbReason.dataProvider = _loc2_;
      this._cbReason.selectedIndex = 0;
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnOk:
            if(this._cbReason.selectedItem.id > 0)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("REPORT_MESSAGE_CONFIRMATION"),"CAUTION_YESNO",{name:"ReportMessage",listener:this});
            }
            else
            {
               this.api.kernel.showMessage(this.api.lang.getText("ERROR_WORD"),this.api.lang.getText("ERROR_MUST_SELECT_A_REASON"),"ERROR_BOX");
            }
            break;
         case this._btnCancel:
            this.unloadThis();
         default:
            return;
      }
   }
   function yes(oEvent)
   {
      var _loc0_;
      var _loc3_;
      if((_loc0_ = oEvent.target._name) === "AskYesNoReportMessage")
      {
         _loc3_ = this._sMessage.substring(this._sMessage.indexOf(": ") + 7,this._sMessage.indexOf("</font>"));
         this.api.network.Chat.reportMessage(this._sCharacterName,this._taMessage,_loc3_,this._cbReason.selectedItem.id);
         if(this._btnIgnoreToo.selected)
         {
            this.api.kernel.ChatManager.addToBlacklist(this._sCharacterName);
            this.api.kernel.showMessage(undefined,this.api.lang.getText("TEMPORARY_BLACKLISTED_AND_REPORTED",[this._sCharacterName]),"INFO_CHAT");
         }
         else
         {
            this.api.kernel.showMessage(undefined,this.api.lang.getText("REPORTED",[this._sCharacterName]),"INFO_CHAT");
         }
         this.unloadThis();
      }
   }
   function no(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "AskYesNoReportMessage")
      {
         this.unloadThis();
      }
   }
}
