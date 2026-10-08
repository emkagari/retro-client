742114418 - 1;
class ank.gapi.controls.DataGrid extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _aColumnsButtons;
   var _aColumnsButtonsState;
   var _aColumnsNames;
   var _aColumnsProperties;
   var _aColumnsWidths;
   var _lstList;
   var _mcTitle;
   var attachMovie;
   var createEmptyMovieClip;
   var dispatchEvent;
   var drawRoundRect;
   var enabled;
   var getNextHighestDepth;
   var getStyle;
   var initialized;
   static var CLASS_NAME = "DataGrid";
   var _nRowHeight = 20;
   var _nTitleHeight = 20;
   var _sCellRenderer = "DefaultCellRenderer";
   var _bMultipleSelection = false;
   function DataGrid()
   {
      super();
   }
   function set titleHeight(nTitleHeight)
   {
      this._nTitleHeight = nTitleHeight;
   }
   function get titleHeight()
   {
      return this._nTitleHeight;
   }
   function set columnsWidths(aColumnsWidths)
   {
      this._aColumnsWidths = aColumnsWidths;
   }
   function get columnsWidths()
   {
      return this._aColumnsWidths;
   }
   function set columnsNames(aColumnsNames)
   {
      this._aColumnsNames = aColumnsNames;
      this.setLabels();
   }
   function get columnsNames()
   {
      return this._aColumnsNames;
   }
   function set columnsButtonsState(aColumnsButtonsState)
   {
      this._aColumnsButtonsState = aColumnsButtonsState;
      this.updateButtonColumnState();
   }
   function get columnsButtonsState()
   {
      return this._aColumnsButtonsState;
   }
   function set columnsProperties(aColumnsProperties)
   {
      this._aColumnsProperties = aColumnsProperties;
   }
   function get columnsProperties()
   {
      return this._aColumnsProperties;
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
      this._sCellRenderer = sCellRenderer;
   }
   function get cellRenderer()
   {
      return this._sCellRenderer;
   }
   function set dataProvider(eaDataProvider)
   {
      this._lstList.dataProvider = eaDataProvider;
   }
   function get dataProvider()
   {
      return this._lstList.dataProvider;
   }
   function set selectedIndex(nIndex)
   {
      this._lstList.selectedIndex = nIndex;
   }
   function get selectedIndex()
   {
      return this._lstList.selectedIndex;
   }
   function get selectedItem()
   {
      return this._lstList.selectedItem;
   }
   function addItem(oItem)
   {
      this._lstList.addItem(oItem);
   }
   function addItemAt(oItem, nIndex)
   {
      this._lstList.addItemAt(oItem,nIndex);
   }
   function removeItemAt(oItem, nIndex)
   {
      this._lstList.removeItemAt(nIndex);
   }
   function removeAll()
   {
      this._lstList.removeAll();
   }
   function setVPosition(nPosition)
   {
      this._lstList.setVPosition(nPosition);
   }
   function sortOn(sPropName, nOption)
   {
      this._lstList.selectedIndex = -1;
      this._lstList.sortOn(sPropName,nOption);
   }
   function init()
   {
      super.init(false,ank.gapi.controls.DataGrid.CLASS_NAME);
   }
   function createChildren()
   {
      this.attachMovie("List","_lstList",10,{styleName:"none",multipleSelection:this._bMultipleSelection,rowHeight:this._nRowHeight,cellRenderer:this._sCellRenderer,enabled:this.enabled});
      if(this.enabled)
      {
         this._lstList.addEventListener("itemSelected",this);
         this._lstList.addEventListener("itemdblClick",this);
         this._lstList.addEventListener("itemRollOver",this);
         this._lstList.addEventListener("itemRollOut",this);
         this._lstList.addEventListener("itemDrag",this);
      }
      this.createEmptyMovieClip("_mcTitle",20);
   }
   function size()
   {
      super.size();
      this.arrange();
   }
   function arrange()
   {
      this._lstList._y = this._nTitleHeight;
      this._lstList.setSize(this.__width,this.__height - this._nTitleHeight);
      this._mcTitle._width = this.__width;
      this._mcTitle._height = this._nTitleHeight;
      var _loc2_ = 0;
      this._aColumnsButtons = [];
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      while(_loc3_ < this._aColumnsWidths.length)
      {
         _loc4_ = _loc2_ + this._aColumnsWidths[_loc3_] >= this.__width ? this.__width - _loc2_ : this._aColumnsWidths[_loc3_];
         if(this._aColumnsProperties[_loc3_] != undefined)
         {
            this["_btnTitle" + _loc3_].removeMovieClip();
            _loc5_ = ank.gapi.controls.Button(this.attachMovie("Button","_btnTitle" + _loc3_,this.getNextHighestDepth(),{_x:_loc2_,styleName:"none",label:"",backgroundDown:"ButtonTransparentUp",backgroundUp:"ButtonTransparentUp",toggle:true,params:{index:_loc3_}}));
            _loc5_.setSize(_loc4_,this._nTitleHeight);
            _loc5_.addEventListener("click",this);
            _loc5_.addEventListener("over",this);
            _loc5_.addEventListener("out",this);
            this._aColumnsButtons[_loc3_] = _loc5_;
         }
         this["_lblTitle" + _loc3_].removeMovieClip();
         _loc6_ = this.attachMovie("Label","_lblTitle" + _loc3_,this.getNextHighestDepth(),{_x:_loc2_,styleName:this.getStyle().labelstyle,text:this._aColumnsNames[_loc3_]});
         _loc6_.setSize(_loc4_,this._nTitleHeight);
         _loc2_ += _loc4_;
         _loc3_ = _loc3_ + 1;
      }
   }
   function draw()
   {
      var _loc2_ = this.getStyle();
      this._lstList.styleName = _loc2_.liststyle;
      var _loc3_;
      var _loc4_;
      if(this.initialized)
      {
         _loc3_ = this.getStyle().labelstyle;
         _loc4_ = 0;
         while(_loc4_ < this._aColumnsWidths.length)
         {
            this["_lblTitle" + _loc4_].styleName = _loc3_;
            _loc4_ = _loc4_ + 1;
         }
      }
      this.drawRoundRect(this._mcTitle,0,0,1,1,0,_loc2_.titlebgcolor);
      this._mcTitle._alpha = _loc2_.titlebgcolor != -1 ? 100 : 0;
   }
   function setLabels()
   {
      var _loc2_;
      if(this.initialized)
      {
         _loc2_ = 0;
         while(_loc2_ < this._aColumnsWidths.length)
         {
            this["_lblTitle" + _loc2_].text = this._aColumnsNames[_loc2_];
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function updateButtonColumnState()
   {
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < this._aColumnsButtons.length)
      {
         _loc3_ = this._aColumnsButtons[_loc2_];
         if(_loc3_ != undefined)
         {
            _loc3_.enabled = !!this._aColumnsButtonsState[_loc2_];
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function click(oEvent)
   {
      var _loc3_ = oEvent.target.params.index;
      var _loc4_ = this._aColumnsProperties[_loc3_];
      var _loc5_ = !oEvent.target.selected ? Array.CASEINSENSITIVE | Array.DESCENDING : Array.CASEINSENSITIVE;
      if(!_global.isNaN(Number(this._lstList.dataProvider[0][_loc4_])))
      {
         _loc5_ |= Array.NUMERIC;
      }
      this.sortOn(_loc4_,_loc5_);
   }
   function over(oEvent)
   {
      this.dispatchEvent({type:"titleRollOver",target:oEvent.target});
   }
   function out(oEvent)
   {
      this.dispatchEvent({type:"titleRollOut",target:oEvent.target});
   }
   function itemSelected(oEvent)
   {
      oEvent.list = oEvent.target;
      oEvent.target = this;
      this.dispatchEvent(oEvent);
   }
   function itemRollOver(oEvent)
   {
      this.dispatchEvent({type:"itemRollOver",row:oEvent.row,item:oEvent.item,targets:oEvent.targets,owner:this});
   }
   function itemRollOut(oEvent)
   {
      this.dispatchEvent(oEvent);
   }
   function itemDrag(oEvent)
   {
      this.dispatchEvent(oEvent);
   }
   function itemdblClick(oEvent)
   {
      this.dispatchEvent(oEvent);
   }
}
