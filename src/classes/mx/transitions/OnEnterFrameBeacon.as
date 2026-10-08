class mx.transitions.OnEnterFrameBeacon
{
   function OnEnterFrameBeacon()
   {
   }
   static function init()
   {
      var _loc2_ = _global.MovieClip;
      var _loc3_;
      if(!_root.__OnEnterFrameBeacon)
      {
         mx.transitions.BroadcasterMX.initialize(_loc2_);
         _loc3_ = _root.createEmptyMovieClip("__OnEnterFrameBeacon",9876);
         _loc3_.onEnterFrame = function()
         {
            _global.MovieClip.broadcastMessage("onEnterFrame");
         };
      }
   }
}
