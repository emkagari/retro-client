class dofus.graphics.gapi.ui.spellforget.SpellForgetItem extends ank.gapi.core.UIBasicComponent
{
   var _lblLevel;
   var _lblName;
   var _mcList;
   var _oItem;
   function SpellForgetItem()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      if(bUsed)
      {
         this._oItem = dofus.datacenter.Spell(oItem);
         this._lblName.text = this._oItem.name;
         this._lblLevel.text = String(this._oItem.level);
      }
      else if(this._lblName.text != undefined)
      {
         this._lblName.text = "";
         this._lblLevel.text = "";
      }
   }
}
