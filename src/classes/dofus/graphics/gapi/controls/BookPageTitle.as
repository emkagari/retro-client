class dofus.graphics.gapi.controls.BookPageTitle extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _lblAuthor;
   var _lblSubTitle;
   var _oPage;
   var _txtTitle;
   var addToQueue;
   var initialized;
   static var CLASS_NAME = "BookPageTitle";
   function BookPageTitle()
   {
      super();
   }
   function set page(oPage)
   {
      this._oPage = oPage;
      if(this.initialized)
      {
         this.updateData();
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.BookPageTitle.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.updateData});
   }
   function updateData()
   {
      this._txtTitle.text = this._oPage.title != undefined ? this._oPage.title : "";
      this._lblSubTitle.text = this._oPage.subtitle != undefined ? this._oPage.subtitle : "";
      this._lblAuthor.text = this._oPage.author != undefined ? this._oPage.author : "";
   }
}
