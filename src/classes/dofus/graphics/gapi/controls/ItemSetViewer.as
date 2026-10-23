class dofus.graphics.gapi.controls.ItemSetViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _lblEffects;
   var _lblItems;
   var _lstEffects;
   var _mcParentUI;
   var _oItemSet;
   var _visible;
   var _winBg;
   var addToQueue;
   var dispatchEvent;
   var gapi;
   var initialized;
   static var CLASS_NAME = "ItemSetViewer";
   function ItemSetViewer()
   {
      super();
   }
   function set itemSet(oItemSet)
   {
      this.addToQueue({object:this,method:function(oSet)
      {
         this._oItemSet = oSet;
         if(this.initialized)
         {
            this.updateData();
         }
      },params:[oItemSet]});
   }
   function set currentOverItem(oItem_)
   {
      this._mcParentUI.currentOverItem = oItem_;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.ItemSetViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.updateData});
      this._mcParentUI = this.api.ui.lastOpenedComponent;
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      var _loc2_ = 1;
      var _loc3_;
      while(_loc2_ <= 8)
      {
         _loc3_ = this["_ctr" + _loc2_];
         _loc3_.addEventListener("over",this);
         _loc3_.addEventListener("out",this);
         _loc3_.addEventListener("click",this);
         _loc2_ = _loc2_ + 1;
      }
   }
   function initTexts()
   {
      this._lblEffects.text = this.api.lang.getText("ITEMSET_EFFECTS");
      this._lblItems.text = this.api.lang.getText("ITEMSET_EQUIPED_ITEMS");
   }
   function updateData()
   {
      var _loc2_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      if(this._oItemSet != undefined)
      {
         _loc2_ = this._oItemSet.items;
         this._winBg.title = this._oItemSet.name;
         _loc3_ = this._oItemSet.itemCount != undefined ? this._oItemSet.itemCount : 8;
         _loc4_ = 1;
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = _loc2_[_loc5_];
            _loc7_ = this["_ctr" + _loc4_];
            _loc4_ = _loc4_ + 1;
            _loc7_._visible = true;
            _loc7_.contentData = _loc6_.item;
            _loc7_.borderRenderer = !_loc6_.isEnabled ? "ItemSetViewerItemBorder" : "ItemSetViewerItemBorderNone";
            _loc7_.cornerIcon = !_loc6_.isEquiped ? "" : "Equipped";
            _loc5_ = _loc5_ + 1;
         }
         this._lstEffects.dataProvider = this._oItemSet.effects;
         _loc8_ = _loc3_ + 1;
         while(_loc8_ <= 8)
         {
            _loc9_ = this["_ctr" + _loc8_];
            _loc9_._visible = false;
            _loc8_ = _loc8_ + 1;
         }
         this._visible = true;
      }
      else
      {
         ank.utils.Logger.err("[ItemSetViewer] le set n\'est pas défini");
         this._visible = false;
      }
   }
   function click(oEvent_)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent_.target._name)
      {
         case "_btnClose":
            this.dispatchEvent({type:"close"});
            break;
         case "_ctr1":
         case "_ctr2":
         case "_ctr3":
         case "_ctr4":
         case "_ctr5":
         case "_ctr6":
         case "_ctr7":
         case "_ctr8":
            _loc3_ = oEvent_.target.contentData;
            _loc4_ = 0;
            while(_loc4_ < this._oItemSet.items.length)
            {
               if(this._oItemSet.items[_loc4_].item.unicID == _loc3_.unicID)
               {
                  this._oItemSet.items[_loc4_].isEnabled = !this._oItemSet.items[_loc4_].isEnabled;
               }
               _loc4_ = _loc4_ + 1;
            }
            this._oItemSet.updateEffects();
            this.updateData();
         default:
            return;
      }
   }
   function over(oEvent)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent.target._name)
      {
         case "_ctr1":
         case "_ctr2":
         case "_ctr3":
         case "_ctr4":
         case "_ctr5":
         case "_ctr6":
         case "_ctr7":
         case "_ctr8":
            _loc3_ = oEvent.target.contentData;
            this.currentOverItem = _loc3_;
            _loc4_ = _loc3_.name;
            this.gapi.showTooltip(this.api.lang.getText(oEvent.target.cornerIcon == "" ? "ITEM_NOT_EQUIPPED" : "ITEM_EQUIPPED",[_loc4_]) + "\n\n" + this.api.lang.getText("CLICK_TO_SIMULATE_EQUIP_ITEM"),_loc3_.style + "ToolTip");
         default:
            return;
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
      this.currentOverItem = undefined;
   }
}
