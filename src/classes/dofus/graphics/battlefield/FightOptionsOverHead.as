class dofus.graphics.battlefield.FightOptionsOverHead extends MovieClip
{
   var _mc;
   var _tTeam;
   var onEnterFrame;
   static var ICON_WIDTH = 20;
   function FightOptionsOverHead(tTeam)
   {
      super();
      this.initialize(tTeam);
      this.drawClip();
   }
   function get height()
   {
      return 20;
   }
   function initialize(tTeam)
   {
      this._mc.removeMovieClip();
      this.createEmptyMovieClip("_mc",10);
      this._tTeam = tTeam;
   }
   function drawClip()
   {
      for(var a in this._mc)
      {
         this._mc[a].removeMovieClip();
      }
      var _loc2_ = 0;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      for(var a in this._tTeam.options)
      {
         _loc3_ = this._tTeam.options[a];
         if(_loc3_ == true)
         {
            _loc4_ = "UI_FightOption" + a + "Up";
            if(dofus.Constants.TRIPLEFRAMERATE && a == dofus.datacenter.Team.OPT_NEED_HELP)
            {
               _loc4_ += "_TripleFramerate";
            }
            _loc5_ = this._mc.attachMovie(_loc4_,"mcOption" + _loc2_,_loc2_);
            _loc5_._x = _loc2_ * dofus.graphics.battlefield.FightOptionsOverHead.ICON_WIDTH;
            _loc5_.onEnterFrame = function()
            {
               this.play();
               delete this.onEnterFrame;
            };
            _loc2_ = _loc2_ + 1;
         }
      }
      this._x = (- _loc2_ * dofus.graphics.battlefield.FightOptionsOverHead.ICON_WIDTH) / 2;
   }
}
