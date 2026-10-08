class dofus.datacenter.Mount extends Object
{
   var _aEffects;
   var _lang;
   var _nChevauchorGfxID;
   var _nPods;
   var _sEffects;
   var _sName;
   var capacities;
   var chevauchorGfxFile;
   var customColor1;
   var customColor2;
   var customColor3;
   var dispatchEvent;
   var fecondable;
   var fecondation;
   var gfxFile;
   var level;
   var maturity;
   var maturityMax;
   var modelID;
   var mountable;
   var newBorn;
   var ownerName;
   var sex;
   var wild;
   var _bNewBorn = false;
   function Mount(nModelID, nChevauchorGfxID, bNewBorn)
   {
      super();
      mx.events.EventDispatcher.initialize(this);
      this.newBorn = bNewBorn;
      this.modelID = nModelID;
      this._lang = _global.API.lang.getMountText(this.modelID);
      this.gfxFile = dofus.Constants.CLIPS_PERSOS_PATH + this._lang.g + ".swf";
      this.useCustomColor = nChevauchorGfxID;
   }
   function set name(value)
   {
      this._sName = value;
      this.dispatchEvent({type:"nameChanged",name:value});
   }
   function get name()
   {
      return this._sName;
   }
   function set pods(value)
   {
      this._nChevauchorGfxID = value;
      this.dispatchEvent({type:"podsChanged",pods:value});
   }
   function get pods()
   {
      return this._nChevauchorGfxID;
   }
   function get label()
   {
      return this._lang.n;
   }
   function get modelName()
   {
      return this._lang.n;
   }
   function get iconFile()
   {
      return dofus.Constants.GUILDS_MINI_PATH + this._lang.g + ".swf";
   }
   function set useCustomColor(nID)
   {
      this._nPods = nID;
      this.chevauchorGfxFile = dofus.Constants.CHEVAUCHOR_PATH + nID + ".swf";
   }
   function get useCustomColor()
   {
      return this._nPods;
   }
   function get isChameleon()
   {
      var _loc2_;
      for(var k in this.capacities)
      {
         _loc2_ = this.capacities[k].data;
         if(_loc2_ == 9)
         {
            return true;
         }
      }
      return false;
   }
   function get color1()
   {
      if(!_global.isNaN(this.customColor1))
      {
         return this.customColor1;
      }
      return this._lang.c1;
   }
   function get color2()
   {
      if(!_global.isNaN(this.customColor2))
      {
         return this.customColor2;
      }
      return this._lang.c2;
   }
   function get color3()
   {
      if(!_global.isNaN(this.customColor3))
      {
         return this.customColor3;
      }
      return this._lang.c3;
   }
   function isMine(oApi)
   {
      return this.ownerName == oApi.datacenter.Player.Name;
   }
   function get mature()
   {
      return this.maturity == this.maturityMax && (this.maturity != undefined && this.maturityMax != undefined);
   }
   function get effects()
   {
      return dofus.datacenter.Item.getItemDescriptionEffects(this._aEffects,undefined,true,false);
   }
   function setEffects(compressedData)
   {
      this._sEffects = compressedData;
      this._aEffects = [];
      var _loc3_ = compressedData.split(",");
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_].split("#");
         _loc5_[0] = _global.parseInt(_loc5_[0],16);
         _loc5_[1] = _loc5_[1] != "0" ? _global.parseInt(_loc5_[1],16) : undefined;
         _loc5_[2] = _loc5_[2] != "0" ? _global.parseInt(_loc5_[2],16) : undefined;
         _loc5_[3] = _loc5_[3] != "0" ? _global.parseInt(_loc5_[3],16) : undefined;
         _loc5_[4] = _loc5_[4];
         this._aEffects.push(_loc5_);
         _loc4_ = _loc4_ + 1;
      }
   }
   function getToolTip()
   {
      var _loc2_ = this.modelName;
      _loc2_ += "\n" + _global.API.lang.getText("NAME_BIG") + " : " + this.name;
      _loc2_ += "\n" + _global.API.lang.getText("LEVEL") + " : " + this.level;
      _loc2_ += "\n" + _global.API.lang.getText("CREATE_SEX") + " : " + (!this.sex ? _global.API.lang.getText("ANIMAL_MEN") : _global.API.lang.getText("ANIMAL_WOMEN"));
      _loc2_ += "\n" + _global.API.lang.getText("MOUNTABLE") + " : " + (!this.mountable ? _global.API.lang.getText("NO") : _global.API.lang.getText("YES"));
      _loc2_ += "\n" + _global.API.lang.getText("WILD") + " : " + (!this.wild ? _global.API.lang.getText("NO") : _global.API.lang.getText("YES"));
      if(this.fecondation > 0)
      {
         _loc2_ += "\n" + _global.API.lang.getText("PREGNANT_SINCE",[this.fecondation]);
      }
      else if(this.fecondable)
      {
         _loc2_ += "\n" + _global.API.lang.getText("FECONDABLE");
      }
      return _loc2_;
   }
   function get forceReloadOnContainer()
   {
      return true;
   }
}
