class dofus.graphics.gapi.controls.encyclopedia.EncyclopediaEquipmentsViewerEquipment extends ank.gapi.core.UIBasicComponent
{
   var _btnViewCraft;
   var _btnViewMonsters;
   var _ctrIcon;
   var _lblCategory;
   var _lblLevel;
   var _lblName;
   var _ldrType;
   var _mcEncyclopedia;
   var _mcIconBackground;
   var _mcList;
   var _oItem;
   var addToQueue;
   var api;
   var _bLabelNameMoved = false;
   var _bLabelCagetoryMoved = false;
   function EncyclopediaEquipmentsViewerEquipment()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem_)
   {
      var _loc5_;
      if(bUsed)
      {
         this._oItem = oItem_;
         this._lblName.text = oItem_.name;
         this._mcIconBackground._visible = true;
         this._ctrIcon.contentPath = dofus.Constants.ITEMS_PATH + oItem_.category + "/" + oItem_.gfxID + ".swf";
         this._ctrIcon._visible = true;
         this._lblCategory.text = oItem_.categoryName + (!dofus.Constants.DEBUG ? "" : " (" + oItem_.category + ")");
         this._lblLevel.text = oItem_.level;
         this._btnViewCraft._visible = oItem_.craftable;
         this._btnViewMonsters._visible = oItem_.droppable;
         _loc5_ = this._lblName.textHeight > 20;
         if(_loc5_ != this._bLabelNameMoved)
         {
            this._lblName._y += !_loc5_ ? 6 : -6;
            this._bLabelNameMoved = _loc5_;
         }
         _loc5_ = this._lblCategory.textHeight > 20;
         if(_loc5_ != this._bLabelCagetoryMoved)
         {
            this._lblCategory._y += !_loc5_ ? 6 : -6;
            this._bLabelCagetoryMoved = _loc5_;
         }
         this.updateItemFromParams();
      }
      else if(this._lblName.text != undefined)
      {
         this._lblName.text = "";
         this._lblCategory.text = "";
         this._lblLevel.text = "";
         this._ldrType.contentPath = "";
         this._ctrIcon._visible = false;
         this._mcIconBackground._visible = false;
         this._btnViewCraft._visible = false;
         this._btnViewMonsters._visible = false;
      }
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.api = _global.API;
      this._mcIconBackground._visible = false;
      this._btnViewCraft._visible = false;
      this._btnViewMonsters._visible = false;
      this._mcEncyclopedia = this.api.ui.getUIComponent("Encyclopedia");
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._ctrIcon.addEventListener("over",this);
      this._ctrIcon.addEventListener("click",this);
      this._ctrIcon.addEventListener("out",this);
      this._ldrType.addEventListener("over",this);
      this._ldrType.addEventListener("out",this);
      this._btnViewCraft.addEventListener("over",this);
      this._btnViewCraft.addEventListener("click",this);
      this._btnViewCraft.addEventListener("out",this);
      this._btnViewMonsters.addEventListener("over",this);
      this._btnViewMonsters.addEventListener("click",this);
      this._btnViewMonsters.addEventListener("out",this);
   }
   function updateItemFromParams()
   {
      var _loc2_ = "Brown";
      var _loc3_;
      for(var k in this._oItem.params.type)
      {
         _loc2_ = k;
         _loc3_ = this._oItem.params.type[k];
         break;
      }
      this._lblName.styleName = _loc2_ + "LeftSmallBoldLabel";
      this._ldrType.contentPath = _loc2_;
      this._ldrType.contentParams = _loc3_;
      this._ctrIcon.cornerIcon = !this._oItem.params.attributes.TwoHanded ? "" : "ItemViewerTwoHand";
   }
   function click(oEvent_)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      switch(oEvent_.target)
      {
         case this._ctrIcon:
            _loc3_ = this._oItem.id;
            _loc4_ = new dofus.datacenter.Item(-1,_loc3_,1,undefined,String(this.api.lang.getItemStats(_loc3_)));
            if(_loc4_ != undefined)
            {
               if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY))
               {
                  this.api.kernel.GameManager.insertItemInChat(_loc4_);
               }
               else
               {
                  this._mcEncyclopedia._mcTabViewer.displayDetails(_loc3_);
               }
            }
            break;
         case this._btnViewCraft:
            _loc5_ = new dofus.datacenter.Item(-1,this._oItem.id);
            this.api.ui.loadUIComponent("ItemUtility","ItemUtility",{item:_loc5_},{bAlwaysOnTop:true});
            break;
         case this._btnViewMonsters:
            _loc6_ = new dofus.datacenter.Item(-1,this._oItem.id);
            _loc7_ = dofus.datacenter.Item.droppedFromMonstersWithEnabledCriterions(_loc6_.unicID);
            this.api.ui.getUIComponent("Encyclopedia").setCurrentTab("Bestiary",_loc7_);
         default:
            return;
      }
   }
   function over(oEvent_)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent_.target)
      {
         case this._ctrIcon:
            _loc3_ = this._oItem.id;
            _loc4_ = new dofus.datacenter.Item(-1,_loc3_,1,undefined,String(this.api.lang.getItemStats(_loc3_)));
            if(_loc4_ != undefined)
            {
               _loc4_.showStatsTooltip(_loc4_.style,!this._oItem.params.attributes.TwoHanded ? undefined : this.api.lang.getText("TWO_HANDS_WEAPON"));
               this._mcEncyclopedia.currentOverItem = _loc4_;
            }
            return;
         case this._ldrType:
            if(this._ldrType.contentParams != undefined)
            {
               this.api.ui.showTooltip(String(this._ldrType.contentParams));
            }
            return;
         case this._btnViewCraft:
            this.api.ui.showTooltip(this.api.lang.getText("ASSOCIATE_RECEIPTS"));
            return;
         case this._btnViewMonsters:
            if(this._oItem.isDroppable)
            {
               this.api.ui.showTooltip(this.api.lang.getText("DISPLAY_MONSTERS_WHO_DROP_ITEM"));
            }
            return;
         default:
            if(dofus.Constants.DEBUG)
            {
               this.api.ui.showTooltip("GFX : " + this._oItem.category + "/" + this._oItem.gfxID);
            }
            return;
      }
   }
   function out(oEvent_)
   {
      this._mcEncyclopedia.currentOverItem = undefined;
      this.api.ui.hideTooltip();
   }
}
