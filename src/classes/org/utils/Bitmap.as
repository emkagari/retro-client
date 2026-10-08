class org.utils.Bitmap
{
   var tmc;
   function Bitmap()
   {
   }
   static function loadBitmapSmoothed(url, target)
   {
      var _loc4_ = target.createEmptyMovieClip("bitmap_mc",target.getNextHighestDepth());
      var _loc5_ = {};
      _loc5_.tmc = target;
      _loc5_.onLoadInit = function(mc_)
      {
         mc_._visible = false;
         mc_.forceSmoothing = true;
         var _loc3_ = new flash.display.BitmapData(mc_._width,mc_._height,true);
         this.tmc.attachBitmap(_loc3_,this.tmc.getNextHighestDepth(),"auto",true);
         _loc3_.draw(mc_);
      };
      var _loc6_ = new MovieClipLoader();
      _loc6_.addListener(_loc5_);
      _loc6_.loadClip(url,_loc4_);
   }
}
