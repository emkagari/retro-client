class dofus.graphics.gapi.ui.Encyclopedia extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aSearchedIDs;
   var _bSubareaFilterBasedOnPlayerPosition;
   var _btnClose;
   var _btnResetFilters;
   var _btnTabBestiary;
   var _btnTabCeremonial;
   var _btnTabConsumables;
   var _btnTabEquipments;
   var _btnTabRessources;
   var _currentOverItem;
   var _filtersList;
   var _lblFilters;
   var _mcPlacer;
   var _mcTabViewer;
   var _nSubareaInitialFilter;
   var _winBg;
   var addToQueue;
   var attachMovie;
   var gapi;
   var getNextHighestDepth;
   var unloadThis;
   static var CLASS_NAME = "Encyclopedia";
   var _sCurrentTab = "Bestiary";
   function Encyclopedia()
   {
      super();
   }
   function set currentTab(sTab)
   {
      this._sCurrentTab = sTab;
   }
   function get currentOverItem()
   {
      return this._currentOverItem;
   }
   function set currentOverItem(oItem_)
   {
      this._currentOverItem = oItem_;
   }
   function get itemViewer()
   {
      return new dofus.graphics.gapi.controls.RightClickContextItemViewer(this.api);
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Encyclopedia.CLASS_NAME);
      if(this.api.datacenter.Game.isFight)
      {
         this._aSearchedIDs = this.api.datacenter.Game.fightMonsters;
      }
   }
   function destroy()
   {
   }
   function callClose()
   {
      var _loc2_ = this._mcTabViewer._mcDetails;
      if(_loc2_ != undefined)
      {
         _loc2_.close();
      }
      else
      {
         this.unloadThis();
      }
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.setCurrentTab,params:[this._sCurrentTab]});
   }
   function initTexts()
   {
      this._winBg.title = this.api.lang.getText("ENCYCLOPEDIA");
      this._btnTabBestiary.label = this.api.lang.getText("ENCYCLOPEDIA_BESTIARY");
      this._btnTabConsumables.label = this.api.lang.getText("ENCYCLOPEDIA_CONSUMABLES");
      this._btnTabRessources.label = this.api.lang.getText("ENCYCLOPEDIA_RESSOURCES");
      this._btnTabEquipments.label = this.api.lang.getText("ENCYCLOPEDIA_EQUIPMENTS");
      this._btnTabCeremonial.label = this.api.lang.getText("ENCYCLOPEDIA_CEREMONIAL");
      this._lblFilters.text = this.api.lang.getText("HINTS_FILTER");
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnTabBestiary.addEventListener("click",this);
      this._btnTabConsumables.addEventListener("click",this);
      this._btnTabRessources.addEventListener("click",this);
      this._btnTabEquipments.addEventListener("click",this);
      this._btnTabCeremonial.addEventListener("click",this);
      this._btnResetFilters.addEventListener("click",this);
      this._btnResetFilters.addEventListener("over",this);
      this._btnResetFilters.addEventListener("out",this);
   }
   function initData()
   {
      if(this._nSubareaInitialFilter == undefined)
      {
         this._nSubareaInitialFilter = this.api.datacenter.Map.subarea;
         this._bSubareaFilterBasedOnPlayerPosition = true;
      }
   }
   function updateCurrentTabInformations()
   {
      this._mcTabViewer.removeMovieClip();
      var _loc2_ = ank.utils.ExtendedArray.createWithoutDuplicatesFromArray(this._aSearchedIDs);
      switch(this._sCurrentTab)
      {
         case "Bestiary":
            this.attachMovie("EncyclopediaBestiaryViewer","_mcTabViewer",this.getNextHighestDepth(),{_x:this._mcPlacer._x,_y:this._mcPlacer._y,_filtersList:this._filtersList,_aSearchedMonsterIDs:_loc2_,_nSubareaInitialFilter:this._nSubareaInitialFilter,_bIgnoreSubareaFilterIfEmpty:this._bSubareaFilterBasedOnPlayerPosition});
            break;
         case "Consumables":
            this.attachMovie("EncyclopediaConsumablesViewer","_mcTabViewer",this.getNextHighestDepth(),{_x:this._mcPlacer._x,_y:this._mcPlacer._y,_filtersList:this._filtersList,_aSearchedItemIDs:_loc2_});
            break;
         case "Ressources":
            this.attachMovie("EncyclopediaRessourcesViewer","_mcTabViewer",this.getNextHighestDepth(),{_x:this._mcPlacer._x,_y:this._mcPlacer._y,_filtersList:this._filtersList,_aSearchedItemIDs:_loc2_});
            break;
         case "Equipments":
            this.attachMovie("EncyclopediaEquipmentsViewer","_mcTabViewer",this.getNextHighestDepth(),{_x:this._mcPlacer._x,_y:this._mcPlacer._y,_filtersList:this._filtersList,_aSearchedItemIDs:_loc2_});
            break;
         case "Ceremonial":
            this.attachMovie("EncyclopediaCeremonialViewer","_mcTabViewer",this.getNextHighestDepth(),{_x:this._mcPlacer._x,_y:this._mcPlacer._y,_filtersList:this._filtersList,_aSearchedItemIDs:_loc2_});
      }
      this._nSubareaInitialFilter = undefined;
      this._aSearchedIDs = undefined;
   }
   function setCurrentTab(sNewTab, aSearchedIDs)
   {
      var _loc4_ = this["_btnTab" + this._sCurrentTab];
      var _loc5_ = this["_btnTab" + sNewTab];
      _loc4_.selected = true;
      _loc4_.enabled = true;
      _loc5_.selected = false;
      _loc5_.enabled = false;
      this._sCurrentTab = sNewTab;
      this._filtersList.closeAll();
      this._filtersList.removeAll();
      if(aSearchedIDs != undefined)
      {
         this._aSearchedIDs = aSearchedIDs;
      }
      this.updateCurrentTabInformations();
   }
   static function openEncyclopediaForItem(oItem_)
   {
      var _loc3_ = "";
      if(oItem_.isCeremonial)
      {
         _loc3_ = "Ceremonial";
      }
      else if(oItem_.isEquipable)
      {
         _loc3_ = "Equipments";
      }
      else if(oItem_.isConsumable)
      {
         _loc3_ = "Consumables";
      }
      else
      {
         _loc3_ = "Ressources";
      }
      var _loc4_ = _global.API.ui;
      var _loc5_ = dofus.graphics.gapi.ui.Encyclopedia(_loc4_.getUIComponent("Encyclopedia"));
      if(_loc5_ != undefined)
      {
         _loc5_.setCurrentTab(_loc3_,[oItem_.unicID]);
      }
      else
      {
         _loc4_.loadUIAutoHideComponent("Encyclopedia","Encyclopedia",{_sCurrentTab:_loc3_,_aSearchedIDs:[oItem_.unicID]},{bStayIfPresent:true});
      }
   }
   static function openEncyclopediaForSubarea(oSubarea)
   {
      var _loc3_ = "Bestiary";
      var _loc4_ = _global.API.ui;
      _loc4_.loadUIAutoHideComponent("Encyclopedia","Encyclopedia",{_sCurrentTab:_loc3_,_nSubareaInitialFilter:oSubarea.id},{bStayIfPresent:true});
   }
   static function resetData()
   {
      dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer.resetData();
      dofus.graphics.gapi.controls.encyclopedia.EncyclopediaRessourcesViewer.resetData();
      dofus.graphics.gapi.controls.encyclopedia.EncyclopediaConsumablesViewer.resetData();
      dofus.graphics.gapi.controls.encyclopedia.EncyclopediaEquipmentsViewer.resetData();
      dofus.graphics.gapi.controls.encyclopedia.EncyclopediaCeremonialViewer.resetData();
      var _loc2_ = _global.API.ui.getUIComponent("Encyclopedia");
      if(_loc2_ != undefined && _loc2_._mcTabViewer != undefined)
      {
         _loc2_._mcTabViewer.initData();
      }
   }
   function click(oEvent_)
   {
      switch(oEvent_.target)
      {
         case this._btnClose:
            this.unloadThis();
            break;
         case this._btnTabBestiary:
            this.setCurrentTab("Bestiary");
            break;
         case this._btnTabRessources:
            this.setCurrentTab("Ressources");
            break;
         case this._btnTabConsumables:
            this.setCurrentTab("Consumables");
            break;
         case this._btnTabEquipments:
            this.setCurrentTab("Equipments");
            break;
         case this._btnTabCeremonial:
            this.setCurrentTab("Ceremonial");
            break;
         case this._btnResetFilters:
            this._filtersList.resetFilters();
         default:
            return;
      }
   }
   function over(oEvent_)
   {
      var _loc0_;
      if((_loc0_ = oEvent_.target) === this._btnResetFilters)
      {
         this.gapi.showTooltip(this.api.lang.getText("FILTER_RESET"));
      }
   }
   function out(oEvent_)
   {
      this.gapi.hideTooltip();
   }
   function createMonsterPopupMenu(oMonster)
   {
      var _loc3_ = this.api.ui.createPopupMenu();
      _loc3_.addStaticItem(oMonster.name);
      _loc3_.addItem(this.api.lang.getText("CLICK_TO_INSERT"),this.api.kernel.GameManager,this.api.kernel.GameManager.insertMonsterInChat,[oMonster]);
      _loc3_.show(_root._xmouse,_root._ymouse);
   }
}
