class dofus.graphics.gapi.ui.title.TitleItem extends ank.gapi.core.UIBasicComponent
{
   var _btnIcon;
   var _lblTitle;
   var _ldrIcon;
   var _mcList;
   var _nType;
   var _oItem;
   var addToQueue;
   function TitleItem()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function get api()
   {
      return this._mcList.gapi.api;
   }
   function setValue(bUsed, sSuggested, oItem_)
   {
      if(bUsed)
      {
         this._oItem = oItem_;
         this._nType = oItem_.type;
         this._lblTitle.text = oItem_.text;
         this._ldrIcon.contentPath = oItem_.iconFile;
         this._btnIcon.icon = oItem_.iconFile;
         this._ldrIcon._visible = oItem_.id != -1;
         this._btnIcon._visible = this._ldrIcon._visible;
      }
      else if(this._lblTitle.text != undefined)
      {
         this._lblTitle.text = "";
         this._nType = 0;
         this._ldrIcon.contentPath = "";
         this._ldrIcon._visible = false;
         this._btnIcon._visible = false;
      }
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._btnIcon.addEventListener("over",this);
      this._btnIcon.addEventListener("out",this);
   }
   function over(oEvent_)
   {
      var _loc3_ = this._oItem.toString();
      if(_loc3_ != undefined)
      {
         this._mcList.gapi.showTooltip(this._oItem.toString());
      }
   }
   function out(oEvent_)
   {
      this._mcList.gapi.hideTooltip();
   }
}
