187835424 - 1;
class ank.battlefield.GlobalSpriteHandler extends dofus.utils.ApiElement
{
   var _aFrameToGo;
   var _mclLoader;
   var _oSprites;
   var _sAccessoriesPath;
   var api;
   var _oMapPolykrome = {};
   var _oMapGuild = {};
   function GlobalSpriteHandler(oAPI)
   {
      super();
      this.initialize(oAPI);
   }
   function initialize(oAPI)
   {
      super.initialize(oAPI);
      this._oSprites = {};
      this._mclLoader = new MovieClipLoader();
      this._mclLoader.addListener(this);
      this._aFrameToGo = [];
      this._oMapPolykrome["10"] = {head:3,body:1,bottom:2};
      this._oMapPolykrome["11"] = {head:3,body:1,bottom:2};
      this._oMapPolykrome["20"] = {head:2,body:3,bottom:1};
      this._oMapPolykrome["21"] = {head:2,body:3,bottom:1};
      this._oMapPolykrome["30"] = {head:3,body:1,bottom:2};
      this._oMapPolykrome["31"] = {head:3,body:1,bottom:2};
      this._oMapPolykrome["40"] = {head:2,body:3,bottom:1};
      this._oMapPolykrome["41"] = {head:2,body:3,bottom:1};
      this._oMapPolykrome["50"] = {head:2,body:3,bottom:1};
      this._oMapPolykrome["51"] = {head:2,body:3,bottom:1};
      this._oMapPolykrome["60"] = {head:2,body:3,bottom:1};
      this._oMapPolykrome["61"] = {head:1,body:3,bottom:2};
      this._oMapPolykrome["70"] = {head:2,body:3,bottom:1};
      this._oMapPolykrome["71"] = {head:2,body:3,bottom:1};
      this._oMapPolykrome["80"] = {head:2,body:3,bottom:1};
      this._oMapPolykrome["81"] = {head:2,body:3,bottom:1};
      this._oMapPolykrome["90"] = {head:1,body:2,bottom:3};
      this._oMapPolykrome["91"] = {head:1,body:2,bottom:3};
      this._oMapPolykrome["100"] = {head:3,body:2,bottom:1};
      this._oMapPolykrome["101"] = {head:1,body:3,bottom:2};
      this._oMapPolykrome["110"] = {head:2,body:3,bottom:1};
      this._oMapPolykrome["111"] = {head:2,body:3,bottom:1};
      this._oMapPolykrome["120"] = {head:1,body:3,bottom:2};
      this._oMapPolykrome["121"] = {head:1,body:3,bottom:2};
      this._oMapPolykrome["8010"] = {head:1,body:3,bottom:2};
      this._oMapPolykrome["8011"] = {head:1,body:3,bottom:2};
      this._oMapPolykrome["1264"] = {head:1,body:3,bottom:2};
      this._oMapPolykrome["7030"] = {head:1,body:3,bottom:2};
      this._oMapPolykrome["7031"] = {head:1,body:3,bottom:2};
   }
   function setAccessoriesRoot(path)
   {
      this._sAccessoriesPath = path;
   }
   function addSprite(mcSprite, oSpriteData)
   {
      this._oSprites[mcSprite._target] = {mc:mcSprite,data:oSpriteData};
      this.garbageCollector();
   }
   function setColors(mc, color1, color2, color3)
   {
      var _loc6_ = this._oSprites[mc._target].data;
      if(color1 != -1)
      {
         _loc6_.color1 = color1;
      }
      if(color2 != -1)
      {
         _loc6_.color2 = color2;
      }
      if(color3 != -1)
      {
         _loc6_.color3 = color3;
      }
   }
   function setAccessories(mc, aAccessories)
   {
      var _loc4_ = this._oSprites[mc._target].data;
      if(aAccessories)
      {
         _loc4_.accessories = aAccessories;
      }
   }
   function applyColor(mc, nZone, isMount)
   {
      var _loc5_ = this.getSpriteData(mc);
      if(!_loc5_)
      {
         return undefined;
      }
      var _loc6_ = "color" + nZone;
      var _loc7_ = !(isMount && _loc5_.mount) ? _loc5_[_loc6_] : _loc5_.mount[_loc6_];
      if(_loc7_ == undefined)
      {
         return undefined;
      }
      var _loc8_;
      if(_loc7_ == -1)
      {
         if(!this.hasFallbackColor(mc))
         {
            return undefined;
         }
         _loc8_ = this.getClassTextFromSpriteData(_loc5_);
         if(_loc8_ == undefined)
         {
            return undefined;
         }
         if(isMount && _loc5_.mount)
         {
            switch(nZone)
            {
               case 1:
                  nZone = 2;
                  break;
               case 2:
               case 3:
                  nZone = 3;
            }
         }
         _loc7_ = Number(_loc8_["p" + _loc5_.Sex]["c" + nZone]);
         if(_global.isNaN(_loc7_))
         {
            return undefined;
         }
      }
      var _loc9_ = new Color(mc);
      _loc9_.setTransform({ra:0,rb:_loc7_ >> 16 & 0xFF,ga:0,gb:_loc7_ >> 8 & 0xFF,ba:0,bb:_loc7_ & 0xFF,aa:100,ab:0});
   }
   function hasFallbackColor(mc_)
   {
      var _loc3_ = mc_._url;
      if(_loc3_.indexOf("/sprites/accessories/") != -1)
      {
         return true;
      }
      var _loc4_ = _loc3_.indexOf("/sprites/");
      if(_loc4_ == -1)
      {
         return false;
      }
      var _loc5_ = Number(_loc3_.substring(_loc4_ + 9,_loc3_.length - 4));
      if(_global.isNaN(_loc5_))
      {
         return false;
      }
      return _loc5_ >= 7000 && _loc5_ <= 7027;
   }
   function getClassTextFromSpriteData(d_)
   {
      var _loc3_ = this.api.lang.getClassText(d_.Guild);
      var _loc4_;
      var _loc5_;
      if(_loc3_ == undefined)
      {
         _loc4_ = d_.gfxFileName;
         _loc5_ = _loc4_.length;
         d_.Guild = Number(_loc4_.slice(0,_loc5_ - 1));
         d_.Sex = Number(_loc4_.charAt(_loc5_ - 1));
         _loc3_ = this.api.lang.getClassText(d_.Guild);
      }
      return _loc3_;
   }
   function getColorIndex(nSpriteGfxID, sBodyPart)
   {
      var _loc4_ = this._oMapPolykrome[nSpriteGfxID];
      if(_loc4_)
      {
         return _loc4_[sBodyPart] || -1;
      }
      return -1;
   }
   function applyColorForBodyPart(mc_, sBodyPart)
   {
      var _loc4_ = this.getSpriteData(mc_);
      if(_loc4_ == undefined)
      {
         return undefined;
      }
      var _loc5_ = this.getColorIndex(_loc4_.gfxID != undefined ? _loc4_.gfxID : _loc4_.gfxFileName,sBodyPart);
      if(_loc5_ == -1)
      {
         return undefined;
      }
      this.applyColor(mc_,_loc5_);
   }
   function applyBottomColor(mc_)
   {
      this.applyColorForBodyPart(mc_,"bottom");
   }
   function applyBodyColor(mc_)
   {
      this.applyColorForBodyPart(mc_,"body");
   }
   function applyHeadColor(mc_)
   {
      this.applyColorForBodyPart(mc_,"head");
   }
   function applyAccessory(mc, accessoryID, side, mcToHide, bFix)
   {
      if(bFix == undefined)
      {
         bFix = false;
      }
      var _loc7_ = this.getSpriteData(mc);
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      if(_loc7_ != undefined)
      {
         _loc8_ = dofus.datacenter.Accessory(_loc7_.accessories[accessoryID]);
         if(_loc8_.canBeHide && this.api.kernel.OptionsManager.getOption("HideOptionalItem"))
         {
            return undefined;
         }
         _loc9_ = _loc8_.gfx;
         mc.clip.removeMovieClip();
         if(bFix)
         {
            switch(_loc7_.direction)
            {
               case 3:
               case 4:
               case 7:
                  mc._x = - mc._x;
            }
         }
         if(_loc9_ != undefined)
         {
            if(mcToHide)
            {
               mcToHide.gotoAndStop(!(_loc9_.length == 0 || _loc9_ == "_") ? 2 : 1);
            }
            if(!ank.battlefield.Constants.USE_STREAMING_FILES || ank.battlefield.Constants.STREAMING_METHOD == "compact")
            {
               mc.attachMovie(_loc9_,"clip",10);
               if(_loc7_.accessories[accessoryID].frame != undefined)
               {
                  mc.clip.gotoAndStop(side + _loc7_.accessories[accessoryID].frame);
               }
               else
               {
                  mc.clip.gotoAndStop(side);
               }
            }
            else
            {
               _loc10_ = _loc9_.split("_");
               if(_loc10_[0] == undefined || (_global.isNaN(Number(_loc10_[0])) || (_loc10_[1] == undefined || _global.isNaN(Number(_loc10_[1])))))
               {
                  return undefined;
               }
               _loc11_ = mc.createEmptyMovieClip("clip",10);
               if(_loc7_.skin !== undefined)
               {
                  this._aFrameToGo[_loc11_] = side + _loc7_.skin;
               }
               else
               {
                  this._aFrameToGo[_loc11_] = side;
               }
               this._mclLoader.loadClip(this._sAccessoriesPath + _loc10_.join("/") + ".swf",_loc11_);
            }
         }
      }
   }
   function applyAnim(mc, sAnim)
   {
      var _loc4_ = this.getSpriteData(mc);
      if(_loc4_ != undefined)
      {
         if(_loc4_.bAnimLoop)
         {
            _loc4_.mc.saveLastAnimation(_loc4_.animation);
         }
         else
         {
            _loc4_.mc.setAnim(sAnim);
         }
      }
   }
   function applyEnd(mc)
   {
      var _loc3_ = this.getSpriteData(mc);
      if(_loc3_ != undefined)
      {
         if(!_loc3_.bAnimLoop)
         {
            if(_loc3_.isInSpellAnimation)
            {
               _loc3_.isInSpellAnimation = undefined;
               delete _loc3_.animTimer;
            }
            _loc3_.sequencer.onActionEnd();
         }
      }
   }
   function applySprite(mc)
   {
      var _loc3_ = this.getSpriteData(mc);
      switch(_loc3_.direction)
      {
         case 0:
         case 4:
            mc.attachMovie(_loc3_.animation + "S","clip",1);
            break;
         case 1:
         case 3:
            mc.attachMovie(_loc3_.animation + "R","clip",1);
            break;
         case 2:
            mc.attachMovie(_loc3_.animation + "F","clip",1);
            break;
         case 5:
         case 7:
            mc.attachMovie(_loc3_.animation + "L","clip",1);
            break;
         case 6:
            mc.attachMovie(_loc3_.animation + "B","clip",1);
         default:
            return;
      }
   }
   function registerCarried(mc)
   {
      var _loc3_ = this.getSpriteData(mc);
      _loc3_.mc.mcCarried = mc;
   }
   function registerChevauchor(mc)
   {
      var _loc3_ = this.getSpriteData(mc);
      _loc3_.mc.mcChevauchorPos = mc;
      _loc3_.mc.updateChevauchorPosition();
   }
   function getSpriteData(mc)
   {
      var _loc3_ = mc._target;
      for(var name in this._oSprites)
      {
         if(_loc3_.substring(0,name.length) == name)
         {
            if(_loc3_.charAt(name.length) == "/")
            {
               if(this._oSprites[name] != undefined)
               {
                  return this._oSprites[name].data;
               }
            }
         }
      }
   }
   function garbageCollector(Void)
   {
      for(var o in this._oSprites)
      {
         if(this._oSprites[o].mc._target == undefined)
         {
            delete this._oSprites[o];
         }
      }
   }
   function recursiveGotoAndStop(mc, frame)
   {
      mc.stop();
      mc.gotoAndStop(frame);
      for(var i in mc)
      {
         if(mc[i] instanceof MovieClip)
         {
            this.recursiveGotoAndStop(mc[i],frame);
         }
      }
   }
   function onLoadInit(mc)
   {
      this.recursiveGotoAndStop(mc,this._aFrameToGo[mc]);
      delete this._aFrameToGo[mc];
   }
}
