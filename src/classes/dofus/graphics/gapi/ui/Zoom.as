class dofus.graphics.gapi.ui.Zoom extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnCancel;
   var _nXScreenPos;
   var _nYScreenPos;
   var _visible;
   var _vsZoom;
   var addToQueue;
   var createEmptyMovieClip;
   var getNextHighestDepth;
   static var CLASS_NAME = "Zoom";
   function Zoom()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Zoom.CLASS_NAME);
      this._visible = false;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._btnCancel.addEventListener("click",this);
      this._btnCancel.addEventListener("over",this);
      this._btnCancel.addEventListener("out",this);
      this._vsZoom.addEventListener("change",this);
      this._vsZoom.min = this.api.gfx.getZoom();
      var _loc2_ = this.createEmptyMovieClip("zoom_mc",this.getNextHighestDepth());
      var oAPI = this.api;
      _loc2_.onMouseUp = function()
      {
         oAPI.mouseClicksMemorizer.storeCurrentMouseClick(false);
      };
      Mouse.addListener(this);
   }
   function setZoom()
   {
      this.api.kernel.GameManager.zoomGfxRoot(this._vsZoom.value,this._nXScreenPos,this._nYScreenPos);
   }
   function onMouseWheel(nValue, mc)
   {
      if(!dofus.graphics.gapi.ui.Zoom.isZooming())
      {
         return undefined;
      }
      if(this._vsZoom.value == 100)
      {
         this._nXScreenPos = _root._xmouse;
         this._nYScreenPos = _root._ymouse;
      }
      this._vsZoom.value += nValue * 10;
      this.setZoom();
   }
   static function isZooming()
   {
      return Key.isDown(Key.CONTROL) && !Key.isDown(Key.SHIFT);
   }
}
