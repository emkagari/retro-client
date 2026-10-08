class dofus.graphics.gapi.controls.ChooseItemSkin extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _cgGrid;
   var _oItem;
   var _oSelectedItem;
   var _parent;
   var addToQueue;
   static var CLASS_NAME = "ChooseItemSkin";
   static var _nOriginalHat = 9234;
   static var _nOriginalCape = 9233;
   static var _nOriginalJewel = 9255;
   static var _nOriginalRing = 9256;
   function ChooseItemSkin()
   {
      super();
   }
   function set item(oItem)
   {
      this._oItem = oItem;
   }
   function get selectedItem()
   {
      return this._oSelectedItem;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.ChooseItemSkin.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function addListeners()
   {
      this._cgGrid.addEventListener("dblClickItem",this._parent);
      this._cgGrid.addEventListener("selectItem",this);
      this._cgGrid.multipleContainerSelectionEnabled = false;
   }
   function initData()
   {
      var _loc2_;
      var _loc3_;
      var _loc4_;
      if(!this._oItem.hasUnknownSkinsCount)
      {
         _loc2_ = this._oItem.maxSkin;
      }
      else
      {
         _loc3_ = this._oItem.realUnicId;
         _loc4_ = _loc3_ != dofus.graphics.gapi.controls.ChooseItemSkin._nOriginalHat && (_loc3_ != dofus.graphics.gapi.controls.ChooseItemSkin._nOriginalCape && (_loc3_ != dofus.graphics.gapi.controls.ChooseItemSkin._nOriginalJewel && _loc3_ != dofus.graphics.gapi.controls.ChooseItemSkin._nOriginalRing));
         _loc2_ = !(_loc4_ && this._oItem.currentLivingXp > 127) ? this._oItem.maxSkin : 10;
      }
      var _loc5_ = new ank.utils.ExtendedArray();
      var _loc6_ = this._oItem.unicID;
      if(this._oItem.isAssociateWithLivingItem)
      {
         _loc6_ = this._oItem.realUnicId;
      }
      if(this._oItem.isEvolving && this._oItem.skinItemInfos != undefined)
      {
         _loc6_ = this._oItem.skinItemUnicID;
      }
      var _loc7_ = 0;
      while(_loc7_ < _loc2_)
      {
         _loc5_.push(new dofus.datacenter.Item(-1,_loc6_,1,0,"",0,_loc7_,1));
         _loc7_ = _loc7_ + 1;
      }
      this._cgGrid.dataProvider = _loc5_;
   }
   function selectItem(oEvent)
   {
      this._oSelectedItem = oEvent.target.contentData;
   }
}
