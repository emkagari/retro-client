class ank.battlefield.SelectionHandler
{
   var _mcBattlefield;
   var _mcContainer;
   var _oDatacenter;
   function SelectionHandler(b, c, d)
   {
      this.initialize(b,c,d);
   }
   function initialize(b, c, d)
   {
      this._mcBattlefield = b;
      this._oDatacenter = d;
      this._mcContainer = c;
      this.clear();
   }
   function clear(Void)
   {
      var _loc3_;
      var _loc4_;
      for(var k in this._mcContainer.Select)
      {
         _loc3_ = this._mcContainer.Select[k];
         if(_loc3_ != undefined)
         {
            _loc4_ = _loc3_.inObjectClips;
            for(var l in _loc4_)
            {
               _loc4_[l].removeMovieClip();
            }
         }
         _loc3_.removeMovieClip();
      }
   }
   function clearLayer(sLayer)
   {
      if(sLayer == undefined)
      {
         sLayer = "default";
      }
      var _loc3_ = this._mcContainer.Select[sLayer];
      var _loc4_;
      if(_loc3_ != undefined)
      {
         _loc4_ = _loc3_.inObjectClips;
         for(var k in _loc4_)
         {
            _loc4_[k].removeMovieClip();
         }
      }
      _loc3_.removeMovieClip();
   }
   function select(bSelected, nCellNum, nColor, sLayer, nAlpha, bAnimate)
   {
      var _loc8_ = this._mcBattlefield.mapHandler.getCellData(nCellNum);
      if(sLayer == undefined)
      {
         sLayer = "default";
      }
      var _loc9_ = this._mcContainer.Select[sLayer];
      if(_loc9_ == undefined)
      {
         _loc9_ = this._mcContainer.Select.createEmptyMovieClip(sLayer,this._mcContainer.Select.getNextHighestDepth());
         _loc9_.inObjectClips = [];
      }
      var _loc10_;
      var _loc11_;
      var _loc13_;
      var _loc12_;
      var _loc14_;
      if(_loc8_ != undefined && _loc8_.x != undefined)
      {
         _loc10_ = _loc8_.movement > 1 && _loc8_.layerObject2Num != 0;
         _loc11_ = "cell" + String(nCellNum);
         if(bSelected)
         {
            if(_loc10_)
            {
               _loc13_ = this._mcContainer.Object2["select" + nCellNum];
               if(_loc13_ == undefined)
               {
                  _loc13_ = this._mcContainer.Object2.createEmptyMovieClip("select" + nCellNum,nCellNum * 100 + 2);
               }
               _loc12_ = _loc13_[sLayer];
               if(_loc12_ == undefined)
               {
                  _loc12_ = _loc13_.attachMovie("s" + _loc8_.groundSlope,sLayer,_loc13_.getNextHighestDepth());
               }
               _loc9_.inObjectClips.push(_loc12_);
            }
            else
            {
               _loc12_ = _loc9_.attachMovie("s" + _loc8_.groundSlope,_loc11_,nCellNum * 100);
            }
            _loc12_._x = _loc8_.x;
            _loc12_._y = _loc8_.y;
            _loc14_ = new Color(_loc12_);
            _loc14_.setRGB(Number(nColor));
            _loc12_._alpha = nAlpha == undefined ? 100 : nAlpha;
            if(bAnimate)
            {
               ank.utils.TweenAnimation.scale(_loc12_,mx.transitions.easing.Back.easeOut,30,100,0.1,true);
            }
         }
         else if(_loc10_)
         {
            this._mcContainer.Object2["select" + nCellNum][sLayer].unloadMovie();
            this._mcContainer.Object2["select" + nCellNum][sLayer].removeMovieClip();
         }
         else
         {
            _loc9_[_loc11_].unloadMovie();
            _loc9_[_loc11_].removeMovieClip();
         }
      }
   }
   function selectMultiple(bSelect, aCellList, nColor, sLayer, nAlpha, bAnimate)
   {
      for(var i in aCellList)
      {
         this.select(bSelect,aCellList[i],nColor,sLayer,nAlpha,bAnimate);
      }
   }
   function getLayers()
   {
      var _loc2_ = [];
      var _loc3_;
      for(var k in this._mcContainer.Select)
      {
         _loc3_ = this._mcContainer.Select[k];
         if(_loc3_ != undefined)
         {
            _loc2_.push(_loc3_._name);
         }
      }
      return _loc2_;
   }
}
