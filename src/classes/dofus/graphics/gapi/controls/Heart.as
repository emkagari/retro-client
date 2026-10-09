class dofus.graphics.gapi.controls.Heart extends ank.gapi.core.UIBasicComponent
{
   var _mcRectangle;
   var _nDisplayState;
   var _nMax;
   var _nMaxHeight;
   var _nValue;
   var _txtCurrent;
   var _txtMax;
   var _txtPercent;
   var _txtValue;
   var addToQueue;
   var gotoAndStop;
   var stop;
   static var CLASS_NAME = "Heart";
   function Heart()
   {
      super();
   }
   function set value(nValue)
   {
      nValue = Number(nValue);
      if(_global.isNaN(nValue))
      {
         return;
      }
      this._nValue = nValue;
      if(this._nMax != undefined)
      {
         this.applyValue();
      }
   }
   function get value()
   {
      return this._nValue;
   }
   function set max(nMax)
   {
      nMax = Number(nMax);
      if(_global.isNaN(nMax))
      {
         return;
      }
      this._nMax = nMax;
      if(this._nValue != undefined)
      {
         this.applyValue();
      }
   }
   function get max()
   {
      return this._nMax;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.Heart.CLASS_NAME);
   }
   function createChildren()
   {
      this._nMaxHeight = this._mcRectangle._height;
      this._nDisplayState = 0;
      this.stop();
   }
   function applyValue()
   {
      switch(this._nDisplayState)
      {
         case 1:
            this._txtMax.text = String(this._nValue);
            this._txtPercent.text = String(this._nMax);
            break;
         case 2:
            this._txtCurrent.text = String(Math.ceil(this._nValue / this._nMax * 100));
            break;
         default:
            this._txtValue.text = String(this._nValue);
      }
      this._mcRectangle._height = this._nValue / this._nMax * this._nMaxHeight;
   }
   function _btnTemporis()
   {
      this._nDisplayState = this._nDisplayState + 1;
      if(this._nDisplayState > 2)
      {
         this._nDisplayState = 0;
      }
      this._nDisplayState = Number(this._nDisplayState);
      if(_global.isNaN(this._nDisplayState))
      {
         this._nDisplayState = 0;
      }
      switch(this._nDisplayState)
      {
         case 1:
            this.gotoAndStop("temporisOne");
            break;
         case 2:
            this.gotoAndStop("temporisTwo");
            break;
         default:
            this.gotoAndStop("normal_");
      }
      this.addToQueue({object:this,method:this.applyValue});
   }
}
