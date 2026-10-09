class dofus.graphics.gapi.ui.CenterInfo extends dofus.graphics.gapi.ui.CenterText
{
   var _lblWhiteDesc;
   var _sDesc;
   static var CLASS_NAME = "CenterInfo";
   function CenterInfo()
   {
      super();
   }
   function set textInfo(sText_)
   {
      this._sDesc = sText_;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.CenterInfo.CLASS_NAME);
   }
   function initText()
   {
      super.initText();
      this._lblWhiteDesc.text = this._sDesc;
   }
}
