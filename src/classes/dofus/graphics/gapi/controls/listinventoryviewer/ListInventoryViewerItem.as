class dofus.graphics.gapi.controls.listinventoryviewer.ListInventoryViewerItem extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _ctrIcon;
   var _lblName;
   var _lblPrice;
   var _mcList;
   var addToQueue;
   function ListInventoryViewerItem()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      var _loc5_;
      if(bUsed)
      {
         this._lblPrice.text = !bUsed ? "" : new ank.utils.ExtendedString(oItem.price).addMiddleChar(this._mcList.gapi.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
         _loc5_ = this._lblPrice.textWidth;
         this._lblName.text = !bUsed ? "" : (oItem.Quantity <= 1 ? "" : "x" + oItem.label + " ") + oItem.name;
         this._lblName.setSize(this.__width - _loc5_ - 30,this.__height);
         this._lblName.styleName = oItem.style != "" ? oItem.style + "LeftSmallLabel" : "BrownLeftSmallLabel";
         this._ctrIcon.contentData = oItem;
      }
      else if(this._lblPrice.text != undefined)
      {
         this._lblPrice.text = "";
         this._lblName.text = "";
         this._ctrIcon.contentData = undefined;
      }
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.arrange();
   }
   function size()
   {
      super.size();
      this.addToQueue({object:this,method:this.arrange});
   }
   function arrange()
   {
      this._lblName.setSize(this.__width - this._lblPrice.textWidth - 30,this.__height);
      this._lblPrice.setSize(this.__width - 20,this.__height);
   }
}
