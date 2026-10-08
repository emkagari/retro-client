class dofus.graphics.gapi.controls.JobOptionsViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnEnabled;
   var _btnFreeIfFailed;
   var _btnNotFree;
   var _btnValidate;
   var _lbNotFree;
   var _lblCraftComplexity;
   var _lblCraftComplexityValue;
   var _lblFreeIfFailed;
   var _lblPublicMode;
   var _lblReferencingOptions;
   var _lblRessourcesNeeded;
   var _mcPublicDisable;
   var _oJob;
   var _txtInfos;
   var _vsCraftComplexity;
   var addToQueue;
   var gapi;
   var initialized;
   static var CLASS_NAME = "JobOptionsViewer";
   function JobOptionsViewer()
   {
      super();
   }
   function set job(oJob)
   {
      this._oJob.removeEventListener("optionsChanged",this);
      this._oJob = oJob;
      this._oJob.addEventListener("optionsChanged",this);
      if(this.initialized)
      {
         this.optionsChanged();
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.JobOptionsViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function addListeners()
   {
      this.api.datacenter.Player.addEventListener("craftPublicModeChanged",this);
      this._vsCraftComplexity.addEventListener("change",this);
      this._btnEnabled.addEventListener("click",this);
      this._btnEnabled.addEventListener("over",this);
      this._btnEnabled.addEventListener("out",this);
      this._btnValidate.addEventListener("click",this);
      this._btnNotFree.addEventListener("click",this);
      this._btnFreeIfFailed.addEventListener("click",this);
   }
   function initTexts()
   {
      this._lblReferencingOptions.text = this.api.lang.getText("REFERENCING_OPTIONS");
      this._lbNotFree.text = this.api.lang.getText("NOT_FREE");
      this._lblFreeIfFailed.text = this.api.lang.getText("FREE_IF_FAILED");
      this._lblRessourcesNeeded.text = this.api.lang.getText("MIN_ITEM_IN_RECEIPT");
      this._txtInfos.text = this.api.lang.getText("PUBLIC_MODE_INFOS");
      this._btnValidate.label = this.api.lang.getText("SAVE");
      this._btnValidate.enabled = false;
      this.craftPublicModeChanged();
   }
   function initData()
   {
      this.optionsChanged();
   }
   function refreshBtnEnabledLabel()
   {
      this._btnEnabled.label = !this.api.datacenter.Player.craftPublicMode ? this.api.lang.getText("ENABLE") : this.api.lang.getText("DISABLE");
   }
   function refreshCraftComplexityLabel(nMinSlot)
   {
      this._lblCraftComplexity.text = nMinSlot.toString() + " " + ank.utils.PatternDecoder.combine(this.api.lang.getText("SLOT"),"m",nMinSlot < 2);
   }
   function change(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "_vsCraftComplexity")
      {
         this.refreshCraftComplexityLabel(this._vsCraftComplexity.value);
         this._btnValidate.enabled = true;
      }
   }
   function click(oEvent)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent.target._name)
      {
         case "_btnEnabled":
            this.api.network.Exchange.setPublicMode(!this.api.datacenter.Player.craftPublicMode);
            break;
         case "_btnValidate":
            _loc3_ = this.api.datacenter.Player.Jobs.findFirstItem("id",this._oJob.id);
            if(_loc3_.index != -1)
            {
               _loc4_ = (!this._btnNotFree.selected ? 0 : 1) + (!this._btnFreeIfFailed.selected ? 0 : 2);
               this.api.network.Job.changeJobStats(this._oJob.id,_loc4_,this._vsCraftComplexity._visible != false ? this._vsCraftComplexity.value : 2);
            }
            break;
         case "_btnNotFree":
            this._btnFreeIfFailed.enabled = !this._btnNotFree.selected ? false : true;
            break;
         case "_btnFreeIfFailed":
            break;
         default:
            return;
      }
      this._btnValidate.enabled = true;
   }
   function optionsChanged(oEvent)
   {
      var _loc3_;
      var _loc4_;
      if(this._oJob != undefined && this._btnNotFree.selected != undefined)
      {
         _loc3_ = this._oJob.options;
         _loc4_ = this._oJob.getMaxSkillSlot();
         _loc4_ = _loc4_ <= 8 ? _loc4_ : 8;
         if(_loc4_ > 2)
         {
            this._vsCraftComplexity._visible = true;
            this._vsCraftComplexity.markerCount = _loc4_ - 1;
            this._vsCraftComplexity.min = 2;
            this._vsCraftComplexity.max = _loc4_;
            this._vsCraftComplexity.redraw();
            this._vsCraftComplexity.value = _loc3_.minSlots;
         }
         else
         {
            this._vsCraftComplexity._visible = false;
         }
         this.refreshCraftComplexityLabel(_loc3_.minSlots);
         this._btnNotFree.selected = _loc3_.isNotFree;
         this._btnFreeIfFailed.selected = _loc3_.isFreeIfFailed;
         this._btnFreeIfFailed.enabled = !this._btnNotFree.selected ? false : true;
         this._btnValidate.enabled = false;
      }
   }
   function craftPublicModeChanged(oEvent)
   {
      this._lblCraftComplexityValue.text = this.api.lang.getText("PUBLIC_MODE") + " (" + this.api.lang.getText(!this.api.datacenter.Player.craftPublicMode ? "INACTIVE" : "ACTIVE") + ")";
      this.refreshBtnEnabledLabel();
      this._lblPublicMode._visible = !this.api.datacenter.Player.craftPublicMode;
      this._mcPublicDisable._visible = this.api.datacenter.Player.craftPublicMode;
   }
   function over(oEvent)
   {
      var _loc0_;
      var _loc3_;
      if((_loc0_ = oEvent.target) === this._btnEnabled)
      {
         _loc3_ = !this.api.datacenter.Player.craftPublicMode ? this.api.lang.getText("ENABLE_PUBLIC_MODE") : this.api.lang.getText("DISABLE_PUBLIC_MODE");
         this.gapi.showTooltip(_loc3_);
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
