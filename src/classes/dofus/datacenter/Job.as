class dofus.datacenter.Job extends Object
{
   var _eaCrafts;
   var _eaSkills;
   var _nID;
   var _nLevel;
   var _nXP;
   var _nXPTotal;
   var _nXPmax;
   var _nXPmin;
   var _oJobText;
   var _oOptions;
   var api;
   var dispatchEvent;
   function Job(nID, eaSkills, options)
   {
      super();
      this.initialize(nID,eaSkills,options);
   }
   function set options(o)
   {
      this._oOptions = o;
      this.dispatchEvent({type:"optionsChanged",value:o});
   }
   function get options()
   {
      return this._oOptions;
   }
   function get id()
   {
      return this._nID;
   }
   function get name()
   {
      var _loc2_ = this._oJobText.n;
      if(dofus.Constants.DEBUG)
      {
         _loc2_ += " (" + this.id + ")";
      }
      return _loc2_;
   }
   function get description()
   {
      return this._oJobText.d;
   }
   function get iconFile()
   {
      return dofus.Constants.JOBS_ICONS_PATH + this._oJobText.g + ".swf";
   }
   function get skills()
   {
      return this._eaSkills;
   }
   function get crafts()
   {
      return this._eaCrafts;
   }
   function set level(nLevel)
   {
      this._nLevel = nLevel;
   }
   function get level()
   {
      return this._nLevel;
   }
   function set xpMin(nXPmin)
   {
      this._nXPmin = nXPmin;
   }
   function get xpMin()
   {
      return this._nXPmin;
   }
   function set xp(nXP)
   {
      this._nXP = nXP;
      var _loc3_;
      if(this.api.datacenter.Player.currentJobID == this.id)
      {
         _loc3_ = dofus.graphics.gapi.ui.Banner(this.api.ui.getUIComponent("Banner"));
         if(_loc3_ != undefined && this.api.kernel.OptionsManager.getOption("BannerGaugeMode") == "xpcurrentjob")
         {
            dofus.graphics.gapi.ui.banner.BannerGauge.showGaugeMode(_loc3_);
         }
      }
   }
   function get xp()
   {
      return this._nXP;
   }
   function set xpMax(nXPmax)
   {
      this._nXPmax = nXPmax;
   }
   function get xpMax()
   {
      return this._nXPmax <= Math.pow(10,17) ? this._nXPmax : this._nXP;
   }
   function get specializationOf()
   {
      return this._oJobText.s;
   }
   function get xpTotal()
   {
      return this._nXPTotal;
   }
   function set xpTotal(nValue_)
   {
      this._nXPTotal = nValue_;
   }
   function initialize(nID, eaSkills, options)
   {
      mx.events.EventDispatcher.initialize(this);
      this.api = _global.API;
      this._nID = nID;
      this._eaSkills = eaSkills;
      this._oOptions = options;
      this._oJobText = this.api.lang.getJobText(nID);
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      if(!_global.isNaN(eaSkills.length))
      {
         this._eaCrafts = new ank.utils.ExtendedArray();
         _loc5_ = new ank.utils.ExtendedArray();
         _loc6_ = 0;
         while(_loc6_ < eaSkills.length)
         {
            _loc7_ = _loc5_.findFirstItem("id",eaSkills[_loc6_].id);
            if(_loc7_.index == -1)
            {
               _loc5_.push(eaSkills[_loc6_]);
            }
            else if(_loc7_.item.param1 < eaSkills[_loc6_].param1)
            {
               _loc5_[_loc7_.index] = eaSkills[_loc6_];
            }
            _loc6_ = _loc6_ + 1;
         }
         _loc8_ = 0;
         while(_loc8_ < _loc5_.length)
         {
            _loc9_ = _loc5_[_loc8_];
            _loc10_ = _loc9_.craftsList;
            if(_loc10_ != undefined)
            {
               _loc11_ = 0;
               while(_loc11_ < _loc10_.length)
               {
                  _loc12_ = _loc10_[_loc11_];
                  _loc13_ = new dofus.datacenter.Craft(_loc12_,_loc9_);
                  if(_loc13_.itemsCount <= _loc9_.param1)
                  {
                     this._eaCrafts.push(_loc13_);
                  }
                  _loc11_ = _loc11_ + 1;
               }
            }
            this._eaCrafts.sortOn("name");
            _loc8_ = _loc8_ + 1;
         }
      }
   }
   function getMaxSkillSlot()
   {
      var _loc2_ = -1;
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < this._eaSkills.length)
      {
         _loc4_ = this._eaSkills[_loc3_];
         if(_loc4_.param1 > _loc2_)
         {
            _loc2_ = _loc4_.param1;
         }
         _loc3_ = _loc3_ + 1;
      }
      return _loc2_;
   }
}
