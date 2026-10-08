class dofus.graphics.gapi.ui.fightsinfos.FightsInfosPlayerItem extends ank.gapi.core.UIBasicComponent
{
   var _lblLevel;
   var _lblName;
   var _ldrGuild;
   var _mcItemPlacer;
   var addToQueue;
   function FightsInfosPlayerItem()
   {
      super();
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      if(bUsed)
      {
         this._lblName.text = oItem.name;
         this._lblLevel.text = oItem.level;
         this._ldrGuild._visible = oItem.alive;
         this._ldrGuild.contentPath = !oItem.alive ? "" : dofus.Constants.GUILDS_MINI_PATH + oItem.icon + ".swf";
         this._mcItemPlacer._visible = !oItem.alive;
         if(!oItem.alive)
         {
            this.size(true);
         }
      }
      else if(this._lblName.text != undefined)
      {
         this._lblName.text = "";
         this._lblLevel.text = "";
         this._ldrGuild.contentPath = "";
         this._mcItemPlacer._visible = false;
         this.size(false);
      }
   }
   function init()
   {
      super.init(false);
      this._mcItemPlacer._visible = false;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._ldrGuild.addEventListener("complete",this);
      this._ldrGuild.addEventListener("error",this);
   }
   function size(bDisplayIcon)
   {
      this._lblName.width = !bDisplayIcon ? 110 : 94;
      this._lblName._x = !bDisplayIcon ? 5 : 21;
   }
   function complete(oEvent_)
   {
      this.size(true);
   }
   function error(oEvent_)
   {
      this.size(false);
   }
}
