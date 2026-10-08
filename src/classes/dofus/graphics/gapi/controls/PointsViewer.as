class dofus.graphics.gapi.controls.PointsViewer extends ank.gapi.core.UIBasicComponent
{
   var _nTextColor;
   var _nValue;
   var _sBackgroundLink;
   var _txtValue;
   var attachMovie;
   var dispatchEvent;
   var useHandCursor;
   static var CLASS_NAME = "PointsViewer";
   function PointsViewer()
   {
      super();
   }
   function set background(sBackground)
   {
      this._sBackgroundLink = sBackground;
   }
   function set textColor(nTextColor)
   {
      this._nTextColor = nTextColor;
   }
   function set value(nValue)
   {
      nValue = Number(nValue);
      if(_global.isNaN(nValue))
      {
         return;
      }
      this._nValue = nValue;
      this.applyValue();
      this.useHandCursor = false;
   }
   function get value()
   {
      return this._nValue;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.PointsViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this.attachMovie(this._sBackgroundLink,"_mcBg",this._txtValue.getDepth() - 1);
      this._txtValue.textColor = this._nTextColor;
   }
   function applyValue()
   {
      this._txtValue.text = String(this._nValue);
   }
   function onRollOver()
   {
      this.dispatchEvent({type:"over"});
   }
   function onRollOut()
   {
      this.dispatchEvent({type:"out"});
   }
}
