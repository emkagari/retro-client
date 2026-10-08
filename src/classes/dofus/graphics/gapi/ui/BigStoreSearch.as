class dofus.graphics.gapi.ui.BigStoreSearch extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aItems;
   var _aTypes;
   var _bIsMonster;
   var _btnClose;
   var _btnClose2;
   var _btnView;
   var _lblSearch;
   var _lblSearchCount;
   var _lstItems;
   var _nMaxLevel;
   var _oParent;
   var _tiSearch;
   var _winBackground;
   var addToQueue;
   var gapi;
   var unloadThis;
   static var CLASS_NAME = "BigStoreSearch";
   var _sDefaultText = "";
   function BigStoreSearch()
   {
      super();
   }
   function set isMonster(bIsMonster)
   {
      this._bIsMonster = bIsMonster;
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
      super.init(false,dofus.graphics.gapi.ui.BigStoreSearch.CLASS_NAME);
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
      this._lstItems.addEventListener("itemdblClick",this);
   }
   function initTexts()
   {
      this._winBackground.title = this.api.lang.getText("BIGSTORE_SEARCH");
      if(this._bIsMonster)
      {
         this._lblSearch.text = this.api.lang.getText("BIGSTORE_SEARCH_MONSTER_NAME");
      }
      else
      {
         this._lblSearch.text = this.api.lang.getText("BIGSTORE_SEARCH_ITEM_NAME");
      }
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
      this._aItems = [];
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if(this._bIsMonster)
      {
         _loc3_ = this.api.lang.getMonsters();
         for(var k in _loc3_)
         {
            _loc4_ = _loc3_[k];
            if(_loc4_.s == true)
            {
               if(_loc4_.n)
               {
                  this._aItems.push({id:k,name:_loc4_.nn});
               }
            }
         }
      }
      else
      {
         _loc5_ = this.api.lang.getItemUnics();
         for(var k in _loc5_)
         {
            _loc6_ = _loc5_[k];
            if(!(_loc6_.ep == undefined || _loc6_.ep > this.api.datacenter.Basics.aks_current_regional_version))
            {
               if(_loc2_[_loc6_.t] && (_loc6_.h != true && _loc6_.l <= this._nMaxLevel))
               {
                  if(dofus.datacenter.Item.isFullSoul(_loc6_.t))
                  {
                     continue;
                  }
                  this._aItems.push({id:k,name:_loc6_.nn});
               }
            }
         }
      }
   }
   function searchItem(sText)
   {
      var _loc3_ = sText.split(" ");
      var _loc4_ = new ank.utils.ExtendedArray();
      var _loc5_ = {};
      var _loc6_ = 0;
      var _loc7_;
      var _loc8_;
      while(_loc6_ < this._aItems.length)
      {
         _loc7_ = this._aItems[_loc6_];
         _loc8_ = this.searchWordsInName(_loc3_,_loc7_.name);
         if(_loc8_)
         {
            _loc5_[_loc7_.id] = true;
         }
         _loc6_ += 1;
      }
      for(var k in _loc5_)
      {
         if(_loc5_[k] == true)
         {
            if(this._bIsMonster)
            {
               _loc4_.push(new dofus.datacenter.MonsterInBidHouse(Number(k)));
            }
            else
            {
               _loc4_.push(new dofus.datacenter.Item(0,Number(k)));
            }
         }
      }
      this._lstItems.dataProvider = _loc4_;
      this._lblSearchCount.text = _loc4_.length == 0 ? this.api.lang.getText("NO_BIGSTORE_SEARCH_RESULT") : _loc4_.length + " " + ank.utils.PatternDecoder.combine(this.api.lang.getText(!this._bIsMonster ? "OBJECTS" : "MONSTER"),"m",_loc4_ < 2);
      this._btnView.enabled = false;
   }
   function searchWordsInName(aWords, sName)
   {
      var _loc4_ = aWords.length - 1;
      var _loc5_;
      var _loc6_;
      while(_loc4_ >= 0)
      {
         _loc5_ = aWords[_loc4_];
         _loc6_ = sName.indexOf(_loc5_);
         if(_loc6_ == -1)
         {
            return false;
         }
         sName = sName.substr(0,_loc6_) + sName.substr(_loc6_ + _loc5_.length);
         _loc4_ -= 1;
      }
      return true;
   }
   function click(oEvent)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent.target)
      {
         case this._btnClose:
         case this._btnClose2:
            this.callClose();
            break;
         case this._btnView:
            _loc3_ = this._lstItems.selectedItem;
            this.api.network.Exchange.bigStoreSearch(_loc3_.type == undefined ? -1 : _loc3_.type,_loc3_.unicID);
            _loc4_ = this.api.ui.getUIComponent("BigStoreBuy").isFullSoul;
            if(!_loc4_)
            {
               this.api.ui.getUIComponent("BigStoreBuy").currentItemSearched = _loc3_;
               this.api.network.Exchange.getItemMiddlePriceInBigStore(_loc3_.unicID);
            }
         default:
            return;
      }
   }
   function change(oEvent)
   {
      var _loc3_ = new ank.utils.ExtendedString(this._tiSearch.text).trim().removeAccents();
      if(_loc3_.length >= 2)
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
   function itemdblClick(oEvent_)
   {
      this.click({target:this._btnView});
   }
}
