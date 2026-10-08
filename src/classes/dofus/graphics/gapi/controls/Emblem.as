class dofus.graphics.gapi.controls.Emblem extends ank.gapi.core.UIBasicComponent
{
   var _ldrEmblemBack;
   var _ldrEmblemShadow;
   var _ldrEmblemUp;
   var _nBackColor;
   var _nUpColor;
   var _sBackFile;
   var _sUpFile;
   var addToQueue;
   var initialized;
   var setMovieClipColor;
   static var CLASS_NAME = "Emblem";
   var _bShadow = false;
   function Emblem()
   {
      super();
   }
   function set shadow(bShadow)
   {
      this._bShadow = bShadow;
   }
   function get shadow()
   {
      return this._bShadow;
   }
   function set backID(nBackID)
   {
      if(nBackID < 1 || nBackID > dofus.Constants.EMBLEM_BACKS_COUNT)
      {
         nBackID = 1;
      }
      this._sBackFile = dofus.Constants.EMBLEMS_BACK_PATH + nBackID + ".swf";
      if(this.initialized)
      {
         this.layoutBack();
      }
   }
   function set backColor(nBackColor)
   {
      this._nBackColor = nBackColor;
      if(this.initialized)
      {
         this.layoutBack();
      }
   }
   function set upID(nUpID)
   {
      if(nUpID < 1 && nUpID != -1 || nUpID > dofus.Constants.EMBLEM_UPS_COUNT)
      {
         nUpID = 1;
      }
      this._sUpFile = dofus.Constants.EMBLEMS_UP_PATH + nUpID + ".swf";
      if(this.initialized)
      {
         this.layoutUp();
      }
   }
   function set upColor(nUpColor)
   {
      this._nUpColor = nUpColor;
      if(this.initialized)
      {
         this.layoutUp();
      }
   }
   function set data(oData)
   {
      this._sBackFile = dofus.Constants.EMBLEMS_BACK_PATH + oData.backID + ".swf";
      this._nBackColor = oData.backColor;
      this._sUpFile = dofus.Constants.EMBLEMS_UP_PATH + oData.upID + ".swf";
      this._nUpColor = oData.upColor;
      if(this.initialized)
      {
         this.layoutBack();
         this.layoutUp();
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.Emblem.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.layoutContent});
   }
   function initScale()
   {
   }
   function addListeners()
   {
      this._ldrEmblemBack.addEventListener("initialization",this);
      this._ldrEmblemUp.addEventListener("initialization",this);
   }
   function layoutContent()
   {
      if(this._sBackFile != undefined)
      {
         if(this._bShadow)
         {
            this._ldrEmblemShadow.contentPath = this._sBackFile;
            this._ldrEmblemShadow.filters = [new flash.filters.GlowFilter(16777215,1,2,2,1,1)];
         }
         this._ldrEmblemShadow._visible = this._bShadow;
         this._ldrEmblemShadow.enabled = false;
         this.layoutBack();
         this.layoutUp();
      }
   }
   function layoutBack()
   {
      if(this._ldrEmblemBack.contentPath == this._sBackFile)
      {
         this.applyBackColor();
      }
      else
      {
         this._ldrEmblemBack.contentPath = this._sBackFile;
      }
   }
   function layoutUp()
   {
      if(this._ldrEmblemUp.contentPath == this._sUpFile)
      {
         this.applyUpColor();
      }
      else
      {
         this._ldrEmblemUp.contentPath = this._sUpFile;
      }
   }
   function applyBackColor()
   {
      this.setMovieClipColor(this._ldrEmblemBack.content.back,this._nBackColor);
   }
   function applyUpColor()
   {
      if(this._nUpColor == -1)
      {
         return undefined;
      }
      this.setMovieClipColor(this._ldrEmblemUp.content,this._nUpColor);
   }
   function initialization(oEvent)
   {
      var _loc3_ = oEvent.target;
      switch(_loc3_._name)
      {
         case "_ldrEmblemBack":
            this.applyBackColor();
            break;
         case "_ldrEmblemUp":
            this.applyUpColor();
         default:
            return;
      }
   }
}
