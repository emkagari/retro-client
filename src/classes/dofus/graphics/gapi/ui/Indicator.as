class dofus.graphics.gapi.ui.Indicator extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aCoordinates;
   var _mcArrow;
   var _mcArrowShadow;
   var _mcLight;
   var attachMovie;
   var gapi;
   static var CLASS_NAME = "Indicator";
   static var SHADOW_OFFSET = 3;
   static var SHADOW_TRANSFORM = {ra:0,rb:0,ga:0,gb:0,ba:0,bb:0,aa:40,ab:0};
   var _bRotate = true;
   var _nOffset = 0;
   function Indicator()
   {
      super();
   }
   function set rotate(bRotate)
   {
      this._bRotate = bRotate;
   }
   function set coordinates(aCoordinates)
   {
      this._aCoordinates = aCoordinates;
   }
   function set offset(nOffset)
   {
      this._nOffset = nOffset;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Indicator.CLASS_NAME);
   }
   function createChildren()
   {
      var _loc2_ = this._aCoordinates[0];
      var _loc3_ = this._aCoordinates[1];
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc4_;
      if(this._bRotate)
      {
         _loc5_ = this.gapi.screenWidth / 2;
         _loc6_ = this.gapi.screenHeight / 2;
         _loc7_ = Math.atan2(this._aCoordinates[1] - _loc6_,this._aCoordinates[0] - _loc5_);
         _loc4_ = _loc7_ * 180 / Math.PI - 90;
         _loc2_ -= this._nOffset != undefined ? this._nOffset * Math.cos(_loc7_) : 0;
         _loc3_ -= this._nOffset != undefined ? this._nOffset * Math.sin(_loc7_) : 0;
      }
      else
      {
         _loc3_ -= this._nOffset != undefined ? this._nOffset : 0;
      }
      var _loc8_ = "UI_IndicatorLight";
      var _loc9_ = "UI_IndicatorArrow";
      if(dofus.Constants.TRIPLEFRAMERATE)
      {
         _loc8_ += "_TripleFramerate";
         _loc9_ += "_TripleFramerate";
      }
      this.attachMovie(_loc8_,"_mcLight",10,{_x:_loc2_,_y:_loc3_});
      this.attachMovie(_loc9_,"_mcArrowShadow",20,{_x:_loc2_ + dofus.graphics.gapi.ui.Indicator.SHADOW_OFFSET,_y:_loc3_ + dofus.graphics.gapi.ui.Indicator.SHADOW_OFFSET});
      this.attachMovie(_loc9_,"_mcArrow",30,{_x:_loc2_,_y:_loc3_});
      var _loc10_ = new Color(this._mcArrowShadow);
      _loc10_.setTransform(dofus.graphics.gapi.ui.Indicator.SHADOW_TRANSFORM);
      if(this._bRotate)
      {
         this._mcLight._rotation = _loc4_;
         this._mcArrow._rotation = _loc4_;
         this._mcArrowShadow._rotation = _loc4_;
      }
   }
}
