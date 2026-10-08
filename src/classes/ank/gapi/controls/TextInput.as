class ank.gapi.controls.TextInput extends ank.gapi.controls.Label
{
   var _bEnabled;
   var _oFocusListener;
   var _tText;
   var addToQueue;
   var dispatchEvent;
   static var CLASS_NAME = "TextInput";
   var _sTextfiledType = "input";
   var _sRestrict = "none";
   var _nMaxChars = -1;
   var _sPlaceholder = "";
   var _sRealText = "";
   var _bPlaceholderActive = false;
   function TextInput()
   {
      super();
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
   function get focused()
   {
      return Selection.getFocus() == String(this._tText);
   }
   function set tabIndex(nTabIndex)
   {
      this._tText.tabIndex = nTabIndex;
   }
   function get tabIndex()
   {
      return this._tText.tabIndex;
   }
   function set tabEnabled(bEnabled)
   {
      this._tText.tabEnabled = bEnabled;
   }
   function get tabEnabled()
   {
      return this._tText.tabEnabled;
   }
   function set password(bPassword)
   {
      this._tText.password = bPassword;
   }
   function get password()
   {
      return this._tText.password;
   }
   function set placeholder(sText_)
   {
      if(sText_ == "" || sText_ == undefined)
      {
         this._sPlaceholder = "";
         this.removeFocusEvent();
      }
      else
      {
         this._sPlaceholder = sText_;
         if(this._oFocusListener == undefined)
         {
            this.addFocusEvent();
         }
      }
   }
   function get placeholder()
   {
      return this._sPlaceholder;
   }
   function get placeholderActive()
   {
      return this._bPlaceholderActive;
   }
   function set placeholderActive(bActive)
   {
      this._bPlaceholderActive = bActive;
   }
   function get text()
   {
      return this._sRealText;
   }
   function set text(sText_)
   {
      this._sRealText = sText_;
      this.updateText();
   }
   function setFocus()
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
   }
   function createChildren()
   {
      super.createChildren();
      this.setRestrict();
      this.setMaxChars();
   }
   function clearText()
   {
      this._sRealText = "";
      if(this._sPlaceholder != "")
      {
         this._bPlaceholderActive = true;
      }
      this.updateText();
   }
   function updateText()
   {
      if(this._bPlaceholderActive)
      {
         super.text = this._sPlaceholder;
      }
      else
      {
         super.text = this._sRealText;
      }
   }
   function setEnabled()
   {
      if(this._bEnabled)
      {
         this._tText.type = "input";
      }
      else
      {
         this._tText.type = "dynamic";
      }
   }
   function setRestrict()
   {
      this._tText.restrict = this._sRestrict;
   }
   function setMaxChars()
   {
      this._tText.maxChars = this._nMaxChars;
   }
   function removeFocusEvent()
   {
      if(this._oFocusListener != undefined)
      {
         Selection.removeListener(this._oFocusListener);
      }
      this._oFocusListener = undefined;
   }
   function addFocusEvent()
   {
      var ref = this;
      this._oFocusListener = {};
      this._oFocusListener.onSetFocus = function(oldFocus_txt, newFocus_txt)
      {
         ref.updateFocus();
      };
      Selection.addListener(this._oFocusListener);
      if(this.text == "")
      {
         this.placeholderActive = true;
      }
      this.updateText();
   }
   function updateFocus()
   {
      if(this.focused)
      {
         if(this.placeholderActive)
         {
            this.placeholderActive = false;
         }
      }
      else if(this.text == "")
      {
         this.placeholderActive = true;
      }
      this.updateText();
   }
   function onChanged()
   {
      if(!this._bPlaceholderActive)
      {
         this._sRealText = super.text;
         this.dispatchEvent({type:"change"});
      }
   }
}
