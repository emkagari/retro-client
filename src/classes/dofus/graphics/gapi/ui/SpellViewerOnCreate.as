class dofus.graphics.gapi.ui.SpellViewerOnCreate extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _alpha;
   var _bhClose;
   var _btnClose;
   var _lbViewSpell;
   var _lblBreedName;
   var _lblBreedSpells;
   var _mcSpellDesc;
   var _mcViewAllSpell;
   var _mcWindowBg;
   var _nBreed;
   var _nSpellID;
   var _name;
   var _parent;
   var _x;
   var _y;
   var addToQueue;
   var gapi;
   var initialized;
   var onEnterFrame;
   var onRelease;
   var unloadThis;
   static var CLASS_NAME = "SpellViewerOnCreate";
   static var SPELLS_DISPLAYED = 20;
   var _bExpanded = false;
   function SpellViewerOnCreate()
   {
      super();
   }
   function get breed()
   {
      return this._nBreed;
   }
   function set breed(n)
   {
      this.api.datacenter.Player.Guild = n;
      this._nBreed = n;
      if(this.initialized)
      {
         this.updateData();
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.SpellViewerOnCreate.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initText});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function initText()
   {
      this._mcViewAllSpell.text = this.api.lang.getText("CLASS_SPELLS");
      this._lblBreedName.text = this.api.lang.getClassText(this._nBreed).sn;
      this._lbViewSpell.text = this.api.lang.getText("SEE_ALL_SPELLS");
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnClose.addEventListener("over",this);
      this._btnClose.addEventListener("out",this);
      this._bhClose.addEventListener("click",this);
      this._mcWindowBg.onRelease = function()
      {
      };
      this._mcWindowBg.useHandCursor = false;
      this._lblBreedSpells.onRelease = function()
      {
         var aTarget = {};
         var _loc2_ = 0;
         var _loc3_;
         var _loc4_;
         var _loc5_;
         var _loc6_;
         var _loc7_;
         while(_loc2_ < dofus.graphics.gapi.ui.SpellViewerOnCreate.SPELLS_DISPLAYED)
         {
            _loc3_ = this._parent["_ctr" + _loc2_];
            _loc4_ = this._parent._mcPlacerSpell._x;
            _loc5_ = this._parent._mcPlacerSpell._y;
            _loc6_ = _loc4_ + (_loc2_ - (_loc2_ <= 9 ? 0 : 10)) * (_loc3_.width + 5);
            _loc7_ = _loc5_ + (5 + _loc3_.height) * (_loc2_ <= 9 ? 0 : 1);
            aTarget["_ctr" + _loc2_] = {x:_loc6_,y:_loc7_};
            _loc3_.onEnterFrame = function()
            {
               if(dofus.Constants.TRIPLEFRAMERATE)
               {
                  this._x += (aTarget[this._name].x - this._x) / 6;
                  this._y += (aTarget[this._name].y - this._y) / 6;
               }
               else
               {
                  this._x += (aTarget[this._name].x - this._x) / 2;
                  this._y += (aTarget[this._name].y - this._y) / 2;
               }
               this._alpha += (100 - this._alpha) / 2;
               if(Math.abs(this._x - aTarget[this._name].x) < 0.5 && (Math.abs(this._y - aTarget[this._name].y) < 0.5 && Math.abs(this._alpha - 100) < 0.5))
               {
                  delete this.onEnterFrame;
               }
            };
            _loc2_ = _loc2_ + 1;
         }
         var ref = this._parent;
         var _loc8_ = 0;
         this.onEnterFrame = function()
         {
            var _loc2_ = (ref._mcPlacerAllSpell._y - ref._mcSpellDesc._y) / 2;
            ref._mcSpellDesc._y += _loc2_;
            ref._mcWindowBg._y += _loc2_;
            if(Math.abs(ref._mcSpellDesc._y - ref._mcPlacerAllSpell._y) < 0.5)
            {
               ref._mcWindowBg._y += ref._mcPlacerAllSpell._y - ref._mcSpellDesc._y;
               ref._mcSpellDesc._y = ref._mcPlacerAllSpell._y;
               delete this.onEnterFrame;
            }
         };
         this._parent._mcBgViewAllSpell1._visible = false;
         this._parent._mcBgViewAllSpell2._visible = false;
         this._parent._lbViewSpell._visible = false;
         this._parent._bExpanded = true;
         delete this.onRelease;
      };
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < dofus.graphics.gapi.ui.SpellViewerOnCreate.SPELLS_DISPLAYED)
      {
         _loc3_ = this["_ctr" + _loc2_];
         _loc3_.addEventListener("over",this);
         _loc3_.addEventListener("out",this);
         _loc3_.addEventListener("click",this);
         _loc3_.addEventListener("onContentLoaded",this);
         _loc2_ = _loc2_ + 1;
      }
   }
   function initData()
   {
      var _loc2_ = this.api.lang.getClassText(this._nBreed).s;
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      while(_loc3_ < dofus.graphics.gapi.ui.SpellViewerOnCreate.SPELLS_DISPLAYED)
      {
         _loc4_ = _loc2_[_loc3_];
         if(_loc4_ != undefined)
         {
            _loc5_ = new dofus.datacenter.Spell(_loc4_,1);
            _loc6_ = this["_ctr" + _loc3_];
            _loc6_.contentData = _loc5_;
            _loc6_._alpha = !this._bExpanded ? (_loc3_ >= 3 ? 0 : 100) : 100;
         }
         _loc3_ = _loc3_ + 1;
      }
      if(_loc2_.length < dofus.graphics.gapi.ui.SpellViewerOnCreate.SPELLS_DISPLAYED / 2 || this.api.datacenter.Basics.aks_current_server.isTemporis())
      {
         this._lblBreedSpells.onRelease();
      }
      this._mcSpellDesc._ldrSpellBig.addEventListener("complete",this);
      this.showSpellInfo(_loc2_[0],1);
   }
   function showSpellInfo(nSpellID, nLevel)
   {
      this._nSpellID = nSpellID;
      var _loc4_ = this.api.kernel.CharactersManager.getSpellObjectFromData(nSpellID + "~" + nLevel + "~");
      if(!_loc4_.isValid)
      {
         if(nLevel != 1)
         {
            this.showSpellInfo(nSpellID,1);
            return undefined;
         }
         _loc4_;
      }
      var _loc5_ = 1;
      var _loc6_;
      while(_loc5_ < 7)
      {
         _loc6_ = this["_btnLevel" + _loc5_];
         _loc6_.selected = _loc5_ == nLevel;
         _loc5_ = _loc5_ + 1;
      }
      if(_loc4_.name == undefined)
      {
         this._mcSpellDesc._lblSpellName.text = "";
         this._mcSpellDesc._lblSpellRange.text = "";
         this._mcSpellDesc._lblSpellAP.text = "";
         this._mcSpellDesc._txtSpellDescription.text = "";
         this._mcSpellDesc._ldrSpellBig.contentPath = "";
         if(this._mcSpellDesc._ldrSpellBig.loaded)
         {
            this._mcSpellDesc._ldrSpellBig.content.applyColors();
         }
      }
      else if(this._mcSpellDesc._lblSpellName.text != undefined)
      {
         this._mcSpellDesc._lblSpellName.text = _loc4_.name;
         this._mcSpellDesc._lblSpellRange.text = this.api.lang.getText("RANGEFULL") + " : " + _loc4_.rangeStr;
         this._mcSpellDesc._lblSpellAP.text = this.api.lang.getText("ACTIONPOINTS") + " : " + _loc4_.apCost;
         this._mcSpellDesc._txtSpellDescription.text = _loc4_.description + "\n" + _loc4_.descriptionNormalHit;
         this._mcSpellDesc._ldrSpellBig.forceReload = true;
         this._mcSpellDesc._ldrSpellBig.contentParams = _loc4_.params;
         this._mcSpellDesc._ldrSpellBig.contentPath = _loc4_.iconFile;
      }
   }
   function updateData()
   {
      this.initText();
      this.initData();
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._bhClose:
         case this._btnClose:
            this.unloadThis();
            return;
         default:
            this.showSpellInfo(oEvent.target.contentData.ID,1);
            return;
      }
   }
   function refreshSpellsPack()
   {
      var _loc2_ = 0;
      var _loc3_;
      var _loc4_;
      while(_loc2_ < dofus.graphics.gapi.ui.SpellViewerOnCreate.SPELLS_DISPLAYED)
      {
         _loc3_ = this["_ctr" + _loc2_];
         _loc4_ = _loc3_.content;
         _loc4_.applyColors();
         _loc2_ = _loc2_ + 1;
      }
      var _loc5_ = this._mcSpellDesc._ldrSpellBig;
      _loc5_.content.applyColors();
   }
   function complete(oEvent)
   {
      var _loc3_ = oEvent.clip;
      _loc3_.applyColors();
   }
   function onContentLoaded(oEvent)
   {
      var _loc3_ = oEvent.content;
      _loc3_.applyColors();
   }
   function over(oEvent)
   {
      var _loc0_;
      var _loc3_;
      var _loc4_;
      if((_loc0_ = oEvent.target) !== this._btnClose)
      {
         _loc3_ = oEvent.target.contentData.ID;
         if(_loc3_ != undefined)
         {
            _loc4_ = dofus.datacenter.Spell(this.api.kernel.CharactersManager.getSpellObjectFromData(_loc3_ + "~1~"));
            this.gapi.showTooltip(_loc4_.name + ", " + this.api.lang.getText("REQUIRED_SPELL_LEVEL").toLowerCase() + ": " + _loc4_.minPlayerLevel);
         }
      }
      else
      {
         this.gapi.showTooltip(this.api.lang.getText("CLOSE"));
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
