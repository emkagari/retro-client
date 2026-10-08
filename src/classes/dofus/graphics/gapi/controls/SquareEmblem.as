class dofus.graphics.gapi.controls.SquareEmblem extends ank.gapi.core.UIBasicComponent
{
   var _ldrEmblemUp;
   var _mcBack;
   var _nBackColor;
   var _nUpColor;
   var _sUpFile;
   var addToQueue;
   var initialized;
   var setMovieClipColor;
   static var CLASS_NAME = "SquareEmblem";
   function SquareEmblem()
   {
      super();
   }
   function set backColor(nBackColor)
   {
      this._nBackColor = nBackColor;
      if(this.initialized)
      {
         this.applyBackColor();
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
      this._nBackColor = oData.backColor;
      this._sUpFile = dofus.Constants.EMBLEMS_UP_PATH + oData.upID + ".swf";
      this._nUpColor = oData.upColor;
      if(this.initialized)
      {
         this.applyBackColor();
         this.layoutUp();
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.SquareEmblem.CLASS_NAME);
   }
   function createChildren()
   {
      this.data = _global.API.datacenter.Player.guildInfos.emblem;
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.layoutContent});
   }
   function initScale()
   {
   }
   function addListeners()
   {
      this._ldrEmblemUp.addEventListener("initialization",this);
   }
   function layoutContent()
   {
      if(this._sUpFile != undefined)
      {
         this.applyBackColor();
         this.layoutUp();
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
      this.setMovieClipColor(this._mcBack,this._nBackColor);
      this._mcBack._alpha = 100;
   }
   function applyUpColor()
   {
      if(this._nUpColor == -1)
      {
         return undefined;
      }
      this.setMovieClipColor(this._ldrEmblemUp.content,this._nUpColor);
   }
   function initialization(oEvent_)
   {
      var _loc3_ = oEvent_.target;
      var _loc0_;
      if((_loc0_ = _loc3_._name) === "_ldrEmblemUp")
      {
         this.applyUpColor();
      }
   }
}
