class ank.gapi.controls.Window extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _bInitialized;
   var _lblTitle;
   var _ldrContent;
   var _mcBackground;
   var _mcBorder;
   var _mcTitle;
   var _x;
   var _y;
   var addToQueue;
   var attachMovie;
   var createEmptyMovieClip;
   var dispatchEvent;
   var drawRoundRect;
   var gapi;
   var getStyle;
   var onRelease;
   var setSize;
   var useHandCursor;
   static var CLASS_NAME = "Window";
   static var LBL_TITLE_HEIGHT = 25;
   static var LBL_TITLE_TOP_PADDING = 5;
   static var LBL_TITLE_LEFT_PADDING = 5;
   var _bCenterScreen = false;
   var _bInterceptMouseEvent = true;
   var _sContentPath = "none";
   var _bContentLoaded = false;
   var _bDrag = false;
   function Window()
   {
      super();
   }
   function set title(sTitle)
   {
      this.addToQueue({object:this,method:function()
      {
         this._lblTitle.text = sTitle;
      }});
   }
   function get title()
   {
      return this._lblTitle.text;
   }
   function set contentPath(sContentPath)
   {
      this._bContentLoaded = false;
      this._sContentPath = sContentPath;
      if(sContentPath == "none")
      {
         this.addToQueue({object:this,method:function()
         {
            this._ldrContent.contentPath = "";
         }});
      }
      else
      {
         this.addToQueue({object:this,method:function()
         {
            this._ldrContent.contentPath = sContentPath;
         }});
      }
   }
   function get contentPath()
   {
      return this._ldrContent.contentPath;
   }
   function set contentParams(oParams)
   {
      this.addToQueue({object:this,method:function()
      {
         this._ldrContent.contentParams = oParams;
      }});
   }
   function get contentParams()
   {
      return this._ldrContent.contentParams;
   }
   function get content()
   {
      return this._ldrContent.content;
   }
   function set interceptMouseEvent(bIntercept)
   {
      this._bInterceptMouseEvent = bIntercept;
   }
   function get interceptMouseEvent()
   {
      return this._bInterceptMouseEvent;
   }
   function set centerScreen(bInterceptMouseEvent)
   {
      this._bDrag = bInterceptMouseEvent;
      this.useHandCursor = false;
      if(bInterceptMouseEvent)
      {
         this.onRelease = function()
         {
         };
      }
      else
      {
         delete this.onRelease;
      }
   }
   function get centerScreen()
   {
      return this._bDrag;
   }
   function setPreferedSize()
   {
      this._ldrContent._x = this._ldrContent._y = 0;
      var _loc2_ = this._ldrContent.content.getBounds(this);
      var _loc3_ = _loc2_.xMax - _loc2_.xMin;
      var _loc4_ = _loc2_.yMax - _loc2_.yMin;
      var _loc5_ = this.getStyle();
      var _loc6_ = _loc5_.cornerradius;
      var _loc7_ = _loc5_.borderwidth == undefined ? 0 : _loc5_.borderwidth;
      var _loc8_ = _loc5_.titleheight;
      this._ldrContent._x = _loc7_ - _loc2_.xMin;
      this._ldrContent._y = _loc7_ + _loc8_ - _loc2_.yMin;
      this.setSize(2 * _loc7_ + _loc3_,2 * _loc7_ + _loc8_ + _loc4_ + (typeof _loc6_ != "object" ? _loc6_ : Math.max(_loc6_.bl,_loc6_.br)));
   }
   function init()
   {
      super.init(false,ank.gapi.controls.Window.CLASS_NAME);
   }
   function createChildren()
   {
      this.createEmptyMovieClip("_mcBorder",10);
      this.createEmptyMovieClip("_mcBackground",20);
      this.createEmptyMovieClip("_mcTitle",30);
      this.attachMovie("GAPILoader","_ldrContent",40);
      this._ldrContent.addEventListener("complete",this);
      this.attachMovie("Label","_lblTitle",50,{_x:ank.gapi.controls.Window.LBL_TITLE_LEFT_PADDING,_y:ank.gapi.controls.Window.LBL_TITLE_TOP_PADDING});
   }
   function size()
   {
      super.size();
      this.arrange();
   }
   function arrange()
   {
      this._lblTitle.setSize(this.__width - ank.gapi.controls.Window.LBL_TITLE_LEFT_PADDING,ank.gapi.controls.Window.LBL_TITLE_HEIGHT);
      if(this._bInitialized)
      {
         this.draw();
      }
      if(this._bInterceptMouseEvent)
      {
         this._x = (this.gapi.screenWidth - this.__width) / 2;
         this._y = (this.gapi.screenHeight - this.__height) / 2;
      }
   }
   function draw()
   {
      if(this._sContentPath != "none" && !this._bContentLoaded)
      {
         return undefined;
      }
      var _loc2_ = this.getStyle();
      this._lblTitle.styleName = _loc2_.titlestyle;
      var _loc3_ = _loc2_.cornerradius;
      var _loc4_ = _loc2_.bordercolor;
      var _loc5_ = _loc2_.borderwidth == undefined ? 0 : _loc2_.borderwidth;
      var _loc6_ = _loc2_.backgroundcolor;
      var _loc7_ = _loc2_.backgroundalpha == undefined ? 100 : _loc2_.backgroundalpha;
      var _loc8_ = _loc2_.backgroundrotation == undefined ? 0 : _loc2_.backgroundrotation;
      var _loc9_ = _loc2_.backgroundradient;
      var _loc10_ = _loc2_.backgroundratio;
      var _loc11_ = _loc2_.displaytitle == undefined ? true : _loc2_.displaytitle;
      var _loc12_ = _loc2_.titlecolor;
      var _loc13_ = _loc2_.titleheight;
      var _loc14_;
      if(typeof _loc3_ == "object")
      {
         _loc14_ = {tl:_loc3_.tl - _loc5_,tr:_loc3_.tr - _loc5_,br:_loc3_.bl - _loc5_,bl:_loc3_.bl - _loc5_};
      }
      else
      {
         _loc14_ = _loc3_ - _loc5_;
      }
      var _loc15_;
      if(typeof _loc3_ == "object")
      {
         _loc15_ = {tl:_loc3_.tl - _loc5_,tr:_loc3_.tr - _loc5_,br:0,bl:0};
      }
      else
      {
         _loc15_ = {tl:_loc3_ - _loc5_,tr:_loc3_ - _loc5_,bl:0,br:0};
      }
      this._mcBorder.clear();
      this._mcBackground.clear();
      this._mcTitle.clear();
      this.drawRoundRect(this._mcBorder,0,0,this.__width,this.__height,_loc3_,_loc4_);
      this.drawRoundRect(this._mcBackground,_loc5_,_loc5_,this.__width - 2 * _loc5_,this.__height - 2 * _loc5_,_loc14_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_);
      if(_loc11_)
      {
         this.drawRoundRect(this._mcTitle,_loc5_,_loc5_,this.__width - 2 * _loc5_,_loc13_,_loc15_,_loc12_);
      }
   }
   function complete()
   {
      this._bContentLoaded = true;
      this.dispatchEvent({type:"complete"});
      this.setPreferedSize();
   }
}
