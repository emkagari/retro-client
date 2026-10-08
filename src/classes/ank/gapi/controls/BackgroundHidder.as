class ank.gapi.controls.BackgroundHidder extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var createEmptyMovieClip;
   var dispatchEvent;
   var drawRoundRect;
   var getStyle;
   var hidden_mc;
   var onRelease;
   var useHandCursor;
   static var CLASS_NAME = "BackgroundHidder";
   function BackgroundHidder()
   {
      super();
   }
   function set handCursor(bHandCursor)
   {
      this.useHandCursor = bHandCursor;
   }
   function init()
   {
      super.init(false,ank.gapi.controls.BackgroundHidder.CLASS_NAME);
   }
   function createChildren()
   {
      this.createEmptyMovieClip("hidden_mc",10);
      this.onRelease = function()
      {
         this.dispatchEvent({type:"click"});
      };
   }
   function arrange()
   {
      this.hidden_mc._width = this.__width;
      this.hidden_mc._height = this.__height;
   }
   function draw()
   {
      var _loc2_ = this.getStyle();
      var _loc3_ = _loc2_.backgroundcolor != undefined ? _loc2_.backgroundcolor : 0;
      var _loc4_ = _loc2_.backgroundalpha != undefined ? _loc2_.backgroundalpha : 10;
      this.hidden_mc.clear();
      this.drawRoundRect(this.hidden_mc,0,0,1,1,0,_loc3_,_loc4_);
   }
}
