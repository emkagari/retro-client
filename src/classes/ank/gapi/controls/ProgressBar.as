class ank.gapi.controls.ProgressBar extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _bDisableBackground;
   var _bEnabled;
   var _bInitialized;
   var _bShowAnimOnLoad;
   var _bShowGradient;
   var _mcRenderer;
   var _mcRendererUber;
   var addToQueue;
   var attachMovie;
   var dispatchEvent;
   var getStyle;
   var onRollOut;
   var onRollOver;
   var setMovieClipColor;
   static var CLASS_NAME = "ProgressBar";
   var _sRenderer = "ProgressBarDefaultRenderer";
   var _nValue = 0;
   var _nMinimum = 0;
   var _nMaximum = 100;
   var _nUberValue = 0;
   var _nUberMinimum = 0;
   var _nUberMaximum = 100;
   function ProgressBar()
   {
      super();
   }
   function set renderer(sRenderer)
   {
      if(this._bInitialized)
      {
         return;
      }
      this._sRenderer = sRenderer;
   }
   function set minimum(nMinimum)
   {
      this._nMinimum = Number(nMinimum);
   }
   function get minimum()
   {
      return this._nMinimum;
   }
   function set maximum(nMaximum)
   {
      this._nMaximum = Number(nMaximum);
   }
   function get maximum()
   {
      return this._nMaximum;
   }
   function set value(nValue)
   {
      if(nValue >= this._nMaximum)
      {
         nValue = this._nMaximum;
      }
      if(nValue <= this._nMinimum)
      {
         nValue = this._nMinimum;
      }
      this._nValue = Number(nValue);
      this.addToQueue({object:this,method:this.applyValue});
   }
   function set showGradient(bShow_)
   {
      this._bShowGradient = bShow_;
   }
   function set showAnimOnLoad(bShow_)
   {
      this._bShowAnimOnLoad = bShow_;
   }
   function get value()
   {
      return this._nValue;
   }
   function set uberValue(nUberValue)
   {
      if(nUberValue >= this._nUberMaximum)
      {
         nUberValue = this._nUberMaximum;
      }
      if(nUberValue <= this._nUberMinimum)
      {
         nUberValue = this._nUberMinimum;
      }
      this._nUberValue = Number(nUberValue);
      this.addToQueue({object:this,method:this.applyValueUber});
   }
   function get uberValue()
   {
      return this._nUberValue;
   }
   function set uberMinimum(nMinimum)
   {
      this._nUberMinimum = Number(nMinimum);
   }
   function get uberMinimum()
   {
      return this._nUberMinimum;
   }
   function set uberMaximum(nMaximum)
   {
      this._nUberMaximum = Number(nMaximum);
   }
   function get uberMaximum()
   {
      return this._nUberMaximum;
   }
   function set disableBackground(bDisable)
   {
      this._bDisableBackground = bDisable;
   }
   function get disableBackground()
   {
      return this._bDisableBackground;
   }
   function init()
   {
      super.init(false,ank.gapi.controls.ProgressBar.CLASS_NAME);
   }
   function createChildren()
   {
      this.attachMovie(this._sRenderer,"_mcRenderer",10);
      this.attachMovie(this._sRenderer,"_mcRendererUber",20);
      this._mcRendererUber._mcBgLeft._visible = false;
      this._mcRendererUber._mcBgRight._visible = false;
      this._mcRendererUber._mcBgMiddle._visible = false;
      this.hideUp(true);
      this.uberHideUp(true);
      this.hideGradient(true);
      this.uberHideGradient(true);
      this.hideBackground(this._bDisableBackground);
   }
   function size()
   {
      super.size();
   }
   function arrange()
   {
      var _loc2_ = [this._mcRenderer,this._mcRendererUber];
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      while(_loc3_ < _loc2_.length)
      {
         _loc4_ = _loc2_[_loc3_];
         _loc4_._mcBgLeft._height = _loc4_._mcBgMiddle._height = _loc4_._mcBgRight._height = this.__height;
         _loc5_ = _loc4_._mcBgLeft._yscale;
         _loc4_._mcBgLeft._xscale = _loc4_._mcUpLeft._xscale = _loc4_._mcUpLeft._yscale = _loc5_;
         _loc4_._mcBgRight._xscale = _loc4_._mcUpRight._xscale = _loc4_._mcUpRight._yscale = _loc5_;
         _loc4_._mcUpMiddle._yscale = _loc5_;
         _loc6_ = _loc4_._mcBgLeft._width;
         _loc7_ = _loc4_._mcBgRight._width;
         this._mcRenderer._mcRectangle._height = this._mcRenderer._mcBgLeft._height;
         this._mcRenderer._mcRectangle._width = this._mcRenderer._mcBgLeft._width + this._mcRenderer._mcBgMiddle._width + this._mcRenderer._mcBgRight._width;
         _loc4_._mcBgLeft._x = _loc4_._mcBgLeft._y = _loc4_._mcBgMiddle._y = _loc4_._mcBgRight._y = _loc4_._mcRectangle._y = 0;
         _loc4_._mcUpLeft._x = _loc4_._mcUpLeft._y = _loc4_._mcUpMiddle._y = _loc4_._mcUpRight._y = 0;
         _loc4_._mcBgMiddle._x = _loc4_._mcUpMiddle._x = _loc6_;
         _loc4_._mcBgRight._x = this.__width - _loc7_;
         _loc4_._mcBgMiddle._width = this.__width - _loc6_ - _loc7_;
         _loc4_._mcUpLeft._width = _loc4_._mcUpLeft._width;
         if(this._bShowGradient)
         {
            _loc4_._mcGradientLeft._height = _loc4_._mcUpLeft._height;
            _loc4_._mcGradientLeft._width = _loc4_._mcUpLeft._width;
            _loc4_._mcGradientMiddle._height = _loc4_._mcUpMiddle._height;
            _loc4_._mcGradientMiddle._width = _loc4_._mcUpMiddle._width;
            _loc4_._mcGradientRight._height = _loc4_._mcUpRight._height;
            _loc4_._mcGradientRight._width = _loc4_._mcUpRight._width;
            _loc4_._mcGradientLeft._x = _loc4_._mcGradientLeft._y = _loc4_._mcGradientMiddle._y = _loc4_._mcGradientMiddle._y = _loc4_._mcGradientRight._y = 0;
            _loc4_._mcGradientMiddle._x = _loc4_._mcUpMiddle._x;
            _loc4_._mcGradientRight._x = _loc4_._mcUpRight._x;
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function draw()
   {
      var _loc3_ = this.getStyle();
      var _loc4_ = [this._mcRenderer,this._mcRendererUber];
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc2_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      while(_loc5_ < _loc4_.length)
      {
         _loc6_ = _loc4_[_loc5_];
         _loc7_ = _loc6_ != this._mcRendererUber ? "" : "uber";
         _loc2_ = _loc6_._mcBgLeft;
         for(var k in _loc2_)
         {
            _loc8_ = k.split("_")[0];
            this.setMovieClipColor(_loc2_[k],_loc3_[_loc7_ + _loc8_ + "color"]);
         }
         _loc2_ = _loc6_._mcBgMiddle;
         for(var k in _loc2_)
         {
            _loc9_ = k.split("_")[0];
            this.setMovieClipColor(_loc2_[k],_loc3_[_loc7_ + _loc9_ + "color"]);
         }
         _loc2_ = _loc6_._mcBgRight;
         for(var k in _loc2_)
         {
            _loc10_ = k.split("_")[0];
            this.setMovieClipColor(_loc2_[k],_loc3_[_loc7_ + _loc10_ + "color"]);
         }
         _loc2_ = _loc6_._mcUpLeft;
         for(var k in _loc2_)
         {
            _loc11_ = k.split("_")[0];
            this.setMovieClipColor(_loc2_[k],_loc3_[_loc7_ + _loc11_ + "color"]);
         }
         _loc2_ = _loc6_._mcUpMiddle;
         for(var k in _loc2_)
         {
            _loc12_ = k.split("_")[0];
            this.setMovieClipColor(_loc2_[k],_loc3_[_loc7_ + _loc12_ + "color"]);
         }
         _loc2_ = _loc6_._mcUpRight;
         for(var k in _loc2_)
         {
            _loc13_ = k.split("_")[0];
            this.setMovieClipColor(_loc2_[k],_loc3_[_loc7_ + _loc13_ + "color"]);
         }
         _loc5_ = _loc5_ + 1;
      }
   }
   function hideUp(bHide)
   {
      this._mcRenderer._mcUpLeft._visible = !bHide;
      this._mcRenderer._mcUpMiddle._visible = !bHide;
      this._mcRenderer._mcUpRight._visible = !bHide;
   }
   function uberHideUp(bHide)
   {
      this._mcRendererUber._mcUpLeft._visible = !bHide;
      this._mcRendererUber._mcUpMiddle._visible = !bHide;
      this._mcRendererUber._mcUpRight._visible = !bHide;
   }
   function hideGradient(bHide)
   {
      this._mcRenderer._mcGradientLeft._visible = !bHide;
      this._mcRenderer._mcGradientMiddle._visible = !bHide;
      this._mcRenderer._mcGradientRight._visible = !bHide;
   }
   function uberHideGradient(bHide)
   {
      this._mcRendererUber._mcGradientLeft._visible = !bHide;
      this._mcRendererUber._mcGradientMiddle._visible = !bHide;
      this._mcRendererUber._mcGradientRight._visible = !bHide;
   }
   function hideBackground(bHide)
   {
      this._mcRenderer._mcBgLeft._visible = !bHide;
      this._mcRenderer._mcBgMiddle._visible = !bHide;
      this._mcRenderer._mcBgRight._visible = !bHide;
   }
   function applyValue()
   {
      var _loc2_ = this._mcRenderer._mcBgLeft._width;
      var _loc3_ = this._mcRenderer._mcBgLeft._width;
      var _loc4_ = this._nValue - this._nMinimum;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(_loc4_ == 0)
      {
         this.hideUp(true);
         this.hideGradient(true);
      }
      else
      {
         this.hideUp(false);
         _loc5_ = this._nMaximum - this._nMinimum;
         _loc6_ = this.__width - _loc2_ - _loc3_;
         _loc7_ = Math.floor(_loc4_ / _loc5_ * _loc6_);
         this._mcRenderer._mcUpMiddle._width = _loc7_ + 0.5;
         this._mcRenderer._mcUpRight._x = _loc7_ + _loc2_;
         if(this._bShowGradient)
         {
            this.hideGradient(false);
            this._mcRenderer._mcGradientMiddle._width = _loc7_;
            this._mcRenderer._mcGradientRight._x = _loc7_ + _loc2_;
         }
      }
   }
   function applyValueUber()
   {
      if(this._nUberValue == undefined)
      {
         return undefined;
      }
      var _loc2_ = this._mcRendererUber._mcBgLeft._width;
      var _loc3_ = this._mcRendererUber._mcBgLeft._width;
      var _loc4_ = this._nUberValue - this._nUberMinimum;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(_loc4_ == 0)
      {
         this.uberHideUp(true);
         this.uberHideGradient(true);
      }
      else
      {
         this.uberHideUp(false);
         _loc5_ = this._nUberMaximum - this._nUberMinimum;
         _loc6_ = this.__width - _loc2_ - _loc3_;
         _loc7_ = Math.floor(_loc4_ / _loc5_ * _loc6_);
         this._mcRendererUber._mcUpMiddle._width = _loc7_ + 0.5;
         this._mcRendererUber._mcUpRight._x = _loc7_ + _loc2_;
         if(this._bShowGradient)
         {
            this.uberHideGradient(false);
            this._mcRendererUber._mcGradientMiddle._width = _loc7_;
            this._mcRendererUber._mcGradientRight._x = _loc7_ + _loc2_;
         }
      }
   }
   function setEnabled()
   {
      if(this._bEnabled)
      {
         this.onRollOver = function()
         {
            this.dispatchEvent({type:"over"});
         };
         this.onRollOut = function()
         {
            this.dispatchEvent({type:"out"});
         };
      }
      else
      {
         this.onRollOver = undefined;
         this.onRollOut = undefined;
      }
   }
}
