class dofus.graphics.gapi.controls.JobViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnTabCharacteristics;
   var _btnTabCrafts;
   var _btnTabOptions;
   var _cvCraftViewer;
   var _eaPlayerJobs;
   var _itvItemViewer;
   var _jovJobOptionsViewer;
   var _lblLevel;
   var _lblName;
   var _lblNoJob;
   var _lblNoTool;
   var _lblSkill;
   var _lblTool;
   var _lblXP;
   var _ldrIcon;
   var _lstJobs;
   var _lstSkills;
   var _mcHidder;
   var _mcPlacer;
   var _nRequestedJobIdx;
   var _oJob;
   var _pbXP;
   var _sCurrentEntityNameSearch;
   var _tiSearch;
   var _winBg;
   var addToQueue;
   var attachMovie;
   var gapi;
   var unloadThis;
   static var CLASS_NAME = "JobViewer";
   var _sCurrentTab = "Characteristics";
   function JobViewer()
   {
      super();
   }
   function set selectedJobIndex(nIdx)
   {
      this._nRequestedJobIdx = nIdx;
   }
   function set job(oJob)
   {
      this._oJob = oJob;
      this.addToQueue({object:this,method:this.layoutContent});
   }
   function get job()
   {
      return this._oJob;
   }
   function get craftViewer()
   {
      return this._cvCraftViewer;
   }
   function get openedCraftList()
   {
      return this._cvCraftViewer;
   }
   function get itemViewer()
   {
      return new dofus.graphics.gapi.controls.RightClickContextItemViewer(this.api);
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.JobViewer.CLASS_NAME);
   }
   function destroy()
   {
      this.gapi.hideTooltip();
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this._lblNoTool._visible = false;
      this._mcPlacer._visible = false;
      this._mcHidder._visible = false;
      this._lblNoJob._visible = false;
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.addListeners});
   }
   function initTexts()
   {
      this._lblXP.text = this.api.lang.getText("EXPERIMENT");
      this._lblSkill.text = this.api.lang.getText("SKILLS");
      this._lblTool.text = this.api.lang.getText("TOOL");
      this._lblNoTool.text = this.api.lang.getText("NO_TOOL_JOB");
      this._btnTabCharacteristics.label = this.api.lang.getText("CHARACTERISTICS");
      this._btnTabCrafts.label = this.api.lang.getText("RECEIPTS");
      this._btnTabOptions.label = this.api.lang.getText("OPTIONS");
      this._winBg.title = this.api.lang.getText("MY_JOBS");
      this._tiSearch.placeholder = this.api.lang.getText("SEARCH");
      this._lblNoJob.text = this.api.lang.getText("UNKNOW_JOB");
      this._tiSearch.restrict = dofus.Constants.INV_SEARCH_RESTRICT;
   }
   function addListeners()
   {
      this._btnTabCharacteristics.addEventListener("click",this);
      this._btnTabCrafts.addEventListener("click",this);
      this._btnTabOptions.addEventListener("click",this);
      this._btnClose.addEventListener("click",this);
      this._lstJobs.addEventListener("itemSelected",this);
      this._eaPlayerJobs.addEventListener("modelChanged",this);
      this._tiSearch.addEventListener("change",this);
   }
   function initData()
   {
      this._eaPlayerJobs = this.api.datacenter.Player.Jobs;
      this._sCurrentEntityNameSearch = "";
      this.updateJobList();
      if(this._nRequestedJobIdx == undefined && this._lstJobs.dataProvider[0].level != undefined)
      {
         this._nRequestedJobIdx = 0;
      }
      if(this._nRequestedJobIdx != undefined)
      {
         this._lstJobs.selectedIndex = this._nRequestedJobIdx;
         this.job = this._lstJobs.dataProvider[this._nRequestedJobIdx];
      }
      this.addToQueue({object:this,method:this.layoutContent});
   }
   function updateJobList()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = this.api.lang.getAllJobsText();
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      for(var i in _loc3_)
      {
         _loc4_ = Number(i);
         _loc5_ = _loc3_[_loc4_];
         if(!(_global.isNaN(_loc5_.g) || _loc5_.g < 1))
         {
            _loc6_ = new dofus.datacenter.Job(_loc4_);
            _loc7_ = new ank.utils.ExtendedString(_loc6_.name).removeAccents().toUpperCase();
            if(!(this._sCurrentEntityNameSearch.length >= 2 && !ank.utils.ExtendedString.searchWordsInName(this._sCurrentEntityNameSearch.split(" "),_loc7_)))
            {
               _loc8_ = this.api.datacenter.Player.getJobInfo(_loc4_);
               if(_loc8_ != undefined)
               {
                  _loc2_.push(_loc8_);
               }
               else
               {
                  _loc2_.push(new dofus.datacenter.Job(_loc4_));
               }
            }
         }
      }
      var _loc9_ = function(a_, b_)
      {
         if(a_.level == undefined && b_.level == undefined)
         {
            return ank.utils.ExtendedString.compare(a_.name,b_.name);
         }
         if(a_.level == undefined)
         {
            return 1;
         }
         if(b_.level == undefined)
         {
            return -1;
         }
         if(b_.level != a_.level)
         {
            return b_.level - a_.level;
         }
         if(b_.xp != a_.xp)
         {
            return b_.xp - a_.xp;
         }
         return ank.utils.ExtendedString.compare(a_.name,b_.name);
      };
      _loc2_.sort(_loc9_);
      this._lstJobs.dataProvider = _loc2_;
   }
   function layoutContent()
   {
      var _loc2_ = this._oJob.level != undefined;
      this._mcHidder._visible = !_loc2_;
      this._lblNoJob._visible = !_loc2_;
      this._lblName._visible = _loc2_;
      this._lblLevel._visible = _loc2_;
      this._ldrIcon._visible = _loc2_;
      if(!_loc2_)
      {
         return undefined;
      }
      this.setCurrentTab(this._sCurrentTab);
      this._lstSkills.removeMovieClip();
      var _loc3_ = this.api.datacenter.Player.currentJobID == this._oJob.id;
      this._ldrIcon.contentPath = this._oJob.iconFile;
      this._lblName.text = this._oJob.name;
      this._lblLevel.text = this.api.lang.getText("LEVEL") + " " + this._oJob.level;
      this._pbXP.minimum = this._oJob.xpMin;
      this._pbXP.maximum = this._oJob.xpMax;
      this._pbXP.value = this._oJob.xp;
      this._pbXP.addEventListener("over",this);
      this._pbXP.addEventListener("out",this);
      var _loc4_ = this._oJob.skills;
      if(_loc4_.length != 0)
      {
         _loc4_.sortOn("skillName");
         this._lstSkills.dataProvider = _loc4_;
      }
      var _loc5_;
      if(_loc3_)
      {
         this._lblNoTool._visible = false;
         this._itvItemViewer._visible = true;
         _loc5_ = dofus.datacenter.Item(this.api.datacenter.Player.Inventory.findFirstItem("position",1).item);
         this._itvItemViewer.itemData = _loc5_;
      }
      else
      {
         this._lblNoTool._visible = true;
         this._itvItemViewer._visible = false;
      }
   }
   function showCraftViewer(bShow)
   {
      var _loc3_;
      if(bShow)
      {
         _loc3_ = this.attachMovie("CraftViewer","_cvCraftViewer",20);
         _loc3_._x = this._mcPlacer._x;
         _loc3_._y = this._mcPlacer._y;
         _loc3_.job = this._oJob;
      }
      else
      {
         this._cvCraftViewer.removeMovieClip();
      }
   }
   function showOptionViewer(bShow)
   {
      var _loc3_;
      if(bShow)
      {
         _loc3_ = this.attachMovie("JobOptionsViewer","_jovJobOptionsViewer",20);
         _loc3_._x = this._mcPlacer._x;
         _loc3_._y = this._mcPlacer._y;
         _loc3_.job = this._oJob;
      }
      else
      {
         this._jovJobOptionsViewer.removeMovieClip();
      }
   }
   function updateCurrentTabInformations()
   {
      switch(this._sCurrentTab)
      {
         case "Characteristics":
            this.showOptionViewer(false);
            this.showCraftViewer(false);
            break;
         case "Crafts":
            this.showOptionViewer(false);
            this.showCraftViewer(true);
            break;
         case "Options":
            this.showCraftViewer(false);
            this.showOptionViewer(true);
         default:
            return;
      }
   }
   function setCurrentTab(sNewTab)
   {
      var _loc3_ = this["_btnTab" + this._sCurrentTab];
      var _loc4_ = this["_btnTab" + sNewTab];
      _loc3_.selected = true;
      _loc3_.enabled = true;
      _loc4_.selected = false;
      _loc4_.enabled = false;
      this._sCurrentTab = sNewTab;
      this.updateCurrentTabInformations();
   }
   function modelChanged(oEvent_)
   {
      var _loc0_;
      if((_loc0_ = oEvent_.target) === this._eaPlayerJobs)
      {
         this.updateJobList();
      }
   }
   function over(oEvent_)
   {
      var _loc0_;
      if((_loc0_ = oEvent_.target) === this._pbXP)
      {
         this.gapi.showTooltip(new ank.utils.ExtendedString(this.job.xp).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this.job.xpMax).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3));
      }
   }
   function out(oEvent_)
   {
      this.gapi.hideTooltip();
   }
   function change(oEvent_)
   {
      var _loc0_;
      if((_loc0_ = oEvent_.target) === this._tiSearch)
      {
         if(this._tiSearch.text == this._sCurrentEntityNameSearch)
         {
            return undefined;
         }
         if(this._tiSearch.text.length > 0)
         {
            this._sCurrentEntityNameSearch = new ank.utils.ExtendedString(this._tiSearch.text).removeAccents().toUpperCase();
         }
         else
         {
            this._sCurrentEntityNameSearch = "";
         }
         this.updateJobList();
      }
   }
   function itemSelected(oEvent_)
   {
      this.job = oEvent_.target.selectedItem;
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnTabCharacteristics:
            this.setCurrentTab("Characteristics");
            break;
         case this._btnTabCrafts:
            this.setCurrentTab("Crafts");
            break;
         case this._btnTabOptions:
            this.setCurrentTab("Options");
            break;
         case this._btnClose:
            this.callClose();
         default:
            return;
      }
   }
}
