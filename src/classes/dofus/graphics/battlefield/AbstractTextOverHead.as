class dofus.graphics.battlefield.AbstractTextOverHead extends ank.gapi.core.UIBasicComponent
{
   var _height;
   var _mcGfx;
   var _mcTxtBackground;
   var _width;
   var createEmptyMovieClip;
   var drawRoundRect;
   static var BACKGROUND_ALPHA = 70;
   static var BACKGROUND_COLOR = 0;
   static var TEXT_SMALL_FORMAT = new TextFormat("Verdana",10,16777215,false,false,false,null,null,"left");
   static var TEXT_SMALL_FORMAT2 = new TextFormat("Verdana",9,16777215,false,false,false,null,null,"left");
   static var TEXT_FORMAT2 = new TextFormat("Verdana",9,16777215,false,false,false,null,null,"center");
   static var TEXT_FORMAT = new TextFormat("Verdana",10,16777215,true,false,false,null,null,"center");
   static var CORNER_RADIUS = 0;
   static var WIDTH_SPACER = 4;
   static var HEIGHT_SPACER = 4;
   function AbstractTextOverHead()
   {
      super();
   }
   function get height()
   {
      return Math.ceil(this._height);
   }
   function get width()
   {
      return Math.ceil(this._width);
   }
   function initialize()
   {
      this.createEmptyMovieClip("_mcGfx",10);
      this.createEmptyMovieClip("_mcTxtBackground",20);
   }
   function drawBackground(nWidth, nHeight, nColor)
   {
      this.drawRoundRect(this._mcTxtBackground,(- nWidth) / 2,0,nWidth,nHeight,3,nColor,dofus.graphics.battlefield.AbstractTextOverHead.BACKGROUND_ALPHA);
   }
   function drawGfx(sFile, nFrame)
   {
      this._mcGfx.attachClassMovie(ank.utils.SWFLoader,"_mcSwfLoader",10);
      this._mcGfx._mcSwfLoader.loadSWF(sFile,nFrame);
   }
   function addPvpGfxEffect(nPvpGain, nFrame)
   {
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      switch(nPvpGain)
      {
         case -1:
            _loc4_ = 0.5;
            _loc5_ = [];
            _loc5_ = _loc5_.concat([_loc4_,0,0,0,0]);
            _loc5_ = _loc5_.concat([0,_loc4_,0,0,0]);
            _loc5_ = _loc5_.concat([0,0,_loc4_,0,0]);
            _loc5_ = _loc5_.concat([0,0,0,1,0]);
            _loc6_ = new flash.filters.ColorMatrixFilter(_loc5_);
            this._mcGfx.filters = [_loc6_];
            break;
         case 1:
            switch(Math.floor((nFrame - 1) / 10))
            {
               case 0:
                  _loc7_ = 11201279;
                  break;
               case 1:
                  _loc7_ = 13369344;
                  break;
               case 2:
                  _loc7_ = 0;
            }
            _loc8_ = 0.5;
            _loc9_ = 10;
            _loc10_ = 10;
            _loc11_ = 2;
            _loc12_ = 3;
            _loc13_ = false;
            _loc14_ = false;
            _loc15_ = new flash.filters.GlowFilter(_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_);
            _loc16_ = [];
            _loc16_.push(_loc15_);
            this._mcGfx.filters = _loc16_;
         default:
            return;
      }
   }
}
