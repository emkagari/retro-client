class dofus.graphics.gapi.controls.SpellBoostViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _lblAP1;
   var _lblAP2;
   var _lblLevel1;
   var _lblLevel2;
   var _lblName;
   var _lblNew;
   var _lblRange1;
   var _lblRange2;
   var _ldrIcon;
   var _mcArrowCritical;
   var _oSpell;
   var _txtCritical1;
   var _txtCritical2;
   var _txtDamages1;
   var _txtDamages2;
   var addToQueue;
   var initialized;
   static var CLASS_NAME = "SpellBoostViewer";
   function SpellBoostViewer()
   {
      super();
   }
   function set spell(oSpell)
   {
      this._oSpell = oSpell;
      if(this.initialized)
      {
         this.initData();
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.SpellBoostViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
   }
   function initData()
   {
      this.updateData();
   }
   function initTexts()
   {
      this._mcArrowCritical.text = this.api.lang.getText("NEW_CHARACTERISTICS");
   }
   function updateData()
   {
      if(this._oSpell != undefined)
      {
         this._ldrIcon.forceReload = true;
         this._ldrIcon.contentParams = this._oSpell.params;
         this._ldrIcon.contentPath = this._oSpell.iconFile;
         this._lblName.text = this._oSpell.name;
         this._lblNew.text = this.api.lang.getText("LEVEL") + " " + this._oSpell.level;
         this._lblLevel2.text = this._oSpell.apCost + " " + this.api.lang.getText("AP");
         this._txtDamages1.text = this._oSpell.rangeStr + " " + this.api.lang.getText("RANGE");
         this._lblLevel1.text = this._oSpell.descriptionNormalHit;
         this._txtDamages2.text = this._oSpell.descriptionCriticalHit != undefined ? this._oSpell.descriptionCriticalHit : "";
         this._txtCritical2._visible = this._oSpell.descriptionCriticalHit != undefined;
         this._oSpell.level += 1;
         this._lblRange1.text = this.api.lang.getText("LEVEL") + " " + this._oSpell.level;
         this._lblRange2.text = this._oSpell.apCost + " " + this.api.lang.getText("AP");
         this._txtCritical1.text = this._oSpell.rangeStr + " " + this.api.lang.getText("RANGE");
         this._lblAP1.text = this._oSpell.descriptionNormalHit;
         this._lblAP2.text = this._oSpell.descriptionCriticalHit != undefined ? this._oSpell.descriptionCriticalHit : "";
         this._oSpell.level -= 1;
      }
   }
}
