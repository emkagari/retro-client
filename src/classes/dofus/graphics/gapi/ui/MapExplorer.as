class dofus.graphics.gapi.ui.MapExplorer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aCategories;
   var _bIsInDungeon;
   var _btnCenterOnMe;
   var _btnClose;
   var _btnDungeon;
   var _btnMove;
   var _btnSelect;
   var _btnZoomMinous;
   var _btnZoomPlus;
   var _currentOverItem;
   var _dmHighlightMap;
   var _dmMap;
   var _eaInvadeAreas;
   var _lblArea;
   var _lblAreaName;
   var _lblHints;
   var _lblZoom;
   var _mcFilter0;
   var _mcFilterPlacer;
   var _mcTriangleE;
   var _mcTriangleN;
   var _mcTriangleNE;
   var _mcTriangleNW;
   var _mcTriangleS;
   var _mcTriangleSE;
   var _mcTriangleSW;
   var _mcTriangleW;
   var _mnMap;
   var _nForcedInitialZoom;
   var _oHighlightedMaps;
   var _sPointer;
   var _vsZoom;
   var _winBg;
   var addToQueue;
   var attachMovie;
   var gapi;
   var getNextHighestDepth;
   var label;
   var oHint;
   var setMovieClipTransform;
   var unloadThis;
   static var CLASS_NAME = "MapExplorer";
   static var OVER_TRIANGLE_TRANSFORM = {ra:0,rb:255,ga:0,gb:102,ba:0,bb:0};
   static var OUT_TRIANGLE_TRANSFORM = {ra:0,rb:184,ga:0,gb:177,ba:0,bb:143};
   static var DIRECTIONS = ["NW","N","NE","W","E","SW","S","SE"];
   static var FILTER_CONQUEST_ID = 5;
   var _bShowPlayerPosition = true;
   var _bSaveZoom = true;
   var _bSavePosition = true;
   function MapExplorer()
   {
      super();
   }
   function set mapID(nMapID)
   {
      this._dmHighlightMap = new dofus.datacenter.DofusMap(nMapID);
   }
   function set mapPointer(oPointer)
   {
      this._lblZoom = oPointer;
   }
   function get isDungeonMapDisplayed()
   {
      return this._btnDungeon.selected;
   }
   function set invadeAreasID(eaAreas)
   {
      this._eaInvadeAreas = eaAreas;
   }
   function get currentOverItem()
   {
      return this._currentOverItem;
   }
   function set currentOverItem(oItem_)
   {
      this._currentOverItem = oItem_;
   }
   function multipleSelect(aCoords)
   {
      this._mnMap.clear("highlight");
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
      for(var k in aCoords)
      {
         _loc3_ = aCoords[k];
         if(_loc3_ != undefined)
         {
            _loc4_ = _loc3_.type;
            _loc5_ = _loc3_.x;
            _loc6_ = _loc3_.y;
            _loc7_ = _loc3_.mapID;
            _loc8_ = _loc3_.label;
            if(this.isDungeonMapDisplayed && this._bIsInDungeon)
            {
               _loc9_ = this._dmMap.dungeon.m;
               _loc10_ = this._dmMap.dungeonCurrentMap;
               if(_loc10_.z != _loc9_.z)
               {
                  continue;
               }
               _loc5_ = _loc9_.x;
               _loc6_ = _loc9_.y;
            }
            switch(_loc4_)
            {
               case 1:
                  _loc11_ = dofus.Constants.FLAG_MAP_PHOENIX;
                  break;
               case 2:
                  _loc11_ = dofus.Constants.FLAG_MAP_GROUP;
                  _loc8_ = "[" + _loc5_ + "," + _loc6_ + "] " + this.api.ui.getUIComponent("Party").getMemberById(aCoords[k].playerID).name;
                  if(_loc8_ != undefined)
                  {
                     break;
                  }
                  delete aCoords[k];
                  continue;
               case 3:
                  _loc11_ = dofus.Constants.FLAG_MAP_SEEK;
                  _loc8_ = "[" + _loc5_ + "," + _loc6_ + "] " + aCoords[k].playerName;
                  break;
               default:
                  _loc11_ = dofus.Constants.FLAG_MAP_OTHERS;
            }
            _loc12_ = this._mnMap.addXtraClip("UI_MapExplorerFlag","highlight","highlight" + _loc4_ + k,_loc5_,_loc6_,_loc11_,100,false,true);
            if(_loc8_ != undefined)
            {
               _loc12_.label = _loc12_.label == undefined ? _loc8_ : _loc12_.label + "\n" + _loc8_;
               _loc12_.gapi = this.gapi;
               _loc12_.onRollOver = function()
               {
                  this.gapi.showTooltip(this.label);
               };
               _loc12_.onRollOut = function()
               {
                  this.gapi.hideTooltip();
               };
            }
         }
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.MapExplorer.CLASS_NAME);
   }
   function destroy()
   {
      if(!this.isDungeonMapDisplayed)
      {
         if(this._bSaveZoom)
         {
            this.api.datacenter.Basics.mapExplorer_zoom = this._mnMap.zoom;
         }
         if(this._bSavePosition)
         {
            this.api.datacenter.Basics.mapExplorer_coord = {x:this._mnMap.currentX,y:this._mnMap.currentY};
         }
      }
      this.gapi.hideTooltip();
      this.gapi.removeCursor(true);
      this.api.gfx._visible = true;
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      ank.utils.MouseEvents.addListener(this);
      this.gapi.removeCursor(true);
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.layoutContent});
      this.api.gfx._visible = false;
   }
   function initTexts()
   {
      this._winBg.title = this.api.lang.getText("WORLD_MAP");
      this._mcTriangleNW.text = this.api.lang.getText("ZOOM");
      this._lblHints.text = this.api.lang.getText("HINTS_FILTER");
   }
   function layoutContent()
   {
      var _loc2_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      if(!this.isDungeonMapDisplayed)
      {
         this._lblHints._visible = true;
         this._mnMap.showGrid = this.api.datacenter.Basics.mapExplorer_grid;
         this._aCategories = this.api.lang.getHintsCategories();
         this._aCategories[0] = {n:this.api.lang.getText("OPTION_GRID"),c:"Yellow"};
         _loc2_ = this.api.kernel.OptionsManager.getOption("MapFilters");
         _loc3_ = 0;
         _loc4_ = 0;
         while(_loc4_ < this._aCategories.length)
         {
            if(this._aCategories[_loc4_] != undefined && this["_mcFilter" + _loc4_] == undefined)
            {
               _loc5_ = {};
               _loc5_._y = this._mcFilterPlacer._y;
               _loc5_._x = this._mcFilterPlacer._x + _loc3_;
               _loc5_.backgroundDown = "ButtonCheckDown";
               _loc5_.backgroundUp = "ButtonCheckUp";
               _loc5_.styleName = this._aCategories[_loc4_].c + "MapHintCheckButton";
               _loc5_.toggle = true;
               _loc5_.selected = false;
               _loc5_.enabled = true;
               _loc6_ = ank.gapi.controls.Button(this.attachMovie("Button","_mcFilter" + _loc4_,this.getNextHighestDepth(),_loc5_));
               _loc6_.setSize(12,12);
               _loc6_.addEventListener("click",this);
               _loc6_.addEventListener("over",this);
               _loc6_.addEventListener("out",this);
               _loc3_ += 17;
            }
            else
            {
               this["_mcFilter" + _loc4_]._visible = true;
            }
            if(_loc4_ != 0)
            {
               _loc7_ = _loc2_[_loc4_] == 1;
               this.setMapFilter(_loc4_,_loc7_);
               this.showHintsCategory(_loc4_,_loc7_);
            }
            _loc4_ = _loc4_ + 1;
         }
         this._mcFilter0.selected = this.api.datacenter.Basics.mapExplorer_grid;
      }
      else
      {
         _loc8_ = 0;
         while(_loc8_ < this._aCategories.length)
         {
            this["_mcFilter" + _loc8_]._visible = false;
            _loc8_ = _loc8_ + 1;
         }
         this._lblHints._visible = false;
         this._mnMap.showGrid = false;
      }
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnZoomPlus.addEventListener("click",this);
      this._btnZoomMinous.addEventListener("click",this);
      this._btnMove.addEventListener("click",this);
      this._btnSelect.addEventListener("click",this);
      this._btnCenterOnMe.addEventListener("click",this);
      this._btnDungeon.addEventListener("click",this);
      this._btnZoomPlus.addEventListener("over",this);
      this._btnZoomMinous.addEventListener("over",this);
      this._btnMove.addEventListener("over",this);
      this._btnSelect.addEventListener("over",this);
      this._btnCenterOnMe.addEventListener("over",this);
      this._btnDungeon.addEventListener("over",this);
      this._btnZoomPlus.addEventListener("out",this);
      this._btnZoomMinous.addEventListener("out",this);
      this._btnMove.addEventListener("out",this);
      this._btnSelect.addEventListener("out",this);
      this._btnCenterOnMe.addEventListener("out",this);
      this._btnDungeon.addEventListener("out",this);
      this._mnMap.addEventListener("overMap",this);
      this._mnMap.addEventListener("outMap",this);
      this._mnMap.addEventListener("over",this);
      this._mnMap.addEventListener("out",this);
      this._mnMap.addEventListener("zoom",this);
      this._mnMap.addEventListener("select",this);
      this._mnMap.addEventListener("xtraLayerLoad",this);
      this._mnMap.addEventListener("moved",this);
      if(this.api.datacenter.Player.isAuthorized)
      {
         this._mnMap.addEventListener("doubleClick",this);
      }
      this._vsZoom.addEventListener("change",this);
      this.api.datacenter.Conquest.addEventListener("worldDataChanged",this);
   }
   function initData()
   {
      if(this._dmMap == undefined)
      {
         this._dmMap = this.api.datacenter.Map;
      }
      this._bIsInDungeon = this._dmMap.isDungeon;
      if(this._bIsInDungeon)
      {
         this._btnDungeon.enabled = true;
         if(!this.api.datacenter.Player.isAuthorized && this._dmHighlightMap == undefined)
         {
            this.initDungeonMap();
            this._btnDungeon.selected = true;
         }
         else
         {
            this.initWorldMap();
         }
      }
      else
      {
         this.initWorldMap();
         this._btnDungeon.enabled = false;
      }
   }
   function initWorldMap()
   {
      this._lblArea._visible = false;
      var _loc2_;
      if(this._dmHighlightMap != undefined)
      {
         _loc2_ = {x:this._dmHighlightMap.x,y:this._dmHighlightMap.y};
      }
      this.showMapSuperArea(this._dmMap.superarea);
      if(_loc2_ != undefined)
      {
         this._mnMap.setMapPosition(_loc2_.x,_loc2_.y);
      }
      if(this._nForcedInitialZoom != undefined)
      {
         this._mnMap.zoom = this._nForcedInitialZoom;
      }
      else
      {
         this._mnMap.zoom = this.api.datacenter.Basics.mapExplorer_zoom;
      }
   }
   function showMapSuperArea(nSuperAreaID)
   {
      if(nSuperAreaID == undefined)
      {
         return undefined;
      }
      this._mnMap.contentPath = dofus.Constants.LOCAL_MAPS_PATH + nSuperAreaID + ".swf";
      this._mnMap.clear();
      this._mnMap.setMapPosition(this._dmMap.x,this._dmMap.y);
      var _loc3_ = this.api.datacenter.Map;
      if(this._bShowPlayerPosition)
      {
         this._mnMap.addXtraClip("UI_MapExplorerSelectRectangle","rectangle","currentPosition",_loc3_.x,_loc3_.y,dofus.Constants.MAP_CURRENT_POSITION,50);
      }
      if(this._dmHighlightMap != undefined && this._dmHighlightMap != _loc3_)
      {
         this._mnMap.addXtraClip("UI_MapExplorerSelectRectangle","rectangle","waypointPosition",this._dmHighlightMap.x,this._dmHighlightMap.y,dofus.Constants.MAP_WAYPOINT_POSITION,50);
      }
      if(this.api.datacenter.Basics.banner_targetCoords != undefined)
      {
         this._mnMap.addXtraClip("UI_MapExplorerFlag","flag","targetCoords",this.api.datacenter.Basics.banner_targetCoords[0],this.api.datacenter.Basics.banner_targetCoords[1],255,100);
      }
      if(this.api.datacenter.Basics.aks_infos_highlightCoords != undefined)
      {
         this.multipleSelect(this.api.datacenter.Basics.aks_infos_highlightCoords);
      }
   }
   function hideArrows(bHide)
   {
      this._sPointer._visible = this._mcTriangleSW._visible = this._mcTriangleW._visible = this._mcTriangleE._visible = this._mcTriangleSE._visible = this._mcTriangleS._visible = this._mcTriangleN._visible = this._mcTriangleNE._visible = !bHide;
   }
   function setMapFilter(categoryID, bEnabled)
   {
      var _loc4_ = this.api.kernel.OptionsManager.getOption("MapFilters");
      if(_loc4_[categoryID] != bEnabled)
      {
         _loc4_[categoryID] = Number(bEnabled);
         this.api.kernel.OptionsManager.setOption("MapFilters",_loc4_);
      }
   }
   function showHintsCategory(categoryID, bShow)
   {
      this["_mcFilter" + categoryID].selected = bShow;
      var _loc4_ = "hints" + categoryID;
      if(bShow)
      {
         this._mnMap.loadXtraLayer(dofus.Constants.MAP_HINTS_FILE,_loc4_);
      }
      else
      {
         this._mnMap.clear(_loc4_);
      }
   }
   function drawHintsOnCategoryLayer(categoryID)
   {
      var _loc3_ = "hints" + categoryID;
      var _loc4_;
      if(dofus.graphics.gapi.ui.MapExplorer.FILTER_CONQUEST_ID == categoryID)
      {
         _loc4_ = dofus.datacenter.Hint.getConquestAreaHints();
      }
      else
      {
         _loc4_ = this.api.lang.getHintsByCategory(categoryID);
      }
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      while(_loc5_ < _loc4_.length)
      {
         var oHint = new dofus.datacenter.Hint(_loc4_[_loc5_]);
         _loc6_ = "hint" + _loc5_;
         _loc7_ = this._mnMap.getXtraLayer(_loc3_)[_loc6_];
         if(oHint.superAreaID !== this._dmMap.superarea)
         {
            _loc7_.removeMovieClip();
         }
         else if(_loc7_.oHint.gfx != oHint.gfx)
         {
            _loc8_ = this._mnMap.addXtraClip(oHint.gfx,_loc3_,_loc6_,oHint.x,oHint.y,undefined,undefined,true);
            _loc8_.oHint = oHint;
            _loc8_.gapi = this.gapi;
            var self = this;
            _loc8_.onRollOver = function()
            {
               self.gapi.showTooltip("[" + this.oHint.x + ", " + this.oHint.y + "] " + this.oHint.name);
               var _loc2_;
               if(oHint.isDungeonHint)
               {
                  _loc2_ = this.oHint.getSubareaFromDungeonHint();
                  if(_loc2_ != undefined)
                  {
                     self.currentOverItem = _loc2_;
                  }
               }
            };
            _loc8_.onRollOut = function()
            {
               self.gapi.hideTooltip();
            };
         }
         _loc5_ = _loc5_ + 1;
      }
   }
   function drawHighlightedMaps()
   {
      this._mnMap.addMapsClip(this._oHighlightedMaps,"_mcHighlightedMaps",dofus.Constants.MONSTER_SPAWN_MAP_COLOR,30);
   }
   function initDungeonMap()
   {
      this._lblArea._visible = true;
      this._lblArea.text = this._dmMap.dungeonName;
      var _loc2_ = this.api.datacenter.Map;
      this._mnMap.contentPath = "";
      this._mnMap.clear();
      this._mnMap.createXtraLayer("dungeonParchment");
      this._mnMap.createXtraLayer("dungeonMap");
      this._mnMap.createXtraLayer("highlight");
      var _loc3_ = this._dmMap.dungeon.m;
      var _loc4_ = this._dmMap.dungeonCurrentMap;
      var _loc5_;
      var _loc6_;
      for(var a in _loc3_)
      {
         _loc5_ = _loc3_[a];
         if(_loc4_.z == _loc5_.z)
         {
            _loc6_ = this._mnMap.addXtraClip("UI_MapExplorerRectangle","dungeonMap","dungeonCell" + a,_loc5_.x,_loc5_.y);
            if(_loc5_.n != undefined)
            {
               _loc6_.label = "[" + _loc5_.x + ", " + _loc5_.y + "] " + _loc5_.n;
               _loc6_.gapi = this.gapi;
               _loc6_.onRollOver = function()
               {
                  this.gapi.showTooltip(this.label);
               };
               _loc6_.onRollOut = function()
               {
                  this.gapi.hideTooltip();
               };
            }
         }
      }
      this._mnMap.addXtraClip("UI_MapExplorerSelectRectangle","dungeonMap","currentPosition",_loc4_.x,_loc4_.y,dofus.Constants.MAP_CURRENT_POSITION,50);
      this._mnMap.loadXtraLayer(dofus.Constants.MAP_HINTS_FILE,"dungeonHints");
      this._mnMap.loadXtraLayer(dofus.Constants.LOCAL_MAPS_PATH + "dungeon.swf","dungeonParchment");
   }
   function initDungeonParchment()
   {
      var _loc2_ = this._mnMap.getXtraLayer("dungeonParchment");
      var _loc3_ = this._mnMap.getXtraLayer("dungeonMap");
      var _loc4_ = _loc3_._width;
      var _loc5_ = _loc3_._height;
      var _loc6_ = _loc2_.view._x;
      var _loc7_ = _loc2_.view._y;
      var _loc8_ = _loc2_.view._width;
      var _loc9_ = _loc2_.view._height;
      var _loc10_ = 100;
      var _loc11_;
      var _loc12_;
      if(_loc4_ > _loc8_ || _loc5_ > _loc9_)
      {
         _loc11_ = _loc8_ / _loc4_;
         _loc12_ = _loc9_ / _loc5_;
         if(_loc12_ > _loc11_)
         {
            _loc10_ = 100 * _loc4_ / _loc8_;
         }
         else
         {
            _loc10_ = 100 * _loc5_ / _loc9_;
         }
         _loc2_._xscale = _loc2_._yscale = _loc10_;
      }
      var _loc13_ = _loc6_ * _loc10_ / 100 + (_loc8_ * _loc10_ / 100 - _loc4_) / 2;
      var _loc14_ = _loc7_ * _loc10_ / 100 + (_loc9_ * _loc10_ / 100 - _loc5_) / 2;
      _loc2_.parchment._x = (- _loc13_) * 100 / _loc10_;
      _loc2_.parchment._y = (- _loc14_) * 100 / _loc10_;
      var _loc15_ = _loc2_._parent._xscale;
      var _loc16_ = _loc2_._width * _loc10_ / 100 * _loc15_ / 100;
      var _loc17_ = _loc2_._height * _loc10_ / 100 * _loc15_ / 100;
      var _loc18_ = this._mnMap._width;
      var _loc19_ = this._mnMap._height;
      if(_loc16_ > _loc17_)
      {
         this._mnMap.zoom = this._mnMap.zoom * _loc18_ / _loc16_;
      }
      else
      {
         this._mnMap.zoom = this._mnMap.zoom * _loc19_ / _loc17_;
      }
      this._mnMap.setMapPosition(this._dmMap.dungeonCurrentMap.x,this._dmMap.dungeonCurrentMap.y);
   }
   function drawHintsDungeon()
   {
      var _loc2_ = this._dmMap.dungeon.m;
      var _loc3_;
      var _loc4_;
      for(var a in _loc2_)
      {
         _loc3_ = _loc2_[a];
         if(_loc3_.i != undefined)
         {
            _loc4_ = this._mnMap.addXtraClip(_loc3_.i,"dungeonHints",_loc3_.i,_loc3_.x,_loc3_.y,undefined,undefined,true);
            if(_loc3_.n != undefined)
            {
               _loc4_.label = "[" + _loc3_.x + ", " + _loc3_.y + "] " + _loc3_.n;
               _loc4_.gapi = this.gapi;
               _loc4_.onRollOver = function()
               {
                  this.gapi.showTooltip(this.label);
               };
               _loc4_.onRollOut = function()
               {
                  this.gapi.hideTooltip();
               };
            }
         }
      }
   }
   function onMouseWheel(nIncrement, mcTarget)
   {
      if(dofus.graphics.gapi.ui.Zoom.isZooming())
      {
         return undefined;
      }
      if(mcTarget._target.indexOf("_mnMap",0) != -1)
      {
         this._mnMap.zoom += nIncrement >= 0 ? 5 : -5;
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
      switch(oEvent.target)
      {
         case this._btnClose:
            this.callClose();
            return;
         case this._btnZoomPlus:
            this.api.sounds.events.onMapButtonClick();
            this._mnMap.interactionMode = "zoom+";
            this._btnZoomMinous.selected = false;
            this._btnMove.selected = false;
            this._btnSelect.selected = false;
            this._btnZoomPlus.enabled = false;
            this._btnZoomMinous.enabled = true;
            this._btnMove.enabled = true;
            this._btnSelect.enabled = true;
            this.hideArrows(true);
            return;
         case this._btnZoomMinous:
            this.api.sounds.events.onMapButtonClick();
            this._mnMap.interactionMode = "zoom-";
            this._btnZoomPlus.selected = false;
            this._btnMove.selected = false;
            this._btnSelect.selected = false;
            this._btnZoomPlus.enabled = true;
            this._btnZoomMinous.enabled = false;
            this._btnMove.enabled = true;
            this._btnSelect.enabled = true;
            this.hideArrows(true);
            return;
         case this._btnMove:
            this.api.sounds.events.onMapButtonClick();
            this._mnMap.interactionMode = "move";
            this._btnZoomMinous.selected = false;
            this._btnZoomPlus.selected = false;
            this._btnSelect.selected = false;
            this._btnZoomPlus.enabled = true;
            this._btnZoomMinous.enabled = true;
            this._btnMove.enabled = false;
            this._btnSelect.enabled = true;
            this.hideArrows(false);
            return;
         case this._btnSelect:
            this.api.sounds.events.onMapButtonClick();
            this._mnMap.interactionMode = "select";
            this._btnZoomMinous.selected = false;
            this._btnZoomPlus.selected = false;
            this._btnMove.selected = false;
            this._btnZoomPlus.enabled = true;
            this._btnZoomMinous.enabled = true;
            this._btnMove.enabled = true;
            this._btnSelect.enabled = false;
            this.hideArrows(true);
            return;
         case this._btnCenterOnMe:
            if(this.isDungeonMapDisplayed)
            {
               _loc3_ = this._dmMap.dungeonCurrentMap;
               this._mnMap.setMapPosition(_loc3_.x,_loc3_.y);
            }
            else
            {
               this._mnMap.setMapPosition(this.api.datacenter.Map.x,this.api.datacenter.Map.y);
            }
            return;
         case this._btnDungeon:
            if(this._btnDungeon.selected)
            {
               this.initDungeonMap();
            }
            else
            {
               this.initWorldMap();
            }
            this.layoutContent();
            return;
         default:
            _loc4_ = oEvent.target._name;
            _loc5_ = Number(_loc4_.substr(9,_loc4_.length));
            if(_loc5_ != 0)
            {
               _loc6_ = !this.api.kernel.OptionsManager.getOption("MapFilters")[_loc5_];
               this.setMapFilter(_loc5_,_loc6_);
               this.showHintsCategory(_loc5_,_loc6_);
               _loc7_ = dofus.graphics.gapi.ui.Banner(this.api.ui.getUIComponent("Banner"));
               _loc7_.illustration.updateHints();
               _loc7_.chat.miniMapReplacementPanel.updateHints();
               _loc7_.chat.shortcutsReplacementPanel.miniMap.updateHints();
            }
            else
            {
               _loc8_ = !this.api.datacenter.Basics.mapExplorer_grid;
               this.api.datacenter.Basics.mapExplorer_grid = _loc8_;
               this._mnMap.showGrid = _loc8_;
            }
            return;
      }
   }
   function over(oEvent)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent.target)
      {
         case this._mnMap:
            _loc3_ = oEvent.target._name.substr(4);
            this.setMovieClipTransform(this["_mcTriangle" + _loc3_],dofus.graphics.gapi.ui.MapExplorer.OVER_TRIANGLE_TRANSFORM);
            return;
         case this._btnZoomPlus:
            this.gapi.showTooltip(this.api.lang.getText("MAP_EXPLORER_ZOOM_PLUS"));
            return;
         case this._btnZoomMinous:
            this.gapi.showTooltip(this.api.lang.getText("MAP_EXPLORER_ZOOM_MINOUS"));
            return;
         case this._btnMove:
            this.gapi.showTooltip(this.api.lang.getText("MAP_EXPLORER_MOVE"));
            return;
         case this._btnSelect:
            this.gapi.showTooltip(this.api.lang.getText("MAP_EXPLORER_SELECT"));
            return;
         case this._btnCenterOnMe:
            this.gapi.showTooltip(this.api.lang.getText("MAP_EXPLORER_CENTER"));
            return;
         case this._btnDungeon:
            this.gapi.showTooltip(this.api.lang.getText("MAP_EXPLORER_DUNGEON"));
            return;
         default:
            _loc4_ = oEvent.target._name;
            this.gapi.showTooltip(this.api.lang.getHintsCategory(Number(_loc4_.substr(9,_loc4_.length))).n);
            return;
      }
   }
   function out(oEvent)
   {
      var _loc0_;
      var _loc3_;
      if((_loc0_ = oEvent.target) !== this._mnMap)
      {
         this.gapi.hideTooltip();
      }
      else
      {
         _loc3_ = 0;
         while(_loc3_ < dofus.graphics.gapi.ui.MapExplorer.DIRECTIONS.length)
         {
            this.setMovieClipTransform(this["_mcTriangle" + dofus.graphics.gapi.ui.MapExplorer.DIRECTIONS[_loc3_]],dofus.graphics.gapi.ui.MapExplorer.OUT_TRIANGLE_TRANSFORM);
            _loc3_ = _loc3_ + 1;
         }
      }
   }
   function change(oEvent)
   {
      this._mnMap.zoom = oEvent.target.value;
   }
   function zoom(oEvent)
   {
      this._vsZoom.value = oEvent.target.zoom;
   }
   function select(oEvent)
   {
      this.api.sounds.events.onMapFlag();
      var _loc3_ = oEvent.coordinates;
      this._mnMap.clear("flag");
      if(this.api.kernel.GameManager.updateCompass(_loc3_.x,_loc3_.y,false))
      {
         this._mnMap.addXtraClip("UI_MapExplorerFlag","flag","targetCoords",_loc3_.x,_loc3_.y,255,100,false,true);
      }
   }
   function overMap(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc9_;
      var _loc7_;
      var _loc8_;
      if(!this.isDungeonMapDisplayed)
      {
         _loc3_ = this.api.kernel.AreasManager.getAreaIDFromCoordinates(oEvent.coordinates.x,oEvent.coordinates.y,this._dmMap.superarea);
         _loc4_ = this.api.kernel.AreasManager.getSubAreaIDFromCoordinates(oEvent.coordinates.x,oEvent.coordinates.y,this._dmMap.superarea);
         if(_loc4_ != undefined)
         {
            _loc5_ = this.api.lang.getMapSubAreaName(_loc4_);
            _loc6_ = dofus.datacenter.Subarea(this.api.datacenter.Subareas.getItemAt(_loc4_));
            this.currentOverItem = _loc6_;
            _loc9_ = this.api.lang.getMapAreaText(_loc3_).n;
            this._lblArea.text = this.api.lang.getText("AREA") + " : " + _loc9_;
            if(_loc6_ != undefined)
            {
               _loc7_ = _loc6_.color;
               _loc8_ = (_loc5_ != _loc9_ ? " " + _loc5_ : _loc9_) + " - " + _loc6_.alignment.name;
            }
            else
            {
               _loc7_ = dofus.Constants.AREA_NO_ALIGNMENT_COLOR;
               _loc8_ = _loc5_ != _loc9_ ? " " + _loc5_ : "";
            }
            if(this._vsZoom.value != 2)
            {
               this._mnMap.addSubareaClip(_loc4_,_loc7_ == -1 ? dofus.Constants.AREA_NO_ALIGNMENT_COLOR : _loc7_,20);
            }
            this._lblAreaName.text = _loc8_;
            this._lblArea._visible = true;
         }
         else
         {
            this.currentOverItem = undefined;
            this.outMap();
         }
      }
   }
   function outMap(oEvent)
   {
      this.currentOverItem = undefined;
      if(!this.isDungeonMapDisplayed)
      {
         this._mnMap.removeAreaClip();
         if(this._lblAreaName.text != undefined)
         {
            this._lblAreaName.text = "";
         }
         this._lblArea._visible = false;
      }
   }
   function doubleClick(oEvent)
   {
      var _loc3_;
      var _loc4_;
      if(!this.api.datacenter.Game.isFight && !this.isDungeonMapDisplayed)
      {
         _loc3_ = oEvent.coordinates.x;
         _loc4_ = oEvent.coordinates.y;
         if(_loc3_ != undefined && _loc4_ != undefined)
         {
            this.api.network.Basics.autorisedMoveCommand(_loc3_,_loc4_);
         }
      }
   }
   function xtraLayerLoad(oEvent)
   {
      var _loc3_;
      switch(oEvent.mc._name)
      {
         case "dungeonHints":
            this.drawHintsDungeon();
            return;
         case "dungeonParchment":
            this.initDungeonParchment();
            return;
         default:
            _loc3_ = oEvent.mc._name;
            this.drawHintsOnCategoryLayer(Number(_loc3_.substr(5,_loc3_.length)));
            return;
      }
   }
   function worldDataChanged(oEvent)
   {
      this.addToQueue({object:this,method:this.drawHintsOnCategoryLayer,params:[dofus.graphics.gapi.ui.MapExplorer.FILTER_CONQUEST_ID]});
   }
   function moved()
   {
      if(this._oHighlightedMaps != undefined)
      {
         this.drawHighlightedMaps();
      }
   }
   function createMapPopupMenu(oSubarea)
   {
      var _loc3_ = this.api.ui.createPopupMenu();
      _loc3_.addStaticItem(oSubarea.name);
      _loc3_.addItem(this.api.lang.getText("ENCYCLOPEDIA_BESTIARY"),dofus.graphics.gapi.ui.Encyclopedia,dofus.graphics.gapi.ui.Encyclopedia.openEncyclopediaForSubarea,[oSubarea]);
      _loc3_.show(_root._xmouse,_root._ymouse);
   }
}
