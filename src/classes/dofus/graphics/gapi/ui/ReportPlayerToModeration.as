class dofus.graphics.gapi.ui.ReportPlayerToModeration extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bTargetIsOffline;
   var _btnCancel;
   var _btnClose;
   var _btnIgnoreToo;
   var _btnLinkChatConversation;
   var _btnOk;
   var _cbReason;
   var _lblComplementary;
   var _lblIgnoreToo;
   var _lblLinkChatConversation;
   var _lblReason;
   var _lblTarget;
   var _oCurrentCategory;
   var _sComplementary;
   var _sTargetID;
   var _sTargetName;
   var _taComplementary;
   var _taFakeCategory;
   var _winBackground;
   var addToQueue;
   var unloadThis;
   static var CLASS_NAME = "ReportPlayerToModeration";
   static var MAX_COMPLEMENTARY_CHARACTERS_COUNT = 280;
   function ReportPlayerToModeration()
   {
      super();
   }
   function get targetID()
   {
      return this._sTargetID;
   }
   function set targetID(sTargetID)
   {
      this._sTargetID = sTargetID;
   }
   function get targetName()
   {
      return this._sTargetName;
   }
   function set targetName(sTargetName)
   {
      this._sTargetName = sTargetName;
   }
   function get targetIsOffline()
   {
      return this._bTargetIsOffline;
   }
   function set targetIsOffline(bTargetIsOffline)
   {
      this._bTargetIsOffline = bTargetIsOffline;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.ReportPlayerToModeration.CLASS_NAME);
   }
   function callClose()
   {
      this.unloadThis();
      return true;
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
      this._btnClose.addEventListener("click",this);
      this._btnOk.addEventListener("click",this);
      this._btnLinkChatConversation.addEventListener("click",this);
      this._btnIgnoreToo.addEventListener("click",this);
      this._taComplementary.addEventListener("change",this);
      this._cbReason.addEventListener("itemSelected",this);
      this._cbReason.addEventListener("itemRollOver",this);
      this._cbReason.addEventListener("itemRollOut",this);
      this._btnLinkChatConversation.addEventListener("over",this);
      this._btnLinkChatConversation.addEventListener("out",this);
   }
   function initTexts()
   {
      this._winBackground.title = this.api.lang.getText("REPORT_PLAYER");
      this._lblTarget.text = this.api.lang.getText("REPORTED_PLAYER") + " : " + this._sTargetName;
      this._lblReason.text = this.api.lang.getText("REASON_WORD") + " :";
      this._lblLinkChatConversation.text = this.api.lang.getText("LINK_MY_CHAT_HISTORY");
      this._lblIgnoreToo.text = this.api.lang.getText("BLACKLIST_MESSAGE_AUTHOR") + " (" + this.api.lang.getText("BLACKLIST_TEMPORARLY") + ")";
      this._lblComplementary.text = this.api.lang.getText("COMPLEMENTARY_INFOS");
      this._btnOk.label = this.api.lang.getText("VALIDATE");
      this._btnCancel.label = this.api.lang.getText("CANCEL_SMALL");
   }
   function initData()
   {
      if(this._sTargetID == undefined || (this._sTargetName == undefined || this._bTargetIsOffline == undefined))
      {
         this.api.kernel.showMessage(undefined,"*se parle à soi même* faudrait peut être que tu te mettes au café, sis...","ERROR_CHAT");
         this.unloadThis();
         return undefined;
      }
      this._sComplementary = "";
      this._taComplementary.maxChars = dofus.graphics.gapi.ui.ReportPlayerToModeration.MAX_COMPLEMENTARY_CHARACTERS_COUNT;
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = this.api.datacenter.Player.modReportSessionData.ModReportCategories.getItems();
      var _loc4_ = new ank.utils.ExtendedArray();
      var _loc5_;
      for(var k in _loc3_)
      {
         _loc5_ = _loc3_[k];
         if(_loc5_ instanceof dofus.datacenter.modreport.ModReportCategory)
         {
            if(_loc5_.isRequiringOfflineCharacter && !this._bTargetIsOffline)
            {
               continue;
            }
            if(_loc5_.isRequiringOnlineCharacter && this._bTargetIsOffline)
            {
               continue;
            }
            _loc4_.push({label:_loc5_.label,id:_loc5_.categoryID,value:_loc5_});
         }
      }
      _loc4_.sortOn("label");
      _loc2_.push({id:dofus.datacenter.modreport.ModReportCategory.NOT_A_CATEGORY_ID,label:"(" + this.api.lang.getText("PLEASE_SELECT") + ")"});
      var _loc6_ = 0;
      while(_loc6_ < _loc4_.length)
      {
         _loc2_.push(_loc4_[_loc6_]);
         _loc6_ = _loc6_ + 1;
      }
      this._cbReason.dataProvider = _loc2_;
      this._cbReason.selectedIndex = 0;
      this.updateButtonsVisibilityByCategory(dofus.datacenter.modreport.ModReportCategory.NOT_A_CATEGORY_ID);
   }
   function updateButtonsVisibilityByCategory(nCategoryID, oCategory)
   {
      if(nCategoryID == dofus.datacenter.modreport.ModReportCategory.NOT_A_CATEGORY_ID)
      {
         this._btnIgnoreToo._visible = false;
         this._lblIgnoreToo._visible = false;
         this._btnLinkChatConversation._visible = false;
         this._lblLinkChatConversation._visible = false;
         this._taComplementary._visible = false;
         this._lblComplementary._visible = false;
         this._btnOk.enabled = false;
         this._taFakeCategory._visible = false;
         this._oCurrentCategory = undefined;
      }
      else
      {
         if(oCategory.isFakeCategory)
         {
            this._taFakeCategory.text = oCategory.fakeCategoryRedirectionText;
         }
         this._taFakeCategory._visible = oCategory.isFakeCategory;
         this._btnIgnoreToo._visible = !oCategory.isFakeCategory;
         this._btnIgnoreToo.selected = true;
         this._lblIgnoreToo._visible = !oCategory.isFakeCategory;
         this._btnLinkChatConversation._visible = !oCategory.isFakeCategory && oCategory.isAllowIncludeChatConversation;
         if(this._btnLinkChatConversation._visible)
         {
            this._btnLinkChatConversation.selected = true;
            this._btnLinkChatConversation.disabledStyle = oCategory.isForceIncludeChatConversation;
            this._btnLinkChatConversation.disableClickEvents = this._btnLinkChatConversation.disabledStyle;
         }
         this._lblLinkChatConversation._visible = !oCategory.isFakeCategory && oCategory.isAllowIncludeChatConversation;
         this._taComplementary._visible = !oCategory.isFakeCategory && oCategory.isAllowIncludeCustomText;
         this._lblComplementary._visible = !oCategory.isFakeCategory && oCategory.isAllowIncludeCustomText;
         this._btnOk.enabled = !oCategory.isFakeCategory;
         this._oCurrentCategory = oCategory;
      }
   }
   function itemSelected(oEvent)
   {
      var _loc0_;
      var _loc3_;
      if((_loc0_ = oEvent.target._name) === "_cbReason")
      {
         _loc3_ = oEvent.item;
         this.updateButtonsVisibilityByCategory(_loc3_.id,_loc3_.value);
      }
   }
   function itemRollOver(oEvent)
   {
      var _loc0_;
      var _loc3_;
      var _loc4_;
      if((_loc0_ = oEvent.owner._name) === "_cbReason")
      {
         _loc3_ = oEvent.item;
         if(_loc3_.id == dofus.datacenter.modreport.ModReportCategory.NOT_A_CATEGORY_ID)
         {
            this.api.ui.hideTooltip();
         }
         else
         {
            _loc4_ = _loc3_.value.description;
            if(_loc4_ == undefined || _loc4_.length == 0)
            {
               _loc4_ = this.api.lang.getText("NO_DESCRIPTION_FOR_THIS_CATEGORY");
            }
            this.api.ui.showTooltip(_loc4_);
         }
      }
   }
   function itemRollOut(oEvent)
   {
      this.api.ui.hideTooltip();
   }
   function destroy()
   {
   }
   function change(oEvent)
   {
      var _loc3_ = oEvent.target;
      var _loc0_;
      if((_loc0_ = _loc3_) === this._taComplementary)
      {
         this._sComplementary = _loc3_.text;
      }
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnOk:
            this.api.kernel.showMessage(undefined,this.api.lang.getText("REPORT_ANOTHER_PLAYER_CONFIRMATION_POPUP"),"CAUTION_YESNO",{name:"MakeReport",listener:this});
            break;
         case this._btnCancel:
         case this._btnClose:
            this.unloadThis();
         default:
            return;
      }
   }
   function over(oEvent)
   {
      var _loc0_;
      var _loc3_;
      if((_loc0_ = oEvent.target) === this._btnLinkChatConversation)
      {
         _loc3_ = this.api.lang.getText("LINK_MY_CHAT_HISTORY_TOOLTIP");
         this.api.ui.showTooltip(_loc3_);
      }
   }
   function out(oEvent)
   {
      this.api.ui.hideTooltip();
   }
   function yes(oEvent)
   {
      var _loc0_;
      var _loc3_;
      var _loc4_;
      if((_loc0_ = oEvent.target._name) === "AskYesNoMakeReport")
      {
         if(this._oCurrentCategory != undefined)
         {
            if(this._btnIgnoreToo.selected)
            {
               this.api.kernel.ChatManager.addToBlacklist(this._sTargetName);
               this.api.kernel.showMessage(undefined,this.api.lang.getText("TEMPORARY_BLACKLISTED",[this._sTargetName]),"INFO_CHAT");
            }
            _loc3_ = this._oCurrentCategory.isAllowIncludeChatConversation && (this._oCurrentCategory.isForceIncludeChatConversation || this._btnLinkChatConversation.selected);
            _loc4_ = !this._oCurrentCategory.isAllowIncludeCustomText ? "" : this._sComplementary;
            this.api.network.ModReport.sendCreateReportToModeration(this._sTargetID,this._oCurrentCategory.categoryID,_loc3_,_loc4_);
            this.unloadThis();
         }
      }
   }
}
