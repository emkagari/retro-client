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
      this._lblWhiteDesc = sText_;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.CenterInfo.CLASS_NAME);
   }
   function initText()
   {
      super.initText();
      this._sDesc.text = this._lblWhiteDesc;
      org.flashdevelop.utils.FlashConnect.trace(this._lblWhiteDesc,"dofus.graphics.gapi.ui.CenterInfo::initText","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/graphics/gapi/ui/CenterInfo.as",49);
   }
}
