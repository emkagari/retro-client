class dofus.graphics.gapi.ui.InventorySearch extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aItems;
   var _aTypes;
   var _btnClose;
   var _btnClose2;
   var _btnView;
   var _lblSearch;
   var _lblSearchCount;
   var _lstItems;
   var _nMaxLevel;
   var _oDataProvider;
   var _oParent;
   var _tiSearch;
   var _winBackground;
   var addToQueue;
   var dispatchEvent;
   var gapi;
   var unloadThis;
   static var CLASS_NAME = "InventorySearch";
   static var MIN_SEARCH_CHAR = 2;
   var _sDefaultText = "";
   function InventorySearch()
   {
      super();
   }
   function set types(aTypes)
   {
      this._aTypes = aTypes;
   }
   function set maxLevel(nMaxLevel)
   {
      this._nMaxLevel = nMaxLevel;
   }
   function set defaultSearch(sText)
   {
      this._sDefaultText = sText;
   }
   function set oParent(o)
   {
      this._oParent = o;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.InventorySearch.CLASS_NAME);
   }
   function callClose()
   {
      this.gapi.hideTooltip();
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
      this.generateIndexes();
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnClose2.addEventListener("click",this);
      this._btnView.addEventListener("click",this);
      this._tiSearch.addEventListener("change",this);
      this._lstItems.addEventListener("itemSelected",this);
   }
   function initTexts()
   {
      this._winBackground.title = this.api.lang.getText("BIGSTORE_SEARCH");
      this._lblSearch.text = this.api.lang.getText("INVENTORY_SEARCH_ITEM_NAME",[dofus.graphics.gapi.ui.InventorySearch.MIN_SEARCH_CHAR]);
      this._btnClose2.label = this.api.lang.getText("CLOSE");
      this._btnView.label = this.api.lang.getText("BIGSTORE_SEARCH_VIEW");
      this._tiSearch.text = this._sDefaultText;
      this._tiSearch.setFocus();
   }
   function generateIndexes()
   {
      var _loc2_ = {};
      for(var k in this._aTypes)
      {
         _loc2_[this._aTypes[k]] = true;
      }
      var _loc3_ = this._oDataProvider;
      this._aItems = [];
      var _loc4_;
      for(var k in _loc3_)
      {
         _loc4_ = _loc3_[k];
         this._aItems.push({id:_loc4_.unicID,name:_loc4_.nameUppercase,quantity:_loc4_.Quantity});
      }
   }
   function searchItem(sText)
   {
      var _loc3_ = sText.split(" ");
      var _loc4_ = new ank.utils.ExtendedArray();
      var _loc5_ = {};
      var _loc6_ = 0;
      var _loc7_ = 0;
      var _loc8_;
      var _loc9_;
      while(_loc7_ < this._aItems.length)
      {
         _loc8_ = this._aItems[_loc7_];
         _loc9_ = this.searchWordsInName(_loc3_,_loc8_.name,_loc6_);
         if(_loc9_ != 0)
         {
            _loc5_[_loc8_.id] = {wordCount:_loc9_,quantity:_loc8_.quantity};
            _loc6_ = _loc9_;
         }
         _loc7_ = _loc7_ + 1;
      }
      for(var k in _loc5_)
      {
         if(_loc5_[k].wordCount >= _loc6_)
         {
            _loc4_.push(new dofus.datacenter.Item(0,Number(k),_loc5_[k].quantity));
         }
      }
      this._lstItems.dataProvider = _loc4_;
      this._lblSearchCount.text = _loc4_.length != 0 ? _loc4_.length + " " + ank.utils.PatternDecoder.combine(this.api.lang.getText("OBJECTS"),"m",_loc4_ < 2) : this.api.lang.getText("NO_INVENTORY_SEARCH_RESULT");
      this._btnView.enabled = false;
   }
   function searchWordsInName(aWords, sName, nMaxWordsCount)
   {
      var _loc5_ = 0;
      var _loc6_ = aWords.length;
      var _loc7_;
      while(_loc6_ >= 0)
      {
         _loc7_ = aWords[_loc6_];
         if(sName.indexOf(_loc7_) != -1)
         {
            _loc5_ = _loc5_ + 1;
         }
         else if(_loc5_ + _loc6_ < nMaxWordsCount)
         {
            return 0;
         }
         _loc6_ = _loc6_ - 1;
      }
      return _loc5_;
   }
   function click(oEvent)
   {
      var _loc3_;
      switch(oEvent.target._name)
      {
         case "_btnClose":
         case "_btnClose2":
            this.callClose();
            break;
         case "_btnView":
            _loc3_ = this._lstItems.selectedItem;
            this.dispatchEvent({type:"select",value:_loc3_.unicID});
            this.callClose();
         default:
            return;
      }
   }
   function change(oEvent)
   {
      var _loc3_ = new ank.utils.ExtendedString(this._tiSearch.text).trim().removeAccents();
      if(_loc3_.length >= dofus.graphics.gapi.ui.InventorySearch.MIN_SEARCH_CHAR)
      {
         this.searchItem(_loc3_.toUpperCase());
      }
      else
      {
         this._lstItems.dataProvider = new ank.utils.ExtendedArray();
         if(this._lblSearchCount.text != undefined)
         {
            this._lblSearchCount.text = "";
         }
      }
      this._oParent.defaultSearch = this._tiSearch.text;
   }
   function itemSelected(oEvent)
   {
      this._btnView.enabled = true;
   }
}
