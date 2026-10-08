class ank.battlefield.PointerHandler
{
   var _aShapes;
   var _mcBattlefield;
   var _mcContainer;
   var _mcZones;
   function PointerHandler(b, c)
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
      this.hide();
      this._aShapes = [];
   }
   function hide(Void)
   {
      this._mcZones.removeMovieClip();
      this._mcZones = this._mcContainer.createEmptyMovieClip("zones_mc",2);
      this._mcZones.cacheAsBitmap = _global.CONFIG.cacheAsBitmap["Zone/Pointers"];
   }
   function addShape(sShape, mSize, nColor, nCellNumRef)
   {
      this._aShapes.push({shape:sShape,size:mSize,col:nColor,cellNumRef:nCellNumRef});
   }
   function draw(nCellNum)
   {
      var _loc3_ = this._aShapes;
      if(_loc3_.length == 0)
      {
         return undefined;
      }
      this.hide();
      var _loc4_ = 0;
      var _loc5_;
      var _loc7_;
      var _loc8_;
      var _loc6_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc15_;
      var _loc16_;
      var _loc14_;
      var _loc17_;
      var _loc18_;
      var _loc19_;
      var _loc20_;
      var _loc21_;
      while(_loc4_ < _loc3_.length)
      {
         this._mcZones.__proto__ = MovieClip.prototype;
         _loc5_ = ank.battlefield.mc.Zone(this._mcZones.attachClassMovie(ank.battlefield.mc.Zone,"zone" + _loc4_,10 * _loc4_,[this._mcBattlefield.mapHandler]));
         _loc7_ = _loc3_[_loc4_].shape;
         _loc8_ = _loc7_.charCodeAt(0);
         switch(_loc8_)
         {
            case 8:
               _loc6_ = ank.battlefield.mc.Zone.getCellsSquare(this._mcBattlefield.mapHandler,_loc3_[_loc4_].size,nCellNum);
               break;
            case 16:
               _loc6_ = ank.battlefield.mc.Zone.getCellsLineWide(this._mcBattlefield.mapHandler,_loc3_[_loc4_].size,_loc3_[_loc4_].cellNumRef,nCellNum);
               break;
            case 17:
               _loc6_ = ank.battlefield.mc.Zone.getCellsSpike(this._mcBattlefield.mapHandler,_loc3_[_loc4_].size,_loc3_[_loc4_].cellNumRef,nCellNum);
               break;
            case 4:
            case 80:
               _loc5_.drawCircle(0,_loc3_[_loc4_].col,nCellNum);
               break;
            case 3:
            case 67:
               if(typeof _loc3_[_loc4_].size == "number")
               {
                  _loc5_.drawCircle(_loc3_[_loc4_].size,_loc3_[_loc4_].col,nCellNum);
               }
               else if(_loc3_[_loc4_].size[0] == 0 && !_global.isNaN(Number(_loc3_[_loc4_].size[1])))
               {
                  _loc5_.drawCircle(Number(_loc3_[_loc4_].size[1]),_loc3_[_loc4_].col,nCellNum);
               }
               else
               {
                  _loc9_ = 0;
                  if(_loc3_[_loc4_].size[0] > 0)
                  {
                     _loc9_ = -1;
                  }
                  _loc5_.drawRing(_loc3_[_loc4_].size[0] + _loc9_,_loc3_[_loc4_].size[1],_loc3_[_loc4_].col,nCellNum);
               }
               break;
            case 6:
            case 68:
               _loc10_ = -1;
               _loc11_ = -1;
               if(typeof _loc3_[_loc4_].size == "number")
               {
                  _loc11_ = Number(_loc3_[_loc4_].size);
                  _loc10_ = _loc11_ % 2 != 0 ? 0 : 1;
               }
               else
               {
                  _loc10_ = Number(_loc3_[_loc4_].size[1]);
                  _loc11_ = Number(_loc3_[_loc4_].size[0]);
               }
               _loc12_ = _loc10_;
               while(_loc12_ < _loc11_)
               {
                  _loc5_.drawRing(_loc12_ + 1,_loc12_,_loc3_[_loc4_].col,nCellNum);
                  _loc12_ += 2;
               }
               break;
            case 2:
            case 76:
               _loc5_.drawLine(_loc3_[_loc4_].size,_loc3_[_loc4_].col,nCellNum,_loc3_[_loc4_].cellNumRef);
               break;
            case 1:
            case 88:
               if(typeof _loc3_[_loc4_].size == "number")
               {
                  _loc5_.drawCross(_loc3_[_loc4_].size,_loc3_[_loc4_].col,nCellNum);
               }
               else
               {
                  _loc13_ = this._mcBattlefield.mapHandler;
                  _loc15_ = _loc13_.getWidth();
                  _loc16_ = ank.battlefield.utils.Pathfinding.getCaseCoordonnee(_loc13_,nCellNum);
                  _loc14_ = nCellNum - _loc15_ * _loc3_[_loc4_].size[0];
                  if(ank.battlefield.utils.Pathfinding.getCaseCoordonnee(_loc13_,_loc14_).y == _loc16_.y)
                  {
                     _loc5_.drawLine(_loc3_[_loc4_].size[1] - _loc3_[_loc4_].size[0],_loc3_[_loc4_].col,_loc14_,nCellNum,true);
                  }
                  _loc14_ = nCellNum - (_loc15_ - 1) * _loc3_[_loc4_].size[0];
                  if(ank.battlefield.utils.Pathfinding.getCaseCoordonnee(_loc13_,_loc14_).x == _loc16_.x)
                  {
                     _loc5_.drawLine(_loc3_[_loc4_].size[1] - _loc3_[_loc4_].size[0],_loc3_[_loc4_].col,_loc14_,nCellNum,true);
                  }
                  _loc14_ = nCellNum + _loc15_ * _loc3_[_loc4_].size[0];
                  if(ank.battlefield.utils.Pathfinding.getCaseCoordonnee(_loc13_,_loc14_).y == _loc16_.y)
                  {
                     _loc5_.drawLine(_loc3_[_loc4_].size[1] - _loc3_[_loc4_].size[0],_loc3_[_loc4_].col,_loc14_,nCellNum,true);
                  }
                  _loc14_ = nCellNum + (_loc15_ - 1) * _loc3_[_loc4_].size[0];
                  if(ank.battlefield.utils.Pathfinding.getCaseCoordonnee(_loc13_,_loc14_).x == _loc16_.x)
                  {
                     _loc5_.drawLine(_loc3_[_loc4_].size[1] - _loc3_[_loc4_].size[0],_loc3_[_loc4_].col,_loc14_,nCellNum,true);
                  }
               }
               break;
            case 5:
            case 84:
               _loc5_.drawLine(_loc3_[_loc4_].size,_loc3_[_loc4_].col,nCellNum,_loc3_[_loc4_].cellNumRef,false,true);
               break;
            case 82:
               _loc5_.drawRectangle(_loc3_[_loc4_].size[0],_loc3_[_loc4_].size[1],_loc3_[_loc4_].col,nCellNum);
               break;
            case 7:
            case 79:
               _loc5_.drawRing(_loc3_[_loc4_].size,_loc3_[_loc4_].size - 1,_loc3_[_loc4_].col,nCellNum);
         }
         if(_loc6_ != undefined)
         {
            _loc17_ = this._mcBattlefield.mapHandler.getCellsData();
            _loc18_ = 0;
            while(_loc18_ < _loc6_.length)
            {
               _loc19_ = _loc6_[_loc18_];
               if(_loc19_ >= 0)
               {
                  if(_loc19_ <= this._mcBattlefield.mapHandler.getCellCount())
                  {
                     _loc20_ = _loc17_[_loc19_];
                     if(!(_loc20_ == undefined || !_loc20_.active))
                     {
                        _loc21_ = _loc5_.createCellMc(_loc19_);
                        _loc5_.drawCircle(0,_loc3_[_loc4_].col,_loc19_,_loc21_);
                        this.movePointerTo(_loc21_,_loc19_);
                     }
                  }
               }
               _loc18_ = _loc18_ + 1;
            }
         }
         else
         {
            this.movePointerTo(_loc5_,nCellNum);
         }
         _loc4_ = _loc4_ + 1;
      }
   }
   function movePointerTo(mcZone, nCellNum)
   {
      var _loc4_ = this._mcBattlefield.mapHandler.getCellData(nCellNum);
      mcZone._x = _loc4_.x;
      mcZone._y = _loc4_.y + ank.battlefield.Constants.LEVEL_HEIGHT * (_loc4_.groundLevel - 7);
   }
}
