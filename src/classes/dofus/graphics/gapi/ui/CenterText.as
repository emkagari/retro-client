class dofus.graphics.gapi.ui.CenterText extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _lblWhite;
   var _mcBackground;
   var _prgbGfxLoad;
   var addToQueue;
   var unloadThis;
   static var CLASS_NAME = "CenterText";
   var _sText = "";
   var _bBackground = false;
   var _nTimer = 0;
   function CenterText()
   {
      super();
   }
   function set text(sText)
   {
      this._sText = sText;
   }
   function set background(bBackground)
   {
      this._bBackground = bBackground;
   }
   function set timer(nTimer)
   {
      this._nTimer = nTimer;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.CenterText.CLASS_NAME);
   }
   function createChildren()
   {
      if(this._sText.length == 0)
      {
         return undefined;
      }
      this.addToQueue({object:this,method:this.initText});
      this._mcBackground._visible = false;
      this._prgbGfxLoad._visible = false;
      if(this._nTimer != 0)
      {
         ank.utils.Timer.setTimer(this,"centertext",this,this.unloadThis,this._nTimer);
      }
   }
   function initText()
   {
      this._lblWhite.text = this._sText;
      this._lblWhite.filters = [new flash.filters.GlowFilter(0,1,3,3,7,1)];
      var _loc2_ = this._lblWhite.textHeight;
      this._mcBackground._visible = this._bBackground;
      this._mcBackground._height = _loc2_ + 2.5 * (this._lblWhite._y - this._mcBackground._y);
   }
   function updateProgressBar(sLabel, nCurrentVal, nMaxVal)
   {
      var _loc5_ = Math.floor(nCurrentVal / nMaxVal * 100);
      if(_global.isNaN(_loc5_))
      {
         _loc5_ = 0;
      }
      this._prgbGfxLoad._visible = true;
      this._prgbGfxLoad.txtInfo.text = sLabel;
      this._prgbGfxLoad.txtPercent.text = _loc5_ + "%";
      this._prgbGfxLoad.mcProgressBar._width = _loc5_;
   }
}
