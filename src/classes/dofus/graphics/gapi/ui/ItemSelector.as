class dofus.graphics.gapi.ui.ItemSelector extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aTypes;
   var _btnCancel;
   var _btnClose;
   var _btnSelect;
   var _cbType;
   var _eaItems;
   var _eaItemsOriginal;
   var _itvItemViewer;
   var _lblNumber;
   var _lblQuantity;
   var _lblSearch;
   var _lblType;
   var _lst;
   var _tiSearch;
   var _txtQuantity;
   var _winBg;
   var _winItemViewer;
   var addToQueue;
   var dispatchEvent;
   var unloadThis;
   static var CLASS_NAME = "ItemSelector";
   function ItemSelector()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.ItemSelector.CLASS_NAME);
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.hideItemViewer(true);
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function initTexts()
   {
      this._winBg.title = "Liste des objets";
      this._lblSearch.text = this.api.lang.getText("BIGSTORE_SEARCH_ITEM_NAME");
      this._lblType.text = this.api.lang.getText("TYPE");
      this._lblQuantity.text = this.api.lang.getText("QUANTITY");
      this._btnCancel.label = this.api.lang.getText("CANCEL_SMALL");
      this._btnSelect.label = this.api.lang.getText("SELECT");
      this._tiSearch.setFocus();
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnCancel.addEventListener("click",this);
      this._btnSelect.addEventListener("click",this);
      this._tiSearch.addEventListener("change",this);
      this._cbType.addEventListener("itemSelected",this);
      this._lst.addEventListener("itemSelected",this);
      this._lst.dblClickEnabled = true;
      this._lst.addEventListener("itemdblClick",this);
   }
   function initData()
   {
      this._eaItems = new ank.utils.ExtendedArray();
      this._txtQuantity.restrict = "0-9";
      this._txtQuantity.text = "1";
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = this.api.lang.getAllItemTypes();
      for(var a in _loc3_)
      {
         _loc2_.push({label:_loc3_[a].n,id:a});
      }
      _loc2_.sortOn("label");
      _loc2_.splice(0,0,{label:"All (recherche uniquement)",id:0});
      this._cbType.dataProvider = _loc2_;
      this._aTypes = [];
      var _loc4_ = 0;
      while(_loc4_ < this._cbType.dataProvider.length)
      {
         this._aTypes.push(this._cbType.dataProvider[_loc4_].id);
         _loc4_ = _loc4_ + 1;
      }
      this._cbType.selectedIndex = 0;
      this.generateIndexes();
      this.change();
   }
   function hideItemViewer(bHide)
   {
      this._winItemViewer._visible = !bHide;
      this._itvItemViewer._visible = !bHide;
   }
   function generateIndexes()
   {
      var _loc2_ = {};
      for(var k in this._aTypes)
      {
         _loc2_[this._aTypes[k]] = true;
      }
      var _loc3_ = this.api.lang.getItemUnics();
      this._eaItems = new ank.utils.ExtendedArray();
      this._eaItemsOriginal = new ank.utils.ExtendedArray();
      var _loc4_;
      for(var k in _loc3_)
      {
         _loc4_ = _loc3_[k];
         if(!(_loc4_.ep != undefined && _loc4_.ep > this.api.datacenter.Basics.aks_current_regional_version))
         {
            if(!_loc4_.et)
            {
               if(_loc2_[_loc4_.t])
               {
                  this._eaItems.push({id:k,name:_loc4_.nn});
                  if(this._cbType.selectedIndex != 0)
                  {
                     this._eaItemsOriginal.push(new dofus.datacenter.Item(0,Number(k)));
                  }
               }
            }
         }
      }
      this._lblNumber.text = this._eaItemsOriginal.length + " " + ank.utils.PatternDecoder.combine(this.api.lang.getText("OBJECTS"),"m",this._eaItemsOriginal.length < 2);
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
      while(_loc7_ < this._eaItems.length)
      {
         _loc8_ = this._eaItems[_loc7_];
         _loc9_ = this.searchWordsInName(_loc3_,_loc8_.name,_loc6_);
         if(_loc9_ != 0)
         {
            _loc5_[_loc8_.id] = _loc9_;
            _loc6_ = _loc9_;
         }
         _loc7_ = _loc7_ + 1;
      }
      for(var k in _loc5_)
      {
         if(_loc5_[k] >= _loc6_)
         {
            _loc4_.push(new dofus.datacenter.Item(0,Number(k)));
         }
      }
      this._lst.dataProvider = _loc4_;
      this._lblNumber.text = _loc4_.length + " " + ank.utils.PatternDecoder.combine(this.api.lang.getText("OBJECTS"),"m",_loc4_.length < 2);
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
      switch(oEvent.target._name)
      {
         case "_btnClose":
         case "_btnCancel":
            this.dispatchEvent({type:"cancel"});
            this.callClose();
            break;
         case "_btnSelect":
            break;
         default:
            return;
      }
      if(this._lst.selectedItem == undefined)
      {
         return undefined;
      }
      this.dispatchEvent({type:"select",ui:"ItemSelector",itemId:this._lst.selectedItem.unicID,itemQuantity:this._txtQuantity.text});
   }
   function change(oEvent)
   {
      if(this._tiSearch.text.length >= 2)
      {
         this.searchItem(new ank.utils.ExtendedString(this._tiSearch.text).removeAccents().toUpperCase());
      }
      else if(this._lst.dataProvider != this._eaItemsOriginal)
      {
         this._lst.dataProvider = this._eaItemsOriginal;
         this._lblNumber.text = this._eaItemsOriginal.length + " " + ank.utils.PatternDecoder.combine(this.api.lang.getText("OBJECTS"),"m",this._eaItemsOriginal.length < 2);
      }
   }
   function itemdblClick(oEvent_)
   {
      var _loc0_;
      if((_loc0_ = oEvent_.target) === this._lst)
      {
         if(this._lst.selectedItem != undefined)
         {
            this.dispatchEvent({type:"select",ui:"ItemSelector",itemId:this._lst.selectedItem.unicID,itemQuantity:this._txtQuantity.text});
         }
      }
   }
   function itemSelected(oEvent)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent.target)
      {
         case this._cbType:
            this._aTypes = [];
            if(this._cbType.selectedItem.id != 0)
            {
               this._aTypes.push(this._cbType.selectedItem.id);
            }
            else
            {
               _loc3_ = 0;
               while(_loc3_ < this._cbType.dataProvider.length)
               {
                  if(this._cbType.dataProvider[_loc3_].id != 0)
                  {
                     this._aTypes.push(this._cbType.dataProvider[_loc3_].id);
                  }
                  _loc3_ = _loc3_ + 1;
               }
            }
            this.generateIndexes();
            this.change();
            break;
         case this._lst:
            _loc4_ = this._lst.selectedItem;
            if(_loc4_ == undefined)
            {
               this.hideItemViewer(true);
            }
            else
            {
               if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY))
               {
                  this.api.kernel.GameManager.insertItemInChat(_loc4_);
                  return undefined;
               }
               this.hideItemViewer(false);
               this._itvItemViewer.itemData = _loc4_;
            }
         default:
            return;
      }
   }
}
