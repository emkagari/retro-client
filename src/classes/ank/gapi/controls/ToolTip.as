class ank.gapi.controls.ToolTip extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var __height;
   var __width;
   var _mcBackground;
   var _oParams;
   var _sText;
   var _tfText;
   var _tfTextFormat;
   var _visible;
   var _x;
   var _y;
   var addToQueue;
   var cacheAsBitmap;
   var createEmptyMovieClip;
   var drawRoundRect;
   var getStyle;
   var initialized;
   var removeMovieClip;
   var setSize;
   static var CLASS_NAME = "ToolTip";
   static var MAX_WIDTH = 250;
   static var OFFSET = 14;
   static var H_PADDING = 2;
   var _nMaxX = Stage.width;
   var _nMaxY = Stage.height;
   var _lastMouseX = -1;
   var _lastMouseY = -1;
   function ToolTip()
   {
      super();
   }
   function set params(oParams)
   {
      this._oParams = oParams;
   }
   function set text(sText)
   {
      this._sText = sText;
      if(this.initialized)
      {
         this._mcBackground.clear();
         this.draw();
      }
   }
   function init()
   {
      super.init(false,ank.gapi.controls.ToolTip.CLASS_NAME);
   }
   function createChildren()
   {
      this._visible = false;
      this.createEmptyMovieClip("_mcBackground",10);
      this._tfText = this._mcBackground.createTextField("_tfText",20,0,0,ank.gapi.controls.ToolTip.MAX_WIDTH,100);
      this._tfText.wordWrap = true;
      this._tfText.selectable = false;
      this._tfText.autoSize = "left";
      this._tfText.multiline = true;
      this._tfText.html = true;
      this.addToQueue({object:this,method:this.displayToolTip});
      Key.addListener(this);
   }
   function destroy()
   {
      Key.removeListener(this);
      this.removeMovieClip();
   }
   function placeToolTip()
   {
      var _loc2_ = _root._xmouse + ank.gapi.controls.ToolTip.H_PADDING;
      var _loc3_ = _root._ymouse + ank.gapi.controls.ToolTip.OFFSET;
      if(_loc2_ + this.__width > this._nMaxX - 6)
      {
         if(_root._xmouse - this.__width - ank.gapi.controls.ToolTip.H_PADDING > 0)
         {
            _loc2_ = _root._xmouse - this.__width - ank.gapi.controls.ToolTip.H_PADDING;
         }
         else
         {
            _loc2_ = this._nMaxX - this.__width - ank.gapi.controls.ToolTip.H_PADDING;
         }
      }
      if(_loc3_ + this.__height > this._nMaxY)
      {
         if(_root._ymouse - this.__height - ank.gapi.controls.ToolTip.H_PADDING > 0)
         {
            _loc3_ = _root._ymouse - this.__height - ank.gapi.controls.ToolTip.H_PADDING;
         }
         else
         {
            _loc3_ = this._nMaxY - this.__height - ank.gapi.controls.ToolTip.H_PADDING;
         }
      }
      this._x = _loc2_;
      this._y = _loc3_;
   }
   function displayToolTip()
   {
      this.placeToolTip();
      this._visible = true;
   }
   function draw()
   {
      this.cacheAsBitmap = false;
      var _loc2_ = this.getStyle();
      this._tfTextFormat = new TextFormat();
      this._tfTextFormat.font = _loc2_.font;
      this._tfTextFormat.size = _loc2_.size;
      this._tfTextFormat.color = _loc2_.color;
      if(!this._tfText.html)
      {
         this._tfTextFormat.bold = _loc2_.bold;
         this._tfTextFormat.italic = _loc2_.italic;
         this._tfText.text = this._sText;
      }
      else
      {
         this._tfText.htmlText = this._sText;
      }
      this._tfText.embedFonts = _loc2_.embedfonts;
      this._tfText.antiAliasType = _loc2_.antialiastype;
      this._tfText.setTextFormat(this._tfTextFormat);
      this.setSize(this._tfText.textWidth + 10,this._tfText.textHeight + 10);
      this._tfText._x = 2.5;
      this._tfText._y = 2.4;
      this.drawRoundRect(this._mcBackground,0,0,this.__width,this.__height,3,_loc2_.bgcolor,_loc2_.bgalpha);
      this.cacheAsBitmap = true;
   }
   function onKeyDown()
   {
      this.destroy();
   }
   function onMouseDown()
   {
      this.destroy();
   }
   function onMouseMove()
   {
      if(this._lastMouseX != _root._xmouse || this._lastMouseY != _root._ymouse)
      {
         this.placeToolTip();
         this._lastMouseX = _root._xmouse;
         this._lastMouseY = _root._ymouse;
      }
   }
}
