54435850 - 1;
class ank.gapi.controls.Loader extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _bInited;
   var _bLoaded;
   var _mvlLoader;
   var _nBytesLoaded;
   var _nBytesTotal;
   var _oParams;
   var _oTempVars;
   var _sFrame;
   var _sPrevURL;
   var _visible;
   var createEmptyMovieClip;
   var dispatchEvent;
   var holder_mc;
   var onRelease;
   var onRollOut;
   var onRollOver;
   static var CLASS_NAME = "Loader";
   var _bEnabled = false;
   var _bAutoLoad = true;
   var _bScaleContent = false;
   var _bCenterContent = false;
   var _sURL = "";
   var _sURLFallback = "";
   var _bForceReload = false;
   function Loader()
   {
      super();
   }
   function get tempVars()
   {
      return this._oTempVars;
   }
   function set tempVars(oTempVars)
   {
      this._oTempVars = oTempVars;
   }
   function set enabled(bEnabled)
   {
      super.enabled = bEnabled;
   }
   function set scaleContent(bScaleContent)
   {
      this._bScaleContent = bScaleContent;
   }
   function get scaleContent()
   {
      return this._bScaleContent;
   }
   function set autoLoad(bAutoLoad)
   {
      this._bAutoLoad = bAutoLoad;
   }
   function get autoLoad()
   {
      return this._bAutoLoad;
   }
   function set centerContent(bCenter)
   {
      this._bCenterContent = bCenter;
   }
   function get centerContent()
   {
      return this._bCenterContent;
   }
   function set contentParams(oParams)
   {
      this._oParams = oParams;
      if(this._oParams.frame)
      {
         this.frame = this._oParams.frame;
      }
   }
   function get contentParams()
   {
      return this._oParams;
   }
   function set contentPath(sURL)
   {
      this._sURL = sURL;
      if(this._bAutoLoad)
      {
         this.load();
      }
   }
   function get contentPath()
   {
      return this._sURL;
   }
   function set fallbackContentPath(sURLFallback)
   {
      this._sURLFallback = sURLFallback;
   }
   function get fallbackContentPath()
   {
      return this._sURLFallback;
   }
   function set forceReload(bForce)
   {
      this._bForceReload = bForce;
   }
   function get forceReload()
   {
      return this._bForceReload;
   }
   function get bytesLoaded()
   {
      return this._nBytesLoaded;
   }
   function get bytesTotal()
   {
      return this._nBytesTotal;
   }
   function get percentLoaded()
   {
      var _loc2_ = Math.round(this.bytesLoaded / this.bytesTotal * 100);
      _loc2_ = !_global.isNaN(_loc2_) ? _loc2_ : 0;
      return _loc2_;
   }
   function get content()
   {
      return this.holder_mc.content_mc;
   }
   function set content(mcContent)
   {
      this.holder_mc.content_mc = mcContent;
   }
   function get holder()
   {
      return this.holder_mc;
   }
   function get loaded()
   {
      return this._bLoaded;
   }
   function set frame(sFrame)
   {
      this._sFrame = sFrame;
      this.content.gotoAndStop(sFrame);
      this.size();
   }
   function set cacheAsBitmap(bEnabled)
   {
      this.holder_mc.content_mc.cacheAsBitmap = bEnabled;
   }
   function forceNextLoad()
   {
      delete this._sPrevURL;
   }
   function init()
   {
      super.init(false,ank.gapi.controls.Loader.CLASS_NAME);
      if(this._bScaleContent == undefined)
      {
         this._bScaleContent = true;
      }
      this._bInited = true;
      this._nBytesLoaded = 0;
      this._nBytesTotal = 0;
      this._bLoaded = false;
      this._mvlLoader = new MovieClipLoader();
      this._mvlLoader.addListener(this);
   }
   function createChildren()
   {
      this.createEmptyMovieClip("holder_mc",10);
      if(this._bAutoLoad && this._sURL != undefined)
      {
         this.load();
      }
   }
   function size()
   {
      super.size();
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(this.holder_mc.content_mc != undefined)
      {
         if(this._sFrame != undefined && this._sFrame != "")
         {
            this.frame = this._sFrame;
         }
         if(this._bScaleContent)
         {
            _loc3_ = this.holder_mc.content_mc._width;
            _loc4_ = this.holder_mc.content_mc._height;
            _loc5_ = _loc3_ / _loc4_;
            _loc6_ = this.__width / this.__height;
            if(_loc5_ == _loc6_)
            {
               this.holder_mc._width = this.__width;
               this.holder_mc._height = this.__height;
            }
            else if(_loc5_ > _loc6_)
            {
               this.holder_mc._width = this.__width;
               this.holder_mc._height = this.__width / _loc5_;
            }
            else
            {
               this.holder_mc._width = this.__height * _loc5_;
               this.holder_mc._height = this.__height;
            }
            _loc7_ = this.holder_mc.content_mc.getBounds();
            this.holder_mc.content_mc._x = - _loc7_.xMin;
            this.holder_mc.content_mc._y = - _loc7_.yMin;
            this.holder_mc._x = (this.__width - this.holder_mc._width) / 2;
            this.holder_mc._y = (this.__height - this.holder_mc._height) / 2;
         }
         if(this._bCenterContent)
         {
            this.holder_mc._x = this.__width / 2;
            this.holder_mc._y = this.__height / 2;
         }
      }
   }
   function setEnabled()
   {
      if(this._bEnabled)
      {
         this.onRelease = function()
         {
            this.dispatchEvent({type:"click"});
         };
         this.onRollOut = function()
         {
            this.dispatchEvent({type:"out"});
         };
         this.onRollOver = function()
         {
            this.dispatchEvent({type:"over"});
         };
      }
      else
      {
         delete this.onRelease;
         delete this.onRollOut;
         delete this.onRollOver;
      }
   }
   function load()
   {
      if(this._sPrevURL == undefined && this._sURL == "")
      {
         return undefined;
      }
      if(!this._bForceReload && (this._sPrevURL == this._sURL || this._sURL == undefined || this.holder_mc == undefined))
      {
         return undefined;
      }
      this._visible = false;
      this._bLoaded = false;
      this._sPrevURL = this._sURL;
      this.holder_mc.content_mc.removeMovieClip();
      if(this._sURL.toLowerCase().indexOf(".swf") != -1)
      {
         if(this.holder_mc.content_mc == undefined)
         {
            this.holder_mc.createEmptyMovieClip("content_mc",1);
            this.holder_mc.content_mc.cacheAsBitmap = _global.CONFIG.cacheAsBitmap["Controls/Loader"];
         }
         this._mvlLoader.loadClip(this._sURL,this.holder_mc.content_mc);
      }
      else
      {
         this.holder_mc.attachMovie(this._sURL,"content_mc",1,this._oParams);
         this.holder_mc.content_mc.cacheAsBitmap = _global.CONFIG.cacheAsBitmap["Controls/Loader"];
         this.onLoadComplete(this.holder_mc.content_mc);
         this.onLoadInit(this.holder_mc.content_mc);
      }
   }
   function onLoadError(mc)
   {
      if(this._sURLFallback != "")
      {
         this._sURL = this._sURLFallback;
         this._sURLFallback = "";
         this.load();
      }
      else
      {
         this.dispatchEvent({type:"error",target:this,clip:mc});
      }
   }
   function onLoadProgress(mc, bl, bt)
   {
      this._nBytesLoaded = bl;
      this._nBytesTotal = bt;
      this.dispatchEvent({type:"progress",target:this,clip:mc});
   }
   function onLoadComplete(mc)
   {
      this._bLoaded = true;
      this.dispatchEvent({type:"complete",clip:mc});
   }
   function onLoadInit(mc)
   {
      this.size();
      this._visible = true;
      this.dispatchEvent({type:"initialization",clip:(!mc.clip ? mc : mc.clip)});
   }
}
