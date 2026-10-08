536744724 - 1;
class ank.gapi.controls.ComboBox extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _bDisabledStyle;
   var _bEnabled;
   var _btnOpen;
   var _eaDataProvider;
   var _lblCombo;
   var _ldrIcon;
   var _lstCombo;
   var _mcBack;
   var _mcComboBoxPopup;
   var _nListHeight;
   var _nListWidth;
   var _nListX;
   var _nListY;
   var _nOriginalLblX;
   var _nSelectedIndex;
   var _parent;
   var attachMovie;
   var dispatchEvent;
   var drawRoundRect;
   var gapi;
   var getNextHighestDepth;
   var getStyle;
   var initialized;
   var localToGlobal;
   var setMovieClipTransform;
   static var CLASS_NAME = "ComboBox";
   var _bButtonLeft = false;
   var _nRowHeight = 20;
   var _nButtonWidth = 20;
   var _nLabelLeftMargin = 4;
   var _nLabelRightMargin = 4;
   var _nLabelTopMargin = 0;
   var _nLabelBottomMargin = 0;
   var _nListLeftMargin = 4;
   var _nListRightMargin = 4;
   var _nRowCount = 4;
   var _sMcListParent = "uiLayer";
   var _sCellRenderer = "DefaultCellRenderer";
   var _sButtonBackgroundUp = "ButtonComboBoxUp";
   var _sButtonBackgroundDown = "ButtonComboBoxDown";
   var _sButtonIcon = "ComboBoxButtonNormalIcon";
   var _sBackground = "ComboBoxNormal";
   var _nIconOffset = 15;
   function ComboBox()
   {
      super();
   }
   function set cellRenderer(sCellRenderer)
   {
      this._sCellRenderer = sCellRenderer;
   }
   function get cellRenderer()
   {
      return this._sCellRenderer;
   }
   function set isButtonLeft(bButtonLeft)
   {
      this._bButtonLeft = bButtonLeft;
   }
   function get isButtonLeft()
   {
      return this._bButtonLeft;
   }
   function set rowHeight(nRowHeight)
   {
      if(nRowHeight == 0)
      {
         return;
      }
      this._nRowHeight = nRowHeight;
   }
   function get rowHeight()
   {
      return this._nRowHeight;
   }
   function set buttonWidth(nButtonWidth)
   {
      this._nButtonWidth = nButtonWidth;
   }
   function get buttonWidth()
   {
      return this._nButtonWidth;
   }
   function set labelLeftMargin(nLabelLeftMargin)
   {
      this._nLabelLeftMargin = nLabelLeftMargin;
   }
   function get labelLeftMargin()
   {
      return this._nLabelLeftMargin;
   }
   function set labelRightMargin(nLabelRightMargin)
   {
      this._nLabelRightMargin = nLabelRightMargin;
   }
   function get labelRightMargin()
   {
      return this._nLabelRightMargin;
   }
   function set labelTopMargin(nLabelTopMargin)
   {
      this._nLabelTopMargin = nLabelTopMargin;
   }
   function get labelTopMargin()
   {
      return this._nLabelTopMargin;
   }
   function set labelBottomMargin(nLabelBottomMargin)
   {
      this._nLabelBottomMargin = nLabelBottomMargin;
   }
   function get labelBottomMargin()
   {
      return this._nLabelBottomMargin;
   }
   function set listLeftMargin(nListLeftMargin)
   {
      this._nListLeftMargin = nListLeftMargin;
   }
   function get listLeftMargin()
   {
      return this._nListLeftMargin;
   }
   function set listRightMargin(nListRightMargin)
   {
      this._nListRightMargin = nListRightMargin;
   }
   function get listRightMargin()
   {
      return this._nListRightMargin;
   }
   function set rowCount(nRowCount)
   {
      this._nRowCount = nRowCount;
   }
   function get rowCount()
   {
      return this._nRowCount;
   }
   function set mcListParent(sMcListParent)
   {
      this._sMcListParent = sMcListParent;
   }
   function get mcListParent()
   {
      return this._sMcListParent;
   }
   function set background(sBackground)
   {
      this._sBackground = sBackground;
   }
   function get background()
   {
      return this._sBackground;
   }
   function set buttonBackgroundUp(sButtonBackgroundUp)
   {
      this._sButtonBackgroundUp = sButtonBackgroundUp;
   }
   function get backgroundUp()
   {
      return this._sButtonBackgroundUp;
   }
   function set buttonBackgroundDown(sButtonBackgroundDown)
   {
      this._sButtonBackgroundDown = sButtonBackgroundDown;
   }
   function get buttonBackgroundDown()
   {
      return this._sButtonBackgroundDown;
   }
   function set buttonIcon(sButtonIcon)
   {
      this._sButtonIcon = sButtonIcon;
      if(this.initialized)
      {
         this._btnOpen.icon = sButtonIcon;
      }
   }
   function get buttonIcon()
   {
      return this._sButtonIcon;
   }
   function set dataProvider(eaDataProvider)
   {
      this._eaDataProvider = eaDataProvider;
      this._eaDataProvider.addEventListener("modelChanged",this);
      this.modelChanged();
      if(this.initialized)
      {
         this.removeList();
         this.calculateListSize();
      }
   }
   function get dataProvider()
   {
      return this._eaDataProvider;
   }
   function set selectedIndex(nSelectedIndex)
   {
      this._nSelectedIndex = nSelectedIndex;
      if(this.initialized)
      {
         this.removeList();
         this.setLabel(this.selectedItem);
      }
   }
   function get selectedIndex()
   {
      return this._nSelectedIndex;
   }
   function get selectedItem()
   {
      return this._eaDataProvider[this._nSelectedIndex];
   }
   function closeList()
   {
      this.removeList();
   }
   function init()
   {
      super.init(false,ank.gapi.controls.ComboBox.CLASS_NAME);
   }
   function createChildren()
   {
      this.attachMovie(this._sBackground,"_mcBack",this.getNextHighestDepth());
      this._mcBack.onRelease = function()
      {
         this._parent.autoOpenCloseList();
      };
      this._mcBack.useHandCursor = false;
      this.attachMovie("Button","_btnOpen",this.getNextHighestDepth(),{toggle:true,icon:this._sButtonIcon,backgroundUp:this._sButtonBackgroundUp,backgroundDown:this._sButtonBackgroundDown});
      this._btnOpen.addEventListener("click",this);
      this.attachMovie("Label","_lblCombo",this.getNextHighestDepth(),{text:""});
      Key.addListener(this);
   }
   function size()
   {
      super.size();
      this.arrange();
   }
   function arrange()
   {
      var _loc2_ = Math.max(this.__width - this._nButtonWidth - this._nLabelLeftMargin - this._nLabelRightMargin,0);
      var _loc3_ = Math.max(this.__height - this._nLabelTopMargin - this._nLabelBottomMargin,0);
      this._lblCombo.setSize(_loc2_,_loc3_);
      this._btnOpen.setSize(this._nButtonWidth,this.__height);
      this._lblCombo._y = this._nLabelTopMargin;
      if(this._bButtonLeft)
      {
         this._lblCombo._x = this._nButtonWidth + this._nLabelLeftMargin;
      }
      else
      {
         this._lblCombo._x = this._nLabelLeftMargin;
         this._btnOpen._x = this.__width - this._nButtonWidth;
      }
      this._nOriginalLblX = this._lblCombo._x;
      this._mcBack.setSize(this.__width,this.__height,true);
      this.calculateListSize();
   }
   function draw()
   {
      var _loc2_ = this.getStyle();
      this._lblCombo.styleName = _loc2_.labelstyle;
      this._btnOpen.styleName = _loc2_.buttonstyle;
      this._mcBack.setStyleColor(_loc2_,"color");
   }
   function setEnabled()
   {
      this._btnOpen.enabled = this._bEnabled;
      if(!this._bEnabled || this._bDisabledStyle)
      {
         this.setMovieClipTransform(this,this.getStyle().disabledtransform);
      }
      else
      {
         this.setMovieClipTransform(this,{ra:100,rb:0,ga:100,gb:0,ba:100,bb:0,aa:100,ab:0});
      }
   }
   function calculateListSize()
   {
      var _loc2_ = this._eaDataProvider != undefined ? this._eaDataProvider.length : 1;
      var _loc3_ = this._nListLeftMargin;
      var _loc4_ = this.__height;
      this._nListWidth = this.__width - this._nListLeftMargin - this._nListRightMargin - 2;
      this._nListHeight = Math.min(_loc2_,this._nRowCount) * this._nRowHeight + 1;
      var _loc5_ = {x:_loc3_,y:_loc4_};
      this.localToGlobal(_loc5_);
      this._nListX = _loc5_.x;
      this._nListY = _loc5_.y;
   }
   function clearDrawedList()
   {
      this._mcComboBoxPopup.removeMovieClip();
   }
   function drawList()
   {
      this.calculateListSize();
      var _loc2_;
      var _loc3_;
      var _loc4_;
      if(this._sMcListParent == "_parent")
      {
         _loc2_ = this._parent;
      }
      else if(this._sMcListParent == "uiLayer")
      {
         _loc2_ = _global.API.ui;
      }
      else
      {
         _loc3_ = new ank.utils.ExtendedString(String(this._sMcListParent));
         _loc4_ = _loc3_.replace("this",String(this));
         _loc2_ = eval(String(_loc4_));
      }
      if(_loc2_ == undefined)
      {
         _loc2_ = this._parent;
      }
      if(_loc2_._mcComboBoxPopup != undefined)
      {
         _loc2_._mcComboBoxPopup.comboBox.removeList();
      }
      this._mcComboBoxPopup = _loc2_.createEmptyMovieClip("_mcComboBoxPopup",39);
      this._mcComboBoxPopup.gapi = this.gapi;
      this._mcComboBoxPopup.comboBox = this;
      this.drawRoundRect(this._mcComboBoxPopup,this._nListX,this._nListY,this._nListWidth,this._nListHeight,0,this.getStyle().listbordercolor);
      this._mcComboBoxPopup.attachMovie("List","_lstCombo",this._mcComboBoxPopup.getNextHighestDepth(),{styleName:this.getStyle().liststyle,rowHeight:this._nRowHeight,_x:this._nListX + 1,_y:this._nListY,_width:this._nListWidth - 2,_height:this._nListHeight - 1,dataProvider:this._eaDataProvider,selectedIndex:this._nSelectedIndex,cellRenderer:this._sCellRenderer});
      this._lstCombo = this._mcComboBoxPopup._lstCombo;
      this._lstCombo.addEventListener("itemSelected",this);
      this._lstCombo.addEventListener("itemRollOver",this);
      this._lstCombo.addEventListener("itemRollOut",this);
      this._btnOpen.selected = true;
   }
   function removeList()
   {
      this._mcComboBoxPopup.removeMovieClip();
      this._btnOpen.selected = false;
   }
   function autoOpenCloseList()
   {
      if(!this._bEnabled)
      {
         return undefined;
      }
      if(this._btnOpen.selected)
      {
         this.removeList();
      }
      else
      {
         this.drawList();
      }
   }
   function setLabel(oLabel)
   {
      this._lblCombo.text = oLabel.label != undefined ? oLabel.label : "";
      if(oLabel.icon != undefined)
      {
         this._lblCombo._x = this._nOriginalLblX + this._nIconOffset;
         this.attachMovie("GAPILoader","_ldrIcon",100,{_x:3.5,_y:this._lblCombo._y + 2.5,_height:15,_width:15,contentPath:oLabel.icon,scaleContent:true});
      }
      else
      {
         this._lblCombo._x = this._nOriginalLblX;
         this._ldrIcon.removeMovieClip();
      }
   }
   function getSelectedItemText()
   {
      var _loc2_ = this.selectedItem;
      if(typeof _loc2_ == "string")
      {
         return String(_loc2_);
      }
      if(_loc2_.label != undefined)
      {
         return _loc2_.label;
      }
      return "";
   }
   function modelChanged()
   {
      this.setLabel(this.selectedItem);
   }
   function onKeyUp()
   {
      this.removeList();
   }
   function click(oEvent)
   {
      if(this._btnOpen.selected)
      {
         this.drawList();
      }
      else
      {
         this.removeList();
      }
   }
   function itemSelected(oEvent)
   {
      this._nSelectedIndex = this._lstCombo.selectedIndex;
      this.setLabel(this.selectedItem);
      this.removeList();
      this.dispatchEvent({type:"itemSelected",target:this,item:oEvent.item});
   }
   function itemRollOver(oEvent)
   {
      this.dispatchEvent({type:"itemRollOver",owner:this,row:oEvent.row,item:oEvent.item});
   }
   function itemRollOut(oEvent)
   {
      this.dispatchEvent({type:"itemRollOut",owner:this,row:oEvent.row,item:oEvent.item});
   }
}
