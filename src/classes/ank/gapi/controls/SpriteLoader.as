class ank.gapi.controls.SpriteLoader extends ank.gapi.controls.Loader
{
   var _aAccessories;
   var _aColors;
   var _bFlip;
   var _oSpriteData;
   var _sAnimation;
   var _visible;
   var addToQueue;
   var api;
   var dispatchEvent;
   var holder_mc;
   static var CLASS_NAME = "SpriteLoader";
   static var BASE_SIZE = 100;
   var _bLoaded = false;
   function SpriteLoader()
   {
      super();
   }
   function set gfxID(nGfxID)
   {
      if(nGfxID <= 0)
      {
         return;
      }
      var _loc3_ = dofus.Constants.CLIPS_PERSOS_PATH + nGfxID + ".swf";
      this._sURL = _loc3_;
      if(this._bAutoLoad)
      {
         this.load();
      }
   }
   function set contentPath(nGfxID)
   {
      this.gfxID = nGfxID;
   }
   function set animation(sAnimation)
   {
      this._sAnimation = sAnimation;
      if(this._bLoaded)
      {
         this.updateSprite();
      }
   }
   function set flip(bFlip)
   {
      this._bFlip = bFlip;
      if(this._bLoaded)
      {
         this.size();
      }
   }
   function set colors(aColors)
   {
      if(typeof (aColors == String))
      {
         aColors = String(aColors).split(",");
      }
      this._aColors = aColors;
      if(this._bLoaded)
      {
         this.applyColors(aColors);
      }
   }
   function set accessories(aAccessories)
   {
      if(typeof (aAccessories == String))
      {
         aAccessories = String(aAccessories).split(",");
      }
      this._aAccessories = aAccessories;
      if(this._bLoaded)
      {
         this.updateSprite();
      }
   }
   function set spriteData(oSpriteData)
   {
      this._oSpriteData = oSpriteData;
      if(this._bLoaded)
      {
         this.updateSprite();
      }
   }
   function createChildren()
   {
      super.createChildren();
      this.api = _global.API;
      this._oSpriteData = {};
      _global.GAC.addSprite(this,this._oSpriteData);
   }
   function updateSprite(mc_)
   {
      if(mc_ == undefined)
      {
         mc_ = this.holder_mc.content_mc;
      }
      mc_.mcAnim.removeMovieClip();
      var _loc3_ = mc_.attachMovie(this._sAnimation,"mcAnim",10);
      var _loc4_;
      if(_loc3_._totalframes == 1)
      {
         _loc4_ = this.recursiveFindMovieclipChild(_loc3_);
         _loc4_.gotoAndStop("static");
         if(_loc4_._currentframe == 1)
         {
            _loc4_.gotoAndStop(_loc4_._totalframes);
         }
      }
      this.applyColors(this._aColors);
      this.applyAccessories(this._aAccessories);
      this.addToQueue({object:this,method:this.size});
   }
   function recursiveFindMovieclipChild(mc_)
   {
      var _loc3_;
      for(var n in mc_)
      {
         if(typeof mc_[n] == "movieclip")
         {
            _loc3_ = mc_[n];
            if(_loc3_._totalframes == 1)
            {
               return this.recursiveFindMovieclipChild(_loc3_);
            }
            return _loc3_;
         }
      }
      return mc_;
   }
   function applyColors(aColors)
   {
      if(aColors == undefined || (aColors.length == 0 || aColors == [-1,-1,-1]))
      {
         return undefined;
      }
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      while(_loc3_ < aColors.length)
      {
         _loc4_ = aColors[_loc3_];
         _loc5_ = _loc3_ + 1;
         this._oSpriteData["color" + _loc5_] = _loc4_;
         _loc3_ = _loc3_ + 1;
      }
   }
   function applyAccessories(aAccessories)
   {
      if(aAccessories.length == 0 || aAccessories == [0,0,0,0])
      {
         return undefined;
      }
      var _loc3_ = [];
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      while(_loc4_ < aAccessories.length)
      {
         if(String(aAccessories[_loc4_]).length != 0)
         {
            _loc5_ = _global.parseInt(aAccessories[_loc4_],16);
            _loc6_ = this.api.lang.getItemUnicText(_loc5_).t;
            _loc3_[_loc4_] = new dofus.datacenter.Accessory(_loc5_,_loc6_);
         }
         _loc4_ = _loc4_ + 1;
      }
      this._oSpriteData.accessories = _loc3_;
   }
   function size()
   {
      if(!this._bLoaded)
      {
         return undefined;
      }
      var _loc2_ = this.holder_mc.content_mc;
      if(_loc2_ == undefined || _loc2_._width <= 0)
      {
         return undefined;
      }
      var _loc3_ = _loc2_.getBounds(_loc2_);
      var _loc4_ = _loc3_.xMax - _loc3_.xMin;
      var _loc5_ = _loc3_.yMax - _loc3_.yMin;
      var _loc6_ = Math.min(ank.gapi.controls.SpriteLoader.BASE_SIZE / _loc4_,ank.gapi.controls.SpriteLoader.BASE_SIZE / _loc5_);
      _loc2_._xscale = !this._bFlip ? _loc6_ * 100 : (- _loc6_) * 100;
      _loc2_._yscale = _loc6_ * 100;
      _loc2_._x = 0;
      _loc2_._y = 0;
      _loc3_ = _loc2_.getBounds(this.holder_mc);
      _loc2_._x = (ank.gapi.controls.SpriteLoader.BASE_SIZE - (_loc3_.xMax - _loc3_.xMin)) / 2 - _loc3_.xMin;
      _loc2_._y = ank.gapi.controls.SpriteLoader.BASE_SIZE - _loc3_.yMax;
      this._visible = true;
   }
   function removeSprite()
   {
      super.contentPath = "";
   }
   function onLoadInit(mc_)
   {
      this.updateSprite(mc_);
      this.dispatchEvent({type:"initialization",clip:(!mc_.clip ? mc_ : mc_.clip)});
   }
}
