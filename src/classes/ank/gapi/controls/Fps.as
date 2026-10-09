class ank.gapi.controls.Fps extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _lblText;
   var _mcBack;
   var _nSaveTime;
   var attachMovie;
   var createEmptyMovieClip;
   var drawRoundRect;
   var getNextHighestDepth;
   var getStyle;
   var setMovieClipColor;
   static var CLASS_NAME = "Fps";
   var _nAverageOffset = 10;
   var _aValues = [];
   function Fps()
   {
      super();
   }
   function set averageOffset(nAverageOffset)
   {
      this._nAverageOffset = nAverageOffset;
   }
   function init()
   {
      super.init(false,ank.gapi.controls.Fps.CLASS_NAME);
   }
   function createChildren()
   {
      this.createEmptyMovieClip("_mcBack",this.getNextHighestDepth());
      this.drawRoundRect(this._mcBack,0,0,1,1,0,16777215);
      this.attachMovie("Label","_lblText",this.getNextHighestDepth(),{text:"--"});
   }
   function size()
   {
      super.size();
      this.arrange();
   }
   function arrange()
   {
      this._mcBack._width = this.__width;
      this._mcBack._height = this.__height;
      this._lblText.setSize(this.__width,this.__height);
   }
   function draw()
   {
      var _loc2_ = this.getStyle();
      if(_loc2_.backcolor != undefined)
      {
         this.setMovieClipColor(this._mcBack,_loc2_.backcolor);
      }
      this._mcBack._alpha = _loc2_.backalpha;
      this._lblText.styleName = _loc2_.labelstyle;
   }
   function pushValue(nValue)
   {
      this._aValues.push(nValue);
      if(this._aValues.length > this._nAverageOffset)
      {
         this._aValues.shift();
      }
   }
   function getAverage()
   {
      var _loc2_ = 0;
      for(var k in this._aValues)
      {
         _loc2_ += Number(this._aValues[k]);
      }
      return Math.round(_loc2_ / this._aValues.length);
   }
   function onEnterFrame()
   {
      var _loc2_ = getTimer();
      var _loc3_ = _loc2_ - this._nSaveTime;
      this.pushValue(1 / (_loc3_ / 1000));
      this._lblText.text = String(this.getAverage());
      this._nSaveTime = _loc2_;
   }
}
