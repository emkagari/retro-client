class dofus.graphics.gapi.controls.alignmentviewer.AlignmentViewerFeatsItem extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _lblEffect;
   var _lblName;
   var _ldrIcon;
   var _mcList;
   function AlignmentViewerFeatsItem()
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
         this._ldrIcon.contentPath = oItem.iconFile;
         this._lblName.text = oItem.name + (oItem.level != undefined ? " (" + this._mcList.gapi.api.lang.getText("LEVEL_SMALL") + " " + oItem.level + ")" : "");
         this._lblEffect.text = oItem.effect.description != undefined ? oItem.effect.description : "";
      }
      else if(this._lblName.text != undefined)
      {
         this._ldrIcon.contentPath = "";
         this._lblName.text = "";
         this._lblEffect.text = "";
      }
   }
}
