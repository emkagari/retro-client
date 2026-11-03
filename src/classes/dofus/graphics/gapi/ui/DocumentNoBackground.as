class dofus.graphics.gapi.ui.DocumentNoBackground extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bgHidder;
   var _lblTitle;
   var _ldrIcon;
   var _oDoc;
   var addToQueue;
   static var CLASS_NAME = "DocumentNoBackground";
   function DocumentNoBackground()
   {
      super();
   }
   function set document(oDoc)
   {
      this._oDoc = oDoc;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.DocumentNoBackground.CLASS_NAME);
   }
   function callClose()
   {
      this.api.network.Documents.leave();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.updateData});
   }
   function addListeners()
   {
      this._bgHidder.addEventListener("click",this);
   }
   function initTexts()
   {
      if(this._oDoc.title == undefined)
      {
         return undefined;
      }
      this._lblTitle.text = this._oDoc.title;
   }
   function updateData()
   {
      var _loc2_ = this.api.kernel.DocumentsServersManager.getCurrentServer() + "swf/" + this._oDoc.iconID + ".swf";
      this._ldrIcon.contentPath = _loc2_;
   }
   function click(oEvent_)
   {
      var _loc0_;
      if((_loc0_ = oEvent_.target) === this._bgHidder)
      {
         this.callClose();
      }
   }
}
