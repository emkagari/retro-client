class ank.battlefield.PointsHandler
{
   var _aPointsList;
   var _mcBattlefield;
   var _mcContainer;
   var _oDatacenter;
   function PointsHandler(b, c, d)
   {
      this.initialize(b,c,d);
   }
   function initialize(b, c, d)
   {
      this._mcBattlefield = b;
      this._mcContainer = c;
      this._oDatacenter = d;
      this._aPointsList = [];
   }
   function clear()
   {
      for(var k in this._mcContainer)
      {
         this._mcContainer[k].removeMovieClip();
      }
   }
   function addPoints(sID, nX, nY, sValue, nType)
   {
      var _loc7_ = this._mcContainer.getNextHighestDepth();
      var _loc8_ = "pt" + _loc7_;
      this._mcContainer.createEmptyMovieClip(_loc8_,_loc7_);
      var _loc9_ = this._mcContainer[_loc8_];
      var _loc10_ = _loc9_.getNextHighestDepth();
      var _loc11_ = _loc9_.createEmptyMovieClip("clip",_loc10_);
      _loc9_._x = nX;
      _loc9_._y = nY;
      _loc9_.mc = _loc11_;
      _loc9_.file = dofus.Constants.getPointClip(nType);
      _loc9_.value = sValue;
      _loc9_.sID = sID;
      _loc9_.thisPath = this;
      if(this._aPointsList[sID] == undefined)
      {
         this._aPointsList[sID] = [];
      }
      this._aPointsList[sID].push(_loc9_);
      if(this._aPointsList[sID].length == 1)
      {
         this.loadPointClip(_loc9_);
      }
   }
   function loadPointClip(oPoint)
   {
      var _loc3_ = new MovieClipLoader();
      _loc3_.loadClip(oPoint.file,oPoint.mc);
   }
   function onAnimateFinished(sID)
   {
      var _loc3_ = this._aPointsList[sID];
      _loc3_.shift();
      if(_loc3_.length > 0)
      {
         this.loadPointClip(_loc3_[0]);
      }
      else
      {
         delete this._aPointsList[sID];
      }
   }
}
