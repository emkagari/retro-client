class dofus.graphics.gapi.ui.encyclopedia.EncyclopediaBestiarySpellsItem extends ank.gapi.core.UIBasicComponent
{
   var _lblAP;
   var _lblLevel;
   var _lblName;
   var _lblRange;
   var _ldrAdjustableRange;
   var _ldrLineOfSight;
   var _ldrLineOnly;
   var _mcList;
   var _oItem;
   var addToQueue;
   var api;
   function EncyclopediaBestiarySpellsItem()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem_)
   {
      if(bUsed)
      {
         this._oItem = oItem_;
         oItem_.sortName = oItem_.name;
         oItem_.sortLevel = oItem_.level;
         this._lblName.text = oItem_.name;
         this._lblLevel.text = this.api.lang.getText("LEVEL_SMALL") + " " + oItem_.level;
         this._lblRange.text = (oItem_.rangeMin == 0 ? "" : oItem_.rangeMin + "-") + oItem_.rangeMax + " " + this.api.lang.getText("RANGE");
         this._lblAP.text = oItem_.apCost + " " + this.api.lang.getText("AP");
         this._ldrAdjustableRange._visible = oItem_.canBoostRange;
         this._ldrLineOfSight._visible = !oItem_.lineOfSight && (oItem_.rangeMin > 1 || oItem_.canBoostRange);
         this._ldrLineOnly._visible = oItem_.lineOnly && (oItem_.rangeMin > 1 || oItem_.canBoostRange);
      }
      else if(this._lblName.text != undefined)
      {
         this._lblName.text = "";
         this._lblLevel.text = "";
         this._lblRange.text = "";
         this._lblAP.text = "";
         this._ldrAdjustableRange._visible = false;
         this._ldrLineOfSight._visible = false;
         this._ldrLineOnly._visible = false;
      }
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.api = this._mcList._parent._parent.api;
   }
   function addListeners()
   {
      this._ldrAdjustableRange.addEventListener("over",this);
      this._ldrAdjustableRange.addEventListener("out",this);
      this._ldrLineOfSight.addEventListener("over",this);
      this._ldrLineOfSight.addEventListener("out",this);
      this._ldrLineOnly.addEventListener("over",this);
      this._ldrLineOnly.addEventListener("out",this);
   }
   function over(oEvent_)
   {
      switch(oEvent_.target)
      {
         case this._ldrAdjustableRange:
            this.api.ui.showTooltip(this.api.lang.getText("RANGE_BOOST"));
            break;
         case this._ldrLineOfSight:
            this.api.ui.showTooltip(this.api.lang.getText("DONT_NEED_LINE_OF_SIGHT"));
            break;
         case this._ldrLineOnly:
            this.api.ui.showTooltip(this.api.lang.getText("LINE_ONLY"));
         default:
            return;
      }
   }
   function out(oEvent_)
   {
      this.api.ui.hideTooltip();
   }
}
