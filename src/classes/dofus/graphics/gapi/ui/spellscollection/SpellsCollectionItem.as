class dofus.graphics.gapi.ui.spellscollection.SpellsCollectionItem extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnSpellGrade1;
   var _btnSpellGrade2;
   var _btnSpellGrade3;
   var _lblLevel;
   var _lblName;
   var _ldrIcon;
   var _ldrSpellAcquireType;
   var _mcSpellGet;
   var _mcSpellInDeck;
   var _mcSpellNoGet;
   var _mcSpellRarity;
   var _oSpell;
   var addToQueue;
   static var CLASS_NAME = "SpellsCollectionItem";
   function SpellsCollectionItem()
   {
      super();
      this.initialize();
   }
   function get spell()
   {
      return this._oSpell;
   }
   function set spell(oSpell)
   {
      this._oSpell = oSpell;
   }
   function initialize()
   {
      this.api = _global.API;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.spellscollection.SpellsCollectionItem.CLASS_NAME);
   }
   function createChildren()
   {
      this._mcSpellGet._visible = false;
      this._mcSpellNoGet._visible = false;
      this._btnSpellGrade1._visible = false;
      this._btnSpellGrade2._visible = false;
      this._btnSpellGrade3._visible = false;
      this._mcSpellInDeck._visible = false;
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
   }
   function addListeners()
   {
      this._btnSpellGrade1.addEventListener("click",this);
      this._btnSpellGrade2.addEventListener("click",this);
      this._btnSpellGrade3.addEventListener("click",this);
      var ref = this;
      this._mcSpellInDeck.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._mcSpellInDeck.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._mcSpellGet.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._mcSpellGet.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._mcSpellNoGet.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._mcSpellNoGet.onRollOut = function()
      {
         ref.out({target:this});
      };
   }
   function initData()
   {
      this._ldrIcon.forceReload = true;
      this._ldrIcon.contentParams = this._oSpell.params;
      this._ldrIcon.contentPath = this._oSpell.iconFile;
      this._btnSpellGrade1._visible = this._oSpell.maxLevel >= 1;
      this._btnSpellGrade2._visible = this._oSpell.maxLevel >= 2;
      this._btnSpellGrade3._visible = this._oSpell.maxLevel >= 3;
      this._mcSpellRarity.gotoAndStop(this._oSpell.rarity);
      var _loc2_ = this.api.datacenter.Player.getOwnedSpellLevel(this._oSpell.ID);
      var _loc3_ = _loc2_ > -1;
      var _loc4_;
      if(_loc3_)
      {
         _loc4_ = this["_btnSpellGrade" + _loc2_];
         _loc4_.backgroundDown = "ButtonTemporisSpellGet";
         _loc4_.backgroundUp = "ButtonTemporisSpellGet";
      }
      this.setSpellOwnedState();
      this.initSpellOrigin(this._oSpell.origin);
   }
   function initTexts()
   {
      this._lblName.text = this._oSpell.name;
      this._lblLevel.text = this.api.lang.getText("LEVEL_SMALL") + " " + this._oSpell.normalMinPlayerLevel;
   }
   function setSpellOwnedState()
   {
      var _loc2_ = this.api.datacenter.Player.getOwnedSpell(this._oSpell.ID);
      var _loc3_ = _loc2_ != undefined;
      var _loc4_ = false;
      if(_loc3_ && _loc2_.position != undefined)
      {
         _loc4_ = _loc2_.position != -1;
      }
      this._mcSpellNoGet._visible = !_loc3_;
      this._mcSpellGet._visible = _loc3_ && !_loc4_;
      this._mcSpellInDeck._visible = _loc3_ && _loc4_;
   }
   function initSpellOrigin(nOrigin)
   {
      var _loc3_;
      switch(nOrigin)
      {
         case dofus.graphics.gapi.ui.SpellsCollection.SPELLS_ORIGIN_DROP_ON_MONSTER:
            _loc3_ = "SpellAcquireDrop";
            break;
         case dofus.graphics.gapi.ui.SpellsCollection.SPELLS_ORIGIN_CRAFT:
            _loc3_ = "SpellAcquireCraft";
            break;
         case dofus.graphics.gapi.ui.SpellsCollection.SPELLS_ORIGIN_UNKNOWN:
            _loc3_ = "SpellAcquireUnknown";
            break;
         default:
            _loc3_ = "";
      }
      this._ldrSpellAcquireType.contentPath = _loc3_;
      this._ldrSpellAcquireType.content._xscale = -100;
   }
   function click(oEvent)
   {
      var _loc3_ = dofus.graphics.gapi.ui.SpellsCollection(this.api.ui.getUIComponent("SpellsCollection"));
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      switch(oEvent.target)
      {
         case this._btnSpellGrade1:
            _loc3_.selectItem({spell:this._oSpell,grade:1});
            break;
         case this._btnSpellGrade2:
            _loc3_.selectItem({spell:this._oSpell,grade:2});
            break;
         case this._btnSpellGrade3:
            _loc3_.selectItem({spell:this._oSpell,grade:3});
         default:
            return;
      }
   }
   function over(oEvent)
   {
      switch(oEvent.target)
      {
         case this._mcSpellInDeck:
            this.api.ui.showTooltip(this.api.lang.getText("SPELL_EQUIPED_CURRENT_DECK"));
            break;
         case this._mcSpellGet:
            this.api.ui.showTooltip(this.api.lang.getText("SPELL_OWNED"));
            break;
         case this._mcSpellNoGet:
            this.api.ui.showTooltip(this.api.lang.getText("SPELL_NOT_OWNED"));
         default:
            return;
      }
   }
   function out(oEvent)
   {
      this.api.ui.hideTooltip();
   }
}
