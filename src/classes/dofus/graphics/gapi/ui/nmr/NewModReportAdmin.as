class dofus.graphics.gapi.ui.nmr.NewModReportAdmin extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aCases;
   var _bhReport;
   var _btnActionMarkAllReports;
   var _btnActionOpenPlayerPopupMenu;
   var _btnAddReportToMakeReport;
   var _btnClose;
   var _btnExitReportView;
   var _btnMinimize;
   var _btnMinimizeSmall;
   var _btnNext;
   var _btnOpenReporterPopupMenu;
   var _btnPrevious;
   var _dgCategories;
   var _dgReportsProcessed;
   var _dgReportsToProcess;
   var _lblContext;
   var _lblReporterContext;
   var _lblReporterCustomNote;
   var _lblReporterLinkedChatConversation;
   var _lblReportsProcessed;
   var _lblReportsToProcess;
   var _lblSelectedCategory;
   var _lblSelectedPlayerReport;
   var _selectedModReportCategory;
   var _selectedModReportObject;
   var _taContext;
   var _taReporterContext;
   var _taReporterCustomNote;
   var _taReporterLinkedChatConversation;
   var _winBackground;
   var _winBackgroundSmall;
   var addToQueue;
   var gapi;
   var unloadThis;
   static var CLASS_NAME = "NewModReportAdmin";
   var _nCurrentCaseIndex = 0;
   var _bMinimized = false;
   function NewModReportAdmin()
   {
      super();
   }
   function get isUIMinimized()
   {
      return this._bMinimized;
   }
   function get cases()
   {
      return this._aCases;
   }
   function set cases(aCases)
   {
      this._aCases = aCases;
   }
   function get casesBookCurrentPageID()
   {
      return this._nCurrentCaseIndex + 1;
   }
   function get casesBookLastPageID()
   {
      return this._aCases.length;
   }
   function get currentTargetCase()
   {
      return this._aCases[this._nCurrentCaseIndex];
   }
   function get nextTargetCase()
   {
      if(this._nCurrentCaseIndex + 1 >= this._aCases.length)
      {
         return undefined;
      }
      return this._aCases[this._nCurrentCaseIndex + 1];
   }
   function get previousTargetCase()
   {
      if(this._nCurrentCaseIndex == 0)
      {
         return undefined;
      }
      return this._aCases[this._nCurrentCaseIndex - 1];
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.nmr.NewModReportAdmin.CLASS_NAME);
   }
   function callClose()
   {
      if(!this._bMinimized)
      {
         this._bMinimized = true;
         this.refreshElementsVisibility();
      }
      return true;
   }
   function closeUI()
   {
      this.api.network.ModReport.sendNMRAdminDestroyed();
      this.unloadThis();
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.initData});
   }
   function addListeners()
   {
      this._btnActionMarkAllReports.addEventListener("click",this);
      this._btnActionMarkAllReports.addEventListener("over",this);
      this._btnActionMarkAllReports.addEventListener("out",this);
      this._btnActionOpenPlayerPopupMenu.addEventListener("click",this);
      this._btnActionOpenPlayerPopupMenu.addEventListener("over",this);
      this._btnActionOpenPlayerPopupMenu.addEventListener("out",this);
      this._btnExitReportView.addEventListener("click",this);
      this._btnExitReportView.addEventListener("over",this);
      this._btnExitReportView.addEventListener("out",this);
      this._btnNext.addEventListener("click",this);
      this._btnNext.addEventListener("over",this);
      this._btnNext.addEventListener("out",this);
      this._btnOpenReporterPopupMenu.addEventListener("click",this);
      this._btnOpenReporterPopupMenu.addEventListener("over",this);
      this._btnOpenReporterPopupMenu.addEventListener("out",this);
      this._btnPrevious.addEventListener("click",this);
      this._btnPrevious.addEventListener("over",this);
      this._btnPrevious.addEventListener("out",this);
      this._btnAddReportToMakeReport.addEventListener("click",this);
      this._btnClose.addEventListener("click",this);
      this._btnMinimize.addEventListener("click",this);
      this._btnMinimizeSmall.addEventListener("click",this);
      this._dgCategories.addEventListener("itemSelected",this);
      this._dgReportsProcessed.addEventListener("itemSelected",this);
      this._dgReportsProcessed.addEventListener("itemRollOver",this);
      this._dgReportsProcessed.addEventListener("itemRollOut",this);
      this._dgReportsToProcess.addEventListener("itemSelected",this);
      this._dgReportsToProcess.addEventListener("itemRollOver",this);
      this._dgReportsToProcess.addEventListener("itemRollOut",this);
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
   }
   function initTexts()
   {
      this._winBackground.title = "N.M.R Admin";
      this._winBackgroundSmall.title = "N.M.R Admin";
      this._winBackgroundSmall._visible = false;
      this._btnMinimizeSmall._visible = false;
      this._lblContext.text = this.api.lang.getText("NMR_ADMIN_CASE_TARGET_CONTEXT") + " :";
      this._lblSelectedPlayerReport.text = this.api.lang.getText("NMR_ADMIN_SELECTED_PLAYER_REPORT") + " :";
      this._btnPrevious.label = this.api.lang.getText("NMR_ADMIN_PREVIOUS_CASE");
      this._btnNext.label = this.api.lang.getText("NMR_ADMIN_NEXT_CASE");
      this._lblReportsToProcess.text = this.api.lang.getText("NMR_ADMIN_REPORTS_TO_PROCESS") + " :";
      this._lblReportsProcessed.text = this.api.lang.getText("NMR_ADMIN_REPORTS_ALREADY_PROCESSED") + " :";
      this._lblReporterCustomNote.text = this.api.lang.getText("NMR_ADMIN_REPORTER_CUSTOM_NOTE") + " :";
      this._lblReporterContext.text = this.api.lang.getText("NMR_ADMIN_REPORTER_CONTEXT") + " :";
      this._lblReporterLinkedChatConversation.text = this.api.lang.getText("NMR_ADMIN_LINKED_CHAT_CONVERSATION") + " :";
      this._btnExitReportView.label = this.api.lang.getText("NMR_ADMIN_EXIT_REPORT_VIEW");
      this._btnAddReportToMakeReport.label = this.api.lang.getText("NMR_ADMIN_ADD_TO_MOD_REPORT");
   }
   function initData()
   {
      if(this._aCases == undefined || this._aCases.length == 0)
      {
         this.api.kernel.showMessage(undefined,"*pense* le pouvoir des Six Atouts de Napo n\'immunise pas contre les étourderies, prends garde !","ERROR_CHAT");
         this.closeUI();
         return undefined;
      }
      this._dgCategories.columnsNames = [this.api.lang.getText("NMR_ADMIN_REPORTS_CATEGORY_NAME"),this.api.lang.getText("NMR_ADMIN_REPORTS_COUNT"),this.api.lang.getText("NMR_ADMIN_TOTAL_SCORE")];
      this._dgReportsProcessed.columnsNames = [this.api.lang.getText("NMR_ADMIN_REPORTER_NAME"),"Score","Note","Chat",this.api.lang.getText("STATE")];
      this._dgReportsToProcess.columnsNames = [this.api.lang.getText("NMR_ADMIN_REPORTER_NAME"),"Score","Note","Chat",this.api.lang.getText("STATE")];
      this.initCurrentCase();
      this.initCurrentSelectedCategory();
      this.refreshElementsVisibility();
   }
   function initCurrentCase()
   {
      var _loc2_ = this.currentTargetCase;
      var _loc3_ = this.currentTargetCase.targetPlayerEntityInfos;
      this._winBackground.title = "N.M.R Admin - " + _loc3_.characterName + " (" + this.casesBookCurrentPageID + "/" + this.casesBookLastPageID + ")";
      var _loc4_ = new ank.utils.ExtendedArray();
      var _loc5_ = new ank.utils.ExtendedObject();
      var _loc6_ = _loc2_.reports;
      var _loc7_ = 0;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      while(_loc7_ < _loc6_.length)
      {
         _loc8_ = _loc6_[_loc7_];
         _loc9_ = dofus.datacenter.modreport.ModReportCategory(this.api.datacenter.Player.modReportSessionData.ModReportCategories.getItemAt(_loc8_.categoryID));
         if(_loc9_ != undefined)
         {
            _loc10_ = _loc8_.score;
            _loc11_ = _loc10_ <= 0 ? 0 : 1;
            _loc12_ = _loc5_.getItemAt(_loc8_.categoryID);
            if(_loc12_ != undefined)
            {
               _loc12_.totalScore += _loc10_;
               _loc12_.totalReportsCount += _loc11_;
            }
            else
            {
               _loc5_.addItemAt(_loc8_.categoryID,{id:_loc8_.categoryID,categoryName:_loc9_.name,totalScore:_loc10_,totalReportsCount:_loc11_});
            }
         }
         _loc7_ = _loc7_ + 1;
      }
      if(this._selectedModReportCategory != undefined && _loc5_.getItemAt(this._selectedModReportCategory.categoryID) == undefined)
      {
         this._selectedModReportCategory = undefined;
      }
      var _loc13_ = _loc5_.getItems();
      for(var k in _loc13_)
      {
         _loc4_.push(_loc13_[k]);
      }
      _loc4_.sortOn("categoryName");
      this._dgCategories.dataProvider = _loc4_;
      this._btnNext.enabled = this.casesBookCanGoNextPage();
      this._btnPrevious.enabled = this.casesBookCanGoPreviousPage();
      this._btnActionOpenPlayerPopupMenu.label = this.api.lang.getText("NMR_ADMIN_OPEN_ADMIN_MENU_ON_CASE_TARGET") + " (" + (!_loc2_.targetPlayerEntityInfos.isOnline ? "offline" : "online") + ")";
      this._taContext.text = _loc3_.context;
   }
   function initCurrentSelectedCategory()
   {
      var _loc2_ = this._selectedModReportCategory != undefined;
      this._lblSelectedCategory.text = !_loc2_ ? this.api.lang.getText("NMR_ADMIN_PLEASE_SELECT_A_CATEGORY") : this._selectedModReportCategory.name;
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = new ank.utils.ExtendedArray();
      if(_loc2_)
      {
         _loc3_ = this.currentTargetCase.getReportsToProcessByCategoryIDForUX(this._selectedModReportCategory.categoryID);
         _loc4_ = this.currentTargetCase.getReportsAlreadyProcessedByCategoryIDForUX(this._selectedModReportCategory.categoryID);
      }
      else
      {
         _loc3_ = new ank.utils.ExtendedArray();
         _loc4_ = new ank.utils.ExtendedArray();
      }
      this._dgReportsToProcess.dataProvider = _loc3_;
      this._dgReportsProcessed.dataProvider = _loc4_;
   }
   function initCurrentSelectedModReportObject()
   {
      var _loc2_ = this._selectedModReportCategory != undefined;
      if(!_loc2_)
      {
         this._selectedModReportObject = undefined;
      }
      var _loc3_ = this._selectedModReportObject != undefined;
      if(_loc3_)
      {
         this._taReporterContext.text = this._selectedModReportObject.reporterPlayerEntityInfos.context;
         this._taReporterCustomNote.text = this._selectedModReportObject.reporterCustomNote;
         this._taReporterLinkedChatConversation.text = this._selectedModReportObject.chatConversation;
         this._btnOpenReporterPopupMenu.label = this.api.lang.getText("NMR_ADMIN_OPEN_ADMIN_MENU_ON_REPORTER") + " (" + (!this._selectedModReportObject.reporterPlayerEntityInfos.isOnline ? "offline" : "online") + ")";
      }
   }
   function refreshElementsVisibility()
   {
      var _loc2_ = this._selectedModReportCategory != undefined;
      var _loc3_ = this._selectedModReportObject != undefined;
      this._btnActionOpenPlayerPopupMenu._visible = !this._bMinimized;
      this._bhReport._visible = !this._bMinimized;
      this._dgCategories._visible = !this._bMinimized && !_loc3_;
      this._lblSelectedCategory._visible = !this._bMinimized;
      this._lblReportsToProcess._visible = !this._bMinimized && _loc2_;
      this._dgReportsToProcess._visible = !this._bMinimized && _loc2_;
      this._lblReportsProcessed._visible = !this._bMinimized && _loc2_;
      this._dgReportsProcessed._visible = !this._bMinimized && _loc2_;
      this._btnActionMarkAllReports._visible = !this._bMinimized && _loc2_;
      this._lblContext._visible = !this._bMinimized && !_loc3_;
      this._taContext._visible = !this._bMinimized && !_loc3_;
      this._btnPrevious._visible = !this._bMinimized;
      this._btnNext._visible = !this._bMinimized;
      this._lblReporterCustomNote._visible = !this._bMinimized && _loc3_;
      this._lblReporterLinkedChatConversation._visible = !this._bMinimized && _loc3_;
      this._taReporterCustomNote._visible = !this._bMinimized && _loc3_;
      this._taReporterLinkedChatConversation._visible = !this._bMinimized && _loc3_;
      this._btnExitReportView._visible = !this._bMinimized && _loc3_;
      this._btnOpenReporterPopupMenu._visible = !this._bMinimized && _loc3_;
      this._btnAddReportToMakeReport._visible = !this._bMinimized && _loc3_;
      this._lblSelectedPlayerReport._visible = !this._bMinimized && _loc3_;
      this._lblReporterContext._visible = !this._bMinimized && _loc3_;
      this._taReporterContext._visible = !this._bMinimized && _loc3_;
      this._btnClose._visible = !this._bMinimized;
      this._btnMinimize._visible = !this._bMinimized;
      this._btnMinimizeSmall._visible = this._bMinimized;
      this._winBackground._visible = !this._bMinimized;
      this._winBackgroundSmall._visible = this._bMinimized;
      if(_loc3_)
      {
         this._btnActionMarkAllReports.label = this.api.lang.getText("NMR_ADMIN_MARK_SELECTED_REPORT");
      }
      else
      {
         this._btnActionMarkAllReports.label = this.api.lang.getText("NMR_ADMIN_MARK_ALL_CATEGORY_REPORTS");
      }
   }
   function casesBookCanGoNextPage()
   {
      return this.nextTargetCase != undefined;
   }
   function casesBookCanGoPreviousPage()
   {
      return this.previousTargetCase != undefined;
   }
   function selectCaseAtIndex(nNewIndex)
   {
      if(this._nCurrentCaseIndex == nNewIndex)
      {
         return undefined;
      }
      this._nCurrentCaseIndex = nNewIndex;
      this._selectedModReportCategory = undefined;
      this._selectedModReportObject = undefined;
      this.initCurrentCase();
      this.initCurrentSelectedCategory();
      this.refreshElementsVisibility();
   }
   function onCasesUpdate(aCases)
   {
      var _loc3_ = false;
      var _loc4_ = false;
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      while(_loc5_ < aCases.length)
      {
         _loc6_ = aCases[_loc5_];
         _loc7_ = false;
         _loc8_ = 0;
         while(_loc8_ < this._aCases.length)
         {
            _loc9_ = this._aCases[_loc8_];
            if(_loc9_.targetPlayerEntityInfos.characterID == _loc6_.targetPlayerEntityInfos.characterID)
            {
               if(!_loc4_)
               {
                  _loc4_ = _loc8_ == this._nCurrentCaseIndex;
               }
               this._aCases[_loc8_] = _loc6_;
               _loc7_ = true;
               _loc3_ = true;
               break;
            }
            _loc8_ = _loc8_ + 1;
         }
         if(!_loc7_)
         {
            this._aCases.push(_loc6_);
            _loc3_ = true;
         }
         _loc5_ = _loc5_ + 1;
      }
      if(_loc3_)
      {
         if(_loc4_)
         {
            this._selectedModReportObject = undefined;
         }
         this.initCurrentCase();
         this.initCurrentSelectedCategory();
         this.refreshElementsVisibility();
      }
   }
   function click(oEvent)
   {
      var _loc3_;
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
      switch(oEvent.target)
      {
         case this._btnClose:
            this.closeUI();
            break;
         case this._btnMinimize:
         case this._btnMinimizeSmall:
            this._bMinimized = !this._bMinimized;
            this.refreshElementsVisibility();
            break;
         case this._btnActionOpenPlayerPopupMenu:
            _loc3_ = this.currentTargetCase.targetPlayerEntityInfos;
            this.api.kernel.GameManager.showPlayerPopupMenu(undefined,{sPlayerID:_loc3_.characterID,sPlayerName:_loc3_.characterName});
            break;
         case this._btnExitReportView:
            this._selectedModReportObject = undefined;
            this.refreshElementsVisibility();
            break;
         case this._btnOpenReporterPopupMenu:
            if(this._selectedModReportObject != undefined)
            {
               _loc4_ = this._selectedModReportObject.reporterPlayerEntityInfos;
               this.api.kernel.GameManager.showPlayerPopupMenu(undefined,{sPlayerID:_loc4_.characterID,sPlayerName:_loc4_.characterName});
            }
            break;
         case this._btnNext:
            _loc5_ = this.nextTargetCase;
            if(_loc5_ != undefined)
            {
               if(Key.isDown(Key.SHIFT))
               {
                  _loc6_ = this.api.ui.createPopupMenu();
                  _loc7_ = this._nCurrentCaseIndex + 1;
                  while(_loc7_ < this._aCases.length)
                  {
                     _loc5_ = this._aCases[_loc7_];
                     _loc6_.addItem(_loc5_.targetPlayerEntityInfos.characterName + " (" + (_loc7_ + 1) + "/" + this.casesBookLastPageID + ")",this,this.selectCaseAtIndex,[_loc7_]);
                     _loc7_ = _loc7_ + 1;
                  }
                  _loc6_.show(_root._xmouse,_root._ymouse);
               }
               else
               {
                  this.selectCaseAtIndex(this._nCurrentCaseIndex + 1);
               }
            }
            break;
         case this._btnPrevious:
            _loc8_ = this.previousTargetCase;
            if(_loc8_ != undefined)
            {
               if(Key.isDown(Key.SHIFT))
               {
                  _loc9_ = this.api.ui.createPopupMenu();
                  _loc10_ = this._nCurrentCaseIndex - 1;
                  while(_loc10_ >= 0)
                  {
                     _loc8_ = this._aCases[_loc10_];
                     _loc9_.addItem(_loc8_.targetPlayerEntityInfos.characterName + " (" + (_loc10_ + 1) + "/" + this.casesBookLastPageID + ")",this,this.selectCaseAtIndex,[_loc10_]);
                     _loc10_ = _loc10_ - 1;
                  }
                  _loc9_.show(_root._xmouse,_root._ymouse);
               }
               else
               {
                  this.selectCaseAtIndex(this._nCurrentCaseIndex - 1);
               }
            }
            break;
         case this._btnActionMarkAllReports:
            if(this._selectedModReportCategory != undefined)
            {
               _loc11_ = this._selectedModReportCategory.categoryID;
               _loc12_ = this.api.ui.createPopupMenu();
               _loc12_.addStaticItem(this._selectedModReportObject == undefined ? this.api.lang.getText("MARK_MASS") : this.api.lang.getText("MARK_INDIVIDUAL"));
               _loc13_ = 0;
               while(_loc13_ < dofus.datacenter.modreport.ModReportStates.STATES_ARRAY.length)
               {
                  _loc14_ = dofus.datacenter.modreport.ModReportStates.STATES_ARRAY[_loc13_];
                  if(this._selectedModReportObject != undefined)
                  {
                     _loc15_ = !this._selectedModReportObject.isArchived && this._selectedModReportObject.lastStateChange.state != _loc14_;
                     _loc12_.addItem(_loc14_,this,this.askNMRAdminNonArchivedReportChangeState,[_loc14_],_loc15_);
                  }
                  else
                  {
                     _loc12_.addItem(_loc14_,this,this.askNMRAdminNonArchivedReportsChangeState,[_loc14_],this.currentTargetCase.getMassMarkableReportsCount(_loc11_,_loc14_) > 0);
                  }
                  _loc13_ = _loc13_ + 1;
               }
               _loc12_.show(_root._xmouse,_root._ymouse);
            }
            break;
         case this._btnAddReportToMakeReport:
            if(this._selectedModReportCategory != undefined && this._selectedModReportObject != undefined)
            {
               dofus.graphics.gapi.ui.MakeReport.updateDescription(this.api,this._selectedModReportObject.getTextForMakeReportUI(this._selectedModReportCategory));
            }
         default:
            return;
      }
   }
   function askNMRAdminNonArchivedReportsChangeState(sState)
   {
      var _loc3_ = this.gapi.loadUIComponent("AskYesNoWithString","AskYesNoWithStringChangeCategoryState",{title:this.api.lang.getText("NMR_ADMIN_ACTION_CHANGE_STATE"),help:this.api.lang.getText("NMR_ADMIN_ACTION_CHANGE_STATE_HELP") + " : " + sState,params:{state:sState}});
      _loc3_.addEventListener("yes",this);
   }
   function askNMRAdminNonArchivedReportChangeState(sState)
   {
      var _loc3_ = this.gapi.loadUIComponent("AskYesNoWithString","AskYesNoWithStringChangeReportState",{title:this.api.lang.getText("NMR_ADMIN_ACTION_CHANGE_STATE"),help:this.api.lang.getText("NMR_ADMIN_ACTION_CHANGE_STATE_HELP") + " : " + sState,params:{state:sState}});
      _loc3_.addEventListener("yes",this);
   }
   function over(oEvent)
   {
      var _loc3_ = "";
      var _loc4_ = -20;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      switch(oEvent.target)
      {
         case this._btnActionMarkAllReports:
            if(this._selectedModReportObject == undefined)
            {
               _loc4_ -= 10;
               _loc3_ += this.api.lang.getText("NMR_ADMIN_MARK_ALL_CATEGORY_REPORTS");
            }
            break;
         case this._btnExitReportView:
            if(this._selectedModReportCategory == undefined)
            {
               break;
            }
            _loc3_ += this.api.lang.getText("NMR_ADMIN_BACK_TO_CATEGORIES_VIEW");
            break;
         case this._btnNext:
            _loc5_ = this.nextTargetCase;
            if(_loc5_ == undefined)
            {
               break;
            }
            _loc3_ += this.api.lang.getText("NMR_ADMIN_NEXT_CASE") + " : " + _loc5_.targetPlayerEntityInfos.characterName;
            break;
         case this._btnPrevious:
            _loc6_ = this.previousTargetCase;
            if(_loc6_ == undefined)
            {
               break;
            }
            _loc3_ += this.api.lang.getText("NMR_ADMIN_PREVIOUS_CASE") + " : " + _loc6_.targetPlayerEntityInfos.characterName;
            break;
         case this._btnActionOpenPlayerPopupMenu:
            _loc7_ = this.currentTargetCase.targetPlayerEntityInfos;
            _loc3_ += this.api.lang.getText("NMR_ADMIN_ADMIN_MENU_ON") + " : " + _loc7_.characterName;
            break;
         case this._btnOpenReporterPopupMenu:
            if(this._selectedModReportObject != undefined)
            {
               _loc8_ = this._selectedModReportObject.reporterPlayerEntityInfos;
               _loc3_ += this.api.lang.getText("NMR_ADMIN_ADMIN_MENU_ON") + " : " + _loc8_.characterName;
            }
      }
      if(_loc3_.length > 0)
      {
         this.gapi.showTooltip(_loc3_);
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function onShortcut(sShortcut)
   {
      if(sShortcut == "CODE_NEXT" && this._btnNext.enabled)
      {
         this.click({target:this._btnNext});
         return false;
      }
      if(sShortcut == "CODE_PREVIOUS" && this._btnPrevious.enabled)
      {
         this.click({target:this._btnPrevious});
         return false;
      }
      return true;
   }
   function yes(oEvent)
   {
      var _loc3_ = oEvent.inputText;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      switch(oEvent.target._name)
      {
         case "AskYesNoWithStringChangeCategoryState":
            if(this._selectedModReportCategory != undefined)
            {
               _loc4_ = this.currentTargetCase.targetPlayerEntityInfos.characterID;
               _loc5_ = this._selectedModReportCategory.categoryID;
               _loc6_ = oEvent.params.state;
               this.api.network.ModReport.sendNMRAdminNonArchivedReportsChangeState(_loc4_,_loc5_,_loc6_,_loc3_);
            }
            break;
         case "AskYesNoWithStringChangeReportState":
            if(this._selectedModReportObject != undefined)
            {
               _loc7_ = this.currentTargetCase.targetPlayerEntityInfos.characterID;
               _loc8_ = oEvent.params.state;
               this.api.network.ModReport.sendNMRAdminNonArchivedReportChangeState(_loc7_,this._selectedModReportObject.UUID,_loc8_,_loc3_);
            }
         default:
            return;
      }
   }
   function itemSelected(oEvent)
   {
      var _loc3_ = oEvent.row.item;
      switch(oEvent.target)
      {
         case this._dgCategories:
            this.onModReportCategorySelected(_loc3_.id);
            break;
         case this._dgReportsToProcess:
         case this._dgReportsProcessed:
            this.onModReportObjectSelected(_loc3_.UUID);
         default:
            return;
      }
   }
   function itemRollOver(oEvent)
   {
      var _loc3_ = "";
      var _loc4_ = oEvent.row.item;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      switch(oEvent.owner)
      {
         case this._dgReportsToProcess:
         case this._dgReportsProcessed:
            _loc5_ = _loc4_.UUID;
            _loc6_ = this.currentTargetCase.findReportByUUID(_loc5_);
            if(_loc6_ == undefined)
            {
               break;
            }
            if(_loc6_.isArchived)
            {
               _loc3_ += "ARCHIVED\n";
            }
            _loc7_ = 0;
            while(_loc7_ < _loc6_.statesChanges.length)
            {
               _loc8_ = _loc6_.statesChanges[_loc7_];
               if(_loc7_ > 0)
               {
               }
               _loc3_ += "- " + _loc8_.creationInstantString + " " + _loc8_.state;
               if(_loc8_.issuerAccountPseudo != undefined)
               {
                  _loc3_ += " by " + _loc8_.issuerAccountPseudo;
                  if(_loc8_.issuerCustomNote != undefined && _loc8_.issuerCustomNote.length > 0)
                  {
                     _loc3_ += " : " + _loc8_.issuerCustomNote;
                  }
               }
               _loc3_ += "\n";
               _loc7_ = _loc7_ + 1;
            }
            _loc3_ = _loc3_.substring(0,_loc3_.length - 1);
      }
      if(_loc3_.length > 0)
      {
         this.gapi.showTooltip(_loc3_);
      }
   }
   function itemRollOut(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function onModReportCategorySelected(nCategoryID)
   {
      var _loc3_ = dofus.datacenter.modreport.ModReportCategory(this.api.datacenter.Player.modReportSessionData.ModReportCategories.getItemAt(nCategoryID));
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      this._selectedModReportCategory = _loc3_;
      this._selectedModReportObject = undefined;
      this.initCurrentSelectedCategory();
      this.refreshElementsVisibility();
   }
   function onModReportObjectSelected(sUUID)
   {
      var _loc3_ = this.currentTargetCase.findReportByUUID(sUUID);
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      this._selectedModReportObject = _loc3_;
      this.initCurrentSelectedModReportObject();
      this.refreshElementsVisibility();
   }
}
