class ank.utils.Extensions
{
   var split;
   static var bExtended = false;
   function Extensions()
   {
   }
   static function addExtensions()
   {
      if(ank.utils.Extensions.bExtended == true)
      {
         return true;
      }
      var _loc2_ = String.prototype;
      _loc2_.removeAccents = function()
      {
         var _loc2_ = "ÀÁÂÃÄÅàáâãäåßÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž";
         var _loc3_ = "AAAAAAaaaaaaBOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz";
         var _loc4_ = this.split("");
         var _loc5_ = _loc4_.length;
         var _loc6_ = 0;
         var _loc7_;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc2_.indexOf(_loc4_[_loc6_]);
            if(_loc7_ != -1)
            {
               _loc4_[_loc6_] = _loc3_.charAt(_loc7_);
            }
            _loc6_ = _loc6_ + 1;
         }
         return _loc4_.join("");
      };
      var _loc3_ = ank.utils.extensions.MovieClipExtensions.prototype;
      var _loc4_ = MovieClip.prototype;
      _loc4_.attachClassMovie = _loc3_.attachClassMovie;
      _loc4_.alignOnPixel = _loc3_.alignOnPixel;
      _loc4_.playFirstChildren = _loc3_.playFirstChildren;
      _loc4_.getFirstParentProperty = _loc3_.getFirstParentProperty;
      _loc4_.getActionClip = _loc3_.getActionClip;
      _loc4_.end = _loc3_.end;
      _loc4_.playAll = _loc3_.playAll;
      _loc4_.stopAll = _loc3_.stopAll;
      ank.utils.Extensions.bExtended = true;
      return true;
   }
}
