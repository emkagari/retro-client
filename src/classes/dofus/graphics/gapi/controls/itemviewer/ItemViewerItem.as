class dofus.graphics.gapi.controls.itemviewer.ItemViewerItem extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _btn;
   var _lbl;
   var _ldr;
   var _mcList;
   var _oItem;
   var addToQueue;
   function ItemViewerItem()
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
      if(bUsed)
      {
         this.showButton(false);
         this.showLoader(false);
         if(oItem instanceof dofus.datacenter.Effect)
         {
            this._lbl.text = oItem.description;
            switch(oItem.operator)
            {
               case "+":
                  this._lbl.styleName = !this._oItem.isOver ? "GreenLeftSmallLabel" : "GreenLeftSmallBoldLabel";
                  break;
               case "-":
                  this._lbl.styleName = !this._oItem.isOver ? "RedLeftSmallLabel" : "RedLeftSmallBoldLabel";
                  break;
               default:
                  this._lbl.styleName = "BrownLeftSmallLabel";
            }
            if(this._oItem.isExo)
            {
               this._lbl.styleName = "BlueLeftSmallLabel";
            }
            switch(oItem.type)
            {
               case 995:
                  this.showButton(true,"ItemViewerUseHand");
                  this._btn.addEventListener("click",this);
                  break;
               case 604:
               case 722:
               case 2172:
               case 2173:
                  this.showButton(true,"ItemViewerSpell");
                  this._btn.addEventListener("click",this);
                  break;
               case 2165:
               case 2166:
                  oItem.characteristic = oItem.param1;
                  break;
               default:
                  this.showButton(false,"");
                  this._btn.removeEventListener();
            }
            if(oItem.element != undefined)
            {
               this.showLoader(true,dofus.datacenter.Effect.getIconNameFromID(oItem.element));
            }
            else if(oItem.characteristic != undefined)
            {
               this.showLoader(true,dofus.datacenter.Effect.getIconNameFromID(oItem.characteristic));
            }
         }
         else
         {
            this._lbl.text = sSuggested;
            this._lbl.styleName = "BrownLeftSmallLabel";
         }
      }
      else if(this._lbl.text != undefined)
      {
         this.showButton(false,"");
         this._btn.removeEventListener();
         this._lbl.text = "";
         this.showLoader(false,"");
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
      this._lbl.setSize(this.__width - (!this._ldr.loaded ? 0 : 17),this.__height);
   }
   function showButton(bShow, sIcon)
   {
      this._btn._visible = bShow;
      this._btn.icon = sIcon;
      this.moveLabel(!bShow ? 0 : 20);
      if(bShow == false)
      {
         this._btn.removeEventListener("click",this);
      }
   }
   function showLoader(bShow, sIcon)
   {
      this._ldr._visible = bShow;
      this._ldr.contentPath = sIcon;
      this._ldr._x = this.__width - 17;
      this._lbl.setSize(this.__width - (!bShow ? 0 : 17));
   }
   function moveLabel(x)
   {
      this._lbl._x = x;
   }
   function click()
   {
      var _loc2_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      switch(this._oItem.type)
      {
         case 995:
            this._mcList.gapi.api.network.Mount.data(this._oItem.param1,this._oItem.param2);
            break;
         case 604:
         case 722:
            _loc2_ = this._mcList.gapi.api.datacenter.Spell.getSpellFromLevelID(this._oItem.param3);
            _loc3_ = new dofus.datacenter.Spell(_loc2_.id,_loc2_.level);
            this._mcList.gapi.loadUIComponent("SpellInfos","SpellInfos",{spell:_loc3_},{bAlwaysOnTop:true});
            break;
         case 2172:
         case 2173:
            _loc4_ = this._mcList.gapi.api.datacenter.Player.getOwnedSpellLevel(this._oItem.param3);
            _loc5_ = 1;
            if(_loc4_ > -1)
            {
               _loc5_ += this._oItem.param2;
            }
            _loc6_ = new dofus.datacenter.Spell(this._oItem.param3,_loc5_);
            this._mcList.gapi.loadUIComponent("SpellInfos","SpellInfos",{spell:_loc6_},{bAlwaysOnTop:true});
         default:
            return;
      }
   }
}
