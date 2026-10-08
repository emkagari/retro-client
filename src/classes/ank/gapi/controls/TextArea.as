class ank.gapi.controls.TextArea extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _bBorder;
   var _bInitialized;
   var _bSettingNewText;
   var _cssStyles;
   var _lvText;
   var _parent;
   var _sText;
   var _sURL;
   var _sbVertical;
   var _tText;
   var _target;
   var _tfFormatter;
   var addToQueue;
   var attachMovie;
   var border_mc;
   var createTextField;
   var dispatchEvent;
   var drawBorder;
   var getStyle;
   var parentNode_;
   var setSize;
   static var CLASS_NAME = "TextArea";
   var _bEditable = true;
   var _bSelectable = true;
   var _bAutoHeight = false;
   var _bWordWrap = true;
   var _bScrollBarRight = true;
   var _bHTML = false;
   var _nScrollBarMargin = 0;
   var _nMaxChars = -1;
   var _sRestrict = "none";
   function TextArea()
   {
      super();
   }
   function get tf()
   {
      return this._tText;
   }
   function set restrict(sRestrict)
   {
      this._sRestrict = sRestrict != "none" ? sRestrict : null;
      if(this._tText != undefined)
      {
         this.setRestrict();
      }
   }
   function get restrict()
   {
      return this._tText.restrict;
   }
   function set border(bBorder)
   {
      this._bBorder = bBorder;
      if(this.border_mc == undefined)
      {
         this.drawBorder();
      }
      this.border_mc._visible = bBorder;
   }
   function get border()
   {
      return this._bBorder;
   }
   function set maxChars(nMaxChars)
   {
      this._nMaxChars = nMaxChars != -1 ? nMaxChars : null;
      if(this._tText != undefined)
      {
         this.setMaxChars();
      }
   }
   function get maxChars()
   {
      return this._tText.maxChars;
   }
   function set url(sURL)
   {
      this._sURL = sURL;
      if(this._sURL != "")
      {
         this.loadText();
      }
   }
   function set editable(bEditable)
   {
      this._bEditable = bEditable;
      if(this._bInitialized)
      {
         this.addToQueue({object:this,method:this.setTextFieldProperties});
      }
   }
   function get editable()
   {
      return this._bEditable;
   }
   function set autoHeight(bAutoHeight)
   {
      this._bAutoHeight = bAutoHeight;
      if(this._bInitialized)
      {
         this.addToQueue({object:this,method:this.setTextFieldProperties});
      }
   }
   function get autoHeight()
   {
      return this._bAutoHeight;
   }
   function set selectable(bSelectable)
   {
      this._bSelectable = bSelectable;
      if(this._bInitialized)
      {
         this.addToQueue({object:this,method:this.setTextFieldProperties});
      }
   }
   function get selectable()
   {
      return this._bSelectable;
   }
   function set wordWrap(bWordWrap)
   {
      this._bWordWrap = bWordWrap;
      if(this._bInitialized)
      {
         this.addToQueue({object:this,method:this.setTextFieldProperties});
      }
   }
   function get wordWrap()
   {
      return this._bWordWrap;
   }
   function set html(bHTML)
   {
      this._bHTML = bHTML;
      if(this._bInitialized)
      {
         this.addToQueue({object:this,method:this.setTextFieldProperties});
      }
   }
   function get html()
   {
      return this._bHTML;
   }
   function set text(sText)
   {
      this._sText = sText;
      this._bSettingNewText = true;
      this.addToQueue({object:this,method:this.setTextFieldProperties});
   }
   function get text()
   {
      return this._tText.text;
   }
   function set scrollBarRight(bScrollBarRight)
   {
      this._bScrollBarRight = bScrollBarRight;
   }
   function get scrollBarRight()
   {
      return this._bScrollBarRight;
   }
   function set scrollBarMargin(nScrollBarMargin)
   {
      this._nScrollBarMargin = nScrollBarMargin;
   }
   function get scrollBarMargin()
   {
      return this._nScrollBarMargin;
   }
   function set styleSheet(sCSS)
   {
      if(sCSS != "")
      {
         var _owner = this;
         this._cssStyles = new TextField.StyleSheet();
         this._cssStyles.load(sCSS);
         this._cssStyles.onLoad = function(bSuccess)
         {
            if(_owner._tText != undefined)
            {
               _owner.addToQueue({object:_owner,method:_owner.setTextFieldProperties});
            }
         };
      }
      else
      {
         this._cssStyles = undefined;
         this._tText.styleSheet = null;
      }
   }
   function set scrollPosition(nScrollPosition)
   {
      this._tText.scroll = nScrollPosition;
   }
   function get scrollPosition()
   {
      return this._tText.scroll;
   }
   function set maxscroll(nMaxScroll)
   {
      this._tText.maxscroll = nMaxScroll;
   }
   function get maxscroll()
   {
      return this._tText.maxscroll;
   }
   function get textHeight()
   {
      return this._tText.textHeight;
   }
   function init()
   {
      super.init(false,ank.gapi.controls.TextArea.CLASS_NAME);
      if(this._sURL != undefined)
      {
         this.loadText();
      }
      this._tfFormatter = new TextFormat();
   }
   function setFocus(bSelectAll)
   {
      if(this._tText == undefined)
      {
         this.addToQueue({object:this,method:function()
         {
            Selection.setFocus(this._tText);
         }});
      }
      else
      {
         Selection.setFocus(this._tText);
      }
      if(!bSelectAll)
      {
         Selection.setSelection(this._tText.length,this._tText.length);
      }
   }
   function createChildren()
   {
      this.createTextField("_tText",10,0,0,this.__width - 2,this.__height - 2);
      this._tText._x = 1;
      this._tText._y = 1;
      this._tText.addListener(this);
      this._tText.onSetFocus = function()
      {
         this._parent.onSetFocus();
      };
      this._tText.onKillFocus = function()
      {
         this._parent.onKillFocus();
      };
      ank.utils.MouseEvents.addListener(this);
      this.setRestrict();
      this.setMaxChars();
   }
   function size()
   {
      super.size();
      this.arrange();
   }
   function arrange()
   {
      this._sbVertical.setSize(this.__height);
      this._tText._height = this.__height;
      this._tText._width = this.__width;
   }
   function draw()
   {
      if(this._bBorder)
      {
         this.drawBorder();
      }
      if(!this._bBorder != undefined)
      {
         this.border_mc._visible = this._bBorder;
      }
      var _loc2_ = this.getStyle();
      this._tfFormatter = new TextFormat();
      this._tfFormatter.font = _loc2_.font;
      this._tfFormatter.align = _loc2_.align;
      this._tfFormatter.size = _loc2_.size;
      this._tfFormatter.color = _loc2_.color;
      this._tfFormatter.bold = _loc2_.bold;
      this._tfFormatter.italic = _loc2_.italic;
      this._tText.embedFonts = _loc2_.embedfonts;
      this._tText.antiAliasType = _loc2_.antialiastype;
      this._sbVertical.styleName = _loc2_.scrollbarstyle;
   }
   function loadText()
   {
      if(this._sURL == undefined || this._sURL == "")
      {
         return undefined;
      }
      this._lvText = new LoadVars();
      this._lvText.parentNode_ = this;
      this._lvText.onData = function(sData)
      {
         this.parentNode_.text = sData;
      };
      this._lvText.load(this._sURL);
   }
   function setTextFieldProperties()
   {
      if(this._tText != undefined)
      {
         if(this._bAutoHeight)
         {
            this._tText.autoSize = "left";
         }
         this._tText.wordWrap = !this._bWordWrap ? false : true;
         this._tText.multiline = true;
         this._tText.selectable = this._bSelectable;
         this._tText.type = !this._bEditable ? "dynamic" : "input";
         this._tText.html = this._bHTML;
         if(this._cssStyles != undefined)
         {
            this._tText.styleSheet = this._cssStyles;
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
         }
         else if(this._tfFormatter.font != undefined)
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
         this.onChanged();
      }
   }
   function addScrollBar()
   {
      if(this._sbVertical == undefined)
      {
         this.attachMovie("ScrollBar","_sbVertical",20,{styleName:this.getStyle().scrollbarstyle});
         this._sbVertical.setSize(this.__height - 2);
         this._sbVertical._y = 1;
         this._sbVertical._x = !this._bScrollBarRight ? 0 : this.__width - this._sbVertical._width - 3;
         this._tText._width = this.__width - this._sbVertical._width - 3 - this._nScrollBarMargin;
         this._tText._x = !this._bScrollBarRight ? this._sbVertical._width + this._nScrollBarMargin : 0;
         this._sbVertical.addEventListener("scroll",this);
      }
      var _loc2_ = this._tText.textHeight;
      var _loc3_ = 0.9 * this._tText._height / _loc2_ * this._tText.maxscroll;
      this._sbVertical.setScrollProperties(_loc3_,0,this._tText.maxscroll);
      this._sbVertical.scrollPosition = this._tText.scroll;
      if(this._bSettingNewText)
      {
         this._sbVertical.scrollPosition = 0;
         this._bSettingNewText = false;
      }
   }
   function removeScrollBar()
   {
      if(this._sbVertical != undefined)
      {
         this._sbVertical.removeMovieClip();
         this._tText._width = this.__width;
      }
   }
   function setMaxChars()
   {
      this._tText.maxChars = this._nMaxChars;
   }
   function setRestrict()
   {
      this._tText.restrict = this._sRestrict;
   }
   function onChanged()
   {
      if(this._tText.textHeight >= this._tText._height || this._cssStyles != undefined && this._tText.textHeight + 5 >= this._tText._height)
      {
         this.addScrollBar();
      }
      else
      {
         this.removeScrollBar();
      }
      if(this._bAutoHeight && this._tText.textHeight != this.__height)
      {
         this.setSize(this.__width,this._tText.textHeight);
         this.dispatchEvent({type:"resize"});
      }
      this.dispatchEvent({type:"change",target:this});
   }
   function scroll(oEvent)
   {
      if(oEvent.target == this._sbVertical)
      {
         this._tText.scroll = oEvent.target.scrollPosition;
      }
   }
   function onMouseWheel(nDelta, mc)
   {
      if(dofus.graphics.gapi.ui.Zoom.isZooming())
      {
         return undefined;
      }
      if(String(mc._target).indexOf(this._target) != -1)
      {
         this._sbVertical.scrollPosition -= nDelta;
      }
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
