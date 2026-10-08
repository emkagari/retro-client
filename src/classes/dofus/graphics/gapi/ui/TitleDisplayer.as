class dofus.graphics.gapi.ui.TitleDisplayer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _sTitle;
   var _txtTitle;
   var _txtYouHaveWon;
   var addToQueue;
   static var CLASS_NAME = "TitleDisplayer";
   function TitleDisplayer()
   {
      super();
   }
   function set title(sTitle)
   {
      this._sTitle = sTitle;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.TitleDisplayer.CLASS_NAME);
      this._txtYouHaveWon.text = "";
      this._txtTitle.text = "";
   }
   function createChildren()
   {
      this._txtYouHaveWon._alpha = this._txtTitle._alpha = 0;
      this.addToQueue({object:this,method:this.initText});
   }
   function initText()
   {
      this._txtTitle.text = this._sTitle;
      this._txtYouHaveWon.text = this.api.lang.getText("TITLE_WON");
   }
}
