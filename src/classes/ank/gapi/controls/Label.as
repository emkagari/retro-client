400090414 - 1;
class ank.gapi.controls.Label extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _bEnableOverEvents;
   var _bHTML;
   var _bSettingNewText;
   var _mcDot;
   var _mcOverEvent;
   var _parent;
   var _sText;
   var _tDotText;
   var _tText;
   var _tfFormatter;
   var createEmptyMovieClip;
   var createTextField;
   var dispatchEvent;
   var drawRoundRect;
   var gapi;
   var getStyle;
   var height;
   var setSize;
   var width;
   static var CLASS_NAME = "Label";
   var _sTextfiledType = "dynamic";
   var _bMultiline = false;
   var getStyle_ = false;
   var bDisplayDebug = false;
   function Label()
   {
      super();
   }
   function set html(bHTML)
   {
      this._bHTML = bHTML;
      this.setTextFieldProperties();
   }
   function get html()
   {
      return this._bHTML;
   }
   function set multiline(bWordWrap)
   {
      this._bMultiline = bWordWrap;
      this.setTextFieldProperties();
   }
   function get multiline()
   {
      return this._bMultiline;
   }
   function set wordWrap(bMultiline)
   {
      this.getStyle_ = bMultiline;
      this.setTextFieldProperties();
   }
   function get wordWrap()
   {
      return this.getStyle_;
   }
   function set text(sText)
   {
      this._sText = sText;
      this._bSettingNewText = true;
      this.setTextFieldProperties();
   }
   function get text()
   {
      return this._tText.text != undefined ? this._tText.text : this._sText;
   }
   function get textHeight()
   {
      return this._tText.textHeight;
   }
   function get textWidth()
   {
      return this._tText.textWidth;
   }
   function set textColor(nColor)
   {
      this._tText.textColor = nColor;
   }
   function get textFieldObject()
   {
      return this._tText;
   }
   function set enableOverEvents(enabled)
   {
      this._bEnableOverEvents = enabled;
      this.updateOverZone();
   }
   function setPreferedSize(sAutoSizeAlign)
   {
      this._tText.autoSize = sAutoSizeAlign;
      this.setSize(this.textWidth + 5,this.textHeight);
   }
   function init()
   {
      super.init(false,ank.gapi.controls.Label.CLASS_NAME);
      this._tfFormatter = new TextFormat();
   }
   function createChildren()
   {
      this.createTextField("_tText",10,0,1,this.__width,this.__height - 1);
      this._tText.addListener(this);
      this._tText.onKillFocus = function()
      {
         this._parent.onKillFocus();
      };
      this._tText.onSetFocus = function()
      {
         this._parent.onSetFocus();
      };
      this.setTextFieldProperties();
   }
   function size()
   {
      super.size();
      this._tText._height = this.__height - 1;
      this._tDotText.removeTextField();
      this._mcDot.removeMovieClip();
      if(this._tText.textWidth > this.__width && this._sTextfiledType == "dynamic")
      {
         this.createTextField("_tDotText",20,0,1,this.__width,this.__height - 1);
         this._tDotText.selectable = false;
         this._tDotText.autoSize = "right";
         this._tDotText.embedFonts = this.getStyle().labelembedfonts;
         this._tDotText.text = "...";
         this._tDotText.setNewTextFormat(this._tfFormatter);
         this._tDotText.setTextFormat(this._tfFormatter);
         this._tText._width = this.__width - this._tDotText.textWidth;
         this.createEmptyMovieClip("_mcDot",30);
         this.drawRoundRect(this._mcDot,this.__width - this._tDotText.textWidth,0,this._tDotText.textWidth + 5,this.__height,0,0,0);
         var that = this;
         var graphicApi = this.gapi;
         if(graphicApi == undefined)
         {
            graphicApi = _global.API.ui;
         }
         this._mcDot.onRollOver = function()
         {
            graphicApi.showTooltip(that._sText);
         };
         this._mcDot.onRollOut = function()
         {
            graphicApi.hideTooltip();
         };
      }
      else
      {
         this._tText._width = this.__width;
      }
   }
   function updateOverZone()
   {
      this._mcOverEvent.removeMovieClip();
      if(this._bEnableOverEvents)
      {
         this.createEmptyMovieClip("_mcOverEvent",40);
         this.drawRoundRect(this._mcOverEvent,0,0,this.width,this.height,0,0,0);
         this._mcOverEvent.onRollOver = function()
         {
            this._parent.dispatchEvent({type:"over"});
         };
         this._mcOverEvent.onRollOut = function()
         {
            this._parent.dispatchEvent({type:"out"});
         };
      }
   }
   function draw()
   {
      var _loc2_ = this.getStyle();
      this._tfFormatter = this._tText.getTextFormat();
      this._tfFormatter.font = _loc2_.labelfont;
      this._tfFormatter.align = _loc2_.labelalign;
      this._tfFormatter.size = _loc2_.labelsize;
      if(!this._bHTML)
      {
         this._tfFormatter.color = _loc2_.labelcolor;
      }
      this._tfFormatter.bold = _loc2_.labelbold;
      this._tfFormatter.italic = _loc2_.labelitalic;
      this._tText.embedFonts = _loc2_.labelembedfonts;
      this._tText.antiAliasType = _loc2_.antialiastype;
      this.setTextFieldProperties();
   }
   function setTextFieldProperties()
   {
      if(this._tText != undefined)
      {
         this._tText.wordWrap = this.getStyle_;
         this._tText.multiline = this._bMultiline;
         this._tText.selectable = this._sTextfiledType == "input";
         this._tText.type = this._sTextfiledType;
         this._tText.html = !this._bHTML ? false : true;
         if(this._tfFormatter.font != undefined)
         {
            if(this._sText != undefined)
            {
               if(this._bHTML)
               {
                  this._tText.htmlText = this._sText;
               }
               else
               {
                  this._tText.text = this._sText;
               }
            }
            this._tText.setNewTextFormat(this._tfFormatter);
            this._tText.setTextFormat(this._tfFormatter);
         }
         if(this._tText.textWidth > this.__width && this._sTextfiledType == "dynamic")
         {
            this.size();
         }
         else
         {
            this._tDotText.removeTextField();
            this._mcDot.removeMovieClip();
         }
         this.onChanged();
         this.updateOverZone();
      }
   }
   function onChanged()
   {
      this.dispatchEvent({type:"change"});
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
