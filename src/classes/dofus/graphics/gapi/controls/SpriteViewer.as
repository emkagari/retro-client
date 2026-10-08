class dofus.graphics.gapi.controls.SpriteViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _alpha;
   var _bEnableBackground;
   var _ldrSpriteA;
   var _ldrSpriteB;
   var _mcBackground;
   var _mcCurrentSprite;
   var _mcInteraction;
   var _mcOtherSprite;
   var _mcSpriteA;
   var _mcSpriteB;
   var _nInterval;
   var _oSourceSpriteData;
   var _oSpriteData;
   var _parent;
   var addToQueue;
   var initialized;
   var mcOther;
   var onEnterFrame;
   static var CLASS_NAME = "SpriteViewer";
   var REFRESH_DELAY = 500;
   var SPRITE_ANIMS = ["StaticF","StaticR","StaticL","WalkF","RunF","Anim2R","Anim2L"];
   var _bEnableBlur = true;
   var _nZoom = 200;
   var _bAllowAnimations = true;
   var _bUseSingleLoader = false;
   var _bNoDelay = false;
   var _nSpriteAnimIndex = 0;
   var _bCurrentSprite = false;
   var _bRefreshAccessories = true;
   function SpriteViewer()
   {
      super();
   }
   function get spriteData()
   {
      return this._oSpriteData;
   }
   function set spriteData(oData)
   {
      if(oData.isMounting)
      {
         this.enableBlur = false;
      }
      this._oSpriteData = oData;
      if(this.initialized)
      {
         this.refreshDisplay();
      }
   }
   function get sourceSpriteData()
   {
      return this._oSourceSpriteData;
   }
   function set sourceSpriteData(oData)
   {
      if(this.initialized)
      {
         this.removeSpriteListeners();
      }
      this._oSourceSpriteData = oData;
      if(this.initialized)
      {
         this.addSpriteListeners();
      }
   }
   function get enableBlur()
   {
      return this._bEnableBlur;
   }
   function set enableBlur(bState)
   {
      this._bEnableBlur = bState;
      this._mcSpriteA.onEnterFrame = this._mcSpriteB.onEnterFrame = undefined;
      (!this._bCurrentSprite ? this._mcSpriteB : this._mcSpriteA)._alpha = 100;
      (this._bCurrentSprite ? this._mcSpriteB : this._mcSpriteA)._alpha = 0;
   }
   function get refreshAccessories()
   {
      return this._bRefreshAccessories;
   }
   function set refreshAccessories(bState)
   {
      this._bRefreshAccessories = bState;
   }
   function get zoom()
   {
      return this._nZoom;
   }
   function set zoom(nValue)
   {
      this._nZoom = nValue;
      if(this.initialized)
      {
         this.refreshDisplay();
      }
   }
   function get allowAnimations()
   {
      return this._bAllowAnimations;
   }
   function set allowAnimations(bState)
   {
      this._bAllowAnimations = bState;
      this._mcInteraction._visible = bState;
   }
   function get noDelay()
   {
      return this._bNoDelay;
   }
   function set noDelay(bState)
   {
      this._bNoDelay = bState;
   }
   function get spriteAnims()
   {
      return this.SPRITE_ANIMS;
   }
   function set spriteAnims(a)
   {
      this.SPRITE_ANIMS = a;
   }
   function get refreshDelay()
   {
      return this.REFRESH_DELAY;
   }
   function set refreshDelay(n)
   {
      this.REFRESH_DELAY = n;
   }
   function get useSingleLoader()
   {
      return this._bUseSingleLoader;
   }
   function set useSingleLoader(b)
   {
      this._bUseSingleLoader = b;
   }
   function get enableBackground()
   {
      return this._bEnableBackground;
   }
   function set enableBackground(b_)
   {
      this._bEnableBackground = b_;
      this.displayBackground(b_);
   }
   function refreshDisplay()
   {
      if(this._nInterval > 0)
      {
         _global.clearInterval(this._nInterval);
      }
      if(this._bNoDelay)
      {
         this.beginDisplay();
      }
      else
      {
         this._nInterval = _global.setInterval(this,"beginDisplay",this.REFRESH_DELAY);
      }
   }
   function getColor(nIndex)
   {
      return this._oSpriteData["color" + nIndex] != undefined ? this._oSpriteData["color" + nIndex] : -1;
   }
   function setColor(nIndex, nValue)
   {
      this._oSpriteData["color" + nIndex] = nValue;
      if(this._oSpriteData.isMounting && this._oSpriteData.mount.isChameleon)
      {
         switch(nIndex)
         {
            case 2:
               this._oSpriteData.mount.customColor1 = nValue;
               break;
            case 3:
               this._oSpriteData.mount.customColor2 = nValue;
               this._oSpriteData.mount.customColor3 = nValue;
         }
      }
      this.updateSprite();
   }
   function setColors(oColors)
   {
      this._oSpriteData.color1 = oColors.color1;
      this._oSpriteData.color2 = oColors.color2;
      this._oSpriteData.color3 = oColors.color3;
      if(this._oSpriteData.isMounting && this._oSpriteData.mount.isChameleon)
      {
         this._oSpriteData.mount.customColor1 = oColors.color2;
         this._oSpriteData.mount.customColor2 = oColors.color3;
         this._oSpriteData.mount.customColor3 = oColors.color3;
      }
      this.updateSprite();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.SpriteViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.refreshDisplay});
   }
   function addListeners()
   {
      this._ldrSpriteA.cacheAsBitmap = false;
      this._ldrSpriteB.cacheAsBitmap = false;
      this._ldrSpriteA.addEventListener("initialization",this);
      this._ldrSpriteB.addEventListener("initialization",this);
      this.addSpriteListeners();
      this._mcInteraction.onRelease = function()
      {
         this._parent.click({target:this});
      };
   }
   function removeSpriteListeners()
   {
      if(this._oSourceSpriteData == undefined)
      {
         return undefined;
      }
      if(this._oSourceSpriteData.isLocalPlayer)
      {
         this.api.datacenter.Player.removeEventListener("spriteDataChanged",this);
      }
      this._oSourceSpriteData.removeEventListener("gfxFileChanged",this);
   }
   function addSpriteListeners()
   {
      if(this._oSourceSpriteData == undefined)
      {
         return undefined;
      }
      if(this._oSourceSpriteData.isLocalPlayer)
      {
         this.api.datacenter.Player.addEventListener("spriteDataChanged",this);
      }
      this._oSourceSpriteData.addEventListener("gfxFileChanged",this);
      this._oSourceSpriteData.addEventListener("accessoriesChanged",this);
   }
   function beginDisplay()
   {
      _global.clearInterval(this._nInterval);
      this._nInterval = 0;
      if(this._oSpriteData == undefined)
      {
         return undefined;
      }
      var _loc2_;
      var _loc3_;
      if(this._bEnableBlur && !this._bUseSingleLoader)
      {
         _loc2_ = !this._bCurrentSprite ? this._ldrSpriteB : this._ldrSpriteA;
         this._bCurrentSprite = !this._bCurrentSprite;
         _loc3_ = !this._bCurrentSprite ? this._mcSpriteB : this._mcSpriteA;
      }
      else if(this._bUseSingleLoader)
      {
         _loc2_ = this._ldrSpriteA;
         this._bCurrentSprite = false;
      }
      else
      {
         _loc2_ = !this._bCurrentSprite ? this._ldrSpriteB : this._ldrSpriteA;
      }
      _loc2_.forceReload = true;
      _loc2_.content.removeMovieClip();
      var _loc4_ = _loc2_.holder.createEmptyMovieClip("content_mc",1);
      this._oSpriteData.mc = _loc4_.attachClassMovie(this._oSpriteData.clipClass,"sprite" + this._oSpriteData.id,1,[undefined,undefined,this._oSpriteData]);
      _loc2_.content = this._oSpriteData.mc;
      this._oSpriteData.mc.addEventListener("onLoadInit",_loc2_);
   }
   function attachAnimation(nIndex)
   {
      if(nIndex < 0)
      {
         nIndex = 0;
      }
      var _loc3_ = this.SPRITE_ANIMS[nIndex];
      var _loc4_ = ank.battlefield.mc.Sprite.getDirNumByChar(_loc3_.charAt(_loc3_.length - 1));
      this._oSpriteData.direction = _loc4_;
      _loc3_ = _loc3_.substring(0,_loc3_.length - 1);
      this._mcSpriteA.setAnim(_loc3_,true,true);
      this._mcSpriteB.setAnim(_loc3_,true,true);
   }
   function applyZoom()
   {
      if(this._mcSpriteA != undefined)
      {
         this._mcSpriteA.forcedXScale = this._mcSpriteA._yscale = this._nZoom;
      }
      if(this._mcSpriteB != undefined)
      {
         this._mcSpriteB.forcedXScale = this._mcSpriteB._yscale = this._nZoom;
      }
   }
   function playNextAnim(nStartingIndex)
   {
      if(nStartingIndex == undefined || _global.isNaN(nStartingIndex))
      {
         nStartingIndex = this._nSpriteAnimIndex;
      }
      this._nSpriteAnimIndex = nStartingIndex;
      this.attachAnimation(this._nSpriteAnimIndex);
      this._nSpriteAnimIndex = this._nSpriteAnimIndex + 1;
      if(this._nSpriteAnimIndex >= this.SPRITE_ANIMS.length)
      {
         this._nSpriteAnimIndex = 0;
      }
      this.applyZoom();
   }
   function updateSprite()
   {
      this.attachAnimation(this._nSpriteAnimIndex - 1);
      this.applyZoom();
   }
   function displayBackground(bEnabled)
   {
      this._mcBackground._visible = bEnabled;
   }
   function destroy()
   {
      _global.clearInterval(this._nInterval);
      this._nInterval = 0;
   }
   function initialization(oEvent)
   {
      var _loc0_;
      switch(oEvent.target._name)
      {
         case "_ldrSpriteA":
            var _temp_2 = this;
            var _temp_1 = "_mcCurrentSprite";
            this._mcSpriteA = _loc0_ = oEvent.clip;
            _temp_2[_temp_1] = _loc0_;
            this._mcOtherSprite = this._mcSpriteB;
            break;
         case "_ldrSpriteB":
            var _temp_4 = this;
            var _temp_3 = "_mcCurrentSprite";
            this._mcSpriteB = _loc0_ = oEvent.clip;
            _temp_4[_temp_3] = _loc0_;
            this._mcOtherSprite = this._mcSpriteA;
      }
      this.applyZoom();
      if(this._bEnableBlur)
      {
         this._mcOtherSprite._alpha = 100;
         this._mcCurrentSprite._alpha = 0;
         this._mcCurrentSprite.mcOther = this._mcOtherSprite;
         this._mcCurrentSprite.onEnterFrame = function()
         {
            this._alpha += 10;
            this.mcOther._alpha -= 30;
            if(this._alpha >= 100 && this.mcOther._alpha <= 0)
            {
               this._alpha = 100;
               this.mcOther._alpha = 0;
               this.onEnterFrame = undefined;
            }
         };
      }
      else
      {
         this._mcCurrentSprite._alpha = 100;
         if(this._mcOtherSprite != undefined)
         {
            this._mcOtherSprite._alpha = 0;
         }
      }
      this.addToQueue({object:this,method:this.playNextAnim,params:[0]});
   }
   function click(oEvent)
   {
      this.playNextAnim();
   }
   function spriteDataChanged(oEvent)
   {
      var _loc3_ = oEvent.value;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = new ank.battlefield.datacenter.Sprite("viewer",ank.battlefield.mc.Sprite,_loc3_.gfxFile,undefined,5);
      _loc4_.color1 = _loc3_.color1;
      _loc4_.color2 = _loc3_.color2;
      _loc4_.color3 = _loc3_.color3;
      _loc4_.accessories = _loc3_.accessories;
      _loc4_.mount = _loc3_.mount;
      this.sourceSpriteData = _loc3_;
      this.spriteData = _loc4_;
   }
   function gfxFileChanged(oEvent)
   {
      this._oSpriteData.gfxFile = oEvent.value;
      this.refreshDisplay();
   }
   function accessoriesChanged(oEvent)
   {
      if(!this._bRefreshAccessories)
      {
         return undefined;
      }
      this._oSpriteData.accessories = oEvent.value;
      this.refreshDisplay();
   }
}
