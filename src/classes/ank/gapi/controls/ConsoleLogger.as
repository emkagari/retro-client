class ank.gapi.controls.ConsoleLogger extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _aLogs;
   var _bShadowy;
   var _parent;
   var _tText;
   var createTextField;
   var dispatchEvent;
   var getStyle;
   static var CLASS_NAME = "ConsoleLogger";
   function ConsoleLogger()
   {
      super();
   }
   function get shadowy()
   {
      return this._bShadowy;
   }
   function set shadowy(b)
   {
      this._bShadowy = b;
   }
   function log(sText, sHColor, sLColor)
   {
      var _loc5_ = {};
      _loc5_.text = sText;
      _loc5_.hColor = sHColor != undefined ? sHColor : "#FFFFFF";
      _loc5_.lColor = sLColor != undefined ? sLColor : "#999999";
      this._aLogs.push(_loc5_);
      this.refreshLogs();
   }
   function clear()
   {
      this._aLogs = [];
      this.refreshLogs();
   }
   function init()
   {
      super.init(false,ank.gapi.controls.ConsoleLogger.CLASS_NAME);
   }
   function createChildren()
   {
      this.createTextField("_tText",10,0,0,this.__width,this.__height);
      this._tText.html = true;
      this._tText.text = "";
      this._tText.selectable = false;
      this._tText.multiline = true;
      this._tText.onSetFocus = function()
      {
         this._parent.onSetFocus();
      };
      this._tText.onKillFocus = function()
      {
         this._parent.onKillFocus();
      };
      var _loc2_;
      if(this._bShadowy)
      {
         _loc2_ = [];
         _loc2_.push(new flash.filters.DropShadowFilter(1,60,0,1,3,3,4,3,false,false,false));
         this._tText.filters = _loc2_;
         this._tText.antiAliasType = "advanced";
      }
      this._aLogs = [];
   }
   function size()
   {
      super.size();
      this._tText._width = this.__width;
      this._tText._height = this.__height;
   }
   function draw()
   {
      var _loc2_ = this.getStyle();
      this._tText.embedFonts = this.getStyle().embedfonts;
   }
   function refreshLogs()
   {
      var _loc2_ = "";
      var _loc3_ = this._aLogs.length - 1;
      var _loc5_ = this.getStyle();
      var _loc6_ = 0;
      var _loc4_;
      while(_loc6_ < _loc3_)
      {
         _loc4_ = this._aLogs[_loc6_];
         _loc2_ += "<p><font size=\'" + _loc5_.size + "\' face=\'" + _loc5_.font + "\' color=\'" + _loc4_.lColor + "\'>" + _loc4_.text + "</font></p>";
         _loc6_ = _loc6_ + 1;
      }
      _loc4_ = this._aLogs[_loc3_];
      if(_loc4_ != undefined)
      {
         _loc2_ += "<p><font size=\'" + _loc5_.size + "\' face=\'" + _loc5_.font + "\' color=\'" + _loc4_.hColor + "\'>" + _loc4_.text + "</font></p>";
      }
      this._tText.htmlText = _loc2_;
      this._tText.scroll = this._tText.maxscroll;
   }
   function onHref(sParams)
   {
      this.dispatchEvent({type:"href",params:sParams});
   }
   function onSetFocus()
   {
      fscommand("trapallkeys","false");
   }
   function onKillFocus()
   {
      fscommand("trapallkeys","true");
   }
}
