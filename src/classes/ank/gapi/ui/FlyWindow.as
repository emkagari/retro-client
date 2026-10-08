class ank.gapi.ui.FlyWindow extends ank.gapi.core.UIAdvancedComponent
{
   var _winBackground;
   var addToQueue;
   var initWindowContent;
   static var CLASS_NAME = "FlyWindow";
   function FlyWindow()
   {
      super();
   }
   function set title(sTitle)
   {
      this.addToQueue({object:this,method:function()
      {
         this._winBackground.title = sTitle;
      }});
   }
   function get title()
   {
      return this._winBackground.title;
   }
   function set contentPath(sContentPath)
   {
      this.addToQueue({object:this,method:function()
      {
         this._winBackground.contentPath = sContentPath;
      }});
   }
   function get contentPath()
   {
      return this._winBackground.contentPath;
   }
   function init()
   {
      super.init(false,ank.gapi.ui.FlyWindow.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._winBackground.addEventListener("complete",this);
   }
   function complete(oEvent)
   {
      this.addToQueue({object:this,method:this.initWindowContent});
   }
}
