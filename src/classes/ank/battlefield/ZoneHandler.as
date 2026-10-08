class ank.battlefield.ZoneHandler
{
   var _mcBattlefield;
   var _mcContainer;
   var _mcZones;
   var _nNextLayerDepth;
   function ZoneHandler(b, c)
   {
      this.initialize(b,c);
   }
   function initialize(b, c)
   {
      this._mcBattlefield = b;
      this._mcContainer = c;
      this.clear();
   }
   function clear(Void)
   {
      this._mcZones.removeMovieClip();
      this._mcZones = this._mcContainer.createEmptyMovieClip("zones_mc",10);
      this._nNextLayerDepth = 0;
   }
   function clearZone(nCellNum, radius, layer)
   {
      nCellNum = Number(nCellNum);
      radius = Number(radius);
      if(nCellNum < 0)
      {
         return undefined;
      }
      if(nCellNum > this._mcBattlefield.mapHandler.getCellCount())
      {
         return undefined;
      }
      var _loc5_ = nCellNum * 1000 + radius * 100;
      this._mcZones[layer]["zone" + _loc5_].clear();
   }
   function clearZoneLayer(layer)
   {
      this._mcZones[layer].removeMovieClip();
   }
   function drawZone(nCellNum, radiusIn, radiusOut, layer, col, nShapeID)
   {
      nCellNum = Number(nCellNum);
      radiusIn = Number(radiusIn);
      radiusOut = Number(radiusOut);
      col = Number(col);
      if(nCellNum < 0)
      {
         return undefined;
      }
      if(nCellNum > this._mcBattlefield.mapHandler.getCellCount())
      {
         return undefined;
      }
      if(_global.isNaN(radiusIn) || _global.isNaN(radiusOut))
      {
         return undefined;
      }
      var _loc8_ = nCellNum * 1000 + radiusOut * 100;
      if(this._mcZones[layer] == undefined)
      {
         this._mcZones.createEmptyMovieClip(layer,this._nNextLayerDepth++);
      }
      this._mcZones[layer].__proto__ = MovieClip.prototype;
      this._mcZones[layer].cacheAsBitmap = this._mcZones.cacheAsBitmap = _global.CONFIG.cacheAsBitmap["Zone/Zone"];
      var _loc9_ = ank.battlefield.mc.Zone(this._mcZones[layer].attachClassMovie(ank.battlefield.mc.Zone,"zone" + _loc8_,_loc8_,[this._mcBattlefield.mapHandler]));
      var _loc10_;
      var _loc11_;
      var _loc13_;
      var _loc14_;
      var _loc12_;
      switch(nShapeID)
      {
         case 8:
            _loc10_ = ank.battlefield.mc.Zone.getCellsSquare(this._mcBattlefield.mapHandler,radiusOut,nCellNum);
            break;
         case 3:
         case 67:
            if(radiusIn == 0)
            {
               _loc9_.drawCircle(radiusOut,col,nCellNum);
            }
            else
            {
               if(radiusIn > 0)
               {
                  radiusIn -= 1;
               }
               _loc9_.drawRing(radiusIn,radiusOut,col,nCellNum);
            }
            break;
         case 1:
         case 88:
            if(radiusIn == 0)
            {
               _loc9_.drawCross(radiusOut,col,nCellNum);
            }
            else
            {
               _loc11_ = this._mcBattlefield.mapHandler;
               _loc13_ = _loc11_.getWidth();
               _loc14_ = ank.battlefield.utils.Pathfinding.getCaseCoordonnee(_loc11_,nCellNum);
               _loc12_ = nCellNum - _loc13_ * radiusIn;
               if(ank.battlefield.utils.Pathfinding.getCaseCoordonnee(_loc11_,_loc12_).y == _loc14_.y)
               {
                  _loc9_.drawLine(radiusOut - radiusIn,col,_loc12_,nCellNum,true);
               }
               _loc12_ = nCellNum - (_loc13_ - 1) * radiusIn;
               if(ank.battlefield.utils.Pathfinding.getCaseCoordonnee(_loc11_,_loc12_).x == _loc14_.x)
               {
                  _loc9_.drawLine(radiusOut - radiusIn,col,_loc12_,nCellNum,true);
               }
               _loc12_ = nCellNum + _loc13_ * radiusIn;
               if(ank.battlefield.utils.Pathfinding.getCaseCoordonnee(_loc11_,_loc12_).y == _loc14_.y)
               {
                  _loc9_.drawLine(radiusOut - radiusIn,col,_loc12_,nCellNum,true);
               }
               _loc12_ = nCellNum + (_loc13_ - 1) * radiusIn;
               if(ank.battlefield.utils.Pathfinding.getCaseCoordonnee(_loc11_,_loc12_).x == _loc14_.x)
               {
                  _loc9_.drawLine(radiusOut - radiusIn,col,_loc12_,nCellNum,true);
               }
            }
            break;
         default:
            _loc9_.drawCircle(radiusOut,col,nCellNum);
      }
      var _loc15_;
      var _loc16_;
      var _loc17_;
      var _loc18_;
      var _loc19_;
      if(_loc10_ != undefined)
      {
         _loc15_ = this._mcBattlefield.mapHandler.getCellsData();
         _loc16_ = 0;
         while(_loc16_ < _loc10_.length)
         {
            _loc17_ = _loc10_[_loc16_];
            if(_loc17_ >= 0)
            {
               if(_loc17_ <= this._mcBattlefield.mapHandler.getCellCount())
               {
                  _loc18_ = _loc15_[_loc17_];
                  if(!(_loc18_ == undefined || !_loc18_.active))
                  {
                     _loc19_ = _loc9_.createCellMc(_loc17_);
                     _loc9_.drawCircle(0,col,_loc17_,_loc19_);
                     this.moveZoneTo(_loc19_,_loc17_);
                  }
               }
            }
            _loc16_ = _loc16_ + 1;
         }
      }
      else
      {
         this.moveZoneTo(_loc9_,nCellNum);
      }
   }
   function moveZoneTo(zone, nCellNum)
   {
      var _loc4_ = this._mcBattlefield.mapHandler.getCellData(nCellNum);
      zone._x = _loc4_.x;
      zone._y = _loc4_.y + ank.battlefield.Constants.LEVEL_HEIGHT * (_loc4_.groundLevel - 7);
   }
}
