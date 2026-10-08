class dofus.graphics.gapi.controls.MiniMap extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bIsInDungeon;
   var _bTimerEnable;
   var _dmMap;
   var _ldrBitmapMap;
   var _ldrHints;
   var _mcBg;
   var _mcBgBig;
   var _mcBgCustom;
   var _mcBgSmall;
   var _mcBitmapContainer;
   var _mcCursor;
   var _mcFlags;
   var _mcFlagsContainer;
   var _mcFlagsDirection;
   var _mcHintsContainer;
   var _nCurrentArea;
   var _nCustomBgColor;
   var _nCustomBgScaleHeight;
   var _nCustomBgScaleWidth;
   var _nCustomBgScaleX;
   var _nCustomBgScaleY;
   var _nRandomTag;
   var _nScale;
   var _nScaledHeight;
   var _nScaledWidth;
   var addToQueue;
   var api;
   var dispatchEvent;
   var gapi;
   var label;
   var oHint;
   var oMap;
   var tooltipText;
   static var HIDE_FLAG_ZONE;
   static var CLASS_NAME = "MiniMap";
   static var MAP_IMG_WIDTH = 15;
   static var MAP_IMG_HEIGHT = 15;
   static var SCALE_SMALL = 0;
   static var SCALE_NORMAL = 1;
   static var SCALE_BIG = 2;
   static var SCALE_CUSTOM = 3;
   var _aFlags = [];
   var _nMapScale = 40;
   var _nTileWidth = 40;
   var _nTileHeight = 23;
   var _nLastDoubleClick = 0;
   var _nShowHintsMaxDistance = 6;
   function MiniMap()
   {
      super();
   }
   function getMcBg()
   {
      switch(this._nScale)
      {
         case dofus.graphics.gapi.controls.MiniMap.SCALE_BIG:
            return this._mcBgBig;
         case dofus.graphics.gapi.controls.MiniMap.SCALE_NORMAL:
            return this._mcBg;
         case dofus.graphics.gapi.controls.MiniMap.SCALE_SMALL:
            return this._mcBgSmall;
         case dofus.graphics.gapi.controls.MiniMap.SCALE_CUSTOM:
            return this._mcBgCustom;
         default:
            return undefined;
      }
   }
   function isHittingBackground()
   {
      return this.getMcBg().hitTest(_root._xmouse,_root._ymouse,true);
   }
   function get showHintsMaxDistance()
   {
      return this._nShowHintsMaxDistance;
   }
   function set showHintsMaxDistance(nShowHintsMaxDistance)
   {
      this._nShowHintsMaxDistance = nShowHintsMaxDistance;
   }
   function get customBgScaleX()
   {
      return this._nCustomBgScaleX;
   }
   function set customBgScaleX(nCustomBgScaleX)
   {
      this._nCustomBgScaleX = nCustomBgScaleX;
   }
   function get customBgScaleY()
   {
      return this._nCustomBgScaleY;
   }
   function set customBgScaleY(nCustomBgScaleY)
   {
      this._nCustomBgScaleY = nCustomBgScaleY;
   }
   function get customBgScaleWidth()
   {
      return this._nCustomBgScaleWidth;
   }
   function set customBgScaleWidth(nCustomBgScaleWidth)
   {
      this._nCustomBgScaleWidth = nCustomBgScaleWidth;
   }
   function get customBgScaleHeight()
   {
      return this._nCustomBgScaleHeight;
   }
   function set customBgScaleHeight(nCustomBgScaleHeight)
   {
      this._nCustomBgScaleHeight = nCustomBgScaleHeight;
   }
   function get customBgColor()
   {
      return this._nCustomBgColor;
   }
   function set customBgColor(nCustomBgColor)
   {
      this._nCustomBgColor = nCustomBgColor;
   }
   function updateFlags()
   {
      this.updateDataMap();
      if(this._dmMap.x == undefined || this._dmMap.y == undefined)
      {
         this.addToQueue({object:this,method:this.updateFlags});
         return undefined;
      }
      this.clearFlag();
      if(this.api.datacenter.Basics.banner_targetCoords)
      {
         this.addFlag(this.api.datacenter.Basics.banner_targetCoords[0],this.api.datacenter.Basics.banner_targetCoords[1],255);
      }
      if(this.api.datacenter.Basics.aks_infos_highlightCoords.length <= 0)
      {
         return undefined;
      }
      var _loc2_ = this.api.datacenter.Basics.aks_infos_highlightCoords;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      for(var i in _loc2_)
      {
         if(_loc2_[i])
         {
            if(_loc2_[i].miniMapTagId == undefined)
            {
               _loc2_[i].miniMapTagId = this._nRandomTag;
            }
            if(_loc2_[i].miniMapTagId != this._nRandomTag)
            {
               delete _loc2_[i];
            }
            else
            {
               switch(_loc2_[i].type)
               {
                  case 1:
                     if(!_loc3_)
                     {
                        _loc3_ = _loc2_[i];
                     }
                     else
                     {
                        _loc4_ = this.dist(_loc3_.x,_loc3_.y,this._dmMap.x,this._dmMap.y);
                        _loc5_ = this.dist(_loc2_[i].x,_loc2_[i].y,this._dmMap.x,this._dmMap.y);
                        if(_loc5_ < _loc4_)
                        {
                           _loc3_ = _loc2_[i];
                        }
                     }
                     break;
                  case 2:
                     _loc6_ = _global.API.ui.getUIComponent("Party").getMemberById(_loc2_[i].playerID).name;
                     if(_loc6_ != undefined)
                     {
                        this.addFlag(_loc2_[i].x,_loc2_[i].y,dofus.Constants.FLAG_MAP_GROUP,_loc6_);
                        break;
                     }
                     delete _loc2_[i];
                     break;
                  case 3:
                     this.addFlag(_loc2_[i].x,_loc2_[i].y,dofus.Constants.FLAG_MAP_SEEK,_loc2_[i].playerName);
               }
            }
         }
      }
      if(_loc3_)
      {
         this.addFlag(_loc3_.x,_loc3_.y,dofus.Constants.FLAG_MAP_PHOENIX,this.api.lang.getText("BANNER_MAP_PHOENIX"));
      }
   }
   function setScale(nScale, bUpdateFlags)
   {
      if(nScale == dofus.graphics.gapi.controls.MiniMap.SCALE_CUSTOM && (this._nCustomBgScaleWidth == undefined || (this._nCustomBgScaleHeight == undefined || (this._nCustomBgScaleX == undefined || this._nCustomBgScaleY == undefined))))
      {
         nScale = dofus.graphics.gapi.controls.MiniMap.SCALE_NORMAL;
      }
      this._mcBgCustom._visible = nScale == dofus.graphics.gapi.controls.MiniMap.SCALE_CUSTOM;
      var _loc4_;
      if(nScale == dofus.graphics.gapi.controls.MiniMap.SCALE_CUSTOM)
      {
         this._mcBgCustom._width = this._nCustomBgScaleWidth;
         this._mcBgCustom._height = this._nCustomBgScaleHeight;
         this._mcBgCustom._x = this._nCustomBgScaleX;
         this._mcBgCustom._y = this._nCustomBgScaleY;
         if(this._nCustomBgColor != undefined)
         {
            _loc4_ = new Color(this._mcBgCustom);
            _loc4_.setRGB(this._nCustomBgColor);
            this._nCustomBgColor = undefined;
         }
      }
      if(this._nScale == nScale)
      {
         return undefined;
      }
      this._nScale = nScale;
      this.showScaledBackground();
      this._nScaledHeight = this._nMapScale / 100 * this._nTileHeight;
      this._nScaledWidth = this._nMapScale / 100 * this._nTileWidth;
      switch(nScale)
      {
         case dofus.graphics.gapi.controls.MiniMap.SCALE_SMALL:
            dofus.graphics.gapi.controls.MiniMap.HIDE_FLAG_ZONE = [[1,1,1,1,1,1,1],[1,1,1,1,1,1,1],[1,1,1,1,1,1,1],[1,1,1,1,1,1,1],[1,1,0,0,0,1,1],[1,1,0,0,0,1,1],[1,1,0,0,0,1,1],[1,1,0,0,0,1,1],[1,1,0,0,0,1,1],[1,1,0,0,0,1,1],[1,1,0,0,0,1,1],[1,1,1,1,1,1,1],[1,1,1,1,1,1,1]];
            break;
         case dofus.graphics.gapi.controls.MiniMap.SCALE_NORMAL:
            dofus.graphics.gapi.controls.MiniMap.HIDE_FLAG_ZONE = [[1,1,1,1,1,1,1],[1,1,1,1,1,1,1],[1,1,1,1,1,1,1],[1,0,1,1,0,0,1],[1,0,0,0,0,0,1],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,1],[1,0,0,0,0,0,1],[1,1,0,0,0,1,1]];
            break;
         case dofus.graphics.gapi.controls.MiniMap.SCALE_BIG:
         case dofus.graphics.gapi.controls.MiniMap.SCALE_CUSTOM:
            dofus.graphics.gapi.controls.MiniMap.HIDE_FLAG_ZONE = [[1,1,1,1,1,1,1],[1,1,1,1,1,1,1],[1,0,0,0,0,0,1],[1,0,0,0,0,0,1],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[1,0,0,0,0,0,1],[1,0,0,0,0,0,1],[1,1,0,0,0,1,1]];
      }
      if(bUpdateFlags)
      {
         this.updateFlagsDirections();
      }
   }
   function clearFlag()
   {
      for(var i in this._mcFlagsDirection)
      {
         this._mcFlagsDirection[i].removeMovieClip();
      }
      for(var i in this._mcFlagsContainer)
      {
         this._mcFlagsContainer[i].removeMovieClip();
      }
      this._aFlags = [];
   }
   function addFlag(nX, nY, nColor, sLabel)
   {
      if(_global.isNaN(nX) || _global.isNaN(nY))
      {
         return undefined;
      }
      var _loc6_ = (nColor & 0xFF0000) >> 16;
      var _loc7_ = (nColor & 0xFF00) >> 8;
      var _loc8_ = nColor & 0xFF;
      var _loc9_ = "[" + nX + ", " + nY + "]" + (!sLabel.length ? "" : " " + sLabel);
      var _loc10_ = [];
      var thisMiniMap = this;
      var _loc11_ = function()
      {
         thisMiniMap.dispatchEvent({type:"over"});
         this.gapi.showTooltip(this.tooltipText);
      };
      var _loc12_ = function()
      {
         this.gapi.hideTooltip();
      };
      var _loc13_ = 0;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      var _loc17_;
      while(_loc13_ <= 2)
      {
         _loc14_ = this._mcFlagsDirection.getNextHighestDepth();
         _loc15_ = this._mcFlagsDirection.attachMovie(this.getDirectionLinkageByScale(_loc13_),"dir" + _loc14_,_loc14_);
         _loc15_.stop();
         _loc16_ = new Color(_loc15_._mcCursor._mc._mcColor);
         _loc17_ = {};
         _loc17_ = {ra:0,ga:0,ba:0,rb:_loc6_,gb:_loc7_,bb:_loc8_};
         _loc16_.setTransform(_loc17_);
         _loc15_.tooltipText = _loc9_;
         _loc15_.gapi = this.gapi;
         _loc15_.mcTarget = _loc15_._mcCursor;
         _loc15_.onRollOver = _loc11_;
         _loc15_.onRollOut = _loc12_;
         _loc15_._visible = false;
         this.addClickEvent(_loc15_);
         _loc10_.push(_loc15_);
         _loc13_ = _loc13_ + 1;
      }
      if(!this._mcFlagsContainer)
      {
         this._mcFlagsContainer = this._mcFlags.createEmptyMovieClip("_mcFlagsContainer",1);
      }
      var _loc18_ = this._mcFlagsContainer.getNextHighestDepth();
      var _loc19_ = this._mcFlagsContainer.attachMovie("UI_MapExplorerFlag","flag" + _loc18_,_loc18_);
      _loc19_._x = this._nScaledWidth * nX + this._nScaledWidth / 2;
      _loc19_._y = this._nScaledHeight * nY + this._nScaledHeight / 2;
      _loc19_._xscale = this._nMapScale;
      _loc19_._yscale = this._nMapScale;
      var _loc20_ = new Color(_loc19_._mcColor);
      var _loc21_ = {};
      _loc21_ = {ra:0,ga:0,ba:0,rb:_loc6_,gb:_loc7_,bb:_loc8_};
      _loc20_.setTransform(_loc21_);
      this._aFlags.push({x:nX,y:nY,color:nColor,aDirections:_loc10_});
      _loc19_.tooltipText = _loc9_;
      _loc19_.gapi = this.gapi;
      _loc19_.mcTarget = _loc19_;
      _loc19_.onRollOver = _loc11_;
      _loc19_.onRollOut = _loc12_;
      this.addClickEvent(_loc19_);
      this.updateMap();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.MiniMap.CLASS_NAME);
   }
   function createChildren()
   {
      this.setScale(dofus.graphics.gapi.controls.MiniMap.SCALE_CUSTOM,false);
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.loadMap});
      this.addToQueue({object:this,method:this.updateFlags});
      this._nRandomTag = Math.random();
   }
   function addListeners()
   {
      this.api.gfx.addEventListener("mapLoaded",this);
      this._ldrBitmapMap.addEventListener("initialization",this);
      this.api.datacenter.Conquest.addEventListener("worldDataChanged",this);
   }
   function addClickEvent(mc)
   {
      var _loc3_;
      var _loc4_;
      if(this.api.datacenter.Player.isAuthorized)
      {
         var miniMap = this;
         _loc3_ = function()
         {
            miniMap.onAdminClick();
         };
         mc.onPress = _loc3_;
         delete mc.onRelease;
      }
      else
      {
         var miniMap = this;
         _loc4_ = function()
         {
            miniMap.click();
         };
         mc.onRelease = _loc4_;
         delete mc.onPress;
      }
   }
   function loadMap(bForceReload)
   {
      if(this._dmMap.superarea == undefined)
      {
         this.addToQueue({object:this,method:this.loadMap,params:[bForceReload]});
         return false;
      }
      if(!this._bIsInDungeon)
      {
         if(this._dmMap.superarea !== this._nCurrentArea || bForceReload)
         {
            this._nCurrentArea = this._dmMap.superarea;
            this._ldrBitmapMap.contentPath = dofus.Constants.LOCAL_MAPS_PATH + this._nCurrentArea + ".swf";
            return true;
         }
         return false;
      }
      if(this._dmMap.id !== this._nCurrentArea || bForceReload)
      {
         this._nCurrentArea = this._dmMap.dungeonID;
         this._ldrBitmapMap.contentPath = dofus.Constants.MAP_DUNGEON_FILE;
      }
      return false;
   }
   function initMap()
   {
      this._mcBitmapContainer.removeMovieClip();
      this._mcBitmapContainer = this._ldrBitmapMap.content.createEmptyMovieClip("_mcBitmapContainer",1);
      this._mcBitmapContainer._visible = false;
      this._mcHintsContainer._visible = false;
      this.addClickEvent(this._mcBitmapContainer);
      this.addClickEvent(this._mcCursor);
      var thisMiniMap = this;
      this._mcBitmapContainer.onRollOut = function()
      {
         this.gapi.hideTooltip();
      };
      this._mcBitmapContainer.onRollOver = function()
      {
         thisMiniMap.dispatchEvent({type:"over"});
      };
      this._mcCursor._xscale = this._nMapScale;
      this._mcCursor._yscale = this._nMapScale;
      this._mcCursor.oMap = this._dmMap;
      this._mcCursor.gapi = this.gapi;
      var sLabel;
      this._mcCursor.onRollOver = function()
      {
         if(this.oMap.dungeonFloorName != undefined)
         {
            sLabel = "[" + this.oMap.dungeonCurrentMap.x + ", " + this.oMap.dungeonCurrentMap.y + "] " + this.oMap.dungeonFloorName;
         }
         else
         {
            sLabel = "[" + this.oMap.x + ", " + this.oMap.y + "]";
         }
         thisMiniMap.dispatchEvent({type:"over"});
         this.gapi.showTooltip(sLabel);
      };
      this._mcCursor.onRollOut = function()
      {
         this.gapi.hideTooltip();
      };
   }
   function drawMap()
   {
      var _loc2_ = -10;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      while(_loc2_ < 10)
      {
         _loc3_ = -10;
         while(_loc3_ < 10)
         {
            _loc4_ = Math.floor(this._dmMap.x / dofus.graphics.gapi.controls.MiniMap.MAP_IMG_WIDTH);
            _loc5_ = Math.floor(this._dmMap.y / dofus.graphics.gapi.controls.MiniMap.MAP_IMG_HEIGHT);
            if(_loc4_ < _loc2_ - 2 || (_loc4_ > _loc2_ + 2 || (_loc5_ < _loc3_ - 2 || _loc5_ > _loc3_ + 2)))
            {
               if(this._mcBitmapContainer[_loc2_ + "_" + _loc3_] != undefined)
               {
                  this._mcBitmapContainer[_loc2_ + "_" + _loc3_].removeMovieClip();
               }
            }
            else if(this._mcBitmapContainer[_loc2_ + "_" + _loc3_] == undefined)
            {
               _loc6_ = this._mcBitmapContainer.attachMovie(_loc2_ + "_" + _loc3_,_loc2_ + "_" + _loc3_,this._mcBitmapContainer.getNextHighestDepth());
               _loc6_._xscale = this._nMapScale;
               _loc6_._yscale = this._nMapScale;
               _loc6_._x = _loc6_._width * _loc2_;
               _loc6_._y = _loc6_._height * _loc3_;
            }
            _loc3_ = _loc3_ + 1;
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function showHintsCategory(categoryID, bShow)
   {
      var _loc4_ = "hints" + categoryID;
      if(!this._mcHintsContainer[_loc4_])
      {
         this._mcHintsContainer.createEmptyMovieClip(_loc4_,categoryID);
      }
      if(!bShow)
      {
         this._ldrHints.content[_loc4_].removeMovieClip();
         return undefined;
      }
      var _loc5_;
      if(dofus.graphics.gapi.ui.MapExplorer.FILTER_CONQUEST_ID == categoryID)
      {
         _loc5_ = dofus.datacenter.Hint.getConquestAreaHints();
      }
      else
      {
         _loc5_ = this.api.lang.getHintsByCategory(categoryID);
      }
      var _loc6_ = 0;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      while(_loc6_ < _loc5_.length)
      {
         _loc7_ = new dofus.datacenter.Hint(_loc5_[_loc6_]);
         _loc8_ = this._mcHintsContainer[_loc4_]["hint" + _loc6_];
         if(_loc7_.superAreaID !== this._dmMap.superarea)
         {
            _loc8_.removeMovieClip();
         }
         else if(_loc8_.oHint.gfx != _loc7_.gfx)
         {
            _loc9_ = this.dist(_loc7_.x,_loc7_.y,this._dmMap.x,this._dmMap.y);
            if(_loc9_ > this._nShowHintsMaxDistance)
            {
               _loc8_.removeMovieClip();
            }
            else
            {
               var thisMiniMap = this;
               _loc10_ = this._mcHintsContainer[_loc4_].attachMovie(_loc7_.gfx,"hint" + _loc6_,_loc6_,{_xscale:this._nMapScale,_yscale:this._nMapScale});
               _loc10_._x = this._nScaledWidth * _loc7_.x + this._nScaledWidth / 2;
               _loc10_._y = this._nScaledHeight * _loc7_.y + this._nScaledHeight / 2;
               _loc10_.oHint = _loc7_;
               _loc10_.gapi = this.gapi;
               _loc10_.onRollOver = function()
               {
                  thisMiniMap.dispatchEvent({type:"over"});
                  this.gapi.showTooltip("[" + this.oHint.x + ", " + this.oHint.y + "] " + this.oHint.name);
               };
               _loc10_.onRollOut = function()
               {
                  this.gapi.hideTooltip();
               };
               this.addClickEvent(_loc10_);
            }
         }
         _loc6_ = _loc6_ + 1;
      }
   }
   function drawDungeonMap()
   {
      var _loc2_ = "dungeonCell" + this._dmMap.area;
      if(!this._mcBitmapContainer[_loc2_])
      {
         this._mcBitmapContainer.createEmptyMovieClip(_loc2_,1);
      }
      this.addIconsOnDungeonMap(this._mcBitmapContainer,_loc2_,"UI_MapExplorerRectangle");
      var _loc3_ = this._ldrBitmapMap.content.parchment;
      _loc3_._width = this.customBgScaleWidth + this.customBgScaleWidth * 0.5;
      _loc3_._height = this._nCustomBgScaleHeight;
      _loc3_._x = (- _loc3_._width) / 2 - _loc3_._width * 0.15;
      _loc3_._y = (- _loc3_._height) / 2;
   }
   function showDungeonHints(bShow)
   {
      var _loc3_ = "dungeonHint" + this._dmMap.area;
      if(!this._mcHintsContainer[_loc3_])
      {
         this._mcHintsContainer.createEmptyMovieClip(_loc3_,100);
      }
      if(!bShow)
      {
         this._ldrHints.content[_loc3_].removeMovieClip();
         return undefined;
      }
      this.addIconsOnDungeonMap(this._mcHintsContainer,_loc3_,undefined);
   }
   function addIconsOnDungeonMap(mc, sLayer, sGfx)
   {
      var _loc5_ = sGfx;
      var _loc6_ = 0;
      var _loc7_ = this._dmMap.dungeon.m;
      var _loc8_ = this._dmMap.dungeonCurrentMap;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      for(var mapID in _loc7_)
      {
         _loc9_ = _loc7_[mapID];
         _loc10_ = sLayer + mapID;
         _loc11_ = mc[sLayer];
         if(_loc11_[_loc10_] == undefined)
         {
            if(_loc8_.z == _loc9_.z)
            {
               if(sGfx == undefined)
               {
                  if(_loc9_.i == undefined)
                  {
                     continue;
                  }
                  sGfx = _loc9_.i;
               }
               _loc12_ = _loc11_.attachMovie(sGfx,_loc10_,_loc6_);
               _loc12_._xscale = this._nMapScale;
               _loc12_._yscale = this._nMapScale;
               _loc12_._x = this._nScaledWidth * _loc9_.x + this._nScaledWidth / 2;
               _loc12_._y = this._nScaledHeight * _loc9_.y + this._nScaledHeight / 2;
               if(_loc9_.n != undefined)
               {
                  _loc12_.label = "[" + _loc9_.x + ", " + _loc9_.y + "] " + _loc9_.n;
                  _loc12_.gapi = this.gapi;
                  _loc12_.onRollOver = function()
                  {
                     this.gapi.showTooltip(this.label);
                  };
                  _loc12_.onRollOut = function()
                  {
                     this.gapi.hideTooltip();
                  };
                  _loc6_ = _loc6_ + 1;
                  sGfx = _loc5_;
               }
            }
         }
      }
   }
   function updateMap()
   {
      this.updateDataMap();
      this.updateHints();
      var _loc2_;
      var _loc3_;
      if(this._bIsInDungeon)
      {
         _loc2_ = this._dmMap.dungeonCurrentMap.x;
         _loc3_ = this._dmMap.dungeonCurrentMap.y;
      }
      else
      {
         _loc2_ = this._dmMap.x;
         _loc3_ = this._dmMap.y;
      }
      this._mcBitmapContainer._x = (- this._nScaledWidth) * _loc2_ - this._nScaledWidth / 2;
      this._mcBitmapContainer._y = (- this._nScaledHeight) * _loc3_ - this._nScaledHeight / 2;
      this._mcHintsContainer._x = this._mcBitmapContainer._x;
      this._mcHintsContainer._y = this._mcBitmapContainer._y;
      this._mcFlagsContainer._x = this._mcBitmapContainer._x;
      this._mcFlagsContainer._y = this._mcBitmapContainer._y;
      if(this._bIsInDungeon)
      {
         this.drawDungeonMap();
      }
      else
      {
         this.drawMap();
      }
      this.updateFlagsDirections();
      this._mcBitmapContainer._visible = true;
      this._mcHintsContainer._visible = true;
   }
   function updateDataMap()
   {
      this._dmMap = this.api.datacenter.Map;
      this._bIsInDungeon = this._dmMap.isDungeon && !this.api.datacenter.Player.isAuthorized;
      this._mcFlagsContainer._visible = !this._bIsInDungeon;
      this._mcCursor.oMap = this._dmMap;
   }
   function updateHints()
   {
      var _loc2_ = this.api.lang.getHintsCategories();
      _loc2_[-1] = {n:this.api.lang.getText("OPTION_GRID"),c:"Yellow"};
      var _loc3_ = this.api.kernel.OptionsManager.getOption("MapFilters");
      this._mcHintsContainer = this._ldrHints.content;
      var _loc4_ = -1;
      while(_loc4_ < _loc2_.length)
      {
         if(_loc4_ != -1)
         {
            this.showHintsCategory(_loc4_,!this._bIsInDungeon && _loc3_[_loc4_] == 1);
         }
         _loc4_ = _loc4_ + 1;
      }
      this.showDungeonHints(this._bIsInDungeon);
   }
   function updateFlagsDirections()
   {
      var _loc2_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      for(var i in this._aFlags)
      {
         _loc2_ = this._aFlags[i].x - this._dmMap.x;
         _loc3_ = this._aFlags[i].y - this._dmMap.y;
         if(!(_global.isNaN(_loc3_) || _global.isNaN(_loc2_)))
         {
            _loc4_ = this._aFlags[i].aDirections;
            if(dofus.graphics.gapi.controls.MiniMap.HIDE_FLAG_ZONE[_loc3_ + 6][_loc2_ + 3] == undefined || dofus.graphics.gapi.controls.MiniMap.HIDE_FLAG_ZONE[_loc3_ + 6][_loc2_ + 3] == 1)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  _loc6_ = _loc4_[_loc5_];
                  if(_loc5_ != this._nScale)
                  {
                     _loc6_._visible = false;
                  }
                  else
                  {
                     _loc6_._visible = true;
                     _loc7_ = Math.floor(Math.atan2(_loc3_,_loc2_) / Math.PI * 180);
                     if(_loc7_ < 0)
                     {
                        _loc7_ += 360;
                     }
                     if(_loc7_ > 360)
                     {
                        _loc7_ -= 360;
                     }
                     _loc6_.gotoAndStop(_loc7_ + 1);
                     _loc6_._mcCursor.gotoAndStop(_loc7_ + 1);
                  }
                  _loc5_ = _loc5_ + 1;
               }
            }
            else
            {
               _loc8_ = 0;
               while(_loc8_ < _loc4_.length)
               {
                  _loc9_ = _loc4_[_loc8_];
                  _loc9_._visible = false;
                  _loc8_ = _loc8_ + 1;
               }
            }
         }
      }
   }
   function getDirectionLinkageByScale(nScale)
   {
      switch(nScale)
      {
         case dofus.graphics.gapi.controls.MiniMap.SCALE_SMALL:
            return "FlagDirectionSmall";
         case dofus.graphics.gapi.controls.MiniMap.SCALE_NORMAL:
            return "FlagDirection";
         case dofus.graphics.gapi.controls.MiniMap.SCALE_BIG:
            return "FlagDirectionBig";
         default:
            return undefined;
      }
   }
   function onClickTimer(bIsClick)
   {
      ank.utils.Timer.removeTimer(this,"minimap");
      this._bTimerEnable = false;
      if(bIsClick)
      {
         this.click();
      }
   }
   function getCoordinatesFromReal(nRealX, nRealY)
   {
      var _loc4_ = Math.floor(nRealX / this._nScaledWidth);
      var _loc5_ = Math.floor(nRealY / this._nScaledHeight);
      return {x:_loc4_,y:_loc5_};
   }
   function dist(x1, y1, x2, y2)
   {
      var _loc6_ = x1 - x2;
      var _loc7_ = y1 - y2;
      return Math.sqrt(_loc6_ * _loc6_ + _loc7_ * _loc7_);
   }
   function mapLoaded(oEvent)
   {
      this.updateDataMap();
      if(!this.loadMap())
      {
         this.updateMap();
      }
   }
   function initialization(oEvent)
   {
      this.initMap();
      this.updateMap();
   }
   function showScaledBackground()
   {
      var _loc2_ = [this._mcBgSmall,this._mcBg,this._mcBgBig];
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < _loc2_.length)
      {
         _loc4_ = _loc2_[_loc3_];
         if(this._nScale == _loc3_)
         {
            _loc4_._visible = true;
         }
         else
         {
            _loc4_._visible = false;
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function click()
   {
      if(getTimer() - this._nLastDoubleClick < 750)
      {
         return undefined;
      }
      this.dispatchEvent({type:"click"});
   }
   function doubleClick(oEvent)
   {
      this._nLastDoubleClick = getTimer();
      var _loc3_;
      var _loc4_;
      if(!this.api.datacenter.Game.isFight && !this._bIsInDungeon)
      {
         _loc3_ = oEvent.coordinates.x;
         _loc4_ = oEvent.coordinates.y;
         if(_loc3_ != undefined && _loc4_ != undefined)
         {
            this.api.network.Basics.autorisedMoveCommand(_loc3_,_loc4_);
         }
      }
   }
   function onAdminClick()
   {
      var _loc2_;
      var _loc3_;
      var _loc4_;
      if(this._bTimerEnable != true)
      {
         this._bTimerEnable = true;
         ank.utils.Timer.setTimer(this,"minimap",this,this.onClickTimer,ank.gapi.Gapi.DBLCLICK_DELAY,[true]);
      }
      else
      {
         this.onClickTimer(false);
         _loc2_ = this._mcBitmapContainer._xmouse;
         _loc3_ = this._mcBitmapContainer._ymouse;
         _loc4_ = this.getCoordinatesFromReal(_loc2_,_loc3_);
         this.doubleClick({coordinates:_loc4_});
      }
   }
   function worldDataChanged(oEvent)
   {
      this.addToQueue({object:this,method:this.showHintsCategory,params:[dofus.graphics.gapi.ui.MapExplorer.FILTER_CONQUEST_ID,this.api.kernel.OptionsManager.isMapConquestFilterEnabled]});
   }
}
