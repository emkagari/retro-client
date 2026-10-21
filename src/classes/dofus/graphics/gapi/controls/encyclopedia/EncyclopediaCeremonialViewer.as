class dofus.graphics.gapi.controls.encyclopedia.EncyclopediaCeremonialViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aSearchedItemIDs;
   var _dgEquipments;
   var _filtersList;
   var _lblCount;
   var _mcEncyclopedia;
   var addToQueue;
   var attachMovie;
   var getNextHighestDepth;
   static var _eaData;
   static var CLASS_NAME = "EncyclopediaCeremonialViewer";
   function EncyclopediaCeremonialViewer()
   {
      super();
   }
   function set focusEquipment(nItemID)
   {
      this.displayDetails(nItemID);
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.encyclopedia.EncyclopediaCeremonialViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this._mcEncyclopedia = this.api.ui.getUIComponent("Encyclopedia");
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initFilters});
      this.addToQueue({object:this,method:this.setTagFilter});
      this.addToQueue({object:this,method:this.updateData});
   }
   function addListeners()
   {
      this._dgEquipments.addEventListener("itemSelected",this);
      this._dgEquipments.addEventListener("itemRollOver",this);
      this._dgEquipments.addEventListener("itemRollOut",this);
      this._filtersList.addEventListener("filterChanged",this);
      this._filtersList.addEventListener("filterClosed",this);
   }
   function initFilters()
   {
      this._filtersList.addFilter(new dofus.graphics.gapi.controls.encyclopedia.filters.FilterLabel("CEREMONIAL_TITLE"));
      this._filtersList.addFilter(new dofus.graphics.gapi.controls.encyclopedia.filters.FilterSearch("searchName"));
      var _loc2_ = new dofus.graphics.gapi.controls.encyclopedia.filters.FilterInterval("LEVEL","level","level",1,200);
      _loc2_.max = this.api.datacenter.Player.Level;
      this._filtersList.addFilter(_loc2_);
      this._filtersList.addFilter(new dofus.graphics.gapi.controls.encyclopedia.filters.FilterLabel("CEREMONIAL_CATEGORY"));
      this._filtersList.addFilter(new dofus.graphics.gapi.controls.encyclopedia.filters.FilterCategory("category",this.getCategoryList()));
      this._filtersList.drawAll();
   }
   function setTagFilter()
   {
      var _loc2_;
      if(this._aSearchedItemIDs != undefined && this._aSearchedItemIDs.length > 0)
      {
         _loc2_ = this.api.lang.getText("TARGETED_SEARCH");
         this._filtersList.addFilter(new dofus.graphics.gapi.controls.encyclopedia.filters.FilterTag(_loc2_,"id",this._aSearchedItemIDs));
      }
      if(this._aSearchedItemIDs != undefined)
      {
         this._aSearchedItemIDs = undefined;
         this._filtersList.drawAll();
      }
   }
   function initTexts()
   {
      this._dgEquipments.columnsNames = ["",this.api.lang.getText("NAME_BIG"),this.api.lang.getText("LEVEL"),this.api.lang.getText("ITEM_TYPE"),this.api.lang.getText("TYPE")];
      this._dgEquipments.columnsButtonsState = [false,true,true,true,false];
      this.updateCountLabel(0);
   }
   function initData()
   {
      if(dofus.graphics.gapi.controls.encyclopedia.EncyclopediaCeremonialViewer._eaData != undefined)
      {
         return undefined;
      }
      var _loc2_ = this.api.lang.getItemUnics();
      var _loc3_ = dofus.Constants.DEBUG;
      dofus.graphics.gapi.controls.encyclopedia.EncyclopediaCeremonialViewer._eaData = new ank.utils.ExtendedArray();
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
      var _loc16_;
      var _loc17_;
      var _loc18_;
      var _loc19_;
      for(var k in _loc2_)
      {
         _loc4_ = _loc2_[k];
         _loc5_ = _loc4_.es;
         if(!(!_loc5_ && _loc5_ != undefined))
         {
            if(_loc4_.ce)
            {
               _loc6_ = _loc4_.t;
               _loc7_ = this.api.lang.getItemTypeText(_loc6_).t;
               _loc8_ = this.api.lang.getSlotsFromSuperType(_loc7_)[0] != undefined;
               if(_loc8_)
               {
                  _loc9_ = Number(k);
                  _loc10_ = _loc4_.n + (!_loc3_ ? "" : " (" + _loc9_ + ")");
                  _loc11_ = _loc4_.nn + (!_loc3_ ? "" : " (" + _loc9_ + ")");
                  _loc12_ = _loc4_.g;
                  _loc13_ = String(this.api.lang.getItemTypeText(_loc6_).n);
                  _loc14_ = _loc4_.l;
                  _loc15_ = this.getItemParams(_loc4_);
                  _loc16_ = this.api.lang.getCraftText(_loc9_) != undefined;
                  _loc17_ = _loc4_.drop != undefined && dofus.datacenter.Item.droppedFromMonstersWithEnabledCriterions(_loc9_).length > 0;
                  _loc18_ = _loc4_.ef;
                  _loc19_ = {name:_loc10_,searchName:_loc11_,id:_loc9_,gfxID:_loc12_,categoryName:_loc13_,category:_loc6_,params:_loc15_,level:_loc14_,craftable:_loc16_,droppable:_loc17_,effects:_loc18_,ceremonial:_loc15_.type.Ceremonial != undefined,ethereal:_loc15_.type.Ethereal != undefined,twoHanded:_loc15_.attributes.TwoHanded};
                  dofus.graphics.gapi.controls.encyclopedia.EncyclopediaCeremonialViewer._eaData.push(_loc19_);
               }
            }
         }
      }
      dofus.graphics.gapi.controls.encyclopedia.EncyclopediaCeremonialViewer._eaData.sortOn("searchName");
      this.updateCountLabel(dofus.graphics.gapi.controls.encyclopedia.EncyclopediaCeremonialViewer._eaData.length);
   }
   function updateData()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < dofus.graphics.gapi.controls.encyclopedia.EncyclopediaCeremonialViewer._eaData.length)
      {
         _loc4_ = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaCeremonialViewer._eaData[_loc3_];
         if(this._filtersList.isObjectValid(_loc4_))
         {
            _loc2_.push(_loc4_);
         }
         _loc3_ = _loc3_ + 1;
      }
      this._dgEquipments.dataProvider = _loc2_;
      this.updateCountLabel(_loc2_.length);
   }
   function getEncyclopediaEquipment(nSearchedEquipmentID)
   {
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < dofus.graphics.gapi.controls.encyclopedia.EncyclopediaCeremonialViewer._eaData.length)
      {
         _loc4_ = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaCeremonialViewer._eaData[_loc3_];
         if(nSearchedEquipmentID == _loc4_.id)
         {
            return _loc4_;
         }
         _loc3_ = _loc3_ + 1;
      }
      return undefined;
   }
   function updateCountLabel(nCount)
   {
      this._lblCount.text = nCount + " " + ank.utils.PatternDecoder.combine(this.api.lang.getText("OBJECTS"),null,nCount < 2);
   }
   function displayDetails(nItemID)
   {
      if(!_global.isNaN(nItemID))
      {
         this._filtersList.closeAll();
         this.attachMovie("EncyclopediaEquipmentDetails","_mcDetails",this.getNextHighestDepth(),{itemID:nItemID});
      }
   }
   function getItemParams(oItemData)
   {
      var _loc3_ = {type:{},attributes:{}};
      if(oItemData.s != undefined)
      {
         _loc3_.type.ItemSet = this.api.lang.getItemSetText(oItemData.s).n + (!dofus.Constants.DEBUG ? "" : " (" + oItemData.s + ")");
      }
      if(oItemData.ce)
      {
         _loc3_.type.Ceremonial = this.api.lang.getText("ITEM_TYPE_CEREMONIAL");
      }
      return _loc3_;
   }
   function getCategoryList()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = {};
      var _loc4_;
      var _loc5_;
      for(var k in dofus.graphics.gapi.controls.encyclopedia.EncyclopediaCeremonialViewer._eaData)
      {
         _loc4_ = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaCeremonialViewer._eaData[k];
         _loc5_ = _loc4_.category;
         if(!_loc3_[_loc5_])
         {
            _loc2_.push({label:this.api.lang.getItemTypeText(_loc5_).n,id:_loc5_});
            _loc3_[_loc5_] = true;
         }
      }
      _loc2_.sortOn("label");
      _loc2_.splice(0,0,{label:this.api.lang.getText("WITHOUT_TYPE_FILTER"),id:dofus.graphics.gapi.controls.encyclopedia.filters.FilterCategory.NO_CHOICE_ID});
      return _loc2_;
   }
   function itemSelected(oEvent_)
   {
      var _loc3_ = oEvent_.row.item;
      var _loc4_ = _loc3_.id;
      this.displayDetails(_loc4_);
   }
   function itemRollOver(oEvent_)
   {
      oEvent_.row.cellRenderer_mc.over();
      var _loc3_ = oEvent_.row.item.id;
      this._mcEncyclopedia.currentOverItem = new dofus.datacenter.Item(-1,_loc3_,1,undefined,String(this.api.lang.getItemStats(_loc3_)));
   }
   function itemRollOut(oEvent_)
   {
      oEvent_.row.cellRenderer_mc.out();
      this._mcEncyclopedia.currentOverItem = undefined;
   }
   function filterChanged(oEvent_)
   {
      this._aSearchedItemIDs = undefined;
      this.updateData();
   }
   function filterClosed(oEvent_)
   {
      var _loc3_ = dofus.graphics.gapi.controls.encyclopedia.filters.IFilterComposant(oEvent_.value);
      this._filtersList.removeFilter(_loc3_);
      this._filtersList.drawAll();
      this.updateData();
   }
   static function resetData()
   {
      dofus.graphics.gapi.controls.encyclopedia.EncyclopediaCeremonialViewer._eaData = undefined;
   }
}
