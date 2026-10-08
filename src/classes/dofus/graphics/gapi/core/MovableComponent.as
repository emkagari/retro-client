class dofus.graphics.gapi.core.MovableComponent extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _nOffsetX;
   var _nOffsetY;
   var _nSnap;
   var _oBounds;
   var _x;
   var _y;
   var getBounds;
   var onMouseMove;
   function MovableComponent()
   {
      super();
   }
   function get bounds()
   {
      return this._oBounds;
   }
   function set bounds(o_)
   {
      this._oBounds = o_;
   }
   function get snap()
   {
      return this._nSnap;
   }
   function set snap(n_)
   {
      this._nSnap = n_;
   }
   function init()
   {
      this._oBounds = {left:0,top:0,right:742,bottom:432};
      this._nSnap = 20;
      this._nOffsetX = 0;
      this._nOffsetY = 0;
      super.init(false);
   }
   function snapComponent()
   {
      var _loc2_ = this._x;
      var _loc3_ = this._y;
      var _loc4_ = this.getBounds();
      var _loc5_ = _loc3_ + _loc4_.yMin - this._oBounds.top;
      var _loc6_ = this._oBounds.bottom - _loc3_ - _loc4_.yMax;
      var _loc7_ = _loc2_ + _loc4_.xMin - this._oBounds.left;
      var _loc8_ = this._oBounds.right - _loc2_ - _loc4_.xMax;
      if(_loc5_ < this._nSnap)
      {
         _loc3_ = this._oBounds.top - _loc4_.yMin;
      }
      if(_loc6_ < this._nSnap)
      {
         _loc3_ = this._oBounds.bottom - _loc4_.yMax;
      }
      if(_loc7_ < this._nSnap)
      {
         _loc2_ = this._oBounds.left - _loc4_.xMin;
      }
      if(_loc8_ < this._nSnap)
      {
         _loc2_ = this._oBounds.right - _loc4_.xMax;
      }
      this._y = _loc3_;
      this._x = _loc2_;
   }
   function bindDragHandle(mc_)
   {
      var self = this;
      mc_.onPress = function()
      {
         self.startDragWithOffset();
      };
      mc_.onRelease = mc_.onReleaseOutside = function()
      {
         self.stopDragWithOffset();
         self.dispatchEvent({type:"drop"});
      };
   }
   function startDragWithOffset()
   {
      this.onMouseMove = this.onDragMove;
      this._nOffsetX = _root._xmouse - this._x;
      this._nOffsetY = _root._ymouse - this._y;
   }
   function stopDragWithOffset()
   {
      this.onMouseMove = undefined;
      this._nOffsetX = 0;
      this._nOffsetY = 0;
   }
   function move(x_, y_, bForceDraw)
   {
      if(bForceDraw == undefined)
      {
         bForceDraw = false;
      }
      this.onBeforeMove(x_,y_,bForceDraw);
      this._x = x_;
      this._y = y_;
      this.snapComponent();
   }
   function onDragMove()
   {
      this.move(_root._xmouse - this._nOffsetX,_root._ymouse - this._nOffsetY);
   }
   function onBeforeMove(x_, y_, bForceDraw)
   {
   }
}
