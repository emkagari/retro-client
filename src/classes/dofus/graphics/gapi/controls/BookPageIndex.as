class dofus.graphics.gapi.controls.BookPageIndex extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _lblIndex;
   var _lstChapters;
   var _oPage;
   var addToQueue;
   var dispatchEvent;
   var initialized;
   static var CLASS_NAME = "BookPageIndex";
   function BookPageIndex()
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
      super.init(false,dofus.graphics.gapi.controls.BookPageIndex.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.updateData});
   }
   function addListeners()
   {
      this._lstChapters.addEventListener("itemSelected",this);
   }
   function initTexts()
   {
      this._lblIndex.text = this.api.lang.getText("TABLE_OF_CONTENTS");
   }
   function updateData()
   {
      this._lstChapters.dataProvider = this._oPage.chapters;
   }
   function itemSelected(oEvent)
   {
      var _loc3_ = oEvent.row.item[4];
      this.dispatchEvent({type:"chapterChange",pageNum:_loc3_});
   }
}
