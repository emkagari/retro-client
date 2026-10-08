class ank.battlefield.mc.Zone extends MovieClip
{
   var _mcZone;
   var _oMap;
   var api;
   static var ALPHA = 30;
   function Zone(map)
   {
      super();
      this.initialize(map);
   }
   function initialize(map)
   {
      this.api = _global.API;
      this._oMap = map;
      this.clear();
   }
   function clear()
   {
      this.createEmptyMovieClip("_mcZone",10);
   }
   function remove()
   {
      this.removeMovieClip();
   }
   function createCellMc(nCellID)
   {
      return this._mcZone.createEmptyMovieClip("cell" + nCellID,this._mcZone.getNextHighestDepth());
   }
   static function getCellsSquare(mapHandler, nRadius, nImpactCellNum)
   {
      var _loc5_ = [];
      var _loc6_ = ank.battlefield.utils.Pathfinding.getCaseCoordonnee(mapHandler,nImpactCellNum);
      var _loc7_ = _loc6_.x;
      var _loc8_ = _loc6_.y;
      var _loc9_ = _loc7_ - nRadius;
      var _loc10_;
      var _loc11_;
      while(_loc9_ <= _loc7_ + nRadius)
      {
         _loc10_ = _loc8_ - nRadius;
         while(_loc10_ <= _loc8_ + nRadius)
         {
            _loc11_ = mapHandler.getCaseNum(_loc9_,_loc10_);
            _loc5_.push(_loc11_);
            _loc10_ = _loc10_ + 1;
         }
         _loc9_ = _loc9_ + 1;
      }
      return _loc5_;
   }
   static function getCellsLineWide(mapHandler, nRadius, nCasterCellNum, nImpactCellNum)
   {
      var _loc6_ = [];
      var _loc7_ = ank.battlefield.utils.Pathfinding.getCaseCoordonnee(mapHandler,nImpactCellNum);
      var _loc8_ = _loc7_.x;
      var _loc9_ = _loc7_.y;
      var _loc10_ = ank.battlefield.utils.Pathfinding.getDirection(mapHandler,nCasterCellNum,nImpactCellNum);
      var _loc11_ = 0;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      while(_loc11_ < nRadius)
      {
         _loc12_ = _loc8_ + _loc11_ * ank.battlefield.utils.Pathfinding.getTranslation1(_loc10_);
         _loc13_ = _loc9_ + _loc11_ * ank.battlefield.utils.Pathfinding.getTranslation2(_loc10_);
         _loc14_ = -1;
         while(_loc14_ <= 1)
         {
            _loc15_ = mapHandler.getCaseNum(_loc12_ + _loc14_ * ank.battlefield.utils.Pathfinding.getTranslation2(_loc10_),_loc13_ + _loc14_ * ank.battlefield.utils.Pathfinding.getTranslation1(_loc10_));
            _loc6_.push(_loc15_);
            _loc14_ = _loc14_ + 1;
         }
         _loc11_ = _loc11_ + 1;
      }
      return _loc6_;
   }
   static function getCellsSpike(mapHandler, nRadius, nCasterCellNum, nImpactCellNum)
   {
      var _loc6_ = [];
      var _loc7_ = ank.battlefield.utils.Pathfinding.getCaseCoordonnee(mapHandler,nImpactCellNum);
      var _loc8_ = _loc7_.x;
      var _loc9_ = _loc7_.y;
      var _loc10_ = ank.battlefield.utils.Pathfinding.getDirection(mapHandler,nCasterCellNum,nImpactCellNum);
      var _loc11_ = 0;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      while(_loc11_ <= nRadius)
      {
         _loc12_ = _loc8_ + _loc11_ * ank.battlefield.utils.Pathfinding.getTranslation1(_loc10_);
         _loc13_ = _loc9_ + _loc11_ * ank.battlefield.utils.Pathfinding.getTranslation2(_loc10_);
         _loc14_ = - nRadius + _loc11_;
         while(_loc14_ <= nRadius - _loc11_)
         {
            _loc15_ = mapHandler.getCaseNum(_loc12_ + _loc14_ * ank.battlefield.utils.Pathfinding.getTranslation2(_loc10_),_loc13_ + _loc14_ * ank.battlefield.utils.Pathfinding.getTranslation1(_loc10_));
            _loc6_.push(_loc15_);
            _loc14_ = _loc14_ + 1;
         }
         _loc11_ = _loc11_ + 1;
      }
      return _loc6_;
   }
   function drawCircle(nRadius, nColor, nCenterCellNum, mc)
   {
      var _loc6_ = mc != undefined ? mc : this._mcZone;
      _loc6_.beginFill(nColor,ank.battlefield.mc.Zone.ALPHA);
      this.drawCircleBorder(nRadius,nColor,nCenterCellNum,mc);
      _loc6_.endFill();
   }
   function drawRing(nRadiusIn, nRadiusOut, nColor, nCenterCellNum)
   {
      var _loc6_ = this._mcZone;
      _loc6_.beginFill(nColor,ank.battlefield.mc.Zone.ALPHA);
      this.drawCircleBorder(nRadiusOut,nColor,nCenterCellNum);
      this.drawCircleBorder(nRadiusIn,nColor,nCenterCellNum);
      _loc6_.endFill();
   }
   function drawRectangle(nWidth, nHeight, nColor, nCenterCellNum)
   {
      var _loc6_ = this._mcZone;
      _loc6_.beginFill(nColor,ank.battlefield.mc.Zone.ALPHA);
      this.drawRectangleBorder(nWidth,nHeight,nColor,nCenterCellNum);
      _loc6_.endFill();
   }
   function drawCross(nRadius, nColor, nCenterCellNum)
   {
      var _loc5_ = ank.battlefield.Constants.CELL_COORD;
      var _loc6_ = this._oMap.getWidth();
      var _loc7_ = nCenterCellNum;
      var _loc10_ = this._mcZone;
      _loc10_.beginFill(nColor,ank.battlefield.mc.Zone.ALPHA);
      _loc10_.lineStyle(1,nColor,100);
      var _loc9_ = this.getGroundData(_loc7_);
      _loc10_.moveTo(_loc5_[_loc9_.gf][0][0],_loc5_[_loc9_.gf][0][1] - _loc9_.gl * 20);
      var _loc8_ = 1;
      while(_loc8_ <= nRadius)
      {
         _loc7_ -= _loc6_;
         _loc9_ = this.getGroundData(_loc7_);
         _loc10_.lineTo(_loc5_[_loc9_.gf][0][0] - _loc8_ * ank.battlefield.Constants.CELL_HALF_WIDTH,_loc5_[_loc9_.gf][0][1] - _loc9_.gl * 20 - _loc8_ * ank.battlefield.Constants.CELL_HALF_HEIGHT);
         _loc8_ = _loc8_ + 1;
      }
      _loc8_ = nRadius;
      while(_loc8_ >= 0)
      {
         if(_loc8_ != nRadius)
         {
            _loc7_ += _loc6_;
         }
         _loc9_ = this.getGroundData(_loc7_);
         _loc10_.lineTo(_loc5_[_loc9_.gf][1][0] - _loc8_ * ank.battlefield.Constants.CELL_HALF_WIDTH,_loc5_[_loc9_.gf][1][1] - _loc9_.gl * 20 - _loc8_ * ank.battlefield.Constants.CELL_HALF_HEIGHT);
         _loc8_ = _loc8_ - 1;
      }
      _loc8_ = 1;
      while(_loc8_ <= nRadius)
      {
         _loc7_ -= _loc6_ - 1;
         _loc9_ = this.getGroundData(_loc7_);
         _loc10_.lineTo(_loc5_[_loc9_.gf][1][0] + _loc8_ * ank.battlefield.Constants.CELL_HALF_WIDTH,_loc5_[_loc9_.gf][1][1] - _loc9_.gl * 20 - _loc8_ * ank.battlefield.Constants.CELL_HALF_HEIGHT);
         _loc8_ = _loc8_ + 1;
      }
      _loc8_ = nRadius;
      while(_loc8_ >= 0)
      {
         if(_loc8_ != nRadius)
         {
            _loc7_ += _loc6_ - 1;
         }
         _loc9_ = this.getGroundData(_loc7_);
         _loc10_.lineTo(_loc5_[_loc9_.gf][2][0] + _loc8_ * ank.battlefield.Constants.CELL_HALF_WIDTH,_loc5_[_loc9_.gf][2][1] - _loc9_.gl * 20 - _loc8_ * ank.battlefield.Constants.CELL_HALF_HEIGHT);
         _loc8_ = _loc8_ - 1;
      }
      _loc8_ = 1;
      while(_loc8_ <= nRadius)
      {
         _loc7_ += _loc6_;
         _loc9_ = this.getGroundData(_loc7_);
         _loc10_.lineTo(_loc5_[_loc9_.gf][2][0] + _loc8_ * ank.battlefield.Constants.CELL_HALF_WIDTH,_loc5_[_loc9_.gf][2][1] - _loc9_.gl * 20 + _loc8_ * ank.battlefield.Constants.CELL_HALF_HEIGHT);
         _loc8_ = _loc8_ + 1;
      }
      _loc8_ = nRadius;
      while(_loc8_ >= 0)
      {
         if(_loc8_ != nRadius)
         {
            _loc7_ -= _loc6_;
         }
         _loc9_ = this.getGroundData(_loc7_);
         _loc10_.lineTo(_loc5_[_loc9_.gf][3][0] + _loc8_ * ank.battlefield.Constants.CELL_HALF_WIDTH,_loc5_[_loc9_.gf][3][1] - _loc9_.gl * 20 + _loc8_ * ank.battlefield.Constants.CELL_HALF_HEIGHT);
         _loc8_ = _loc8_ - 1;
      }
      _loc8_ = 1;
      while(_loc8_ <= nRadius)
      {
         _loc7_ += _loc6_ - 1;
         _loc9_ = this.getGroundData(_loc7_);
         _loc10_.lineTo(_loc5_[_loc9_.gf][3][0] - _loc8_ * ank.battlefield.Constants.CELL_HALF_WIDTH,_loc5_[_loc9_.gf][3][1] - _loc9_.gl * 20 + _loc8_ * ank.battlefield.Constants.CELL_HALF_HEIGHT);
         _loc8_ = _loc8_ + 1;
      }
      _loc8_ = nRadius;
      while(_loc8_ > 0)
      {
         if(_loc8_ != nRadius)
         {
            _loc7_ -= _loc6_ - 1;
         }
         _loc9_ = this.getGroundData(_loc7_);
         _loc10_.lineTo(_loc5_[_loc9_.gf][0][0] - _loc8_ * ank.battlefield.Constants.CELL_HALF_WIDTH,_loc5_[_loc9_.gf][0][1] - _loc9_.gl * 20 + _loc8_ * ank.battlefield.Constants.CELL_HALF_HEIGHT);
         _loc8_ = _loc8_ - 1;
      }
      _loc10_.endFill();
   }
   function drawLine(length, nColor, extremCellNum, refCellNum, bCenterRef, bOrtho)
   {
      var _loc8_ = 0;
      var _loc9_ = 0;
      var _loc10_;
      var _loc11_;
      if(bCenterRef == true)
      {
         _loc10_ = this._oMap.getCellData(extremCellNum);
         _loc11_ = this._oMap.getCellData(refCellNum);
         _loc8_ = _loc10_.x - _loc11_.x;
         _loc9_ = _loc10_.rootY - _loc11_.rootY;
      }
      var _loc12_ = ank.battlefield.Constants.CELL_COORD;
      var _loc13_ = this._oMap.getWidth();
      var _loc14_ = extremCellNum;
      var _loc19_ = [0,0,0,0,0,0,0,0];
      var _loc20_;
      if(refCellNum != extremCellNum)
      {
         _loc20_ = ank.battlefield.utils.Pathfinding.getDirection(this._oMap,refCellNum,extremCellNum);
         if(bOrtho == true)
         {
            _loc19_[(_loc20_ + 6) % 8] = length;
            _loc19_[(_loc20_ + 10) % 8] = length;
         }
         else
         {
            _loc19_[_loc20_] = length;
         }
      }
      var _loc18_ = this._mcZone;
      _loc18_.beginFill(nColor,ank.battlefield.mc.Zone.ALPHA);
      _loc18_.lineStyle(1,nColor,100);
      var _loc17_ = this.getGroundData(_loc14_);
      _loc18_.moveTo(_loc12_[_loc17_.gf][0][0] + _loc8_,_loc12_[_loc17_.gf][0][1] - _loc17_.gl * 20 + _loc9_);
      var _loc15_ = 1;
      while(_loc15_ <= _loc19_[5])
      {
         _loc14_ -= _loc13_;
         _loc17_ = this.getGroundData(_loc14_);
         _loc18_.lineTo(_loc12_[_loc17_.gf][0][0] - _loc15_ * ank.battlefield.Constants.CELL_HALF_WIDTH + _loc8_,_loc12_[_loc17_.gf][0][1] - _loc17_.gl * 20 - _loc15_ * ank.battlefield.Constants.CELL_HALF_HEIGHT + _loc9_);
         _loc15_ = _loc15_ + 1;
      }
      _loc15_ = _loc19_[5];
      while(_loc15_ >= 0)
      {
         if(_loc15_ != _loc19_[5])
         {
            _loc14_ += _loc13_;
         }
         _loc17_ = this.getGroundData(_loc14_);
         _loc18_.lineTo(_loc12_[_loc17_.gf][1][0] - _loc15_ * ank.battlefield.Constants.CELL_HALF_WIDTH + _loc8_,_loc12_[_loc17_.gf][1][1] - _loc17_.gl * 20 - _loc15_ * ank.battlefield.Constants.CELL_HALF_HEIGHT + _loc9_);
         _loc15_ = _loc15_ - 1;
      }
      _loc15_ = 1;
      while(_loc15_ <= _loc19_[7])
      {
         _loc14_ -= _loc13_ - 1;
         _loc17_ = this.getGroundData(_loc14_);
         _loc18_.lineTo(_loc12_[_loc17_.gf][1][0] + _loc15_ * ank.battlefield.Constants.CELL_HALF_WIDTH + _loc8_,_loc12_[_loc17_.gf][1][1] - _loc17_.gl * 20 - _loc15_ * ank.battlefield.Constants.CELL_HALF_HEIGHT + _loc9_);
         _loc15_ = _loc15_ + 1;
      }
      _loc15_ = _loc19_[7];
      while(_loc15_ >= 0)
      {
         if(_loc15_ != _loc19_[7])
         {
            _loc14_ += _loc13_ - 1;
         }
         _loc17_ = this.getGroundData(_loc14_);
         _loc18_.lineTo(_loc12_[_loc17_.gf][2][0] + _loc15_ * ank.battlefield.Constants.CELL_HALF_WIDTH + _loc8_,_loc12_[_loc17_.gf][2][1] - _loc17_.gl * 20 - _loc15_ * ank.battlefield.Constants.CELL_HALF_HEIGHT + _loc9_);
         _loc15_ = _loc15_ - 1;
      }
      _loc15_ = 1;
      while(_loc15_ <= _loc19_[1])
      {
         _loc14_ += _loc13_;
         _loc17_ = this.getGroundData(_loc14_);
         _loc18_.lineTo(_loc12_[_loc17_.gf][2][0] + _loc15_ * ank.battlefield.Constants.CELL_HALF_WIDTH + _loc8_,_loc12_[_loc17_.gf][2][1] - _loc17_.gl * 20 + _loc15_ * ank.battlefield.Constants.CELL_HALF_HEIGHT + _loc9_);
         _loc15_ = _loc15_ + 1;
      }
      _loc15_ = _loc19_[1];
      while(_loc15_ >= 0)
      {
         if(_loc15_ != _loc19_[1])
         {
            _loc14_ -= _loc13_;
         }
         _loc17_ = this.getGroundData(_loc14_);
         _loc18_.lineTo(_loc12_[_loc17_.gf][3][0] + _loc15_ * ank.battlefield.Constants.CELL_HALF_WIDTH + _loc8_,_loc12_[_loc17_.gf][3][1] - _loc17_.gl * 20 + _loc15_ * ank.battlefield.Constants.CELL_HALF_HEIGHT + _loc9_);
         _loc15_ = _loc15_ - 1;
      }
      _loc15_ = 1;
      while(_loc15_ <= _loc19_[3])
      {
         _loc14_ += _loc13_ - 1;
         _loc17_ = this.getGroundData(_loc14_);
         _loc18_.lineTo(_loc12_[_loc17_.gf][3][0] - _loc15_ * ank.battlefield.Constants.CELL_HALF_WIDTH + _loc8_,_loc12_[_loc17_.gf][3][1] - _loc17_.gl * 20 + _loc15_ * ank.battlefield.Constants.CELL_HALF_HEIGHT + _loc9_);
         _loc15_ = _loc15_ + 1;
      }
      _loc15_ = _loc19_[3];
      while(_loc15_ > 0)
      {
         if(_loc15_ != _loc19_[3])
         {
            _loc14_ -= _loc13_ - 1;
         }
         _loc17_ = this.getGroundData(_loc14_);
         _loc18_.lineTo(_loc12_[_loc17_.gf][0][0] - _loc15_ * ank.battlefield.Constants.CELL_HALF_WIDTH + _loc8_,_loc12_[_loc17_.gf][0][1] - _loc17_.gl * 20 + _loc15_ * ank.battlefield.Constants.CELL_HALF_HEIGHT + _loc9_);
         _loc15_ = _loc15_ - 1;
      }
      _loc18_.endFill();
   }
   function getGroundData(nCellNum)
   {
      var _loc3_ = this._oMap.getCellData(nCellNum);
      var _loc4_ = _loc3_.groundSlope != undefined ? _loc3_.groundSlope : 1;
      var _loc5_ = _loc3_.groundLevel != undefined ? _loc3_.groundLevel - 7 : 0;
      return {gf:_loc4_,gl:_loc5_};
   }
   function drawCircleBorder(nRadius, nColor, nCenterCellNum, mc)
   {
      var _loc6_ = ank.battlefield.Constants.CELL_COORD;
      var _loc7_ = this._oMap.getWidth();
      var _loc8_ = _loc7_ * 2 - 1;
      var _loc9_ = nCenterCellNum - nRadius * _loc7_;
      var _loc14_ = (- nRadius) * ank.battlefield.Constants.CELL_HALF_WIDTH;
      var _loc15_ = (- nRadius) * ank.battlefield.Constants.CELL_HALF_HEIGHT;
      var _loc13_ = mc != undefined ? mc : this._mcZone;
      _loc13_.lineStyle(1,nColor,100);
      var _loc12_ = this.getGroundData(_loc9_);
      _loc13_.moveTo(_loc14_ + _loc6_[_loc12_.gf][0][0],_loc15_ + _loc6_[_loc12_.gf][0][1] - _loc12_.gl * 20);
      var _loc10_ = 0;
      while(_loc10_ < nRadius + 1)
      {
         if(_loc10_ != 0)
         {
            _loc9_ = _loc9_ + 1;
         }
         _loc12_ = this.getGroundData(_loc9_);
         _loc13_.lineTo(_loc14_ + _loc6_[_loc12_.gf][1][0] + _loc10_ * ank.battlefield.Constants.CELL_WIDTH,_loc15_ + _loc6_[_loc12_.gf][1][1] - _loc12_.gl * 20);
         _loc13_.lineTo(_loc14_ + _loc6_[_loc12_.gf][2][0] + _loc10_ * ank.battlefield.Constants.CELL_WIDTH,_loc15_ + _loc6_[_loc12_.gf][2][1] - _loc12_.gl * 20);
         _loc10_ = _loc10_ + 1;
      }
      _loc10_ -= 1;
      var _loc11_ = 0;
      while(_loc11_ < nRadius)
      {
         _loc9_ += _loc8_;
         _loc12_ = this.getGroundData(_loc9_);
         _loc13_.lineTo(_loc14_ + _loc6_[_loc12_.gf][1][0] + _loc10_ * ank.battlefield.Constants.CELL_WIDTH,_loc15_ + _loc6_[_loc12_.gf][1][1] + (_loc11_ + 1) * ank.battlefield.Constants.CELL_HEIGHT - _loc12_.gl * 20);
         _loc13_.lineTo(_loc14_ + _loc6_[_loc12_.gf][2][0] + _loc10_ * ank.battlefield.Constants.CELL_WIDTH,_loc15_ + _loc6_[_loc12_.gf][2][1] + (_loc11_ + 1) * ank.battlefield.Constants.CELL_HEIGHT - _loc12_.gl * 20);
         _loc11_ = _loc11_ + 1;
      }
      _loc10_ = nRadius;
      while(_loc10_ >= 0)
      {
         if(_loc10_ != nRadius)
         {
            _loc9_ = _loc9_ - 1;
         }
         _loc12_ = this.getGroundData(_loc9_);
         _loc13_.lineTo(_loc14_ + _loc6_[_loc12_.gf][3][0] + _loc10_ * ank.battlefield.Constants.CELL_WIDTH,_loc15_ + _loc6_[_loc12_.gf][3][1] + _loc11_ * ank.battlefield.Constants.CELL_HEIGHT - _loc12_.gl * 20);
         _loc13_.lineTo(_loc14_ + _loc6_[_loc12_.gf][0][0] + _loc10_ * ank.battlefield.Constants.CELL_WIDTH,_loc15_ + _loc6_[_loc12_.gf][0][1] + _loc11_ * ank.battlefield.Constants.CELL_HEIGHT - _loc12_.gl * 20);
         _loc10_ = _loc10_ - 1;
      }
      _loc10_ += 1;
      _loc11_ = nRadius - 1;
      while(_loc11_ >= 0)
      {
         _loc9_ -= _loc8_;
         _loc12_ = this.getGroundData(_loc9_);
         _loc13_.lineTo(_loc14_ + _loc6_[_loc12_.gf][3][0] + _loc10_ * ank.battlefield.Constants.CELL_WIDTH,_loc15_ + _loc6_[_loc12_.gf][3][1] + _loc11_ * ank.battlefield.Constants.CELL_HEIGHT - _loc12_.gl * 20);
         _loc13_.lineTo(_loc14_ + _loc6_[_loc12_.gf][0][0] + _loc10_ * ank.battlefield.Constants.CELL_WIDTH,_loc15_ + _loc6_[_loc12_.gf][0][1] + _loc11_ * ank.battlefield.Constants.CELL_HEIGHT - _loc12_.gl * 20);
         _loc11_ = _loc11_ - 1;
      }
   }
   function drawRectangleBorder(nWidth, nHeight, nColor, nCenterCellNum)
   {
      var _loc6_ = ank.battlefield.Constants.CELL_COORD;
      var _loc7_ = this._oMap.getWidth() * 2 - 1;
      var _loc8_ = Number(nCenterCellNum);
      var _loc13_ = 0;
      var _loc14_ = 0;
      var _loc12_ = this._mcZone;
      _loc12_.lineStyle(1,nColor,100);
      var _loc11_ = this.getGroundData(_loc8_);
      _loc12_.moveTo(_loc13_ + _loc6_[_loc11_.gf][0][0],_loc14_ + _loc6_[_loc11_.gf][0][1] - _loc11_.gl * 20);
      var _loc9_ = 0;
      while(_loc9_ < nWidth)
      {
         if(_loc9_ != 0)
         {
            _loc8_ = _loc8_ + 1;
         }
         _loc11_ = this.getGroundData(_loc8_);
         _loc12_.lineTo(_loc13_ + _loc6_[_loc11_.gf][1][0] + _loc9_ * ank.battlefield.Constants.CELL_WIDTH,_loc14_ + _loc6_[_loc11_.gf][1][1] - _loc11_.gl * 20);
         _loc12_.lineTo(_loc13_ + _loc6_[_loc11_.gf][2][0] + _loc9_ * ank.battlefield.Constants.CELL_WIDTH,_loc14_ + _loc6_[_loc11_.gf][2][1] - _loc11_.gl * 20);
         _loc9_ = _loc9_ + 1;
      }
      _loc9_ -= 1;
      var _loc10_ = 0;
      while(_loc10_ < nHeight - 1)
      {
         _loc8_ += _loc7_;
         _loc11_ = this.getGroundData(_loc8_);
         _loc12_.lineTo(_loc13_ + _loc6_[_loc11_.gf][1][0] + _loc9_ * ank.battlefield.Constants.CELL_WIDTH,_loc14_ + _loc6_[_loc11_.gf][1][1] + (_loc10_ + 1) * ank.battlefield.Constants.CELL_HEIGHT - _loc11_.gl * 20);
         _loc12_.lineTo(_loc13_ + _loc6_[_loc11_.gf][2][0] + _loc9_ * ank.battlefield.Constants.CELL_WIDTH,_loc14_ + _loc6_[_loc11_.gf][2][1] + (_loc10_ + 1) * ank.battlefield.Constants.CELL_HEIGHT - _loc11_.gl * 20);
         _loc10_ = _loc10_ + 1;
      }
      _loc9_ = nWidth - 1;
      while(_loc9_ >= 0)
      {
         if(_loc9_ != nWidth - 1)
         {
            _loc8_ = _loc8_ - 1;
         }
         _loc11_ = this.getGroundData(_loc8_);
         _loc12_.lineTo(_loc13_ + _loc6_[_loc11_.gf][3][0] + _loc9_ * ank.battlefield.Constants.CELL_WIDTH,_loc14_ + _loc6_[_loc11_.gf][3][1] + _loc10_ * ank.battlefield.Constants.CELL_HEIGHT - _loc11_.gl * 20);
         _loc12_.lineTo(_loc13_ + _loc6_[_loc11_.gf][0][0] + _loc9_ * ank.battlefield.Constants.CELL_WIDTH,_loc14_ + _loc6_[_loc11_.gf][0][1] + _loc10_ * ank.battlefield.Constants.CELL_HEIGHT - _loc11_.gl * 20);
         _loc9_ = _loc9_ - 1;
      }
      _loc9_ += 1;
      _loc10_ = nHeight - 2;
      while(_loc10_ >= 0)
      {
         _loc8_ -= _loc7_;
         _loc11_ = this.getGroundData(_loc8_);
         _loc12_.lineTo(_loc13_ + _loc6_[_loc11_.gf][3][0] + _loc9_ * ank.battlefield.Constants.CELL_WIDTH,_loc14_ + _loc6_[_loc11_.gf][3][1] + _loc10_ * ank.battlefield.Constants.CELL_HEIGHT - _loc11_.gl * 20);
         _loc12_.lineTo(_loc13_ + _loc6_[_loc11_.gf][0][0] + _loc9_ * ank.battlefield.Constants.CELL_WIDTH,_loc14_ + _loc6_[_loc11_.gf][0][1] + _loc10_ * ank.battlefield.Constants.CELL_HEIGHT - _loc11_.gl * 20);
         _loc10_ = _loc10_ - 1;
      }
   }
}
