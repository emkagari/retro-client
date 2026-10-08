class ank.utils.TweenAnimation
{
   function TweenAnimation()
   {
   }
   static function scale(mc, easeType, nInitialValue, nFinalValue, nDuration, bUseSeconds)
   {
      var _loc8_ = new mx.transitions.Tween(mc,"_yscale",easeType,nInitialValue,nFinalValue,nDuration,bUseSeconds);
      var _loc9_ = new mx.transitions.Tween(mc,"_xscale",easeType,nInitialValue,nFinalValue,nDuration,bUseSeconds);
   }
   static function alpha(mc, easeType, nInitialValue, nFinalValue, nDuration, bUseSeconds)
   {
      var _loc8_ = new mx.transitions.Tween(mc,"_alpha",easeType,nInitialValue,nFinalValue,nDuration,bUseSeconds);
   }
   static function vertical(mc, easeType, nInitialValue, nFinalValue, nDuration, bUseSeconds)
   {
      var _loc8_ = new mx.transitions.Tween(mc,"_y",easeType,nInitialValue,nFinalValue,nDuration,bUseSeconds);
   }
   static function horizontal(mc, easeType, nInitialValue, nFinalValue, nDuration, bUseSeconds)
   {
      var _loc8_ = new mx.transitions.Tween(mc,"_x",easeType,nInitialValue,nFinalValue,nDuration,bUseSeconds);
   }
   static function width(mc, easeType, nInitialValue, nFinalValue, nDuration, bUseSeconds)
   {
      var _loc8_ = new mx.transitions.Tween(mc,"_width",easeType,nInitialValue,nFinalValue,nDuration,bUseSeconds);
   }
   static function height(mc, easeType, nInitialValue, nFinalValue, nDuration, bUseSeconds)
   {
      var _loc8_ = new mx.transitions.Tween(mc,"_height",easeType,nInitialValue,nFinalValue,nDuration,bUseSeconds);
   }
}
