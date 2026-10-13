class ank.gapi.controls.CircleBar extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _bEnabled;
   var _mcCircle;
   var _parent;
   var _sBackgroundLink;
   var addToQueue;
   var attachMovie;
   var getStyle;
   var setMovieClipColor;
   static var CLASS_NAME = "CircleBar";
   var _nValue = 0;
   var _nMinimum = 0;
   var _nMaximum = 100;
   function CircleBar()
   {
      super();
   }
   function set background(sBackground)
   {
      this._sBackgroundLink = sBackground;
   }
   function set minimum(nMinimum)
   {
      this._nMinimum = nMinimum;
   }
   function get minimum()
   {
      return this._nMinimum;
   }
   function set maximum(nMaximum)
   {
      this._nMaximum = nMaximum;
   }
   function get maximum()
   {
      return this._nMaximum;
   }
   function set value(nValue)
   {
      if(nValue > this._nMaximum)
      {
         nValue = this._nMaximum;
      }
      if(nValue < this._nMinimum)
      {
         nValue = this._nMinimum;
      }
      this._nValue = nValue;
      this.addToQueue({object:this,method:this.applyValue});
   }
   function get value()
   {
      return this._nValue;
   }
   function get trueValue()
   {
      return this._nMaximum != this._nMinimum ? Math.floor((this._nValue - this._nMinimum) / (this._nMaximum - this._nMinimum) * 100) : 0;
   }
   function init()
   {
      super.init(false,ank.gapi.controls.CircleBar.CLASS_NAME);
   }
   function createChildren()
   {
      this.attachMovie(this._sBackgroundLink,"_mcCircle",10);
      this.addToQueue({object:this,method:this.applyValue});
   }
   function size()
   {
      this._mcCircle.setSize(this.__width,this.__height);
   }
   function draw()
   {
      this.setMovieClipColor(this._mcCircle,this.getStyle().bgcolor);
   }
   function applyValue()
   {
      var _loc2_ = this._nValue - this._nMinimum;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if(_loc2_ == 0)
      {
         this._mcCircle._alpha = 0;
      }
      else
      {
         _loc3_ = this._mcCircle._totalframes;
         _loc4_ = this._nMaximum - this._nMinimum;
         _loc5_ = Math.floor(_loc2_ / _loc4_ * (_loc3_ - 1)) + 1;
         this._mcCircle.gotoAndStop(_loc5_);
         this._mcCircle._alpha = 100;
      }
   }
   function setEnabled()
   {
      if(this._bEnabled)
      {
         this._mcCircle.onRollOver = function()
         {
            this._parent.dispatchEvent({target:this._parent,type:"over"});
         };
         this._mcCircle.onRollOut = function()
         {
            this._parent.dispatchEvent({target:this._parent,type:"out"});
         };
      }
      else
      {
         this._mcCircle.onRollOver = undefined;
         this._mcCircle.onRollOut = undefined;
      }
      this._mcCircle.enabled = this._bEnabled;
   }
}
