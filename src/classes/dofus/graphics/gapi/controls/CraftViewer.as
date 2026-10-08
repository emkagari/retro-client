class dofus.graphics.gapi.controls.CraftViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var §\t\t§;
   var _btnCraftableOnly;
   var _btnResetFilters;
   var _btnSlot0;
   var _btnSlot1;
   var _btnSlot2;
   var _btnSlot3;
   var _btnSlot4;
   var _btnSlot5;
   var _btnSlot6;
   var _btnSlot7;
   var _currentOverItem;
   var _lblFilter1;
   var _lblFilter2;
   var _lblFilterTitle;
   var _lblLevel;
   var _lblLevelBis;
   var _lblNoCraft;
   var _lstCrafts;
   var _oJob;
   var _parent;
   var _tiLvlMax;
   var _tiLvlMin;
   var _tiSearch;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "CraftViewer";
   function CraftViewer()
   {
      super();
   }
   function set job(oJob)
   {
      this._oJob = oJob;
      this.addToQueue({object:this,method:this.updateData});
   }
   function set skill(oSkill)
   {
      var _loc3_ = new ank.utils.ExtendedArray();
      _loc3_.push(oSkill);
      var _loc4_ = this.api.datacenter.Player.currentJobID;
      this.job = new dofus.datacenter.Job(_loc4_,_loc3_);
      return this["\t\t"]();
   }
   function get currentOverItem()
   {
      return this._currentOverItem;
   }
   function set currentOverItem(oItem_)
   {
      this._currentOverItem = oItem_;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.CraftViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this._lstCrafts._visible = false;
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
   }
   function addListeners()
   {
      this._btnSlot0.addEventListener("click",this);
      this._btnSlot1.addEventListener("click",this);
      this._btnSlot2.addEventListener("click",this);
      this._btnSlot3.addEventListener("click",this);
      this._btnSlot4.addEventListener("click",this);
      this._btnSlot5.addEventListener("click",this);
      this._btnSlot6.addEventListener("click",this);
      this._btnSlot7.addEventListener("click",this);
      this._btnSlot0.addEventListener("over",this);
      this._btnSlot1.addEventListener("over",this);
      this._btnSlot2.addEventListener("over",this);
      this._btnSlot3.addEventListener("over",this);
      this._btnSlot4.addEventListener("over",this);
      this._btnSlot5.addEventListener("over",this);
      this._btnSlot6.addEventListener("over",this);
      this._btnSlot7.addEventListener("over",this);
      this._btnSlot0.addEventListener("out",this);
      this._btnSlot1.addEventListener("out",this);
      this._btnSlot2.addEventListener("out",this);
      this._btnSlot3.addEventListener("out",this);
      this._btnSlot4.addEventListener("out",this);
      this._btnSlot5.addEventListener("out",this);
      this._btnSlot6.addEventListener("out",this);
      this._btnSlot7.addEventListener("out",this);
      this._btnCraftableOnly.addEventListener("click",this);
      this._btnCraftableOnly.addEventListener("over",this);
      this._btnCraftableOnly.addEventListener("out",this);
      this._btnResetFilters.addEventListener("click",this);
      this._btnResetFilters.addEventListener("over",this);
      this._btnResetFilters.addEventListener("out",this);
      this._tiSearch.addEventListener("change",this);
      this._tiLvlMin.addEventListener("change",this);
      this._tiLvlMax.addEventListener("change",this);
   }
   function initTexts()
   {
      var _loc2_ = this.api.datacenter.Basics.getCraftViewerSearch(this._oJob.id);
      if(_loc2_.length > 0)
      {
         this._tiSearch.text = _loc2_;
      }
      this._tiSearch.placeholder = this.api.lang.getText("SEARCH");
      this._tiSearch.restrict = dofus.Constants.INV_SEARCH_RESTRICT;
      this._lblFilterTitle.text = this.api.lang.getText("FILTER");
      this._lblLevel.text = this.api.lang.getText("LEVEL");
      this._lblLevelBis.text = this.api.lang.getText("TO_RANGE");
      this._lblFilter1.text = this.api.lang.getText("CRAFTABLE");
      this._lblFilter2.text = this.api.lang.getText("CRAFT_COMPOSANT");
   }
   function updateData()
   {
      if(this._oJob == undefined)
      {
         return undefined;
      }
      var _loc2_ = this.api.datacenter.Basics.getCraftViewerFilterNb(this._oJob.id);
      this._btnSlot0.selected = _loc2_[0];
      this._btnSlot1.selected = _loc2_[1];
      this._btnSlot2.selected = _loc2_[2];
      this._btnSlot3.selected = _loc2_[3];
      this._btnSlot4.selected = _loc2_[4];
      this._btnSlot5.selected = _loc2_[5];
      this._btnSlot6.selected = _loc2_[6];
      this._btnSlot7.selected = _loc2_[7];
      var _loc3_ = this.api.datacenter.Basics.getCraftViewerLevelRange(this._oJob.id);
      this._tiLvlMin.text = String(_loc3_.min);
      this._tiLvlMax.text = String(_loc3_.max);
      this._btnCraftableOnly.selected = this.api.datacenter.Basics.getCraftViewerShowOnlyPossibleCraft(this._oJob.id);
      var _loc4_ = new ank.utils.ExtendedString(this.api.datacenter.Basics.getCraftViewerSearch(this._oJob.id)).removeAccents().toUpperCase();
      var _loc5_ = this._oJob.crafts;
      var _loc6_ = new ank.utils.ExtendedArray();
      var _loc7_ = 0;
      var _loc8_;
      while(_loc7_ < _loc5_.length)
      {
         _loc8_ = _loc5_[_loc7_];
         if(_loc8_.craftItem.level >= _loc3_.min)
         {
            if(_loc8_.craftItem.level <= _loc3_.max)
            {
               if(_loc2_[_loc8_.itemsCount - 1])
               {
                  if(!(_loc4_.length >= 2 && !ank.utils.ExtendedString.searchWordsInName(_loc4_.split(" "),_loc8_.craftItem.nameUppercase)))
                  {
                     if(!(this.api.datacenter.Basics.getCraftViewerShowOnlyPossibleCraft(this._oJob.id) && !this.isCraftPossible(_loc8_)))
                     {
                        _loc6_.push(_loc8_);
                     }
                  }
               }
            }
         }
         _loc7_ = _loc7_ + 1;
      }
      var _loc9_;
      if(_loc6_.length != 0)
      {
         this._lstCrafts._visible = true;
         _loc9_ = function(a_, b_)
         {
            if(b_.itemsCount != a_.itemsCount)
            {
               return b_.itemsCount - a_.itemsCount;
            }
            if(b_.craftItem.type != a_.craftItem.type)
            {
               return b_.craftItem.type - a_.craftItem.type;
            }
            return ank.utils.ExtendedString.compare(a_.craftItem.name,b_.craftItem.name);
         };
         _loc6_.sort(_loc9_);
         this._lstCrafts.dataProvider = _loc6_;
         this._lblNoCraft.text = "";
      }
      else
      {
         this._lstCrafts._visible = false;
         this._lblNoCraft.text = this.api.lang.getText("NO_CRAFT_AVAILABLE");
      }
   }
   function craftItem(oItem)
   {
      this._parent.addCraft(oItem.unicID);
   }
   function isCraftPossible(oCraft)
   {
      var _loc3_ = oCraft.items;
      var _loc4_ = _loc3_.length;
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < _loc4_)
      {
         _loc6_ = _loc3_[_loc5_];
         if(this.api.datacenter.Player.getInventoryItemQuantityByUnicID(_loc6_.unicID) < _loc6_.Quantity)
         {
            return false;
         }
         _loc5_ = _loc5_ + 1;
      }
      return true;
   }
   function click(oEvent)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent.target)
      {
         case this._btnCraftableOnly:
            this.api.datacenter.Basics.setCraftViewerShowOnlyPossibleCraft(this._oJob.id,this._btnCraftableOnly.selected);
            break;
         case this._btnResetFilters:
            this.api.datacenter.Basics.resetCraftViewerFilters(this._oJob.id);
            this._tiSearch.clearText();
            break;
         default:
            _loc3_ = this.api.datacenter.Basics.getCraftViewerFilterNb(this._oJob.id);
            _loc4_ = Number(oEvent.target._name.substr(8));
            _loc3_[_loc4_] = oEvent.target.selected;
      }
      this.updateData();
   }
   function over(oEvent)
   {
      var _loc3_;
      switch(oEvent.target)
      {
         case this._btnCraftableOnly:
            this.gapi.showTooltip(this.api.lang.getText("CRAFT_ONLY_POSSIBLE_FILTER"));
            return;
         case this._btnResetFilters:
            this.gapi.showTooltip(this.api.lang.getText("FILTER_RESET"));
            return;
         default:
            _loc3_ = Number(oEvent.target._name.substr(8)) + 1;
            this.gapi.showTooltip(this.api.lang.getText("CRAFT_SLOT_FILTER",[_loc3_]));
            return;
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function change(oEvent_)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent_.target)
      {
         case this._tiSearch:
            if(this._tiSearch.text == this.api.datacenter.Basics.getCraftViewerSearch(this._oJob.id))
            {
               return undefined;
            }
            if(this._tiSearch.text.length > 0)
            {
               this.api.datacenter.Basics.setCraftViewerSearch(this._oJob.id,this._tiSearch.text);
            }
            else
            {
               this.api.datacenter.Basics.setCraftViewerSearch(this._oJob.id,"");
            }
            break;
         case this._tiLvlMin:
            _loc3_ = this._tiLvlMin.text == "" ? 1 : Number(this._tiLvlMin.text);
            if(_loc3_ > 200)
            {
               _loc3_ = 200;
            }
            if(_loc3_ < 1)
            {
               _loc3_ = 1;
            }
            if(this.api.datacenter.Basics.getCraftViewerLevelRange(this._oJob.id).min == _loc3_)
            {
               return undefined;
            }
            this.api.datacenter.Basics.getCraftViewerLevelRange(this._oJob.id).min = _loc3_;
            break;
         case this._tiLvlMax:
            _loc4_ = this._tiLvlMax.text == "" ? 200 : Number(this._tiLvlMax.text);
            if(_loc4_ > 200)
            {
               _loc4_ = 200;
            }
            if(_loc4_ < 1)
            {
               _loc4_ = 1;
            }
            if(this.api.datacenter.Basics.getCraftViewerLevelRange(this._oJob.id).max == _loc4_)
            {
               return undefined;
            }
            this.api.datacenter.Basics.getCraftViewerLevelRange(this._oJob.id).max = _loc4_;
      }
      this.updateData();
   }
}
