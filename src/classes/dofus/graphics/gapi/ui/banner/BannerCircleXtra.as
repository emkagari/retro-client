class dofus.graphics.gapi.ui.banner.BannerCircleXtra extends ank.gapi.core.UIBasicComponent
{
   var _api;
   var _banner;
   function BannerCircleXtra(api, uiBanner)
   {
      super();
      this._api = api;
      this._banner = uiBanner;
   }
   function get api()
   {
      return this._api;
   }
   function setMiniMapScale(nScale)
   {
      if(this._banner._sCurrentCircleXtra != "map")
      {
         return undefined;
      }
      this._banner._mcXtra.setScale(nScale,true);
   }
   function checkMouseOnMiniMap()
   {
      if(this._banner._sCurrentCircleXtra != "map")
      {
         return undefined;
      }
      if(this._banner._mcXtra.isHittingBackground())
      {
         return undefined;
      }
      if(!this._banner._bHeartMovedTop)
      {
         return undefined;
      }
      this._banner.moveHeart(false);
      if(!this.api.datacenter.Game.isFight && this.api.kernel.OptionsManager.getOption("BannerGaugeMode") == "none")
      {
         this.setXtraMask(this._banner._mcCircleXtraMaskBig);
      }
      else
      {
         this.setXtraMask(this._banner._mcCircleXtraMask);
      }
      dofus.graphics.gapi.ui.banner.BannerGauge.showGaugeMode(this._banner);
   }
   function setXtraFightMask(bInFight)
   {
      this._banner._mcChronoGrid._visible = bInFight;
      if(!bInFight)
      {
         this.setXtraMask(this._banner._mcCircleXtraMaskBig);
         if(this._banner._mcCurrentXtraMask == this._banner._mcCircleXtraMaskBig)
         {
            this._banner._ccChrono.setGaugeChrono(100,2109246);
         }
      }
      else
      {
         this.setXtraMask(this._banner._mcCircleXtraMask);
      }
      if(this._banner._mcCurrentXtraMask == this._banner._mcCircleXtraMaskBig)
      {
         if(this._banner._bHeartMovedTop)
         {
            this.setMiniMapScale(dofus.graphics.gapi.controls.MiniMap.SCALE_BIG);
         }
         else
         {
            this.setMiniMapScale(dofus.graphics.gapi.controls.MiniMap.SCALE_NORMAL);
         }
      }
      else
      {
         this.setMiniMapScale(dofus.graphics.gapi.controls.MiniMap.SCALE_SMALL);
      }
      this._banner.displayMovableBar(this.api.kernel.OptionsManager.getOption("MovableBar") && (!this.api.kernel.OptionsManager.getOption("HideSpellBar") || this.api.datacenter.Game.isFight));
   }
   function setXtraMask(mcNewMask)
   {
      this._banner._mcCurrentXtraMask = mcNewMask;
      this._banner._mcXtra.setMask(mcNewMask);
   }
   function setCircleXtraParams(oParams)
   {
      for(var k in oParams)
      {
         this._banner._mcXtra[k] = oParams[k];
      }
   }
   function setXtraMaskOverweight(bOverweight)
   {
      if(bOverweight)
      {
         this.setMovieClipColor(this._banner._mcCircleXtraMaskBig,16737792);
      }
      else
      {
         this.setMovieClipColor(this._banner._mcCircleXtraMaskBig,5327420);
      }
   }
   function updateArtwork(bForceReload)
   {
      var _loc3_;
      if(this._banner._sCurrentCircleXtra == "artwork")
      {
         if(bForceReload)
         {
            this.showCircleXtra(this._banner._sCurrentCircleXtra,false);
            this.showCircleXtra("artwork",true,{bMask:true});
         }
         else
         {
            _loc3_ = dofus.Constants.GUILDS_FACES_PATH + this.api.datacenter.Player.Guild + this.api.datacenter.Player.Sex + ".swf";
            this._banner._mcXtra.fallbackContentPath = _loc3_;
            this._banner._mcXtra.contentPath = dofus.Constants.GUILDS_FACES_PATH + this._banner._oData.data.gfxFileName + ".swf";
         }
      }
   }
   function showCircleXtra(sXtraName, bShow, oParams, oComponentParams)
   {
      if(sXtraName == undefined)
      {
         return null;
      }
      if(sXtraName == this._banner._sCurrentCircleXtra && bShow)
      {
         return null;
      }
      if(sXtraName != this._banner._sCurrentCircleXtra && !bShow)
      {
         return null;
      }
      if(this._banner._sCurrentCircleXtra != undefined && bShow)
      {
         this.showCircleXtra(this._banner._sCurrentCircleXtra,false);
      }
      var _loc8_ = {};
      var _loc9_ = [];
      if(oComponentParams == undefined)
      {
         oComponentParams = {};
      }
      this.api.kernel.OptionsManager.setOption("BannerIllustrationMode",sXtraName);
      if(this._banner._nMiniMapCheckInterval != undefined)
      {
         _global.clearInterval(this._banner._nMiniMapCheckInterval);
      }
      var _loc10_;
      var _loc6_;
      var _loc11_;
      switch(sXtraName)
      {
         case "artwork":
            _loc10_ = dofus.Constants.GUILDS_FACES_PATH + this.api.datacenter.Player.Guild + this.api.datacenter.Player.Sex + ".swf";
            _loc6_ = "GAPILoader";
            _loc8_ = {_x:this._banner._mcCircleXtraMask._x,_y:this._banner._mcCircleXtraMask._y,fallbackContentPath:_loc10_,contentPath:dofus.Constants.GUILDS_FACES_PATH + this._banner._oData.data.gfxFileName + ".swf",enabled:true};
            _loc9_ = ["complete","click","over","out"];
            break;
         case "compass":
            _loc11_ = this.api.datacenter.Map;
            _loc6_ = "Compass";
            _loc8_ = {_x:this._banner._mcCircleXtraPlacer._x,_y:this._banner._mcCircleXtraPlacer._y,_width:this._banner._mcCircleXtraPlacer._width,_height:this._banner._mcCircleXtraPlacer._height,arrow:"UI_BannerCompassArrow",noArrow:"UI_BannerCompassNoArrow",background:"UI_BannerCompassBack",targetCoords:this.api.datacenter.Basics.banner_targetCoords,currentCoords:[_loc11_.x,_loc11_.y]};
            _loc9_ = ["click","over","out"];
            break;
         case "clock":
            _loc6_ = "Clock";
            _loc8_ = {_x:this._banner._mcCircleXtraPlacer._x,_y:this._banner._mcCircleXtraPlacer._y,_width:this._banner._mcCircleXtraPlacer._width,_height:this._banner._mcCircleXtraPlacer._height,arrowHours:"UI_BannerClockArrowHours",arrowMinutes:"UI_BannerClockArrowMinutes",background:"UI_BannerClockBack",updateFunction:{object:this.api.kernel.NightManager,method:this.api.kernel.NightManager.getCurrentTime}};
            _loc9_ = ["click","over","out"];
            break;
         case "helper":
            _loc6_ = "GAPILoader";
            if(dofus.Constants.TRIPLEFRAMERATE)
            {
               _loc8_ = {_x:this._banner._mcCircleXtraPlacer._x,_y:this._banner._mcCircleXtraPlacer._y,contentPath:"Helper_TripleFramerate",enabled:true};
            }
            else
            {
               _loc8_ = {_x:this._banner._mcCircleXtraPlacer._x,_y:this._banner._mcCircleXtraPlacer._y,contentPath:"Helper",enabled:true};
            }
            _loc9_ = ["click","over","out"];
            break;
         case "map":
            this._banner._nMiniMapCheckInterval = _global.setInterval(this,"checkMouseOnMiniMap",dofus.graphics.gapi.ui.Banner.CHECK_MOUSE_POSITION_REFRESH_RATE);
            _loc6_ = "MiniMap";
            _loc8_ = {_x:this._banner._mcCircleXtraPlacer._x,_y:this._banner._mcCircleXtraPlacer._y,contentPath:"Map",enabled:true};
            _loc9_ = ["over","click"];
            break;
         default:
            _loc6_ = "GAPILoader";
            _loc8_ = {_x:this._banner._mcCircleXtraPlacer._x,_y:this._banner._mcCircleXtraPlacer._y,_width:this._banner._mcCircleXtraPlacer._width,_height:this._banner._mcCircleXtraPlacer._height};
      }
      var _loc12_ = null;
      if(bShow)
      {
         for(var k in _loc8_)
         {
            oComponentParams[k] = _loc8_[k];
         }
         _loc12_ = this._banner.attachMovie(_loc6_,"_mcXtra",this._banner.getNextHighestDepth(),oComponentParams);
         this._banner._sCurrentCircleXtra = sXtraName;
         if(oParams.bMask)
         {
            this._banner._sDefaultMaskType = oParams.sMaskSize;
            if(!this.api.datacenter.Game.isFight && this.api.kernel.OptionsManager.getOption("BannerGaugeMode") == "none")
            {
               this.setXtraMask(this._banner._mcCircleXtraMaskBig);
            }
            else
            {
               this.setXtraMask(this._banner._mcCircleXtraMask);
            }
         }
         for(var k in _loc9_)
         {
            this._banner._mcXtra.addEventListener(_loc9_[k],this._banner);
         }
         this._banner._mcXtra.swapDepths(this._banner._mcCircleXtraPlacer);
      }
      else if(this._banner._mcXtra != undefined)
      {
         for(var k in _loc9_)
         {
            this._banner._mcXtra.removeEventListener(_loc9_[k],this._banner);
         }
         this._banner._mcCircleXtraPlacer.swapDepths(this._banner._mcXtra);
         this._banner._mcXtra.removeMovieClip();
         delete this._banner._sCurrentCircleXtra;
      }
      if(oParams.bUpdateGauge)
      {
         dofus.graphics.gapi.ui.banner.BannerGauge.showGaugeMode(this._banner);
      }
      return _loc12_;
   }
}
