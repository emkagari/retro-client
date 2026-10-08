class dofus.graphics.gapi.controls.timeline.TimelinePointer extends ank.gapi.core.UIBasicComponent
{
   var _destScale;
   var _destX;
   var _x;
   var _xscale;
   static var CLASS_NAME = "Timeline";
   function TimelinePointer()
   {
      super();
   }
   function moveTween(destX, destScale)
   {
      this._destX = destX;
      this._destScale = destScale;
      ank.utils.TweenAnimation.horizontal(this,mx.transitions.easing.Strong.easeOut,this._x,this._destX,0.4,true);
      ank.utils.TweenAnimation.scale(this,mx.transitions.easing.Strong.easeOut,this._xscale,this._destScale,0.4,true);
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.timeline.TimelinePointer.CLASS_NAME);
   }
}
