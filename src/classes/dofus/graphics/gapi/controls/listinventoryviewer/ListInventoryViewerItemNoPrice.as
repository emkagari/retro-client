class dofus.graphics.gapi.controls.listinventoryviewer.ListInventoryViewerItemNoPrice extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _ctrIcon;
   var _lblName;
   var _ldrSprite;
   var _oItem;
   var addToQueue;
   function ListInventoryViewerItemNoPrice()
   {
      super();
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      if(bUsed)
      {
         this._oItem = oItem;
         this._lblName.text = !bUsed ? "" : (oItem.Quantity <= 1 ? "" : "x" + oItem.label + " ") + oItem.name;
         if(oItem.isMonsterInBidHouse)
         {
            this.initSprite();
            this._ctrIcon.contentData = undefined;
         }
         else
         {
            this._ctrIcon.contentData = oItem;
            this._ldrSprite.removeSprite();
         }
         this._lblName.styleName = oItem.style != "" ? oItem.style + "LeftSmallLabel" : "BrownLeftSmallLabel";
      }
      else if(this._lblName.text != undefined)
      {
         this._lblName.text = "";
         this._ctrIcon.contentData = undefined;
         this._ldrSprite.removeSprite();
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
      this._lblName.setSize(this.__width - 20,this.__height);
   }
   function initSprite()
   {
      var _loc2_ = new dofus.datacenter.Monster(this._oItem._nMonsterID);
      this._ldrSprite.accessories = _loc2_.accessories;
      this._ldrSprite.colors = [_loc2_.color1,_loc2_.color2,_loc2_.color3];
      this._ldrSprite.gfxID = _loc2_.gfxID;
   }
}
