class ank.battlefield.VisualEffectHandler
{
   var _mcBattlefield;
   var _mcContainer;
   var _mcl;
   var api;
   var attachMovie;
   var end;
   var move;
   var onEnterFrame;
   var shoot;
   static var MAX_INDEX = 21;
   var _incIndex = 0;
   function VisualEffectHandler(b, c)
   {
      this.initialize(b,c);
   }
   function initialize(b, c)
   {
      this._mcBattlefield = b;
      this._mcContainer = c;
      this.clear();
      if(this._mcl == undefined)
      {
         this._mcl = new MovieClipLoader();
         this._mcl.addListener(this);
      }
      this.api = _global.API;
   }
   function clear(Void)
   {
      this._incIndex = 0;
   }
   function addEffect(sprite, oVisualEffect, nCellNum, displayType, targetSprite, bVisible)
   {
      if(displayType < 10)
      {
         return undefined;
      }
      var _loc8_ = !oVisualEffect.bInFrontOfSprite ? -1 : 1;
      var _loc9_ = this.getNextIndex() + ank.battlefield.Constants.MAX_SPRITES_ON_CELL / 2 + 1;
      var _loc10_ = "eff" + _loc9_;
      this._mcContainer[_loc10_].removeMovieClip();
      var _loc11_ = nCellNum * 100 + 50;
      this._mcContainer.createEmptyMovieClip(_loc10_,_loc11_ + _loc8_ * _loc9_);
      var _loc12_ = this._mcContainer[_loc10_];
      _loc12_.createEmptyMovieClip("mc",10);
      _loc12_._visible = (bVisible != undefined ? bVisible : true) && (this.api.electron.isWindowFocused || !this.api.kernel.OptionsManager.getOption("AntiLagHideSpellAnimation"));
      _loc12_.sprite = sprite;
      _loc12_.targetSprite = targetSprite;
      _loc12_.cellNum = nCellNum;
      _loc12_.displayType = displayType;
      _loc12_.level = oVisualEffect.level;
      _loc12_.params = oVisualEffect.params;
      var _loc13_;
      if(oVisualEffect.bTryToBypassContainerColor == true)
      {
         _loc13_ = new Color(_loc12_);
         _loc13_.setTransform({ra:200,rb:0,ga:200,gb:0,ba:200,bb:0});
      }
      this._mcl.loadClip(oVisualEffect.file,_loc12_.mc);
      ank.utils.Timer.setTimer(_loc12_,"battlefield",_loc12_,_loc12_.removeMovieClip,ank.battlefield.Constants.VISUAL_EFFECT_MAX_TIMER);
   }
   function onLoadInit(mc)
   {
      var _loc3_ = mc._parent;
      if(!_loc3_._visible)
      {
         mc._visible = false;
      }
      var _loc4_ = _loc3_.sprite;
      var _loc5_ = _loc3_.targetSprite;
      var _loc6_ = _loc3_.cellNum;
      var displayType = _loc3_.displayType;
      var _loc7_ = _loc3_.level;
      var _loc8_ = _loc3_.params;
      var _loc9_ = _loc3_.ignoreTargetInHeight;
      var _loc10_ = _loc4_.cellNum;
      var _loc11_ = this._mcBattlefield.mapHandler.getCellData(_loc10_);
      var _loc12_ = this._mcBattlefield.mapHandler.getCellData(_loc6_);
      var _loc13_ = _loc4_ ? {x:_loc4_.mc._x,y:_loc4_.mc._y} : {x:_loc11_.x,y:_loc11_.y};
      var _loc14_ = _loc5_ ? {x:_loc5_.mc._x,y:_loc5_.mc._y} : {x:_loc12_.x,y:_loc12_.y};
      var bTripleFramerate = dofus.Constants.TRIPLEFRAMERATE;
      var DEG = 180 / Math.PI;
      var _loc15_ = Math.PI / 2;
      var _loc16_ = Math.atan2;
      var atan = Math.atan;
      var abs = Math.abs;
      var _loc17_ = Math.sqrt;
      var _loc18_ = Math.tan;
      mc.level = _loc7_;
      mc.angle = _loc16_(_loc14_.y - _loc13_.y,_loc14_.x - _loc13_.x) * DEG;
      mc.params = _loc8_;
      var _loc19_;
      var _loc20_;
      var _loc21_;
      var _loc22_;
      var _loc23_;
      var _loc24_;
      var _loc25_;
      var _loc26_;
      var _loc27_;
      var _loc28_;
      var _loc29_;
      switch(displayType)
      {
         case 10:
         case 12:
            mc._ACTION = _loc4_;
            mc._x = _loc13_.x;
            mc._y = _loc13_.y;
            break;
         case 11:
            mc._ACTION = _loc4_;
            mc._x = _loc14_.x;
            mc._y = _loc14_.y;
            break;
         case 20:
         case 21:
            mc._x = _loc13_.x;
            mc._y = _loc13_.y;
            mc.rotate._rotation = mc.angle;
            _loc19_ = mc.attachMovie("shoot","shoot",10);
            _loc19_._x = _loc14_.x - _loc13_.x;
            _loc19_._y = _loc14_.y - _loc13_.y;
            break;
         case 30:
         case 31:
            mc._ACTION = _loc4_;
            mc._x = _loc13_.x;
            mc._y = _loc13_.y - 10;
            _loc20_ = !(displayType == 31 || displayType == 33) ? 0.5 : 0.9;
            var speed = !(displayType == 31 || displayType == 33) ? 0.675 : 0.5;
            if(bTripleFramerate)
            {
               speed /= 3;
            }
            _loc21_ = _loc14_.x - _loc13_.x;
            _loc22_ = _loc14_.y - _loc13_.y;
            _loc23_ = (_loc16_(_loc22_,abs(_loc21_)) + _loc15_) * _loc20_;
            _loc24_ = _loc23_ - _loc15_;
            var xDest = abs(_loc21_);
            var yDest = _loc22_;
            mc.startangle = _loc24_;
            if(_loc21_ <= 0)
            {
               if(_loc21_ == 0 && _loc22_ < 0)
               {
                  mc._yscale = - mc._yscale;
                  yDest = - yDest;
               }
               mc._xscale = - mc._xscale;
            }
            mc.attachMovie("move","move",2);
            var vyi;
            var x;
            var y;
            var g = 9.81;
            var halfg = g * 0.5;
            var t = 0;
            var vx = _loc17_(abs(halfg * (xDest * xDest) / abs(yDest - _loc18_(_loc24_) * xDest)));
            var vy = _loc18_(_loc24_) * vx;
            var invVx = 1 / vx;
            mc.onEnterFrame = function()
            {
               vyi = vy + g * t;
               x = t * vx;
               y = halfg * (t * t) + vy * t;
               t += speed;
               if(abs(y) >= abs(yDest) && x >= xDest || x > xDest)
               {
                  this.attachMovie("shoot","shoot",2);
                  this.shoot._x = xDest;
                  this.shoot._y = yDest;
                  this.shoot._rotation = atan(vyi * invVx) * DEG;
                  this.end();
                  delete this.onEnterFrame;
               }
               else
               {
                  this.move._x = x;
                  this.move._y = y;
                  this.move._rotation = atan(vyi * invVx) * DEG;
               }
            };
            break;
         case 40:
         case 41:
            mc._ACTION = _loc4_;
            mc._x = _loc13_.x;
            mc._y = _loc13_.y;
            _loc25_ = 20;
            if(bTripleFramerate)
            {
               _loc25_ /= 3;
            }
            var xStart = _loc13_.x;
            var yStart = _loc13_.y;
            var xDest = _loc14_.x;
            var yDest = _loc14_.y;
            _loc26_ = _loc16_(yDest - yStart,xDest - xStart);
            var cosRot = Math.cos(_loc26_);
            var sinRot = Math.sin(_loc26_);
            _loc27_ = xStart - xDest;
            _loc28_ = yStart - yDest;
            var fullDist = _loc17_(_loc27_ * _loc27_ + _loc28_ * _loc28_);
            var interval = fullDist / Math.floor(fullDist / _loc25_);
            var dist = 0;
            var inc = 1;
            _loc29_ = false;
            var nFramesToIgnore = !bTripleFramerate ? 0 : 2;
            var nCurrentFrameState = 0;
            mc.onEnterFrame = function()
            {
               dist += interval;
               var _loc2_;
               if(!bTripleFramerate || nCurrentFrameState == 0)
               {
                  if(dist > fullDist)
                  {
                     this.end();
                     if(displayType == 41)
                     {
                        this.attachMovie("shoot","shoot",10);
                        this.shoot._x = xDest - xStart;
                        this.shoot._y = yDest - yStart;
                     }
                     delete this.onEnterFrame;
                  }
                  else
                  {
                     _loc2_ = this.attachMovie("duplicate","duplicate" + inc,inc);
                     _loc2_._x = dist * cosRot;
                     _loc2_._y = dist * sinRot;
                     inc++;
                  }
                  nCurrentFrameState = nFramesToIgnore;
               }
               else
               {
                  nCurrentFrameState--;
               }
            };
            break;
         case 50:
         case 51:
            mc._ACTION = _loc4_;
            mc.cellFrom = _loc13_;
            mc.cellTo = _loc14_;
         default:
            return;
      }
   }
   function getNextIndex(Void)
   {
      this._incIndex = this._incIndex + 1;
      if(this._incIndex > ank.battlefield.VisualEffectHandler.MAX_INDEX)
      {
         this._incIndex = 0;
      }
      return this._incIndex;
   }
}
