class ank.battlefield.utils.Pathfinding
{
   static var DIRECTION_EAST = 0;
   static var DIRECTION_SOUTH_EAST = 1;
   static var DIRECTION_SOUTH = 2;
   static var DIRECTION_SOUTH_WEST = 3;
   static var DIRECTION_WEST = 4;
   static var DIRECTION_NORTH_WEST = 5;
   static var DIRECTION_NORTH = 6;
   static var DIRECTION_NORTH_EAST = 7;
   function Pathfinding()
   {
   }
   static function pathFind(api, mapHandler, nCellBegin, nCellEnd, oParams)
   {
      var _loc7_ = api.datacenter.Game.isFight;
      if(nCellBegin == undefined)
      {
         return null;
      }
      if(nCellEnd == undefined)
      {
         return null;
      }
      if(_loc7_ == undefined)
      {
         _loc7_ = false;
      }
      var _loc8_ = oParams.bAllDirections != undefined ? oParams.bAllDirections : true;
      var _loc9_ = oParams.nMaxLength != undefined ? oParams.nMaxLength : 500;
      var _loc10_ = oParams.bIgnoreSprites != undefined ? oParams.bIgnoreSprites : false;
      var _loc11_ = oParams.bCellNumOnly != undefined ? oParams.bCellNumOnly : false;
      var _loc12_ = oParams.bWithBeginCellNum != undefined ? oParams.bWithBeginCellNum : false;
      var _loc13_ = mapHandler.getWidth();
      var _loc14_;
      var _loc15_;
      var _loc16_;
      if(_loc8_)
      {
         _loc14_ = 8;
         _loc15_ = [1,_loc13_,_loc13_ * 2 - 1,_loc13_ - 1,-1,- _loc13_,- _loc13_ * 2 + 1,- (_loc13_ - 1)];
         _loc16_ = [1.5,1,1.5,1,1.5,1,1.5,1];
      }
      else
      {
         _loc14_ = 4;
         _loc15_ = [_loc13_,_loc13_ - 1,- _loc13_,- (_loc13_ - 1)];
         _loc16_ = [1,1,1,1];
      }
      var _loc17_ = mapHandler.getCellsData();
      var _loc18_ = {};
      var _loc19_ = {};
      var _loc20_ = false;
      var _loc0_;
      var _loc21_ = _loc18_["oCell" + nCellBegin] = {};
      _loc21_.num = nCellBegin;
      _loc21_.g = 0;
      _loc21_.v = 0;
      _loc21_.h = ank.battlefield.utils.Pathfinding.goalDistEstimate(mapHandler,nCellBegin,nCellEnd);
      _loc21_.f = _loc21_.h;
      _loc21_.l = _loc17_[nCellBegin].groundLevel;
      _loc21_.m = _loc17_[nCellBegin].movement;
      _loc21_.parentNode_ = null;
      var _loc22_ = [];
      var _loc23_ = 0;
      while(_loc23_ < _loc17_.length - 1)
      {
         _loc22_[_loc23_] = _loc17_[_loc23_].isUnwalkableLayerObject;
         _loc23_ = _loc23_ + 1;
      }
      var _loc24_ = [];
      var _loc25_;
      if(!_loc10_ && !_loc7_)
      {
         _loc25_ = 0;
         while(_loc25_ < _loc17_.length - 1)
         {
            _loc24_[_loc25_] = _loc17_[_loc25_].isTrigger;
            _loc25_ = _loc25_ + 1;
         }
      }
      var _loc26_;
      var _loc27_;
      var _loc28_;
      var _loc29_;
      var _loc30_;
      var _loc31_;
      var _loc32_;
      var _loc33_;
      var _loc34_;
      var _loc35_;
      var _loc36_;
      var _loc37_;
      var _loc38_;
      var _loc39_;
      var _loc40_;
      var _loc41_;
      var _loc42_;
      var _loc43_;
      while(!_loc20_)
      {
         _loc26_ = null;
         _loc27_ = 500000;
         for(var k in _loc18_)
         {
            if(_loc18_[k].f < _loc27_)
            {
               _loc27_ = _loc18_[k].f;
               _loc26_ = k;
            }
         }
         _loc28_ = _loc18_[_loc26_];
         delete _loc18_[_loc26_];
         if(_loc28_.num == nCellEnd)
         {
            _loc29_ = [];
            while(_loc28_.num != nCellBegin)
            {
               if(_loc28_.m == 0)
               {
                  _loc29_ = [];
               }
               else if(_loc11_)
               {
                  _loc29_.splice(0,0,_loc28_.num);
               }
               else
               {
                  _loc29_.splice(0,0,{num:_loc28_.num,dir:ank.battlefield.utils.Pathfinding.getDirection(mapHandler,_loc28_.parentNode_.num,_loc28_.num)});
               }
               _loc28_ = _loc28_.parentNode_;
            }
            if(_loc12_)
            {
               if(_loc11_)
               {
                  _loc29_.splice(0,0,nCellBegin);
               }
               else
               {
                  _loc29_.splice(0,0,{num:nCellBegin,dir:ank.battlefield.utils.Pathfinding.getDirection(mapHandler,_loc28_.parentNode_.num,nCellBegin)});
               }
            }
            return _loc29_;
         }
         _loc30_ = false;
         _loc31_ = 0;
         for(; _loc31_ < _loc14_; _loc31_ = _loc31_ + 1)
         {
            _loc32_ = _loc28_.num + _loc15_[_loc31_];
            if(Math.abs(_loc17_[_loc32_].x - _loc17_[_loc28_.num].x) <= 53)
            {
               _loc33_ = _loc17_[_loc32_];
               _loc30_ = !(_loc32_ == nCellEnd && _loc33_.movement == 1) ? false : true;
               _loc34_ = _loc33_.groundLevel;
               _loc35_ = _loc28_.l == undefined || Math.abs(_loc34_ - _loc28_.l) < 2;
               if(!_loc35_ || (!_loc33_.active || _loc33_.movement == 1 && !_loc30_))
               {
                  continue;
               }
               _loc36_ = true;
               if(!_loc10_)
               {
                  _loc37_ = _loc33_.spriteOnID;
                  if(_loc7_)
                  {
                     _loc36_ = _loc37_ == undefined ? true : false;
                  }
                  else
                  {
                     _loc38_ = api.gfx.spriteHandler.getSprite(_loc37_);
                     _loc36_ = !(_loc38_ != undefined && (_loc38_ instanceof dofus.datacenter.Character && _loc32_ != nCellEnd)) ? true : false;
                  }
                  if(_loc36_ && (_loc32_ != nCellEnd && _loc24_[_loc32_] == true))
                  {
                     _loc36_ = false;
                  }
               }
               if(_loc36_ && (_loc32_ != nCellEnd && _loc22_[_loc32_] == true))
               {
                  _loc36_ = false;
               }
               if(!_loc36_)
               {
                  continue;
               }
               _loc39_ = "oCell" + _loc32_;
               _loc40_ = _loc28_.v + _loc16_[_loc31_] + (!(_loc33_.movement == 0 || _loc33_.movement == 1) ? 0 : 1000 + (_loc31_ % 2 != 0 ? 0 : 3)) + (!(_loc33_.movement == 1 && _loc30_) ? (_loc31_ == _loc28_.d ? 0 : 0.5) + (5 - _loc33_.movement) / 3 : -1000);
               _loc41_ = _loc28_.g + _loc16_[_loc31_];
               _loc42_ = null;
               if(_loc18_[_loc39_])
               {
                  _loc42_ = _loc18_[_loc39_].v;
               }
               else if(_loc19_[_loc39_])
               {
                  _loc42_ = _loc19_[_loc39_].v;
               }
               if((_loc42_ == null || _loc42_ > _loc40_) && _loc41_ <= _loc9_)
               {
                  if(_loc19_[_loc39_])
                  {
                     delete _loc19_[_loc39_];
                  }
                  _loc43_ = {};
                  _loc43_.num = _loc32_;
                  _loc43_.g = _loc41_;
                  _loc43_.v = _loc40_;
                  _loc43_.h = ank.battlefield.utils.Pathfinding.goalDistEstimate(mapHandler,_loc32_,nCellEnd);
                  _loc43_.f = _loc43_.v + _loc43_.h;
                  _loc43_.d = _loc31_;
                  _loc43_.l = _loc34_;
                  _loc43_.m = _loc33_.movement;
                  _loc43_.parentNode_ = _loc28_;
                  _loc18_[_loc39_] = _loc43_;
               }
            }
         }
         _loc19_["oCell" + _loc28_.num] = {v:_loc28_.v};
         _loc20_ = true;
         for(var k in _loc18_)
         {
            _loc20_ = false;
            break;
         }
      }
      return null;
   }
   static function goalDistEstimate(mapHandler, nCell1, nCell2)
   {
      var _loc5_ = ank.battlefield.utils.Pathfinding.getCaseCoordonnee(mapHandler,nCell1);
      var _loc6_ = ank.battlefield.utils.Pathfinding.getCaseCoordonnee(mapHandler,nCell2);
      var _loc7_ = Math.abs(_loc5_.x - _loc6_.x);
      var _loc8_ = Math.abs(_loc5_.y - _loc6_.y);
      return Math.sqrt(_loc7_ * _loc7_ + _loc8_ * _loc8_);
   }
   static function goalDistance(mapHandler, nCell1, nCell2)
   {
      var _loc5_ = ank.battlefield.utils.Pathfinding.getCaseCoordonnee(mapHandler,nCell1);
      var _loc6_ = ank.battlefield.utils.Pathfinding.getCaseCoordonnee(mapHandler,nCell2);
      var _loc7_ = Math.abs(_loc5_.x - _loc6_.x);
      var _loc8_ = Math.abs(_loc5_.y - _loc6_.y);
      return _loc7_ + _loc8_;
   }
   static function getCaseCoordonnee(mapHandler, nNum)
   {
      var _loc4_ = mapHandler.getWidth();
      var _loc5_ = Math.floor(nNum / (_loc4_ * 2 - 1));
      var _loc6_ = nNum - _loc5_ * (_loc4_ * 2 - 1);
      var _loc7_ = _loc6_ % _loc4_;
      var _loc8_ = {};
      _loc8_.y = _loc5_ - _loc7_;
      _loc8_.x = (nNum - (_loc4_ - 1) * _loc8_.y) / _loc4_;
      return _loc8_;
   }
   static function getTranslation1(nDir)
   {
      switch(nDir)
      {
         case ank.battlefield.utils.Pathfinding.DIRECTION_SOUTH_EAST:
            return 1;
         case ank.battlefield.utils.Pathfinding.DIRECTION_NORTH_WEST:
            return -1;
         default:
            return 0;
      }
   }
   static function getTranslation2(nDir)
   {
      switch(nDir)
      {
         case ank.battlefield.utils.Pathfinding.DIRECTION_SOUTH_WEST:
            return 1;
         case ank.battlefield.utils.Pathfinding.DIRECTION_NORTH_EAST:
            return -1;
         default:
            return 0;
      }
   }
   static function getDirection(mapHandler, nCell1, nCell2)
   {
      var _loc5_ = mapHandler.getWidth();
      var _loc6_ = [1,_loc5_,_loc5_ * 2 - 1,_loc5_ - 1,-1,- _loc5_,- _loc5_ * 2 + 1,- (_loc5_ - 1)];
      var _loc7_ = nCell2 - nCell1;
      var _loc8_ = 7;
      while(_loc8_ >= 0)
      {
         if(_loc6_[_loc8_] == _loc7_)
         {
            return _loc8_;
         }
         _loc8_ = _loc8_ - 1;
      }
      var _loc9_ = ank.battlefield.utils.Pathfinding.getCaseCoordonnee(mapHandler,nCell1);
      var _loc10_ = ank.battlefield.utils.Pathfinding.getCaseCoordonnee(mapHandler,nCell2);
      var _loc11_ = _loc10_.x - _loc9_.x;
      var _loc12_ = _loc10_.y - _loc9_.y;
      if(_loc11_ == 0)
      {
         if(_loc12_ > 0)
         {
            return 3;
         }
         return 7;
      }
      if(_loc11_ > 0)
      {
         return 1;
      }
      return 5;
   }
   static function getDirectionCasterToImpact(casterCoords, impactCoords)
   {
      if(casterCoords.x > impactCoords.x)
      {
         return ank.battlefield.utils.Pathfinding.DIRECTION_NORTH_WEST;
      }
      if(casterCoords.x < impactCoords.x)
      {
         return ank.battlefield.utils.Pathfinding.DIRECTION_SOUTH_EAST;
      }
      if(casterCoords.y < impactCoords.y)
      {
         return ank.battlefield.utils.Pathfinding.DIRECTION_SOUTH_WEST;
      }
      return ank.battlefield.utils.Pathfinding.DIRECTION_NORTH_EAST;
   }
   static function getDirectionFromCoordinates(x1, y1, x2, y2, bAllDirections)
   {
      var _loc7_ = Math.atan2(y2 - y1,x2 - x1);
      if(bAllDirections)
      {
         if(_loc7_ >= (- Math.PI) / 8 && _loc7_ < Math.PI / 8)
         {
            return 0;
         }
         if(_loc7_ >= Math.PI / 8 && _loc7_ < Math.PI / 3)
         {
            return 1;
         }
         if(_loc7_ >= Math.PI / 3 && _loc7_ < 2 * Math.PI / 3)
         {
            return 2;
         }
         if(_loc7_ >= 2 * Math.PI / 3 && _loc7_ < 7 * Math.PI / 8)
         {
            return 3;
         }
         if(_loc7_ >= 7 * Math.PI / 8 || _loc7_ < -7 * Math.PI / 8)
         {
            return 4;
         }
         if(_loc7_ >= -7 * Math.PI / 8 && _loc7_ < -2 * Math.PI / 3)
         {
            return 5;
         }
         if(_loc7_ >= -2 * Math.PI / 3 && _loc7_ < (- Math.PI) / 3)
         {
            return 6;
         }
         if(_loc7_ >= (- Math.PI) / 3 && _loc7_ < (- Math.PI) / 8)
         {
            return 7;
         }
      }
      else
      {
         if(_loc7_ >= 0 && _loc7_ < Math.PI / 2)
         {
            return 1;
         }
         if(_loc7_ >= Math.PI / 2 && _loc7_ <= Math.PI)
         {
            return 3;
         }
         if(_loc7_ >= - Math.PI && _loc7_ < (- Math.PI) / 2)
         {
            return 5;
         }
         if(_loc7_ >= (- Math.PI) / 2 && _loc7_ < 0)
         {
            return 7;
         }
      }
      return 1;
   }
   static function getArroundCellNum(mapHandler, nCellNum, nDirectionModerator, nIndex)
   {
      var _loc6_ = mapHandler.getWidth();
      var _loc7_ = [1,_loc6_,_loc6_ * 2 - 1,_loc6_ - 1,-1,- _loc6_,- _loc6_ * 2 + 1,- (_loc6_ - 1)];
      var _loc8_ = 0;
      switch(nIndex % 8)
      {
         case 0:
            _loc8_ = 2;
            break;
         case 1:
            _loc8_ = 6;
            break;
         case 2:
            _loc8_ = 4;
            break;
         case 3:
            _loc8_ = 0;
            break;
         case 4:
            _loc8_ = 3;
            break;
         case 5:
            _loc8_ = 5;
            break;
         case 6:
            _loc8_ = 1;
            break;
         case 7:
            _loc8_ = 7;
      }
      _loc8_ = (_loc8_ + nDirectionModerator) % 8;
      var _loc9_ = nCellNum + _loc7_[_loc8_];
      var _loc10_ = mapHandler.getCellsData();
      var _loc11_ = _loc10_[_loc9_];
      if(_loc11_.active && (_loc10_[_loc9_] != undefined && Math.abs(_loc10_[_loc9_].x - _loc10_[nCellNum].x) <= 53))
      {
         return _loc9_;
      }
      return nCellNum;
   }
   static function convertHeightToFourDirection(nDirection)
   {
      return nDirection | 1;
   }
   static function getSlopeOk(slope1, level1, slope2, level2, dir)
   {
      switch(dir)
      {
         case 0:
            if(((slope1 - 1 & 2) >> 1) + level1 != (slope2 - 1 & 1) + level2)
            {
               return false;
            }
            break;
         case 1:
            if(((slope1 - 1 & 4) >> 2) + level1 != ((slope2 - 1 & 2) >> 1) + level2)
            {
               return false;
            }
            if(((slope1 - 1 & 8) >> 3) + level1 != (slope2 - 1 & 1) + level2)
            {
               return false;
            }
            break;
         case 2:
            if(((slope1 - 1 & 8) >> 3) + level1 != ((slope2 - 1 & 2) >> 1) + level2)
            {
               return false;
            }
            break;
         case 3:
            if(((slope1 - 1 & 8) >> 3) + level1 != ((slope2 - 1 & 4) >> 2) + level2)
            {
               return false;
            }
            if((slope1 - 1 & 1) + level1 != ((slope2 - 1 & 2) >> 1) + level2)
            {
               return false;
            }
            break;
         case 4:
            if((slope1 - 1 & 1) + level1 != ((slope2 - 1 & 4) >> 2) + level2)
            {
               return false;
            }
            break;
         case 5:
            if((slope1 - 1 & 1) + level1 != ((slope2 - 1 & 8) >> 3) + level2)
            {
               return false;
            }
            if(((slope1 - 1 & 2) >> 1) + level1 != ((slope2 - 1 & 4) >> 2) + level2)
            {
               return false;
            }
            break;
         case 6:
            if(((slope1 - 1 & 2) >> 1) + level1 != ((slope2 - 1 & 8) >> 3) + level2)
            {
               return false;
            }
            break;
         case 7:
            if(((slope1 - 1 & 2) >> 1) + level1 != (slope2 - 1 & 1) + level2)
            {
               return false;
            }
            if(((slope1 - 1 & 4) >> 2) + level1 != ((slope2 - 1 & 8) >> 3) + level2)
            {
               return false;
            }
      }
      return true;
   }
   static function checkView(mapHandler, cell1, cell2)
   {
      var _loc5_ = mapHandler.getCellData(cell2);
      if(!_loc5_.lineOfSight || !_loc5_.active)
      {
         return false;
      }
      var _loc6_ = ank.battlefield.utils.Pathfinding.getCellsIdBetween(mapHandler,cell1,cell2);
      var _loc7_ = 0;
      var _loc8_;
      while(_loc7_ < _loc6_.length - 1)
      {
         _loc8_ = _loc6_[_loc7_];
         if(!ank.battlefield.utils.Pathfinding.isCellFreeForLOS(mapHandler,_loc8_,cell1,cell2))
         {
            return false;
         }
         _loc7_ = _loc7_ + 1;
      }
      return true;
   }
   static function getCellsIdBetween(mapHandler, from, to)
   {
      if(from == to)
      {
         return [];
      }
      var _loc5_ = ank.battlefield.utils.Pathfinding.getCaseCoordonnee(mapHandler,from);
      var _loc6_ = ank.battlefield.utils.Pathfinding.getCaseCoordonnee(mapHandler,to);
      var _loc7_ = _loc5_.x;
      var _loc8_ = _loc5_.y;
      var _loc9_ = _loc6_.x;
      var _loc10_ = _loc6_.y;
      var _loc11_ = _loc9_ - _loc7_;
      var _loc12_ = _loc10_ - _loc8_;
      var _loc13_ = Math.sqrt(_loc11_ * _loc11_ + _loc12_ * _loc12_);
      var _loc14_ = _loc11_ / _loc13_;
      var _loc15_ = _loc12_ / _loc13_;
      var _loc16_ = Math.abs(1 / _loc14_);
      var _loc17_ = Math.abs(1 / _loc15_);
      var _loc18_ = _loc14_ >= 0 ? 1 : -1;
      var _loc19_ = _loc15_ >= 0 ? 1 : -1;
      var _loc20_ = 0.5 * _loc16_;
      var _loc21_ = 0.5 * _loc17_;
      var _loc22_ = [];
      var _loc23_;
      while(_loc7_ != _loc9_ || _loc8_ != _loc10_)
      {
         if(Math.abs(_loc20_ - _loc21_) < 1e-10)
         {
            _loc20_ += _loc16_;
            _loc21_ += _loc17_;
            _loc7_ += _loc18_;
            _loc8_ += _loc19_;
         }
         else if(_loc20_ < _loc21_)
         {
            _loc20_ += _loc16_;
            _loc7_ += _loc18_;
         }
         else
         {
            _loc21_ += _loc17_;
            _loc8_ += _loc19_;
         }
         _loc23_ = ank.battlefield.utils.Pathfinding.getCaseNum(mapHandler,_loc7_,_loc8_);
         _loc22_.push(_loc23_);
      }
      return _loc22_;
   }
   static function isCellFreeForLOS(mapHandler, cellNum)
   {
      var _loc4_ = mapHandler.getCellData(cellNum);
      if(!_loc4_.lineOfSight || !_loc4_.active)
      {
         return false;
      }
      var _loc5_ = _loc4_.spriteOnID;
      var _loc6_ = _global.API;
      var _loc7_ = _loc5_ == undefined ? undefined : _loc6_.gfx.spriteHandler.getSprite(_loc5_);
      var _loc8_ = _loc7_ != undefined && !_loc7_.isInvisibleInFight;
      if(_loc8_)
      {
         return false;
      }
      return true;
   }
   static function getCaseNum(mapHandler, x, y)
   {
      var _loc5_ = mapHandler.getWidth();
      return x * _loc5_ + y * (_loc5_ - 1);
   }
   static function checkAlign(mapHandler, cell1, cell2)
   {
      var _loc5_ = ank.battlefield.utils.Pathfinding.getCaseCoordonnee(mapHandler,cell1);
      var _loc6_ = ank.battlefield.utils.Pathfinding.getCaseCoordonnee(mapHandler,cell2);
      if(_loc5_.x == _loc6_.x)
      {
         return true;
      }
      if(_loc5_.y == _loc6_.y)
      {
         return true;
      }
      return false;
   }
   static function checkRange(mapHandler, nCell1, nCell2, bLineOnly, nRangeMin, nRangeMax, nRangeModerator)
   {
      nRangeMin = Number(nRangeMin);
      nRangeMax = Number(nRangeMax);
      nRangeModerator = Number(nRangeModerator);
      if(nRangeMax != 0)
      {
         nRangeMax += nRangeModerator;
         nRangeMax = Math.max(nRangeMin,nRangeMax);
      }
      if(bLineOnly)
      {
         if(!ank.battlefield.utils.Pathfinding.checkAlign(mapHandler,nCell1,nCell2))
         {
            return false;
         }
      }
      if(ank.battlefield.utils.Pathfinding.goalDistance(mapHandler,nCell1,nCell2) > nRangeMax || ank.battlefield.utils.Pathfinding.goalDistance(mapHandler,nCell1,nCell2) < nRangeMin)
      {
         return false;
      }
      return true;
   }
}
