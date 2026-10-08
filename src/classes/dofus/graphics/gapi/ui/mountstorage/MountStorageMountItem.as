class dofus.graphics.gapi.ui.mountstorage.MountStorageMountItem extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _lbl;
   var _ldrIcon;
   var _ldrNewMount;
   var _mcSexMan;
   var _mcSexWoman;
   var _oItem;
   var addToQueue;
   function MountStorageMountItem()
   {
      super();
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      if(bUsed)
      {
         this._lbl.text = oItem.name;
         this._oItem = dofus.datacenter.Mount(oItem);
         if(this._oItem.newBorn)
         {
            this._ldrNewMount.contentPath = "OeufCasse";
         }
         else
         {
            this._ldrNewMount.contentPath = "";
         }
         this._ldrIcon.contentPath = oItem.iconFile;
         this._mcSexMan._visible = !oItem.sex;
         this._mcSexWoman._visible = !this._mcSexMan._visible;
      }
      else if(this._lbl.text != undefined)
      {
         this._lbl.text = "";
         this._ldrIcon.contentPath = "";
         this._ldrNewMount.contentPath = "";
         this._mcSexMan._visible = false;
         this._mcSexWoman._visible = false;
      }
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.arrange();
   }
   function addListeners()
   {
      this._ldrIcon.addEventListener("complete",this);
   }
   function size()
   {
      super.size();
      this.addToQueue({object:this,method:this.arrange});
   }
   function arrange()
   {
      this._lbl.setSize(this.__width,this.__height);
   }
   function applyRideColor(mc, zone)
   {
      var _loc4_ = this._oItem["color" + zone];
      if(_loc4_ == -1 || _loc4_ == undefined)
      {
         return undefined;
      }
      var _loc5_ = (_loc4_ & 0xFF0000) >> 16;
      var _loc6_ = (_loc4_ & 0xFF00) >> 8;
      var _loc7_ = _loc4_ & 0xFF;
      var _loc8_ = new Color(mc);
      var _loc9_ = {};
      _loc9_ = {ra:0,ga:0,ba:0,rb:_loc5_,gb:_loc6_,bb:_loc7_};
      _loc8_.setTransform(_loc9_);
   }
   function complete(oEvent)
   {
      var ref = this;
      this._ldrIcon.content.applyRideColor = function(mc, zone)
      {
         ref.applyRideColor(mc,zone);
      };
   }
}
