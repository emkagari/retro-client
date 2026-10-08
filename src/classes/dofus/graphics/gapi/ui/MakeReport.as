class dofus.graphics.gapi.ui.MakeReport extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bAllAccounts;
   var _bhReport;
   var _btnCancel;
   var _btnClose;
   var _btnHide;
   var _btnOk;
   var _btnSwitch;
   var _lblAllAccounts;
   var _lblComplementary;
   var _lblDescription;
   var _lblFindAccounts;
   var _lblJailDialog;
   var _lblPenal;
   var _lblReason;
   var _lblTarget;
   var _lblTargetName;
   var _mcTextInputBackground;
   var _nCurrentView;
   var _nRefreshVisuallyTimeout;
   var _sComplementary;
   var _sDescription;
   var _sFindAccounts;
   var _sJailDialog;
   var _sPenal;
   var _sReason;
   var _sTargetPseudos;
   var _taComplementary;
   var _taDescription;
   var _taFindAccounts;
   var _taJailDialog;
   var _taPenal;
   var _tiReasonName;
   var _winBackground;
   var _winBackgroundSmall;
   var addToQueue;
   var unloadThis;
   static var CLASS_NAME = "MakeReport";
   static var FIRST_VIEW = 0;
   static var FAPENAL_VIEW = 1;
   var _bIsDisplayed = true;
   function MakeReport()
   {
      super();
   }
   static function updateDescription(api, sContent)
   {
      var _loc4_ = api.datacenter.Temporary.Report;
      _loc4_.description = sContent;
      var _loc5_ = dofus.graphics.gapi.ui.MakeReport(api.ui.getUIComponent("MakeReport"));
      if(_loc5_ == undefined)
      {
         api.kernel.showMessage(undefined,"MakeReport UI not found","COMMANDS_CHAT");
         return undefined;
      }
      _loc5_.update(true);
   }
   function get isAllAccounts()
   {
      return this._bAllAccounts;
   }
   function set isAllAccounts(bAllAccounts)
   {
      this._bAllAccounts = bAllAccounts;
   }
   function get targetPseudos()
   {
      return this._sTargetPseudos;
   }
   function set targetPseudos(targetPseudos)
   {
      this._sTargetPseudos = targetPseudos;
   }
   function get description()
   {
      return this._sDescription;
   }
   function set description(description)
   {
      this._sDescription = description;
   }
   function get complementary()
   {
      return this._sComplementary;
   }
   function set complementary(sComplementary)
   {
      this._sComplementary = sComplementary;
   }
   function get jailDialog()
   {
      return this._sJailDialog;
   }
   function set jailDialog(sJailDialog)
   {
      this._sJailDialog = sJailDialog;
   }
   function get penal()
   {
      return this._sPenal;
   }
   function set penal(penal)
   {
      this._sPenal = penal;
   }
   function get findAccounts()
   {
      return this._sFindAccounts;
   }
   function set findAccounts(findAccounts)
   {
      this._sFindAccounts = findAccounts;
   }
   function get reason()
   {
      return this._sReason;
   }
   function set reason(reason)
   {
      this._sReason = reason;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.MakeReport.CLASS_NAME);
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
      this._btnHide.addEventListener("click",this);
      this._btnSwitch.addEventListener("click",this);
      this._taDescription.addEventListener("change",this);
      this._taComplementary.addEventListener("change",this);
      this._taFindAccounts.addEventListener("change",this);
      this._taJailDialog.addEventListener("change",this);
      this._taPenal.addEventListener("change",this);
      this._tiReasonName.addEventListener("change",this);
   }
   function initTexts()
   {
      this._winBackground.title = "Make Report";
      this._winBackgroundSmall.title = "Make Report";
      this._winBackgroundSmall._visible = false;
      this._lblTarget.text = "Target(s) :";
      this._lblReason.text = "Reason :";
      this._lblDescription.text = "Description :";
      this._lblJailDialog.text = "Jail dialog :";
      this._lblComplementary.text = "Comments :";
      this._lblAllAccounts.text = "All Accounts : " + (!this._bAllAccounts ? "No" : "Yes");
      this._btnOk.label = "Validate";
      this._btnCancel.label = "Cancel";
      this._btnSwitch.label = "Switch view";
      this._lblFindAccounts.text = "Find Accounts :";
      this._lblPenal.text = "Penal :";
   }
   function initData()
   {
      this._lblTargetName.text = this._sTargetPseudos;
      this._taDescription.text = this._sDescription;
      this._taComplementary.text = this._sComplementary;
      this._taFindAccounts.text = this._sFindAccounts;
      this._taJailDialog.text = this._sJailDialog;
      this._taPenal.text = this._sPenal;
      this._tiReasonName.text = this._sReason;
      this.showViewData(dofus.graphics.gapi.ui.MakeReport.FIRST_VIEW);
      var _loc2_ = dofus.graphics.gapi.ui.nmr.NewModReportAdmin(this.api.ui.getUIComponent("NewModReportAdmin"));
      if(_loc2_ != undefined && !_loc2_.isUIMinimized)
      {
         this.windowHidder();
      }
   }
   function showViewData(nView)
   {
      var _loc3_ = nView == dofus.graphics.gapi.ui.MakeReport.FIRST_VIEW;
      this._lblTarget._visible = _loc3_;
      this._tiReasonName._visible = _loc3_;
      this._lblReason._visible = _loc3_;
      this._lblDescription._visible = _loc3_;
      this._taDescription._visible = _loc3_;
      this._lblComplementary._visible = _loc3_;
      this._taComplementary._visible = _loc3_;
      this._lblAllAccounts._visible = _loc3_;
      this._lblTargetName._visible = _loc3_;
      this._mcTextInputBackground._visible = _loc3_;
      var _loc4_ = nView == dofus.graphics.gapi.ui.MakeReport.FAPENAL_VIEW;
      this._lblPenal._visible = _loc4_;
      this._lblFindAccounts._visible = _loc4_;
      this._lblJailDialog._visible = _loc4_;
      this._taFindAccounts._visible = _loc4_;
      this._taJailDialog._visible = _loc4_;
      this._taPenal._visible = _loc4_;
      this._nCurrentView = nView;
   }
   function makeReport()
   {
      if(!this.api.electron.enabled)
      {
         this.api.kernel.showMessage(undefined,"This feature is not compatible on a Flash Projector","ERROR_CHAT");
         return undefined;
      }
      if(this._sTargetPseudos == undefined || this._sTargetPseudos.length < 1)
      {
         this.api.kernel.showMessage(undefined,"Target(s) cannot be empty","ERROR_CHAT");
         return undefined;
      }
      if(this._sReason == undefined || this._sReason.length < 1)
      {
         this.api.kernel.showMessage(undefined,"Reason cannot be empty","ERROR_CHAT");
         return undefined;
      }
      if(this._sPenal == undefined || this._sPenal.length < 1)
      {
         this.api.kernel.showMessage(undefined,"Penal cannot be empty","ERROR_CHAT");
         return undefined;
      }
      var _loc2_ = this.api.datacenter.Temporary.Report;
      var _loc3_ = _loc2_.targetAccountPseudo;
      var _loc4_ = _loc2_.targetAccountId;
      var _loc5_ = _loc2_.sanctionnatedAccounts;
      this.api.electron.makeReport(this._sReason,_loc3_,_loc4_,_loc5_,this._sDescription,this._sFindAccounts,this._sPenal,this._sJailDialog,this._sComplementary);
      this.unloadThis();
   }
   function update(bPrintFeedback)
   {
      if(this._nRefreshVisuallyTimeout != undefined)
      {
         _global.clearTimeout(this._nRefreshVisuallyTimeout);
      }
      var _loc3_ = _global.setTimeout(this,"updateVisually",500,bPrintFeedback);
      this._nRefreshVisuallyTimeout = _loc3_;
   }
   function updateVisually(bPrintFeedback)
   {
      var _loc3_ = this.api.datacenter.Temporary.Report;
      this._sTargetPseudos = _loc3_.targetPseudos;
      this._lblTargetName.text = this._sTargetPseudos;
      if(_loc3_.description != undefined)
      {
         if(this._taDescription.text.length == 0)
         {
            this._sDescription = this._taDescription.tf.htmlText + _loc3_.description;
         }
         else
         {
            this._sDescription = this._taDescription.tf.htmlText + "\n" + _loc3_.description;
         }
         this._taDescription.text = this._sDescription;
         _loc3_.description = undefined;
      }
      if(_loc3_.complementary != undefined)
      {
         if(this._taComplementary.text.length == 0)
         {
            this._sComplementary = this._taComplementary.tf.htmlText + _loc3_.complementary;
         }
         else
         {
            this._sComplementary = this._taComplementary.tf.htmlText + "\n" + _loc3_.complementary;
         }
         this._taComplementary.text = this._sComplementary;
         _loc3_.complementary = undefined;
      }
      if(_loc3_.penal != undefined)
      {
         if(this._taPenal.text.length == 0)
         {
            this._sPenal = this._taPenal.tf.htmlText + _loc3_.penal;
         }
         else
         {
            this._sPenal = this._taPenal.tf.htmlText + "\n" + _loc3_.penal;
         }
         this._taPenal.text = this._sPenal;
         _loc3_.penal = undefined;
      }
      if(_loc3_.findAccounts != undefined)
      {
         this._sFindAccounts = this._taFindAccounts.tf.htmlText + "\n" + _loc3_.findAccounts;
         this._taFindAccounts.text = this._sFindAccounts;
         _loc3_.findAccounts = undefined;
      }
      if(bPrintFeedback)
      {
         this.api.kernel.showMessage(undefined,"Report updated","COMMANDS_CHAT");
      }
   }
   function windowHidder()
   {
      if(this._bIsDisplayed)
      {
         this._bIsDisplayed = false;
         this._btnHide.backgroundDown = "ButtonMaximizeDown";
         this._btnHide.backgroundUp = "ButtonMaximizeUp";
         this._btnHide.styleName = "OrangeButton";
         this._btnHide._x = 122;
         this._btnHide._y = 418;
      }
      else
      {
         this._bIsDisplayed = true;
         this._btnHide.backgroundDown = "ButtonMinimizeDown";
         this._btnHide.backgroundUp = "ButtonMinimizeUp";
         this._btnHide.styleName = "OrangeButton";
         this._btnHide._x = 694;
         this._btnHide._y = 43.95;
      }
      this._bhReport._visible = this._bIsDisplayed;
      this._btnCancel._visible = this._bIsDisplayed;
      this._btnClose._visible = this._bIsDisplayed;
      this._btnSwitch._visible = this._bIsDisplayed;
      this._btnOk._visible = this._bIsDisplayed;
      this._winBackground._visible = this._bIsDisplayed;
      this._winBackgroundSmall._visible = !this._bIsDisplayed;
      this._bhReport._visible = this._bIsDisplayed;
      if(this._nCurrentView == dofus.graphics.gapi.ui.MakeReport.FIRST_VIEW)
      {
         this._lblTarget._visible = this._bIsDisplayed;
         this._lblTargetName._visible = this._bIsDisplayed;
         this._lblReason._visible = this._bIsDisplayed;
         this._lblAllAccounts._visible = this._bIsDisplayed;
         this._lblDescription._visible = this._bIsDisplayed;
         this._lblComplementary._visible = this._bIsDisplayed;
         this._tiReasonName._visible = this._bIsDisplayed;
         this._taDescription._visible = this._bIsDisplayed;
         this._taComplementary._visible = this._bIsDisplayed;
         this._mcTextInputBackground._visible = this._bIsDisplayed;
      }
      else
      {
         this._lblPenal._visible = this._bIsDisplayed;
         this._lblJailDialog._visible = this._bIsDisplayed;
         this._lblFindAccounts._visible = this._bIsDisplayed;
         this._taPenal._visible = this._bIsDisplayed;
         this._taJailDialog._visible = this._bIsDisplayed;
         this._taFindAccounts._visible = this._bIsDisplayed;
      }
   }
   function destroy()
   {
      this.api.datacenter.Temporary.Report = undefined;
   }
   function change(oEvent)
   {
      var _loc3_ = oEvent.target;
      switch(_loc3_)
      {
         case this._taComplementary:
            this._sComplementary = _loc3_.text;
            break;
         case this._taDescription:
            this._sDescription = _loc3_.text;
            break;
         case this._taFindAccounts:
            this._sFindAccounts = _loc3_.text;
            break;
         case this._taPenal:
            this._sPenal = _loc3_.text;
            break;
         case this._tiReasonName:
            this._sReason = _loc3_.text;
            break;
         case this._taJailDialog:
            this._sJailDialog = _loc3_.text;
         default:
            return;
      }
   }
   function click(oEvent)
   {
      var _loc3_;
      switch(oEvent.target)
      {
         case this._btnHide:
            this.windowHidder();
            break;
         case this._btnOk:
            this.api.kernel.showMessage(undefined,"Validate the current report ?","CAUTION_YESNO",{name:"MakeReport",listener:this});
            break;
         case this._btnCancel:
         case this._btnClose:
            this.api.kernel.showMessage(undefined,"Are you sure you want to close this window ? \n\n(Warning ! The current report will be deleted)","CAUTION_YESNO",{name:"CloseWindow",listener:this});
            break;
         case this._btnSwitch:
            _loc3_ = this._nCurrentView != dofus.graphics.gapi.ui.MakeReport.FIRST_VIEW ? dofus.graphics.gapi.ui.MakeReport.FIRST_VIEW : dofus.graphics.gapi.ui.MakeReport.FAPENAL_VIEW;
            this.showViewData(_loc3_);
         default:
            return;
      }
   }
   function yes(oEvent)
   {
      switch(oEvent.target._name)
      {
         case "AskYesNoMakeReport":
            this.makeReport();
            break;
         case "AskYesNoCloseWindow":
            this.unloadThis();
         default:
            return;
      }
   }
}
