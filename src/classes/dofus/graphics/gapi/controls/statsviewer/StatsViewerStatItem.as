class dofus.graphics.gapi.controls.statsviewer.StatsViewerStatItem extends ank.gapi.core.UIBasicComponent
{
   var _lblAlign;
   var _lblBase;
   var _lblBoost;
   var _lblCatName;
   var _lblItems;
   var _lblName;
   var _lblScrolls;
   var _lblTotal;
   var _ldrIcon;
   var _mcCatBackground;
   var _mcList;
   var _oItem;
   function StatsViewerStatItem()
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
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      if(bUsed)
      {
         this._oItem = oItem;
         if(oItem.isCat)
         {
            this._mcCatBackground._visible = true;
            this._ldrIcon.contentPath = "";
            this._lblCatName.text = oItem.name;
            this._lblName.text = "";
            this._lblBase.text = "";
            this._lblItems.text = "";
            this._lblAlign.text = "";
            this._lblBoost.text = "";
            this._lblTotal.text = "";
            this._lblScrolls.text = "";
         }
         else
         {
            this._mcCatBackground._visible = false;
            if(oItem.p != undefined)
            {
               this._ldrIcon.contentPath = oItem.p;
            }
            else
            {
               this._ldrIcon.contentPath = "";
            }
            this._lblCatName.text = "";
            this._lblName.text = oItem.name;
            _loc5_ = oItem.s - oItem.a;
            if(_loc5_ != 0)
            {
               this._lblBase.text = "" + _loc5_;
               _loc6_ = _loc5_ == 0 || (_loc5_ > 0 && !this.isBadEffect(oItem) || _loc5_ < 0 && this.isBadEffect(oItem));
               if(_loc6_)
               {
                  this._lblBase.styleName = "GreenCenterSmallLabel";
               }
               else
               {
                  this._lblBase.styleName = "RedCenterSmallLabel";
               }
            }
            else
            {
               this._lblBase.text = "-";
               this._lblBase.styleName = "BrownCenterSmallLabel";
            }
            if(oItem.i != 0)
            {
               this._lblItems.text = oItem.i;
               _loc7_ = oItem.i == 0 || (oItem.i > 0 && !this.isBadEffect(oItem) || oItem.i < 0 && this.isBadEffect(oItem));
               if(_loc7_)
               {
                  this._lblItems.styleName = "GreenCenterSmallLabel";
               }
               else
               {
                  this._lblItems.styleName = "RedCenterSmallLabel";
               }
            }
            else
            {
               this._lblItems.text = "-";
               this._lblItems.styleName = "BrownCenterSmallLabel";
            }
            if(oItem.d != 0)
            {
               this._lblAlign.text = oItem.d;
               _loc8_ = oItem.d == 0 || (oItem.d > 0 && !this.isBadEffect(oItem) || oItem.d < 0 && this.isBadEffect(oItem));
               if(_loc8_)
               {
                  this._lblAlign.styleName = "GreenCenterSmallLabel";
               }
               else
               {
                  this._lblAlign.styleName = "RedCenterSmallLabel";
               }
            }
            else
            {
               this._lblAlign.text = "-";
               this._lblAlign.styleName = "BrownCenterSmallLabel";
            }
            if(oItem.b != 0)
            {
               this._lblBoost.text = oItem.b;
               _loc9_ = oItem.b == 0 || (oItem.b > 0 && !this.isBadEffect(oItem) || oItem.b < 0 && this.isBadEffect(oItem));
               if(_loc9_)
               {
                  this._lblBoost.styleName = "GreenCenterSmallLabel";
               }
               else
               {
                  this._lblBoost.styleName = "RedCenterSmallLabel";
               }
            }
            else
            {
               this._lblBoost.text = "-";
               this._lblBoost.styleName = "BrownCenterSmallLabel";
            }
            if(oItem.a != 0)
            {
               this._lblScrolls.text = oItem.a;
               _loc10_ = oItem.a == 0 || (oItem.a > 0 && !this.isBadEffect(oItem) || oItem.a < 0 && this.isBadEffect(oItem));
               if(_loc10_)
               {
                  this._lblScrolls.styleName = "GreenCenterSmallLabel";
               }
               else
               {
                  this._lblScrolls.styleName = "RedCenterSmallLabel";
               }
            }
            else
            {
               this._lblScrolls.text = "-";
               this._lblScrolls.styleName = "BrownCenterSmallLabel";
            }
            _loc11_ = oItem.b + oItem.d + oItem.i + oItem.a + _loc5_;
            if(_loc11_ != 0)
            {
               this._lblTotal.text = String(_loc11_);
               _loc12_ = _loc11_ == 0 || (_loc11_ > 0 && !this.isBadEffect(oItem) || _loc11_ < 0 && this.isBadEffect(oItem));
               if(_loc12_)
               {
                  this._lblTotal.styleName = "GreenCenterSmallLabel";
               }
               else
               {
                  this._lblTotal.styleName = "RedCenterSmallLabel";
               }
            }
            else
            {
               this._lblTotal.text = "-";
               this._lblTotal.styleName = "BrownCenterSmallLabel";
            }
         }
      }
      else if(this._lblName.text != undefined)
      {
         this._mcCatBackground._visible = false;
         this._ldrIcon.contentPath = "";
         this._lblCatName.text = "";
         this._lblName.text = "";
         this._lblBase.text = "";
         this._lblBase.styleName = "BrownCenterSmallLabel";
         this._lblItems.text = "";
         this._lblItems.styleName = "BrownCenterSmallLabel";
         this._lblAlign.text = "";
         this._lblAlign.styleName = "BrownCenterSmallLabel";
         this._lblBoost.text = "";
         this._lblBoost.styleName = "BrownCenterSmallLabel";
         this._lblTotal.text = "";
         this._lblTotal.styleName = "BrownCenterSmallLabel";
      }
   }
   function isBadEffect(oItem_)
   {
      return oItem_.c == 1 && oItem_.idx == 52;
   }
   function init()
   {
      super.init(false);
      this._mcCatBackground._visible = false;
   }
}
