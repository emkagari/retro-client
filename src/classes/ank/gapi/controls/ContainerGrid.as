class ank.gapi.controls.ContainerGrid extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _aSelectedIndexes;
   var _bEnabled;
   var _bInitialized;
   var _eaDataProvider;
   var _eaVisibleContainers;
   var _mcMask;
   var _mcScrollContent;
   var _sbVertical;
   var _target;
   var addToQueue;
   var attachMovie;
   var createEmptyMovieClip;
   var dispatchEvent;
   var drawRoundRect;
   var getStyle;
   static var CLASS_NAME = "ContainerGrid";
   var _nVisibleRowCount = 3;
   var _nVisibleColumnCount = 3;
   var _nRowCount = 1;
   var _bInvalidateLayout = false;
   var _bScrollBar = true;
   var _bSelectable = true;
   var _bMultiContainerSelection = true;
   var _nScrollPosition = 0;
   var _nStyleMargin = 0;
   function ContainerGrid()
   {
      super();
   }
   function set multipleContainerSelectionEnabled(bMultiContainerSelection)
   {
      this._bMultiContainerSelection = bMultiContainerSelection;
   }
   function get multipleContainerSelectionEnabled()
   {
      return this._bMultiContainerSelection;
   }
   function set selectable(bSelectable)
   {
      this._bSelectable = bSelectable;
   }
   function get selectable()
   {
      return this._bSelectable;
   }
   function set visibleRowCount(nVisibleRowCount)
   {
      this._nVisibleRowCount = nVisibleRowCount;
   }
   function get visibleRowCount()
   {
      return this._nVisibleRowCount;
   }
   function get visibleContainers()
   {
      return this._eaVisibleContainers;
   }
   function set visibleColumnCount(nVisibleColumnCount)
   {
      this._nVisibleColumnCount = nVisibleColumnCount;
   }
   function get visibleColumnCount()
   {
      return this._nVisibleColumnCount;
   }
   function set dataProvider(eaDataProvider)
   {
      this._eaDataProvider = eaDataProvider;
      this._eaDataProvider.addEventListener("modelChanged",this);
      this.modelChanged();
      var _loc3_ = this.getMaxRow();
      if(this._nScrollPosition > _loc3_)
      {
         this.setVPosition(_loc3_);
      }
   }
   function get dataProvider()
   {
      return this._eaDataProvider;
   }
   function set selectedIndex(nSelectedIndex)
   {
      this.setSelectedItem(nSelectedIndex);
   }
   function get selectedIndex()
   {
      return this._aSelectedIndexes[this._aSelectedIndexes.length - 1].index;
   }
   function get selectedItem()
   {
      return this._mcScrollContent["c" + this.selectedIndex];
   }
   function get selectedContentData()
   {
      return this._aSelectedIndexes[this._aSelectedIndexes.length - 1].item;
   }
   function set scrollBar(bScrollBar)
   {
      this._bScrollBar = bScrollBar;
   }
   function get scrollBar()
   {
      return this._bScrollBar;
   }
   function get lastLoadedContentIndex()
   {
      var _loc2_ = 0;
      var _loc3_ = 0;
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      while(_loc4_ < this._nVisibleRowCount)
      {
         _loc5_ = 0;
         while(_loc5_ < this._nVisibleColumnCount)
         {
            _loc6_ = this._mcScrollContent["c" + _loc2_];
            if(_loc6_.contentLoaded)
            {
               _loc3_ = _loc6_.id;
            }
            _loc2_ = _loc2_ + 1;
            _loc5_ = _loc5_ + 1;
         }
         _loc4_ = _loc4_ + 1;
      }
      return _loc3_;
   }
   function isSelectedIndex(nIndex)
   {
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < this._aSelectedIndexes.length)
      {
         _loc4_ = this._aSelectedIndexes[_loc3_].index;
         if(_loc4_ == nIndex)
         {
            return true;
         }
         _loc3_ = _loc3_ + 1;
      }
      return false;
   }
   function setVPosition(nPosition)
   {
      var _loc3_ = this.getMaxRow();
      if(nPosition > _loc3_)
      {
         nPosition = _loc3_;
      }
      if(nPosition < 0)
      {
         nPosition = 0;
      }
      var _loc4_;
      if(this._nScrollPosition != nPosition)
      {
         this._nScrollPosition = nPosition;
         this.setScrollBarProperties();
         _loc4_ = this.__height / this._nVisibleRowCount;
         this.layoutContent();
      }
   }
   function getContainer(nIndex)
   {
      return ank.gapi.controls.Container(this._mcScrollContent["c" + nIndex]);
   }
   function unSelectAll()
   {
      var _loc2_ = 0;
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      while(_loc3_ < this._nVisibleRowCount)
      {
         _loc4_ = 0;
         while(_loc4_ < this._nVisibleColumnCount)
         {
            _loc5_ = this._mcScrollContent["c" + _loc2_];
            if(_loc5_.selected)
            {
               _loc5_.selected = false;
            }
            _loc2_ = _loc2_ + 1;
            _loc4_ = _loc4_ + 1;
         }
         _loc3_ = _loc3_ + 1;
      }
      this._aSelectedIndexes = [];
   }
   function init()
   {
      super.init(false,ank.gapi.controls.ContainerGrid.CLASS_NAME);
      this._eaVisibleContainers = new ank.utils.ExtendedArray();
   }
   function createChildren()
   {
      this.createEmptyMovieClip("_mcScrollContent",10);
      this.createEmptyMovieClip("_mcMask",20);
      this.drawRoundRect(this._mcMask,0,0,1,1,0,0);
      this._mcScrollContent.setMask(this._mcMask);
      if(this._bScrollBar)
      {
         this.attachMovie("ScrollBar","_sbVertical",30);
         this._sbVertical.addEventListener("scroll",this);
      }
      ank.utils.MouseEvents.addListener(this);
      this._aSelectedIndexes = [];
   }
   function size()
   {
      super.size();
      this.arrange();
   }
   function arrange()
   {
      if(this._bScrollBar)
      {
         this._sbVertical.setSize(this.__height);
         this._sbVertical.move(this.__width - this._sbVertical.width,0);
      }
      this._mcMask._width = this.__width - (!this._bScrollBar ? 0 : this._sbVertical.width);
      this._mcMask._height = this.__height;
      this.setScrollBarProperties();
      this._bInvalidateLayout = this._bInitialized;
      this.layoutContent();
   }
   function layoutContent()
   {
      var _loc2_ = (this.__width - (!this._bScrollBar ? 0 : this._sbVertical.width)) / this._nVisibleColumnCount;
      var _loc3_ = this.__height / this._nVisibleRowCount;
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(!this._bInvalidateLayout)
      {
         _loc5_ = 0;
         while(_loc5_ < this._nVisibleRowCount)
         {
            _loc6_ = 0;
            while(_loc6_ < this._nVisibleColumnCount)
            {
               _loc7_ = this._mcScrollContent["c" + _loc4_];
               if(_loc7_ == undefined)
               {
                  _loc7_ = ank.gapi.controls.Container(this._mcScrollContent.attachMovie("Container","c" + _loc4_,_loc4_,{margin:this._nStyleMargin}));
                  _loc7_.addEventListener("drag",this);
                  _loc7_.addEventListener("drop",this);
                  _loc7_.addEventListener("over",this);
                  _loc7_.addEventListener("out",this);
                  _loc7_.addEventListener("click",this);
                  _loc7_.addEventListener("dblClick",this);
                  this._eaVisibleContainers.push(_loc7_);
               }
               _loc7_._x = _loc2_ * _loc6_;
               _loc7_._y = _loc3_ * _loc5_;
               _loc7_.setSize(_loc2_,_loc3_);
               _loc4_ = _loc4_ + 1;
               _loc6_ = _loc6_ + 1;
            }
            _loc5_ = _loc5_ + 1;
         }
      }
      var _loc8_ = 0;
      _loc4_ = this._nScrollPosition * this._nVisibleColumnCount;
      var _loc9_ = 0;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      while(_loc9_ < this._nVisibleRowCount)
      {
         _loc10_ = 0;
         while(_loc10_ < this._nVisibleColumnCount)
         {
            _loc11_ = this._mcScrollContent["c" + _loc8_];
            _loc12_ = this._eaDataProvider[_loc4_];
            _loc13_ = _loc12_.label;
            _loc14_ = _loc12_.labelStyle;
            _loc15_ = _loc12_.forceReloadOnContainer;
            _loc11_.forceReload = _loc15_ != undefined && _loc15_;
            _loc11_.showLabel = _loc13_ != undefined;
            _loc11_.labelStyle = _loc14_;
            _loc11_.contentData = _loc12_;
            _loc11_.id = _loc4_;
            if(this.isSelectedIndex(_loc4_))
            {
               _loc11_.selected = true;
            }
            else
            {
               _loc11_.selected = false;
            }
            _loc11_.enabled = this._bEnabled;
            _loc4_ = _loc4_ + 1;
            _loc8_ = _loc8_ + 1;
            _loc10_ = _loc10_ + 1;
         }
         _loc9_ = _loc9_ + 1;
      }
      if(this._bInvalidateLayout)
      {
      }
      this._bInvalidateLayout = false;
   }
   function draw()
   {
      this._bInvalidateLayout = !this._bInitialized;
      this.layoutContent();
      var _loc2_ = this.getStyle();
      var _loc3_ = _loc2_.containerbackground;
      var _loc4_ = _loc2_.containerborder;
      var _loc5_ = _loc2_.containerhighlight;
      this._nStyleMargin = _loc2_.containermargin;
      var _loc6_;
      for(var k in this._mcScrollContent)
      {
         _loc6_ = this._mcScrollContent[k];
         _loc6_.backgroundRenderer = _loc3_;
         _loc6_.borderRenderer = _loc4_;
         _loc6_.highlightRenderer = _loc5_;
         _loc6_.margin = this._nStyleMargin;
         _loc6_.styleName = _loc2_.containerstyle;
      }
      if(this._bScrollBar)
      {
         this._sbVertical.styleName = _loc2_.scrollbarstyle;
      }
   }
   function setEnabled()
   {
      for(var k in this._mcScrollContent)
      {
         this._mcScrollContent[k].enabled = this._bEnabled;
      }
      this.addToQueue({object:this,method:function()
      {
         this._sbVertical.enabled = this._bEnabled;
      }});
   }
   function getMaxRow()
   {
      return Math.ceil(this._eaDataProvider.length / this._nVisibleColumnCount) - this._nVisibleRowCount;
   }
   function setScrollBarProperties()
   {
      var _loc2_ = this._nRowCount - this._nVisibleRowCount;
      var _loc3_ = this._nVisibleRowCount * (_loc2_ / this._nRowCount);
      this._sbVertical.setScrollProperties(_loc3_,0,_loc2_);
      this._sbVertical.scrollPosition = this._nScrollPosition;
   }
   function getItemById(nIndex)
   {
      var _loc3_ = 0;
      var _loc4_ = 0;
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      while(_loc5_ < this._nVisibleRowCount)
      {
         _loc6_ = 0;
         while(_loc6_ < this._nVisibleColumnCount)
         {
            _loc7_ = this._mcScrollContent["c" + _loc3_];
            if(nIndex == _loc7_.id)
            {
               return _loc7_;
            }
            _loc3_ = _loc3_ + 1;
            _loc6_ = _loc6_ + 1;
         }
         _loc5_ = _loc5_ + 1;
      }
   }
   function getSelectedItems()
   {
      var _loc2_ = [];
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < this._aSelectedIndexes.length)
      {
         _loc4_ = this._aSelectedIndexes[_loc3_].item;
         _loc2_.push(_loc4_);
         _loc3_ = _loc3_ + 1;
      }
      _loc2_.reverse();
      return _loc2_;
   }
   function selectContainer(oContainer)
   {
      oContainer.selected = true;
      this._aSelectedIndexes.push({index:oContainer.id,item:oContainer.contentData});
   }
   function unSelectContainer(oContainer)
   {
      oContainer.selected = false;
      this.unSelectIndex(oContainer.id);
   }
   function unSelectIndex(nIndexID)
   {
      if(nIndexID == undefined)
      {
         return undefined;
      }
      var _loc3_ = [];
      var _loc4_ = 0;
      while(_loc4_ < this._aSelectedIndexes.length)
      {
         if(nIndexID != this._aSelectedIndexes[_loc4_].index)
         {
            _loc3_.push(this._aSelectedIndexes[_loc4_]);
         }
         _loc4_ = _loc4_ + 1;
      }
      this._aSelectedIndexes = _loc3_;
   }
   function setSelectedItem(nIndex, bRollOver)
   {
      if(bRollOver == undefined)
      {
         bRollOver = false;
      }
      var _loc4_ = 0;
      var _loc5_ = 0;
      var _loc6_ = 0;
      var _loc7_;
      var _loc8_;
      while(_loc6_ < this._nVisibleRowCount)
      {
         _loc7_ = 0;
         while(_loc7_ < this._nVisibleColumnCount)
         {
            _loc8_ = this._mcScrollContent["c" + _loc4_];
            if(nIndex == _loc8_.id)
            {
               nIndex = _loc4_;
               _loc5_ = _loc8_.id;
            }
            _loc4_ = _loc4_ + 1;
            _loc7_ = _loc7_ + 1;
         }
         _loc6_ = _loc6_ + 1;
      }
      var _loc9_ = this.selectedIndex;
      var _loc10_ = this.getItemById(_loc9_);
      var _loc11_ = this._mcScrollContent["c" + nIndex];
      if(this._bMultiContainerSelection)
      {
         if(!Key.isDown(dofus.Constants.SELECT_MULTIPLE_ITEMS_KEY))
         {
            this.unSelectAll();
         }
      }
      else if(_loc10_ == undefined)
      {
         this.unSelectIndex(_loc9_);
      }
      else
      {
         this.unSelectContainer(_loc10_);
      }
      if(_loc11_.contentData == undefined)
      {
         return undefined;
      }
      if(_loc11_.selected)
      {
         if(bRollOver)
         {
            return undefined;
         }
         this.unSelectContainer(_loc11_);
         return undefined;
      }
      this.selectContainer(_loc11_);
   }
   function modelChanged(oEvent)
   {
      this.unSelectAll();
      var _loc3_ = this._nRowCount;
      this._nRowCount = Math.ceil(this._eaDataProvider.length / this._nVisibleColumnCount);
      this._bInvalidateLayout = true;
      this.layoutContent();
      this.draw();
      this.setScrollBarProperties();
   }
   function scroll(oEvent)
   {
      this.setVPosition(oEvent.target.scrollPosition);
      this.dispatchEvent({type:"scrollGrid",target:oEvent.target,owner:this});
   }
   function drag(oEvent)
   {
      this.dispatchEvent({type:"dragItem",target:oEvent.target,owner:this});
   }
   function drop(oEvent)
   {
      this.dispatchEvent({type:"dropItem",target:oEvent.target,owner:this});
   }
   function over(oEvent)
   {
      if(this._bSelectable && (this._bMultiContainerSelection && (Key.isDown(dofus.Constants.SELECT_MULTIPLE_ITEMS_KEY) && Key.isDown(Key.SHIFT))))
      {
         this.setSelectedItem(oEvent.target.id,true);
      }
      this.dispatchEvent({type:"overItem",target:oEvent.target,owner:this});
   }
   function out(oEvent)
   {
      this.dispatchEvent({type:"outItem",target:oEvent.target});
   }
   function click(oEvent)
   {
      if(this._bSelectable)
      {
         this.setSelectedItem(oEvent.target.id);
      }
      this.dispatchEvent({type:"selectItem",target:oEvent.target,owner:this});
   }
   function dblClick(oEvent)
   {
      var _loc3_ = this.getSelectedItems();
      this.dispatchEvent({type:"dblClickItem",target:oEvent.target,targets:_loc3_,owner:this,item:oEvent.target.contentData});
   }
   function onMouseWheel(nDelta, mc)
   {
      if(dofus.graphics.gapi.ui.Zoom.isZooming())
      {
         return undefined;
      }
      if(String(mc._target).indexOf(this._target) != -1)
      {
         this._sbVertical.scrollPosition -= nDelta <= 0 ? -1 : 1;
      }
   }
}
