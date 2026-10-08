class dofus.graphics.gapi.controls.BannerSpriteInfos extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _lblAP;
   var _lblAir;
   var _lblAirCenter;
   var _lblAirFix;
   var _lblAverageDamages;
   var _lblDodgeAP;
   var _lblDodgeMP;
   var _lblEarth;
   var _lblEarthCenter;
   var _lblEarthFix;
   var _lblFire;
   var _lblFireCenter;
   var _lblFireFix;
   var _lblLP;
   var _lblLevel;
   var _lblMP;
   var _lblName;
   var _lblNeutral;
   var _lblNeutralCenter;
   var _lblNeutralFix;
   var _lblRes;
   var _lblStates;
   var _lblWater;
   var _lblWaterCenter;
   var _lblWaterFix;
   var _ldrBuff;
   var _ldrCandy;
   var _ldrSprite;
   var _nID;
   var _oSprite;
   var addToQueue;
   static var CLASS_NAME = "BannerSpriteInfos";
   static var STATES_ICONS_COUNT = 5;
   function BannerSpriteInfos()
   {
      super();
   }
   function set data(oData)
   {
      this._oSprite = oData;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.BannerSpriteInfos.CLASS_NAME);
   }
   function update(oData)
   {
      this.removeSpriteListeners();
      this.data = oData;
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.addSpriteListeners});
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.initData});
   }
   function addListeners()
   {
      this._ldrSprite.addEventListener("initialization",this);
      var _loc2_ = 1;
      var _loc3_;
      while(_loc2_ <= dofus.graphics.gapi.controls.BannerSpriteInfos.STATES_ICONS_COUNT)
      {
         _loc3_ = this["_ldrState" + _loc2_];
         _loc3_.addEventListener("initialization",this);
         _loc2_ = _loc2_ + 1;
      }
      this._ldrSprite.addEventListener("complete",this);
      this.addSpriteListeners();
   }
   function removeSpriteListeners()
   {
      this._oSprite.removeEventListener("apChanged",this);
      this._oSprite.removeEventListener("mpChanged",this);
      this._oSprite.removeEventListener("lpChanged",this);
      this._oSprite.removeEventListener("resistancesChanged",this);
      this._oSprite.removeEventListener("statesChanged",this);
   }
   function addSpriteListeners()
   {
      this._oSprite.addEventListener("apChanged",this);
      this._oSprite.addEventListener("mpChanged",this);
      this._oSprite.addEventListener("lpChanged",this);
      this._oSprite.addEventListener("resistancesChanged",this);
      this._oSprite.addEventListener("statesChanged",this);
   }
   function canUpdate(oEvent)
   {
      return this._oSprite.id == oEvent.id;
   }
   function apChanged(oEvent)
   {
      if(this.canUpdate(oEvent))
      {
         this._lblAP.text = String(Math.max(0,oEvent.value));
      }
   }
   function mpChanged(oEvent)
   {
      if(this.canUpdate(oEvent))
      {
         this._lblMP.text = String(Math.max(0,oEvent.value));
      }
   }
   function lpChanged(oEvent)
   {
      if(this.canUpdate(oEvent))
      {
         this._lblLP.text = String(oEvent.value);
      }
   }
   function resistancesChanged(oEvent)
   {
      this.updateResistances();
   }
   function statesChanged(oEvent)
   {
      this.updateStates();
   }
   function initTexts()
   {
      this._lblWater.text = this.api.lang.getText("RESISTANCES");
      this._lblStates.text = this.api.lang.getText("STATES");
   }
   function initData()
   {
      this._lblName.text = this._oSprite.name;
      this._lblLevel.text = this.api.lang.getText("LEVEL") + " " + this._oSprite.Level;
      this._lblLP.text = !_global.isNaN(this._oSprite.LP) ? this._oSprite.LP : "";
      this._lblAP.text = !_global.isNaN(this._oSprite.AP) ? String(Math.max(0,this._oSprite.AP)) : "";
      this._lblMP.text = !_global.isNaN(this._oSprite.MP) ? String(Math.max(0,this._oSprite.MP)) : "";
      this._ldrBuff.contentPath = "Dojo";
      this._ldrCandy.contentPath = "Candy";
      this._ldrCandy._visible = this._oSprite.hasCandy == "1";
      this._ldrBuff._visible = this._oSprite.hasBuff == "1";
      this._lblAverageDamages.text = this._oSprite.averageDamages;
      this._ldrSprite.contentPath = this._oSprite.artworkFile;
      var _loc2_ = 1;
      var _loc3_;
      while(_loc2_ <= dofus.graphics.gapi.controls.BannerSpriteInfos.STATES_ICONS_COUNT)
      {
         _loc3_ = this["_ldrState" + _loc2_];
         _loc3_.contentPath = dofus.Constants.STATESICON_FILE;
         _loc2_ = _loc2_ + 1;
      }
      var _loc4_ = this.api.kernel.OptionsManager.getOption("ShowFixRes") && this._oSprite.resistances.length > 7;
      this._lblFire._visible = _loc4_;
      this._lblNeutralFix._visible = _loc4_;
      this._lblNeutralCenter._visible = !_loc4_;
      this._lblEarth._visible = _loc4_;
      this._lblFireFix._visible = _loc4_;
      this._lblFireCenter._visible = !_loc4_;
      this._lblDodgeAP._visible = _loc4_;
      this._lblAirFix._visible = _loc4_;
      this._lblAirCenter._visible = !_loc4_;
      this._lblAir._visible = _loc4_;
      this._lblWaterFix._visible = _loc4_;
      this._lblWaterCenter._visible = !_loc4_;
      this._lblRes._visible = _loc4_;
      this._lblEarthFix._visible = _loc4_;
      this._lblEarthCenter._visible = !_loc4_;
      this._nID = this._oSprite.id;
      this.updateResistances();
      this.updateStates();
   }
   function updateResistances()
   {
      var _loc2_ = this._oSprite.resistances;
      var _loc3_ = _loc2_.length > 7;
      var _loc4_ = this.api.kernel.OptionsManager.getOption("ShowFixRes") && _loc3_;
      if(_loc4_)
      {
         this.updateResistanceLabel(this._lblFire,_loc2_[0],true,true);
         this.updateResistanceLabel(this._lblRes,_loc2_[1],true,true);
         this.updateResistanceLabel(this._lblEarth,_loc2_[2],true,true);
         this.updateResistanceLabel(this._lblAir,_loc2_[3],true,true);
         this.updateResistanceLabel(this._lblDodgeAP,_loc2_[4],true,true);
         this.updateResistanceLabel(this._lblNeutralFix,_loc2_[5],true,false);
         this.updateResistanceLabel(this._lblEarthFix,_loc2_[6],true,false);
         this.updateResistanceLabel(this._lblFireFix,_loc2_[7],true,false);
         this.updateResistanceLabel(this._lblWaterFix,_loc2_[8],true,false);
         this.updateResistanceLabel(this._lblAirFix,_loc2_[9],true,false);
      }
      else
      {
         this.updateResistanceLabel(this._lblNeutralCenter,_loc2_[0],true,true);
         this.updateResistanceLabel(this._lblEarthCenter,_loc2_[1],true,true);
         this.updateResistanceLabel(this._lblFireCenter,_loc2_[2],true,true);
         this.updateResistanceLabel(this._lblWaterCenter,_loc2_[3],true,true);
         this.updateResistanceLabel(this._lblAirCenter,_loc2_[4],true,true);
      }
      this.updateResistanceLabel(this._lblDodgeMP,_loc2_[!_loc3_ ? 5 : 10],false,true);
      this.updateResistanceLabel(this._lblNeutral,_loc2_[!_loc3_ ? 6 : 11],false,true);
   }
   function updateResistanceLabel(oLabel, nValue_, bColorable, bPercent)
   {
      var _loc6_;
      if(bColorable)
      {
         if(nValue_ > 0)
         {
            oLabel.styleName = "GreenLeftExtraSmallLabel";
         }
         else if(nValue_ < 0)
         {
            oLabel.styleName = "DarkRedLeftExtraSmallLabel";
         }
         else
         {
            _loc6_ = this.api.kernel.OptionsManager.getOption("ShowFixRes") && this._oSprite.resistances.length > 7;
            oLabel.styleName = !(bPercent && _loc6_) ? "BrownLeftExtraSmallLabel" : "DarkBrownLeftExtraSmallLabel";
         }
      }
      oLabel.text = (nValue_ != undefined ? nValue_ : "0") + (!bPercent ? "" : "%");
   }
   function updateStates()
   {
      var _loc2_ = 1;
      var _loc3_;
      var _loc4_;
      while(_loc2_ <= dofus.graphics.gapi.controls.BannerSpriteInfos.STATES_ICONS_COUNT)
      {
         _loc3_ = this["_ldrState" + _loc2_];
         _loc4_ = this["_lblState" + _loc2_];
         _loc4_.text = "";
         _loc3_.content._mcState.removeMovieClip();
         _loc2_ = _loc2_ + 1;
      }
      var _loc5_ = this._oSprite.states;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      if(_loc5_ != undefined)
      {
         _loc6_ = 0;
         for(var nState in _loc5_)
         {
            if(_loc5_[nState] == true && this.api.lang.getStateIsDisplayedBanner(Number(nState)))
            {
               _loc6_ = _loc6_ + 1;
               _loc7_ = this["_ldrState" + _loc6_];
               _loc8_ = this["_lblState" + _loc6_];
               _loc8_.text = this.api.lang.getStateShortText(Number(nState)) != "" ? String(this.api.lang.getStateShortText(Number(nState))) : String(this.api.lang.getStateText(Number(nState)));
               this.setStateOnLoader(_loc7_,Number(nState));
            }
         }
      }
   }
   function setStateOnLoader(ldr, nState)
   {
      var _loc4_;
      var _loc5_;
      if(ldr.loaded)
      {
         delete ldr.tempVars;
         _loc4_ = "State_" + nState;
         _loc5_ = ldr.content.attachMovie(_loc4_,"_mcState",ldr.content.getNextHighestDepth());
      }
      else
      {
         ldr.tempVars = {fightStateToPut:nState};
      }
   }
   function applyColor(mc, zone)
   {
      var _loc4_ = 0;
      switch(zone)
      {
         case 1:
            _loc4_ = this._oSprite.color1;
            break;
         case 2:
            _loc4_ = this._oSprite.color2;
            break;
         case 3:
            _loc4_ = this._oSprite.color3;
      }
      if(_loc4_ == -1 || _loc4_ == undefined)
      {
         return undefined;
      }
      var _loc5_ = (_loc4_ & 0xFF0000) >> 16;
      var _loc6_ = (_loc4_ & 0xFF00) >> 8;
      var _loc7_ = _loc4_ & 0xFF;
      var _loc8_ = new Color(mc);
      var _loc9_ = {};
      _loc9_ = {ra:0,ga:0,ba:0,rb:_loc5_,gb:_loc6_,bb:_loc7_};
      _loc8_.setTransform(_loc9_);
   }
   function initialization(oEvent)
   {
      var _loc3_ = oEvent.target;
      var _loc4_ = _loc3_.content;
      var _loc5_;
      if(_loc3_ == this._ldrSprite)
      {
         _loc5_ = _loc4_._mcMask;
         _loc4_._x = - _loc5_._x;
         _loc4_._y = - _loc5_._y;
         this._ldrSprite._xscale = 10000 / _loc5_._xscale;
         this._ldrSprite._yscale = 10000 / _loc5_._yscale;
      }
      else if(_loc3_.tempVars)
      {
         this.setStateOnLoader(_loc3_,_loc3_.tempVars.fightStateToPut);
      }
   }
   function complete(oEvent)
   {
      var ref = this;
      this._ldrSprite.content.stringCourseColor = function(mc_, nColorIndex)
      {
         ref.applyColor(mc_,nColorIndex);
      };
      var _loc3_;
      if(this._oSprite.glowFilter != undefined && this._oSprite.glowFilter != "")
      {
         _loc3_ = Number("0x" + this._oSprite.glowFilter);
         this._ldrSprite.filters = [new flash.filters.GlowFilter(_loc3_,1,10,10,1.5)];
      }
   }
}
