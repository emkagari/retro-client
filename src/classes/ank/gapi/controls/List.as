class ank.gapi.controls.List extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _bEnabled;
   var _eaDataProvider;
   var _mcContent;
   var _mcMask;
   var _nMaskWidth;
   var _nSelectedIndex;
   var _sbVertical;
   var _target;
   var attachMovie;
   var createEmptyMovieClip;
   var dispatchEvent;
   var drawRoundRect;
   var gapi;
   var getStyle;
   var initialized;
   var styleName;
   static var CLASS_NAME = "List";
   var _aRows = [];
   var _nRowHeight = 20;
   var _bInvalidateLayout = true;
   var _bInvalidateScrollBar = true;
   var _nScrollPosition = 0;
   var _sCellRenderer = "DefaultCellRenderer";
   var _bMultipleSelection = false;
   var _bAutoScroll = false;
   var _bDblClickEnabled = false;
   var _bScrollFromEverywhere = false;
   function List()
   {
      super();
   }
   function get scrollFromEverywhere()
   {
      return this._bScrollFromEverywhere;
   }
   function set scrollFromEverywhere(bScrollFromEverywhere)
   {
      this._bScrollFromEverywhere = bScrollFromEverywhere;
   }
   function set multipleSelection(bMultipleSelection)
   {
      this._bMultipleSelection = bMultipleSelection;
   }
   function get multipleSelection()
   {
      return this._bMultipleSelection;
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
   function set cellRenderer(sCellRenderer)
   {
      if(sCellRenderer != undefined)
      {
         this._sCellRenderer = sCellRenderer;
      }
   }
   function get cellRenderer()
   {
      return this._sCellRenderer;
   }
   function set dataProvider(ea)
   {
      delete this._nSelectedIndex;
      this._eaDataProvider = ea;
      this._eaDataProvider.addEventListener("modelChanged",this);
      var _loc3_ = Math.ceil(this.__height / this._nRowHeight);
      if(ea.length <= _loc3_)
      {
         this.setVPosition(0);
      }
      this.modelChanged();
   }
   function get dataProvider()
   {
      return this._eaDataProvider;
   }
   function set selectedIndex(nIndex)
   {
      var _loc3_ = this._mcContent["row" + nIndex];
      this._nSelectedIndex = nIndex;
      this.layoutSelection(nIndex,_loc3_);
   }
   function get selectedIndex()
   {
      return this._nSelectedIndex;
   }
   function get selectedItem()
   {
      return this._eaDataProvider[this._nSelectedIndex];
   }
   function set autoScroll(bAutoScroll)
   {
      this._bAutoScroll = bAutoScroll;
   }
   function get autoScroll()
   {
      return this._bAutoScroll;
   }
   function set dblClickEnabled(bDblClickEnabled)
   {
      this._bDblClickEnabled = bDblClickEnabled;
   }
   function get dblClickEnabled()
   {
      return this._bDblClickEnabled;
   }
   function get length()
   {
      return this._aRows.length;
   }
   function addItem(oItem)
   {
      if(this._eaDataProvider != undefined)
      {
         this._eaDataProvider.push(oItem);
         return undefined;
      }
      this._aRows.push({item:oItem,selected:false});
      this.setScrollBarProperties(true);
      this.layoutContent();
   }
   function addItemAt(oItem, nIndex)
   {
      if(this._eaDataProvider != undefined)
      {
         this._eaDataProvider.pushAt(oItem,nIndex);
         return undefined;
      }
      this._aRows.splice(nIndex,0,{item:oItem,selected:false});
      this.setScrollBarProperties(true);
      this.layoutContent();
   }
   function removeItemAt(nIndex_)
   {
      if(this._eaDataProvider != undefined)
      {
         this._eaDataProvider.removeItems(nIndex_,1);
         return undefined;
      }
      this._aRows.splice(nIndex_,1);
      this.setScrollBarProperties(true);
      this.layoutContent();
   }
   function removeAll()
   {
      if(this._eaDataProvider != undefined)
      {
         this._eaDataProvider.removeAll();
         return undefined;
      }
      this._aRows = [];
      this.setScrollBarProperties(true);
      this.layoutContent();
   }
   function setVPosition(nPosition, bForced)
   {
      var _loc4_ = this._aRows.length - Math.floor(this.__height / this._nRowHeight);
      if(nPosition > _loc4_)
      {
         nPosition = _loc4_;
      }
      if(nPosition < 0)
      {
         nPosition = 0;
      }
      if(_loc4_ < 0)
      {
         _loc4_ = 0;
      }
      var _loc5_;
      var _loc6_;
      if(this._nScrollPosition != nPosition || bForced)
      {
         this._nScrollPosition = nPosition;
         this.setScrollBarProperties(bForced == true);
         this.layoutContent();
         _loc5_ = this.getRolledOverRows();
         if(_loc5_.length == 1)
         {
            _loc6_ = _loc5_[0];
            this.dispatchEvent({type:"itemRollOver",row:_loc6_,item:_loc6_.item,targets:this.getSelectedItems()});
         }
      }
   }
   function sortOn(sPropName, nOption)
   {
      this._eaDataProvider.sortOn(sPropName,nOption);
      this.modelChanged();
   }
   function init()
   {
      super.init(false,ank.gapi.controls.List.CLASS_NAME);
   }
   function createChildren()
   {
      this.attachMovie("ScrollBar","_sbVertical",10,{styleName:this.styleName});
      this._sbVertical.addEventListener("scroll",this);
      this.createEmptyMovieClip("_mcContent",20);
      this.createEmptyMovieClip("_mcMask",30);
      this.drawRoundRect(this._mcMask,0,0,100,100,0,16711680);
      this._mcContent.setMask(this._mcMask);
      ank.utils.MouseEvents.addListener(this);
   }
   function size()
   {
      super.size();
      this._bInvalidateScrollBar = true;
      this.arrange();
      if(this.initialized)
      {
         this.setVPosition(this._nScrollPosition,true);
      }
   }
   function draw()
   {
      if(this.styleName == "none")
      {
         return undefined;
      }
      var _loc2_ = this.getStyle();
      for(var k in this._mcContent)
      {
         this._mcContent[k].styleName = this.styleName;
      }
      this._sbVertical.styleName = _loc2_.scrollbarstyle;
   }
   function arrange()
   {
      if(this._bInvalidateScrollBar)
      {
         this.setScrollBarProperties(false);
      }
      if(this._sbVertical._visible)
      {
         this._sbVertical.setSize(this.__height);
         this._sbVertical._x = this.__width - this._sbVertical.width;
         this._sbVertical._y = 0;
      }
      this._nMaskWidth = !this._sbVertical._visible ? this.__width : this.__width - this._sbVertical.width;
      this._mcMask._width = this._nMaskWidth;
      this._mcMask._height = this.__height;
      this._bInvalidateLayout = true;
      this.layoutContent();
   }
   function layoutContent()
   {
      var _loc2_ = Math.ceil(this.__height / this._nRowHeight);
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      while(_loc3_ < _loc2_)
      {
         _loc4_ = this._mcContent["row" + _loc3_];
         if(_loc4_ == undefined)
         {
            _loc4_ = ank.gapi.controls.list.SelectableRow(this._mcContent.attachMovie("SelectableRow","row" + _loc3_,_loc3_,{_x:0,_y:_loc3_ * this._nRowHeight,index:_loc3_,styleName:this.styleName,enabled:this._bEnabled,gapi:this.gapi}));
            _loc4_.setCellRenderer(this._sCellRenderer);
            _loc4_.addEventListener("itemSelected",this);
            _loc4_.addEventListener("itemdblClick",this);
            _loc4_.addEventListener("itemRollOver",this);
            _loc4_.addEventListener("itemRollOut",this);
            _loc4_.addEventListener("itemDrag",this);
            _loc4_.addEventListener("itemDrop",this);
         }
         _loc5_ = _loc3_ + this._nScrollPosition;
         if(this._bInvalidateLayout)
         {
            _loc4_.setSize(this._nMaskWidth,this._nRowHeight);
         }
         _loc6_ = this._aRows[_loc5_];
         _loc7_ = _loc6_ == undefined ? undefined : _loc6_.item;
         _loc8_ = _loc7_ != undefined ? (typeof _loc7_ != "string" ? _loc7_.label : _loc7_) : "";
         _loc9_ = !((_loc6_.selected || _loc5_ == this._nSelectedIndex) && _loc7_ != undefined) ? "normal" : "selected";
         _loc4_.setValue(_loc8_,_loc7_,_loc9_);
         _loc4_.itemIndex = _loc5_;
         _loc3_ = _loc3_ + 1;
      }
      this._bInvalidateLayout = false;
   }
   function addScrollBar(bArrange)
   {
      if(!this._sbVertical._visible)
      {
         this._sbVertical._visible = true;
         if(bArrange)
         {
            this.arrange();
         }
      }
   }
   function removeScrollBar(bArrange)
   {
      if(this._sbVertical._visible)
      {
         this._sbVertical._visible = false;
         if(bArrange)
         {
            this.arrange();
         }
      }
   }
   function setScrollBarProperties(bArrange)
   {
      this._bInvalidateScrollBar = false;
      var _loc3_ = Math.floor(this.__height / this._nRowHeight);
      var _loc4_ = this._aRows.length - _loc3_;
      var _loc5_ = _loc3_ * (_loc4_ / this._aRows.length);
      if(_loc3_ >= this._aRows.length || this._aRows.length == 0)
      {
         this.removeScrollBar(bArrange);
      }
      else
      {
         this.addScrollBar(bArrange);
         this._sbVertical.setScrollProperties(_loc5_,0,_loc4_);
         this._sbVertical.scrollPosition = this._nScrollPosition;
      }
   }
   function layoutSelection(nIndex, srRow, bRollOver)
   {
      if(bRollOver == undefined)
      {
         bRollOver = false;
      }
      if(nIndex == undefined)
      {
         nIndex = this._nSelectedIndex;
      }
      var _loc5_ = this._aRows[nIndex];
      var _loc6_ = this._bMultipleSelection && Key.isDown(dofus.Constants.SELECT_MULTIPLE_ITEMS_KEY);
      if(!_loc6_)
      {
         this.unSelectAll();
      }
      if(_loc5_.selected && (_loc6_ && !bRollOver))
      {
         _loc5_.selected = false;
         srRow.setState("normal");
      }
      else if(!_loc5_.selected)
      {
         _loc5_.selected = true;
         srRow.setState("selected");
      }
   }
   function getSelectedItems()
   {
      var _loc2_ = [];
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < this._aRows.length)
      {
         if(this._aRows[_loc3_].selected)
         {
            _loc4_ = this._aRows[_loc3_].item;
            _loc2_.push(_loc4_);
         }
         _loc3_ = _loc3_ + 1;
      }
      _loc2_.reverse();
      return _loc2_;
   }
   function getRolledOverRows()
   {
      var _loc2_ = [];
      var _loc3_ = Math.ceil(this.__height / this._nRowHeight);
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < _loc3_)
      {
         _loc5_ = this._mcContent["row" + _loc4_];
         if(_loc5_ != undefined && _loc5_.isRolledOver)
         {
            _loc2_.push(_loc5_);
         }
         _loc4_ = _loc4_ + 1;
      }
      _loc2_.reverse();
      return _loc2_;
   }
   function unSelectAll()
   {
      var _loc2_ = 0;
      while(_loc2_ < this._aRows.length)
      {
         if(this._aRows[_loc2_].selected)
         {
            this._aRows[_loc2_].selected = false;
            this._mcContent["row" + (_loc2_ - this._nScrollPosition)].setState("normal");
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function refreshRowByIndex(nIndex_)
   {
      var _loc3_ = nIndex_ - this._nScrollPosition;
      var _loc4_ = this._mcContent["row" + _loc3_];
      if(_loc4_ == undefined)
      {
         return undefined;
      }
      var _loc5_ = this._aRows[nIndex_];
      if(_loc5_ == undefined)
      {
         return undefined;
      }
      var _loc6_ = _loc5_.item;
      var _loc7_ = typeof _loc6_ != "string" ? _loc6_.label : _loc6_;
      var _loc8_ = !((_loc5_.selected || nIndex_ == this._nSelectedIndex) && _loc6_ != undefined) ? "normal" : "selected";
      _loc4_.setValue(_loc7_,_loc6_,_loc8_);
   }
   function scrollToIndex(nIndex_)
   {
      var _loc3_ = Math.floor(this.__height / this._nRowHeight);
      if(_loc3_ < 1)
      {
         _loc3_ = 1;
      }
      var _loc4_ = nIndex_ - Math.floor(_loc3_ / 2);
      var _loc5_ = this._eaDataProvider.length - _loc3_;
      if(_loc5_ < 0)
      {
         _loc5_ = 0;
      }
      if(_loc4_ > _loc5_)
      {
         _loc4_ = _loc5_;
      }
      if(_loc4_ < 0)
      {
         _loc4_ = 0;
      }
      this.setVPosition(_loc4_,true);
   }
   function scrollToAndSelectIndex(nIndex_)
   {
      this.selectedIndex = nIndex_;
      this.refreshRowByIndex(nIndex_);
      this.scrollToIndex(nIndex_);
   }
   function modelChanged()
   {
      this.selectedIndex = -1;
      this._aRows = [];
      var _loc2_ = this._eaDataProvider.length;
      var _loc3_ = 0;
      while(_loc3_ < _loc2_)
      {
         this._aRows[_loc3_] = {item:this._eaDataProvider[_loc3_],selected:false};
         _loc3_ = _loc3_ + 1;
      }
      if(this._bAutoScroll)
      {
         this.setVPosition(_loc2_,true);
      }
      else
      {
         this.setScrollBarProperties(true);
         this.layoutContent();
      }
   }
   function scroll(oEvent)
   {
      this.setVPosition(oEvent.target.scrollPosition);
   }
   function itemSelected(oEvent)
   {
      var _loc3_ = oEvent.target.itemIndex;
      var _loc4_ = oEvent.target;
      this._nSelectedIndex = _loc3_;
      this.layoutSelection(_loc3_,_loc4_);
      this.dispatchEvent({type:"itemSelected",row:_loc4_,item:_loc4_.item,targets:this.getSelectedItems()});
   }
   function itemdblClick(oEvent)
   {
      var _loc3_ = oEvent.target.itemIndex;
      var _loc4_ = oEvent.target;
      this._nSelectedIndex = _loc3_;
      this.layoutSelection(_loc3_,_loc4_);
      this.dispatchEvent({type:"itemdblClick",row:oEvent.target,targets:this.getSelectedItems()});
   }
   function itemRollOver(oEvent)
   {
      var _loc3_ = this._bMultipleSelection && (Key.isDown(dofus.Constants.SELECT_MULTIPLE_ITEMS_KEY) && Key.isDown(Key.SHIFT));
      var _loc4_;
      var _loc5_;
      if(_loc3_)
      {
         _loc4_ = oEvent.target.itemIndex;
         _loc5_ = oEvent.target;
         this.layoutSelection(_loc4_,_loc5_,true);
      }
      this.dispatchEvent({type:"itemRollOver",row:oEvent.target,item:this._eaDataProvider[oEvent.target.itemIndex],targets:this.getSelectedItems()});
   }
   function itemRollOut(oEvent)
   {
      this.dispatchEvent({type:"itemRollOut",row:oEvent.target,item:this._eaDataProvider[oEvent.target.itemIndex],targets:this.getSelectedItems()});
   }
   function itemDrag(oEvent)
   {
      this.dispatchEvent({type:"itemDrag",row:oEvent.target});
   }
   function itemDrop(oEvent)
   {
      this.dispatchEvent({type:"itemDrop",row:oEvent.target});
   }
   function onMouseWheel(nDelta, mc)
   {
      if(dofus.graphics.gapi.ui.Zoom.isZooming())
      {
         return undefined;
      }
      if(this._bScrollFromEverywhere || String(mc._target).indexOf(this._target) != -1)
      {
         this.setVPosition(this._nScrollPosition - nDelta);
      }
   }
}
