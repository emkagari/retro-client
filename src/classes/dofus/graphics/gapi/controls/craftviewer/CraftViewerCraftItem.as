class dofus.graphics.gapi.controls.craftviewer.CraftViewerCraftItem extends ank.gapi.core.UIBasicComponent
{
   var _ctrItemIcon;
   var _lblItemName;
   var _lblSkill;
   var _mcList;
   var _mcTooltip;
   var _oItem;
   var _parent;
   var addToQueue;
   function CraftViewerCraftItem()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      this._oItem = oItem;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      if(bUsed)
      {
         this._ctrItemIcon.contentData = oItem.craftItem;
         this._ctrItemIcon._visible = true;
         this._lblItemName.text = oItem.craftItem.name + " (" + this._mcList._parent.api.lang.getText("LEVEL_SMALL") + " " + oItem.craftItem.level + ")";
         switch(oItem.difficultyValue)
         {
            case 1:
               this._lblItemName.styleName = "DarkGrayLeftSmallLabel";
               break;
            case 2:
               this._lblItemName.styleName = "GreenLeftSmallBoldLabel";
               break;
            case 3:
               this._lblItemName.styleName = "RedLeftSmallBoldLabel";
         }
         this._mcTooltip.onRollOver = function()
         {
            this._parent.onTooltipRollOver();
         };
         this._mcTooltip.onRollOut = function()
         {
            this._parent.onTooltipRollOut();
         };
         this._mcTooltip.onRelease = function()
         {
            this._parent.click({target:{_name:"_lblItemIcon"}});
         };
         this._mcTooltip._visible = true;
         if(oItem.skill != undefined)
         {
            this._lblSkill.text = "(" + oItem.skill.description + " " + this._mcList._parent.api.lang.getText("ON") + " " + oItem.skill.interactiveObject + ")";
         }
         _loc5_ = oItem.items;
         _loc6_ = _loc5_.length;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc5_[_loc7_];
            _loc9_ = this["_ctr" + _loc7_];
            _loc9_._visible = true;
            _loc9_.contentData = _loc8_;
            this["_lblPlus" + _loc7_]._visible = true;
            _loc7_ = _loc7_ + 1;
         }
         _loc10_ = _loc6_;
         while(_loc10_ < 8)
         {
            this["_ctr" + _loc10_]._visible = false;
            this["_lblPlus" + _loc10_]._visible = false;
            _loc10_ = _loc10_ + 1;
         }
      }
      else if(this._lblItemName.text != undefined)
      {
         this._ctrItemIcon.contentData = "";
         this._ctrItemIcon._visible = false;
         this._lblItemName.text = "";
         this._lblSkill.text = "";
         this._mcTooltip._visible = false;
         _loc11_ = 0;
         while(_loc11_ < 8)
         {
            this["_ctr" + _loc11_]._visible = false;
            this["_lblPlus" + _loc11_]._visible = false;
            _loc11_ = _loc11_ + 1;
         }
      }
   }
   function init()
   {
      super.init(false);
      this._ctrItemIcon._visible = false;
      var _loc3_ = 0;
      while(_loc3_ < 8)
      {
         this["_ctr" + _loc3_]._visible = this["_lblPlus" + _loc3_]._visible = false;
         _loc3_ = _loc3_ + 1;
      }
      this.addToQueue({object:this,method:this.addListeners});
   }
   function size()
   {
      super.size();
   }
   function addListeners()
   {
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < 8)
      {
         _loc3_ = this["_ctr" + _loc2_];
         _loc3_.addEventListener("over",this);
         _loc3_.addEventListener("out",this);
         _loc3_.addEventListener("click",this);
         _loc2_ = _loc2_ + 1;
      }
      this._ctrItemIcon.addEventListener("click",this);
      this._ctrItemIcon.addEventListener("over",this);
      this._ctrItemIcon.addEventListener("out",this);
   }
   function setContainerContentData(nIndex, oItem)
   {
      var _loc4_ = this["_ctr" + nIndex];
      _loc4_.contentData = oItem;
   }
   function click(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      switch(oEvent.target._name)
      {
         case "_ctrItemIcon":
         case "_lblItemIcon":
            if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY) && this._oItem != undefined)
            {
               this._mcList._parent.gapi.api.kernel.GameManager.insertItemInChat(this._oItem.craftItem,"","=");
               _loc3_ = 0;
               while(_loc3_ < this._oItem.items.length)
               {
                  _loc4_ = this._oItem.items[_loc3_];
                  this._mcList._parent.gapi.api.kernel.GameManager.insertItemInChat(_loc4_,_loc4_.Quantity + "x",_loc3_ >= this._oItem.items.length - 1 ? "" : "+");
                  _loc3_ = _loc3_ + 1;
               }
            }
            else
            {
               this._mcList._parent.craftItem(this._ctrItemIcon.contentData);
            }
            return;
         default:
            _loc5_ = oEvent.target.contentData;
            if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY) && _loc5_ != undefined)
            {
               this._mcList._parent.gapi.api.kernel.GameManager.insertItemInChat(_loc5_);
            }
            else
            {
               this._mcList._parent.craftItem(_loc5_);
            }
            return;
      }
   }
   function onTooltipRollOver()
   {
      var _loc2_;
      switch(this._oItem.difficultyValue)
      {
         case 1:
            _loc2_ = this._mcList._parent.gapi.api.lang.getText("CRAFT_DIFFICULTY1");
            break;
         case 2:
            _loc2_ = this._mcList._parent.gapi.api.lang.getText("CRAFT_DIFFICULTY2");
            break;
         case 3:
            _loc2_ = this._mcList._parent.gapi.api.lang.getText("CRAFT_DIFFICULTY3");
      }
      if(_loc2_ != undefined)
      {
         this._mcList._parent.gapi.showTooltip(_loc2_);
      }
   }
   function onTooltipRollOut()
   {
      this._mcList._parent.gapi.hideTooltip();
   }
   function over(oEvent)
   {
      var _loc0_;
      var _temp_1 = _loc0_ = oEvent.target;
      var _loc3_ = oEvent.target.contentData;
      this._mcList._parent.gapi.showTooltip("x" + _loc3_.Quantity + " - " + _loc3_.name);
      this._mcList._parent.currentOverItem = _loc3_;
      _temp_1;
   }
   function out(oEvent)
   {
      this._mcList._parent.gapi.hideTooltip();
      this._mcList._parent.currentOverItem = undefined;
   }
}
