class dofus.graphics.gapi.controls.alignmentviewer.AlignmentViewerOrder extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _lblInfos;
   var _lblOrderName;
   var _lblSpecializationName;
   var _ldrIcon;
   var _oSpec;
   var _txtSpecializationDescription;
   var addToQueue;
   var initialized;
   static var CLASS_NAME = "AlignmentViewerOrder";
   function AlignmentViewerOrder()
   {
      super();
   }
   function set specialization(oSpec)
   {
      this._oSpec = oSpec;
      if(this.initialized)
      {
         this.initData();
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.alignmentviewer.AlignmentViewerOrder.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.initData});
   }
   function initTexts()
   {
      this._lblInfos.text = this.api.lang.getText("PLAYER_SPECIALIZATION");
   }
   function initData()
   {
      if(this._oSpec != undefined)
      {
         this._lblSpecializationName.text = this._oSpec.name;
         this._txtSpecializationDescription.text = this._oSpec.order.name;
         this._ldrIcon.contentPath = this._oSpec.order.iconFile;
         this._lblOrderName.text = this._oSpec.description;
      }
   }
}
