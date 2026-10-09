class ank.battlefield.MapHandler
{
   var _mcBattlefield;
   var _mcContainer;
   var _nAdjustTimer;
   var _nLastCellCount;
   var _nLoadRequest;
   var _oDatacenter;
   var api;
   static var OBJECT_TYPE_BACKGROUND = 1;
   static var OBJECT_TYPE_GROUND = 2;
   static var OBJECT_TYPE_OBJECT1 = 3;
   static var OBJECT_TYPE_OBJECT2 = 4;
   static var TIME_BEFORE_AJUSTING_MAP = 500;
   var _oLoadingCells = {};
   var _oSettingFrames = {};
   var _mclLoader = new MovieClipLoader();
   var _nMaxMapRender = 1;
   var _bShowingFightCells = false;
   var _bTacticMode = false;
   var _nTacticDecorTotalAsset = 3;
   function MapHandler(b, c, d)
   {
      if(b != undefined)
      {
         this.initialize(b,c,d);
      }
      this._mclLoader.addListener(this);
   }
   function get showingFightCells()
   {
      return this._bShowingFightCells;
   }
   function set showingFightCells(bShowingFightCells)
   {
      this._bShowingFightCells = bShowingFightCells;
   }
   function get LoaderRequestLeft()
   {
      return this._nLoadRequest;
   }
   function get validCellsData()
   {
      return this._oDatacenter.Map.validCells;
   }
   function get lineOfSightCellsData()
   {
      return this._oDatacenter.Map.lineOfSightCells;
   }
   function initialize(b, c, d)
   {
      this._mcBattlefield = b;
      this._oDatacenter = d;
      this._mcContainer = c;
      this.api = _global.API;
   }
   function build(oMap, nCellNum, bBuildAll)
   {
      this._oDatacenter.Map = oMap;
      var _loc5_ = ank.battlefield.Constants.CELL_WIDTH;
      var _loc6_ = ank.battlefield.Constants.CELL_HALF_WIDTH;
      var _loc7_ = ank.battlefield.Constants.CELL_HALF_HEIGHT;
      var _loc8_ = ank.battlefield.Constants.LEVEL_HEIGHT;
      var _loc9_ = -1;
      var _loc10_ = 0;
      var _loc11_ = 0;
      var _loc12_ = oMap.data;
      var _loc13_ = _loc12_.length;
      var _loc14_ = oMap.width - 1;
      var _loc15_ = this._mcContainer.ExternalContainer;
      var _loc16_ = nCellNum != undefined;
      var _loc17_ = false;
      var _loc18_ = this._nLastCellCount == _loc13_;
      this._nLoadRequest = 0;
      if(!_loc16_ && (ank.battlefield.Constants.USE_STREAMING_FILES && ank.battlefield.Constants.STREAMING_METHOD == "explod"))
      {
         this._mcContainer.applyMask(false);
      }
      var _loc19_;
      if(oMap.backgroundNum != 0)
      {
         if(ank.battlefield.Constants.USE_STREAMING_FILES && (ank.battlefield.Constants.STREAMING_METHOD == "explod" && !_loc16_))
         {
            _loc19_ = _loc15_.Ground.createEmptyMovieClip("background",-1);
            _loc19_.cacheAsBitmap = _global.CONFIG.cacheAsBitmap["mapHandler/BACKGROUND"];
            this._mclLoader.loadClip(ank.battlefield.Constants.STREAMING_GROUNDS_DIR + oMap.backgroundNum + ".swf",_loc19_);
            this._nLoadRequest = this._nLoadRequest + 1;
         }
         else if(ank.battlefield.Constants.STREAMING_METHOD != "")
         {
            _loc15_.Ground.attachMovie(oMap.backgroundNum,"background",-1).cacheAsBitmap = _global.CONFIG.cacheAsBitmap["mapHandler/BACKGROUND"];
         }
         else
         {
            _loc15_.Ground.attach(oMap.backgroundNum,"background",-1).cacheAsBitmap = _global.CONFIG.cacheAsBitmap["mapHandler/BACKGROUND"];
         }
      }
      var _loc20_ = -1;
      var _loc21_;
      var _loc22_;
      var _loc23_;
      var _loc24_;
      var _loc26_;
      var _loc25_;
      var _loc28_;
      var _loc27_;
      var _loc29_;
      var _loc31_;
      var _loc30_;
      var _loc32_;
      var _loc33_;
      var _loc34_;
      while((_loc20_ = _loc20_ + 1) < _loc13_)
      {
         if(_loc9_ == _loc14_)
         {
            _loc9_ = 0;
            _loc10_ += 1;
            if(_loc11_ == 0)
            {
               _loc11_ = _loc6_;
               _loc14_ -= 1;
            }
            else
            {
               _loc11_ = 0;
               _loc14_ += 1;
            }
         }
         else
         {
            _loc9_ = _loc9_ + 1;
         }
         if(_loc16_)
         {
            if(_loc20_ < nCellNum)
            {
               continue;
            }
            if(_loc20_ > nCellNum)
            {
               return undefined;
            }
         }
         _loc21_ = _loc12_[_loc20_];
         if(_loc21_.active)
         {
            _loc22_ = _loc9_ * _loc5_ + _loc11_;
            _loc23_ = _loc10_ * _loc7_ - _loc8_ * (_loc21_.groundLevel - 7);
            _loc21_.x = _loc22_;
            _loc21_.y = _loc23_;
            if(_loc21_.movement || bBuildAll)
            {
               if(!_loc18_ && !_loc15_.InteractionCell["cell" + _loc20_])
               {
                  if(!_loc17_)
                  {
                     if(ank.battlefield.Constants.STREAMING_METHOD != "")
                     {
                        _loc24_ = _loc15_.InteractionCell.attachMovie("i" + _loc21_.groundSlope,"cell" + _loc20_,_loc20_,{_x:_loc22_,_y:_loc23_});
                     }
                     else
                     {
                        _loc24_ = _loc15_.InteractionCell.attachMovie("i" + _loc21_.groundSlope,"cell" + _loc20_,_loc20_,{_x:_loc22_,_y:_loc23_});
                     }
                  }
                  else
                  {
                     _loc24_ = _loc15_.InteractionCell.createEmptyMovieClip("cell" + _loc20_,_loc20_,{_x:_loc22_,_y:_loc23_});
                  }
                  _loc24_.__proto__ = ank.battlefield.mc.Cell.prototype;
                  _loc24_.initialize(this._mcBattlefield);
               }
               else
               {
                  _loc24_ = _loc15_.InteractionCell["cell" + _loc20_];
               }
               _loc21_.mc = _loc24_;
               _loc24_.data = _loc21_;
            }
            else
            {
               _loc15_.InteractionCell["cell" + _loc20_].removeMovieClip();
            }
            if(_loc21_.layerGroundNum != 0)
            {
               if(ank.battlefield.Constants.USE_STREAMING_FILES && ank.battlefield.Constants.STREAMING_METHOD == "explod")
               {
                  _loc26_ = true;
                  if(_loc16_)
                  {
                     _loc25_ = _loc15_.Ground["cell" + _loc20_];
                     if(_loc25_ != undefined && _loc25_.lastGroundID == _loc21_.layerGroundNum)
                     {
                        _loc25_.fullLoaded = _loc26_ = false;
                        this._oLoadingCells[_loc25_] = _loc21_;
                        this.onLoadInit(_loc25_);
                     }
                  }
                  if(_loc26_)
                  {
                     _loc25_ = _loc15_.Ground.createEmptyMovieClip("cell" + _loc20_,_loc20_);
                     _loc25_.fullLoaded = false;
                     this._oLoadingCells[_loc25_] = _loc21_;
                     this._mclLoader.loadClip(ank.battlefield.Constants.STREAMING_GROUNDS_DIR + _loc21_.layerGroundNum + ".swf",_loc25_);
                     this._nLoadRequest = this._nLoadRequest + 1;
                  }
               }
               else
               {
                  if(!_loc17_)
                  {
                     if(ank.battlefield.Constants.STREAMING_METHOD != "")
                     {
                        _loc25_ = _loc15_.Ground.attachMovie(_loc21_.layerGroundNum,"cell" + _loc20_,_loc20_);
                     }
                     else
                     {
                        _loc25_ = _loc15_.Ground.attach(_loc21_.layerGroundNum,"cell" + _loc20_,_loc20_);
                     }
                  }
                  else
                  {
                     _loc25_ = new MovieClip();
                  }
                  _loc25_.cacheAsBitmap = _global.CONFIG.cacheAsBitmap["mapHandler/Cell/Ground"];
                  _loc25_._x = _loc22_;
                  _loc25_._y = _loc23_;
                  if(_loc21_.groundSlope != 1)
                  {
                     _loc25_.gotoAndStop(_loc21_.groundSlope);
                  }
                  else if(_loc21_.layerGroundRot != 0)
                  {
                     _loc25_._rotation = _loc21_.layerGroundRot * 90;
                     if(_loc25_._rotation % 180)
                     {
                        _loc25_._yscale = 192.86;
                        _loc25_._xscale = 51.85;
                     }
                  }
                  if(_loc21_.layerGroundFlip)
                  {
                     _loc25_._xscale *= -1;
                  }
               }
            }
            else
            {
               _loc15_.Ground["cell" + _loc20_].removeMovieClip();
            }
            if(_loc21_.layerObject1Num != 0)
            {
               if(ank.battlefield.Constants.USE_STREAMING_FILES && ank.battlefield.Constants.STREAMING_METHOD == "explod")
               {
                  _loc28_ = true;
                  if(_loc16_)
                  {
                     _loc27_ = _loc15_.Object1["cell" + _loc20_];
                     if(_loc27_ != undefined && _loc27_.lastObject1ID == _loc21_.layerObject1Num)
                     {
                        _loc27_.fullLoaded = _loc28_ = false;
                        this._oLoadingCells[_loc27_] = _loc21_;
                        this.onLoadInit(_loc27_);
                     }
                  }
                  if(_loc28_)
                  {
                     _loc27_ = _loc15_.Object1.createEmptyMovieClip("cell" + _loc20_,_loc20_);
                     _loc27_.fullLoaded = false;
                     this._oLoadingCells[_loc27_] = _loc21_;
                     this._mclLoader.loadClip(ank.battlefield.Constants.STREAMING_OBJECTS_DIR + _loc21_.layerObject1Num + ".swf",_loc27_);
                     this._nLoadRequest = this._nLoadRequest + 1;
                  }
               }
               else
               {
                  if(!_loc17_)
                  {
                     _loc27_ = _loc15_.Object1.attachMovie(_loc21_.layerObject1Num,"cell" + _loc20_,_loc20_);
                  }
                  else
                  {
                     _loc27_ = new MovieClip();
                  }
                  _loc27_.cacheAsBitmap = _global.CONFIG.cacheAsBitmap["mapHandler/Cell/Object1"];
                  _loc27_._x = _loc22_;
                  _loc27_._y = _loc23_;
                  if(_loc21_.groundSlope == 1 && _loc21_.layerObject1Rot != 0)
                  {
                     _loc27_._rotation = _loc21_.layerObject1Rot * 90;
                     if(_loc27_._rotation % 180)
                     {
                        _loc27_._yscale = 192.86;
                        _loc27_._xscale = 51.85;
                     }
                  }
                  if(_loc21_.layerObject1Flip)
                  {
                     _loc27_._xscale *= -1;
                  }
               }
               _loc21_.mcObject1 = _loc27_;
            }
            else
            {
               _loc15_.Object1["cell" + _loc20_].removeMovieClip();
            }
            if(_loc21_.layerObjectExternal != "")
            {
               if(!_loc17_)
               {
                  _loc29_ = _loc15_.Object2.attachClassMovie(ank.battlefield.mc.InteractiveObject,"cellExt" + _loc20_,_loc20_ * 100 + 1);
               }
               _loc29_.cacheAsBitmap = _global.CONFIG.cacheAsBitmap["mapHandler/Cell/ObjectExternal"];
               _loc29_.initialize(this._mcBattlefield,_loc21_,_loc21_.layerObjectExternalInteractive);
               _loc29_.loadExternalClip(_loc21_.layerObjectExternal,_loc21_.layerObjectExternalAutoSize);
               _loc29_._x = _loc22_;
               _loc29_._y = _loc23_;
               _loc21_.mcObjectExternal = _loc29_;
            }
            else
            {
               _loc15_.Object2["cellExt" + _loc20_].removeMovieClip();
               delete _loc21_.mcObjectExternal;
            }
            if(_loc21_.layerObject2Num != 0)
            {
               if(ank.battlefield.Constants.USE_STREAMING_FILES && ank.battlefield.Constants.STREAMING_METHOD == "explod")
               {
                  _loc31_ = true;
                  if(_loc16_)
                  {
                     _loc30_ = _loc15_.Object2["cell" + _loc20_];
                     if(_loc30_ != undefined && _loc30_.lastObject2ID == _loc21_.layerObject2Num)
                     {
                        _loc30_.fullLoaded = _loc31_ = false;
                        this._oLoadingCells[_loc30_] = _loc21_;
                        this.onLoadInit(_loc30_);
                     }
                  }
                  if(_loc31_)
                  {
                     _loc30_ = _loc15_.Object2.createEmptyMovieClip("cell" + _loc20_,_loc20_ * 100);
                     _loc30_.fullLoaded = false;
                     this._oLoadingCells[_loc30_] = _loc21_;
                     this._mclLoader.loadClip(ank.battlefield.Constants.STREAMING_OBJECTS_DIR + _loc21_.layerObject2Num + ".swf",_loc30_);
                     this._nLoadRequest = this._nLoadRequest + 1;
                  }
               }
               else
               {
                  if(!_loc17_)
                  {
                     _loc30_ = _loc15_.Object2.attachMovie(_loc21_.layerObject2Num,"cell" + _loc20_,_loc20_ * 100);
                  }
                  else
                  {
                     _loc30_ = new MovieClip();
                  }
                  if(_loc30_)
                  {
                     _loc30_.cacheAsBitmap = _global.CONFIG.cacheAsBitmap["mapHandler/Cell/Object2"];
                     if(_loc21_.layerObject2Interactive)
                     {
                        _loc30_.__proto__ = ank.battlefield.mc.InteractiveObject.prototype;
                        _loc30_.initialize(this._mcBattlefield,_loc21_,true);
                     }
                     _loc30_._x = _loc22_;
                     _loc30_._y = _loc23_;
                     if(_loc21_.layerObject2Flip)
                     {
                        _loc30_._xscale = -100;
                     }
                  }
               }
               if(_loc30_)
               {
                  _loc21_.mcObject2 = _loc30_;
               }
               else
               {
                  _loc21_.layerObject2Num = 0;
                  _loc15_.Object2["cell" + _loc20_].removeMovieClip();
                  delete _loc21_.mcObject2;
               }
            }
            else
            {
               _loc15_.Object2["cell" + _loc20_].removeMovieClip();
               delete _loc21_.mcObject2;
            }
         }
         else if(bBuildAll)
         {
            _loc32_ = _loc9_ * _loc5_ + _loc11_;
            _loc33_ = _loc10_ * _loc7_;
            _loc21_.x = _loc32_;
            _loc21_.y = _loc33_;
            _loc34_ = _loc15_.InteractionCell.attachMovie("i1","cell" + _loc20_,_loc20_,{_x:_loc32_,_y:_loc33_});
            _loc34_.__proto__ = ank.battlefield.mc.Cell.prototype;
            _loc34_.initialize(this._mcBattlefield);
            _loc21_.mc = _loc34_;
            _loc34_.data = _loc21_;
         }
      }
      if(!_loc16_)
      {
         if(ank.battlefield.Constants.USE_STREAMING_FILES && ank.battlefield.Constants.STREAMING_METHOD == "explod")
         {
            if(this._nAdjustTimer != undefined)
            {
               return undefined;
            }
            this._nAdjustTimer = _global.setInterval(this,"adjustAndMaskMap",ank.battlefield.MapHandler.TIME_BEFORE_AJUSTING_MAP);
         }
         else
         {
            this.adjustAndMaskMap();
         }
      }
   }
   function tacticMode(bOrig)
   {
      var _loc3_ = this._bTacticMode != bOrig;
      if(!_loc3_)
      {
         return undefined;
      }
      var _loc4_ = this._oDatacenter.Map;
      var _loc5_ = _loc4_.data;
      if(bOrig)
      {
         this._mcContainer.ExternalContainer.clearGround();
         if(_loc4_.savedBackgroundNum == undefined && _loc4_.backgroundNum != 631)
         {
            _loc4_.savedBackgroundNum = _loc4_.backgroundNum;
         }
         _loc4_.backgroundNum = 631;
      }
      else if(_loc4_.savedBackgroundNum != undefined)
      {
         if(_loc4_.savedBackgroundNum == 0)
         {
            _loc4_.backgroundNum = 632;
         }
         else
         {
            _loc4_.backgroundNum = _loc4_.savedBackgroundNum;
         }
      }
      for(var mapCell in _loc5_)
      {
         this.tacticModeRefreshCell(Number(mapCell),bOrig);
      }
      this._bTacticMode = bOrig;
      if(this._bTacticMode)
      {
         this.addTacticAdditionnalDecor(this.lineOfSightCellsData,this.api.lang.getMapSubareaTacticTheme(this.api.datacenter.Map.subarea));
      }
      else
      {
         this.removeTacticAdditionnalDecor(this.lineOfSightCellsData);
      }
   }
   function tacticModeRefreshCell(nCellNum, bOrig)
   {
      if(nCellNum > this.getCellCount())
      {
         ank.utils.Logger.err("[MapHandler] (tacticModeRefreshCell) Cellule " + nCellNum + " inexistante");
         return undefined;
      }
      var _loc4_ = this._oDatacenter.Map;
      var _loc5_ = _loc4_.data[nCellNum];
      if(_loc5_.layerObject2Num == 4561 || _loc5_.layerObject2Num == 4562)
      {
         return undefined;
      }
      if(!_loc5_.active)
      {
         return undefined;
      }
      var _loc6_;
      var _loc7_;
      if(!bOrig)
      {
         _loc6_ = ank.battlefield.datacenter.Cell(_loc4_.originalsCellsBackup.getItemAt(String(nCellNum)));
         if(_loc6_ == undefined)
         {
            ank.utils.Logger.err("[MapHandler] (tacticModeRefreshCell) La case est déjà dans son état init");
            return undefined;
         }
         _loc5_.layerGroundNum = _loc6_.layerGroundNum;
         _loc5_.layerObject1Rot = _loc6_.layerObject1Rot;
         _loc5_.layerObject1Num = _loc6_.layerObject1Num;
         _loc5_.layerObject1Flip = _loc6_.layerObject1Flip;
         _loc5_.layerObject2Flip = _loc6_.layerObject2Flip;
         if(_loc5_.layerObject2Num != 25)
         {
            _loc5_.layerObject2Num = _loc6_.layerObject2Num;
         }
      }
      else
      {
         if(_loc5_.nPermanentLevel == 0)
         {
            _loc7_ = new ank.battlefield.datacenter.Cell();
            for(var cellData in _loc5_)
            {
               _loc7_[cellData] = _loc5_[cellData];
            }
            _loc4_.originalsCellsBackup.addItemAt(String(nCellNum),_loc7_);
         }
         _loc5_.turnTactic(this,_loc4_);
      }
      this.build(_loc4_,nCellNum);
   }
   function updateCell(nCellNum, oNewCell, sMaskHex, nPermanentLevel)
   {
      if(nCellNum > this.getCellCount())
      {
         ank.utils.Logger.err("[updateCell] Cellule " + nCellNum + " inexistante");
         return undefined;
      }
      if(nPermanentLevel == undefined || _global.isNaN(nPermanentLevel))
      {
         nPermanentLevel = 0;
      }
      else
      {
         nPermanentLevel = Number(nPermanentLevel);
      }
      var _loc6_ = _global.parseInt(sMaskHex,16);
      var _loc7_ = (_loc6_ & 0x010000) != 0;
      var _loc8_ = (_loc6_ & 0x8000) != 0;
      var _loc9_ = (_loc6_ & 0x4000) != 0;
      var _loc10_ = (_loc6_ & 0x2000) != 0;
      var _loc11_ = (_loc6_ & 0x1000) != 0;
      var _loc12_ = (_loc6_ & 0x0800) != 0;
      var _loc13_ = (_loc6_ & 0x0400) != 0;
      var _loc14_ = (_loc6_ & 0x0200) != 0;
      var _loc15_ = (_loc6_ & 0x0100) != 0;
      var _loc16_ = (_loc6_ & 0x80) != 0;
      var _loc17_ = (_loc6_ & 0x40) != 0;
      var _loc18_ = (_loc6_ & 0x20) != 0;
      var _loc19_ = (_loc6_ & 0x10) != 0;
      var _loc20_ = (_loc6_ & 8) != 0;
      var _loc21_ = (_loc6_ & 4) != 0;
      var _loc22_ = (_loc6_ & 2) != 0;
      var _loc23_ = (_loc6_ & 1) != 0;
      var _loc24_ = this._oDatacenter.Map.data[nCellNum];
      var _loc25_;
      if(nPermanentLevel > 0)
      {
         if(_loc24_.nPermanentLevel == 0)
         {
            _loc25_ = new ank.battlefield.datacenter.Cell();
            for(var k in _loc24_)
            {
               _loc25_[k] = _loc24_[k];
            }
            this._oDatacenter.Map.originalsCellsBackup.addItemAt(nCellNum,_loc25_);
            _loc24_.nPermanentLevel = nPermanentLevel;
         }
      }
      if(_loc10_)
      {
         _loc24_.active = oNewCell.active;
      }
      if(_loc11_)
      {
         _loc24_.lineOfSight = oNewCell.lineOfSight;
      }
      if(_loc12_)
      {
         _loc24_.movement = oNewCell.movement;
      }
      if(_loc13_)
      {
         _loc24_.groundLevel = oNewCell.groundLevel;
      }
      if(_loc14_)
      {
         _loc24_.groundSlope = oNewCell.groundSlope;
      }
      if(_loc15_)
      {
         _loc24_.layerGroundNum = oNewCell.layerGroundNum;
      }
      if(_loc16_)
      {
         _loc24_.layerGroundFlip = oNewCell.layerGroundFlip;
      }
      if(_loc17_)
      {
         _loc24_.layerGroundRot = oNewCell.layerGroundRot;
      }
      if(_loc18_)
      {
         _loc24_.layerObject1Num = oNewCell.layerObject1Num;
      }
      if(_loc20_)
      {
         _loc24_.layerObject1Rot = oNewCell.layerObject1Rot;
      }
      if(_loc19_)
      {
         _loc24_.layerObject1Flip = oNewCell.layerObject1Flip;
      }
      if(_loc22_)
      {
         _loc24_.layerObject2Flip = oNewCell.layerObject2Flip;
      }
      if(_loc23_)
      {
         _loc24_.layerObject2Interactive = oNewCell.layerObject2Interactive;
      }
      if(_loc21_)
      {
         _loc24_.layerObject2Num = oNewCell.layerObject2Num;
      }
      if(_loc9_)
      {
         _loc24_.layerObjectExternal = oNewCell.layerObjectExternal;
      }
      if(_loc8_)
      {
         _loc24_.layerObjectExternalInteractive = oNewCell.layerObjectExternalInteractive;
      }
      if(_loc7_)
      {
         _loc24_.layerObjectExternalAutoSize = oNewCell.layerObjectExternalAutoSize;
      }
      _loc24_.layerObjectExternalData = oNewCell.layerObjectExternalData;
      this.build(this._oDatacenter.Map,nCellNum);
   }
   function initializeMap(nPermanentLevel)
   {
      if(nPermanentLevel == undefined)
      {
         nPermanentLevel = Number.POSITIVE_INFINITY;
      }
      else
      {
         nPermanentLevel = Number(nPermanentLevel);
      }
      var _loc3_ = this._oDatacenter.Map;
      if(_loc3_.savedBackgroundNum != undefined)
      {
         if(_loc3_.savedBackgroundNum == 0)
         {
            _loc3_.backgroundNum = 632;
         }
         else
         {
            _loc3_.backgroundNum = _loc3_.savedBackgroundNum;
         }
      }
      var _loc4_ = _loc3_.data;
      var _loc5_ = _loc3_.originalsCellsBackup.getItems();
      for(var k in _loc5_)
      {
         this.initializeCell(Number(k),nPermanentLevel);
      }
      this._bTacticMode = false;
   }
   function initializeCell(nCellNum, nPermanentLevel, bSaveTacticMode)
   {
      if(nPermanentLevel == undefined)
      {
         nPermanentLevel = Number.POSITIVE_INFINITY;
      }
      else
      {
         nPermanentLevel = Number(nPermanentLevel);
      }
      var _loc5_ = this._oDatacenter.Map;
      var _loc6_ = _loc5_.data;
      var _loc7_ = _loc5_.originalsCellsBackup.getItemAt(String(nCellNum));
      if(_loc7_ == undefined)
      {
         ank.utils.Logger.err("[MapHandler] (initializeCell) La case est déjà dans son état init");
         return undefined;
      }
      var _loc8_;
      var _loc9_;
      if(_loc6_[nCellNum].nPermanentLevel <= nPermanentLevel)
      {
         if(bSaveTacticMode == true)
         {
            _loc8_ = this.api.datacenter.Game.isTacticMode;
            _loc9_ = new ank.battlefield.datacenter.Cell();
            for(var cellData in _loc7_)
            {
               _loc9_[cellData] = _loc7_[cellData];
            }
            if(_loc8_)
            {
               _loc9_.turnTactic(this,_loc5_);
            }
            _loc6_[nCellNum] = _loc9_;
            this.build(_loc5_,nCellNum);
            if(!_loc8_)
            {
               _loc5_.originalsCellsBackup.removeItemAt(String(nCellNum));
            }
         }
         else
         {
            _loc6_[nCellNum] = _loc7_;
            this.build(_loc5_,nCellNum);
            _loc5_.originalsCellsBackup.removeItemAt(String(nCellNum));
         }
      }
   }
   function setObject2Frame(nCellNum, frame)
   {
      if(typeof frame == "number" && frame < 1)
      {
         ank.utils.Logger.err("[setObject2Frame] frame " + frame + " incorecte");
         return undefined;
      }
      if(nCellNum > this.getCellCount())
      {
         ank.utils.Logger.err("[setObject2Frame] Cellule " + nCellNum + " inexistante");
         return undefined;
      }
      var _loc4_ = this._oDatacenter.Map.data[nCellNum];
      var _loc5_ = _loc4_.mcObject2;
      if(ank.battlefield.Constants.USE_STREAMING_FILES && (ank.battlefield.Constants.STREAMING_METHOD == "explod" && !_loc5_.fullLoaded))
      {
         this._oSettingFrames[nCellNum] = frame;
      }
      else if(ank.battlefield.Constants.USE_STREAMING_FILES && ank.battlefield.Constants.STREAMING_METHOD == "explod")
      {
         for(var s in _loc5_)
         {
            if(_loc5_[s] instanceof MovieClip)
            {
               _loc5_[s].gotoAndStop(frame);
            }
         }
      }
      else
      {
         _loc5_.gotoAndStop(frame);
      }
   }
   function setObjectExternalFrame(nCellNum, frame)
   {
      if(typeof frame == "number" && frame < 1)
      {
         ank.utils.Logger.err("[setObject2Frame] frame " + frame + " incorecte");
         return undefined;
      }
      if(nCellNum > this.getCellCount())
      {
         ank.utils.Logger.err("[setObject2Frame] Cellule " + nCellNum + " inexistante");
         return undefined;
      }
      var _loc4_ = this._oDatacenter.Map.data[nCellNum];
      var _loc5_ = _loc4_.mcObjectExternal._oCell;
      _loc5_.gotoAndStop(frame);
   }
   function setObject2Interactive(nCellNum, bInteractive, nPermanentLevel)
   {
      if(nCellNum > this.getCellCount())
      {
         ank.utils.Logger.err("[setObject2State] Cellule " + nCellNum + " inexistante");
         return undefined;
      }
      var _loc5_ = this._oDatacenter.Map.data[nCellNum];
      if(_loc5_.mcObject2 == this.api.gfx.rollOverMcObject)
      {
         this.api.gfx.onObjectRollOut(_loc5_.mcObject2);
      }
      var _loc6_ = new ank.battlefield.datacenter.Cell();
      _loc6_.layerObject2Interactive = bInteractive;
      this.updateCell(nCellNum,_loc6_,"1",nPermanentLevel);
   }
   function getCellCount(Void)
   {
      return this._oDatacenter.Map.data.length;
   }
   function getCellData(nCellNum)
   {
      return this._oDatacenter.Map.data[nCellNum];
   }
   function getCellsData(Void)
   {
      return this._oDatacenter.Map.data;
   }
   function getWidth(Void)
   {
      return this._oDatacenter.Map.width;
   }
   function getHeight(Void)
   {
      return this._oDatacenter.Map.height;
   }
   function getCaseNum(nX, nY)
   {
      var _loc4_ = this.getWidth();
      return nX * _loc4_ + nY * (_loc4_ - 1);
   }
   function getCellHeight(nCellNum)
   {
      var _loc3_ = this.getCellData(nCellNum);
      var _loc4_ = !(_loc3_.groundSlope == undefined || _loc3_.groundSlope == 1) ? 0.5 : 0;
      var _loc5_ = _loc3_.groundLevel != undefined ? _loc3_.groundLevel - 7 : 0;
      return _loc5_ + _loc4_;
   }
   function getLayerByCellPropertyName(oCellPropertyName)
   {
      var _loc3_ = [];
      for(var i in this._oDatacenter.Map.data)
      {
         _loc3_.push(this._oDatacenter.Map.data[i][oCellPropertyName]);
      }
      return _loc3_;
   }
   function resetEmptyCells()
   {
      var _loc2_ = this._mcBattlefield.spriteHandler.getSprites().getItems();
      var _loc3_ = [];
      var _loc4_;
      for(var k in _loc2_)
      {
         _loc4_ = _loc2_[k];
         if(!(_loc4_.isPendingClearing || (_loc4_.isClear || _loc4_.mc.gfx._width == 0 && getTimer() - _loc4_.creationInstant > 1000)))
         {
            _loc3_[_loc4_.cellNum] = true;
         }
      }
      var _loc5_ = this.getCellCount();
      var _loc6_ = 0;
      var _loc7_ = 0;
      var _loc8_;
      var _loc9_;
      while(_loc7_ < _loc5_)
      {
         if(_loc3_[_loc7_] != true)
         {
            _loc8_ = this._mcBattlefield.mapHandler.getCellData(_loc7_);
            _loc9_ = _loc8_.spriteOnCount;
            if(_loc9_ != 0)
            {
               _loc6_ += _loc9_;
               _loc8_.removeAllSpritesOnID();
            }
         }
         _loc7_ = _loc7_ + 1;
      }
      if(_loc6_ > 0)
      {
      }
   }
   function adjustAndMaskMap()
   {
      if(this._nAdjustTimer != undefined)
      {
         _global.clearInterval(this._nAdjustTimer);
         this._nAdjustTimer = undefined;
      }
      this._mcContainer.applyMask(true);
      this._mcContainer.adjusteMap();
   }
   function onLoadInit(mc)
   {
      this._nLoadRequest = this._nLoadRequest - 1;
      if(this._oLoadingCells[mc] == undefined)
      {
         return undefined;
      }
      var _loc3_ = String(mc).split(".");
      var _loc4_ = _loc3_[_loc3_.length - 2];
      var _loc5_ = this._oLoadingCells[mc];
      var _loc0_;
      switch(_loc4_)
      {
         case "Ground":
            mc.cacheAsBitmap = _global.CONFIG.cacheAsBitmap["mapHandler/Cell/Ground"];
            mc._x = Number(_loc5_.x);
            mc._y = Number(_loc5_.y);
            if(_loc5_.groundSlope == 1 && _loc5_.layerGroundRot != 0)
            {
               mc._rotation = _loc5_.layerGroundRot * 90;
               if(mc._rotation % 180)
               {
                  mc._yscale = 192.86;
                  mc._xscale = 51.85;
               }
               else
               {
                  var _temp_2 = mc;
                  var _temp_1 = "_yscale";
                  mc._xscale = _loc0_ = 100;
                  _temp_2[_temp_1] = _loc0_;
               }
            }
            else
            {
               mc._rotation = 0;
               var _temp_4 = mc;
               var _temp_3 = "_yscale";
               mc._xscale = _loc0_ = 100;
               _temp_4[_temp_3] = _loc0_;
            }
            if(_loc5_.layerGroundFlip)
            {
               mc._xscale *= -1;
            }
            else
            {
               mc._xscale *= 1;
            }
            if(_loc5_.groundSlope != 1)
            {
               mc.gotoAndStop(_loc5_.groundSlope);
            }
            mc.lastGroundID = _loc5_.layerGroundNum;
            break;
         case "Object1":
            mc.cacheAsBitmap = _global.CONFIG.cacheAsBitmap["mapHandler/Cell/Object1"];
            mc._x = Number(_loc5_.x);
            mc._y = Number(_loc5_.y);
            if(_loc5_.groundSlope == 1 && _loc5_.layerObject1Rot != 0)
            {
               mc._rotation = _loc5_.layerObject1Rot * 90;
               if(mc._rotation % 180)
               {
                  mc._yscale = 192.86;
                  mc._xscale = 51.85;
               }
               else
               {
                  var _temp_6 = mc;
                  var _temp_5 = "_yscale";
                  mc._xscale = _loc0_ = 100;
                  _temp_6[_temp_5] = _loc0_;
               }
            }
            else
            {
               mc._rotation = 0;
               var _temp_8 = mc;
               var _temp_7 = "_yscale";
               mc._xscale = _loc0_ = 100;
               _temp_8[_temp_7] = _loc0_;
            }
            if(_loc5_.layerObject1Flip)
            {
               mc._xscale *= -1;
            }
            else
            {
               mc._xscale *= 1;
            }
            mc.lastObject1ID = _loc5_.layerObject1Num;
            break;
         case "Object2":
            mc.cacheAsBitmap = _global.CONFIG.cacheAsBitmap["mapHandler/Cell/Object2"];
            mc._x = Number(_loc5_.x);
            mc._y = Number(_loc5_.y);
            if(_loc5_.layerObject2Interactive)
            {
               mc.__proto__ = ank.battlefield.mc.InteractiveObject.prototype;
               mc.initialize(this._mcBattlefield,_loc5_,true);
            }
            else
            {
               mc.__proto__ = MovieClip.prototype;
            }
            if(_loc5_.layerObject2Flip)
            {
               mc._xscale = -100;
            }
            else
            {
               mc._xscale = 100;
            }
            mc.lastObject2ID = _loc5_.layerObject2Num;
      }
      var _loc6_;
      if(this._oSettingFrames[_loc5_.num] != undefined)
      {
         _loc6_ = this._oDatacenter.Map.data[_loc5_.num].mcObject2;
         for(var s in _loc6_)
         {
            if(_loc6_[s] instanceof MovieClip)
            {
               _loc6_[s].gotoAndStop(this._oSettingFrames[_loc5_.num]);
            }
         }
         delete this._oSettingFrames[_loc5_.num];
      }
      mc.fullLoaded = true;
      delete this._oLoadingCells[mc];
   }
   function showTriggers()
   {
      var _loc2_ = this.getCellsData();
      var _loc3_;
      var _loc4_;
      for(var i in _loc2_)
      {
         _loc3_ = _loc2_[i];
         _loc4_ = _loc3_.isTrigger;
         if(_loc4_)
         {
            this.flagCellNonBlocking(_loc3_.num);
         }
      }
   }
   function showFightCells(sTeam1Cells, sTeam2Cells)
   {
      var _loc4_;
      if(sTeam1Cells == undefined || sTeam2Cells == undefined)
      {
         _loc4_ = this.api.lang.getMapText(this._oDatacenter.Map.id);
         if(_loc4_.p1 == undefined || _loc4_.p2 == undefined)
         {
            return undefined;
         }
         sTeam1Cells = _loc4_.p1;
         sTeam2Cells = _loc4_.p2;
      }
      this._bShowingFightCells = true;
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < sTeam1Cells.length)
      {
         _loc6_ = ank.utils.Compressor.decode64(sTeam1Cells.charAt(_loc5_)) << 6;
         _loc6_ += ank.utils.Compressor.decode64(sTeam1Cells.charAt(_loc5_ + 1));
         this.api.gfx.select(_loc6_,dofus.Constants.TEAMS_COLOR[0],"startPosition");
         _loc5_ += 2;
      }
      var _loc7_ = 0;
      var _loc8_;
      while(_loc7_ < sTeam2Cells.length)
      {
         _loc8_ = ank.utils.Compressor.decode64(sTeam2Cells.charAt(_loc7_)) << 6;
         _loc8_ += ank.utils.Compressor.decode64(sTeam2Cells.charAt(_loc7_ + 1));
         this.api.gfx.select(_loc8_,dofus.Constants.TEAMS_COLOR[1],"startPosition");
         _loc7_ += 2;
      }
   }
   function flagCellNonBlocking(nCellNum, sSprite)
   {
      if(sSprite == undefined)
      {
         sSprite = this.api.datacenter.Player.ID;
      }
      var _loc4_ = new ank.battlefield.datacenter.VisualEffect();
      _loc4_.file = dofus.Constants.CLIPS_PATH + "flag.swf";
      _loc4_.bInFrontOfSprite = true;
      _loc4_.bTryToBypassContainerColor = true;
      this.api.gfx.spriteLaunchVisualEffect(sSprite,_loc4_,nCellNum,11,undefined,undefined,undefined,true,false);
   }
   function drawCellIds()
   {
      var _loc2_ = this._mcContainer.createEmptyMovieClip("mcCellIds",this._mcContainer.getNextHighestDepth());
      _loc2_.cacheAsBitmap = true;
      var _loc3_ = this.validCellsData;
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_];
         _loc6_ = _loc2_.createTextField("cell" + _loc5_.num,_loc2_.getNextHighestDepth(),_loc5_.x,_loc5_.y,0,0);
         _loc6_.selectable = false;
         _loc6_.mouseWheelEnabled = false;
         _loc6_.autoSize = true;
         _loc7_ = new TextFormat();
         _loc7_.align = "center";
         _loc7_.size = 8;
         if(_loc5_.isTrigger)
         {
            _loc7_.color = 16773939;
         }
         else
         {
            _loc7_.color = 16777215;
         }
         _loc7_.bold = true;
         _loc6_.setNewTextFormat(_loc7_);
         _loc6_._alpha = 70;
         _loc6_.text = String(_loc5_.num);
         _loc6_._x -= _loc6_._width / 2;
         _loc6_._y -= _loc6_._height / 2;
         _loc8_ = [];
         _loc8_.push(new flash.filters.GlowFilter(0,40,2,2,4,1,false,false));
         _loc6_.filters = _loc8_;
         _loc4_ = _loc4_ + 1;
      }
      return _loc2_;
   }
   function applyTacticColor(mc_, nColorIndex)
   {
      if(!this.api.gfx.isMapBuild || !this.api.kernel.OptionsManager.getOption("ColorfulTactic"))
      {
         return undefined;
      }
      var _loc4_ = new Color(mc_);
      _loc4_.setRGB(this.api.datacenter.Map.tacticColorsRGB[nColorIndex]);
   }
   function addTacticAdditionnalDecor(aCells, sSubareaTheme)
   {
      if(sSubareaTheme == undefined || (!this.api.gfx.isMapBuild || !this.api.kernel.OptionsManager.getOption("ColorfulTactic")))
      {
         return undefined;
      }
      var _loc4_ = 0;
      var _loc5_ = this.api.datacenter.Map.tacticDecorFrequency;
      var _loc6_ = 0;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      while(_loc6_ < aCells.length)
      {
         _loc7_ = aCells[_loc6_];
         _loc8_ = _loc7_.mcObject2;
         _loc9_ = _loc7_.num;
         _loc10_ = _loc4_++ % this._nTacticDecorTotalAsset + 1;
         _loc8_.attachMovie(sSubareaTheme,"Decor",_loc8_.getNextHighestDepth());
         _loc8_.Decor.gotoAndStop(_loc10_);
         _loc6_ += _loc5_;
      }
   }
   function removeTacticAdditionnalDecor(aCells)
   {
      if(!this.api.gfx.isMapBuild || !this.api.kernel.OptionsManager.getOption("ColorfulTactic"))
      {
         return undefined;
      }
      var _loc3_ = this.api.datacenter.Map.tacticDecorFrequency;
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      while(_loc4_ < aCells)
      {
         _loc5_ = aCells[_loc4_];
         _loc6_ = _loc5_.mcObject2;
         _loc6_.Decor.removeMovieClip();
         _loc4_ += _loc3_;
      }
   }
}
