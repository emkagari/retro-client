class dofus.graphics.gapi.ui.SpellForget extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnCancel;
   var _btnClose;
   var _btnValidate;
   var _lblLevel;
   var _lblName;
   var _lstSpells;
   var _winBg;
   var addToQueue;
   var unloadThis;
   static var CLASS_NAME = "SpellForget";
   function SpellForget()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.SpellForget.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.initData});
   }
   function addListeners()
   {
      this._btnValidate.enabled = false;
      this._btnClose.addEventListener("click",this);
      this._btnCancel.addEventListener("click",this);
      this._btnValidate.addEventListener("click",this);
      this._lstSpells.addEventListener("itemSelected",this);
   }
   function initTexts()
   {
      this._winBg.title = this.api.lang.getText("SPELL_FORGET");
      this._lblName.text = this.api.lang.getText("SPELLS_SHORTCUT");
      this._lblLevel.text = this.api.lang.getText("LEVEL");
      this._btnValidate.label = this.api.lang.getText("VALIDATE");
      this._btnCancel.label = this.api.lang.getText("CANCEL_SMALL");
   }
   function initData()
   {
      var _loc2_ = this.api.datacenter.Player.Spells;
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_;
      for(var k in _loc2_)
      {
         _loc4_ = _loc2_[k];
         if(_loc4_.classID != -1 && _loc4_.level > 1)
         {
            _loc3_.push(_loc4_);
         }
      }
      this._lstSpells.dataProvider = _loc3_;
   }
   function itemSelected(oEvent)
   {
      this._btnValidate.enabled = true;
   }
   function click(oEvent)
   {
      var _loc3_;
      switch(oEvent.target)
      {
         case this._btnValidate:
            _loc3_ = dofus.datacenter.Spell(this._lstSpells.selectedItem);
            this.api.kernel.showMessage(this.api.lang.getText("SPELL_FORGET"),this.api.lang.getText("SPELL_FORGET_CONFIRM",[_loc3_.name]),"CAUTION_YESNO",{name:"SpellForget",listener:this,params:{spell:_loc3_}});
            break;
         case this._btnClose:
         case this._btnCancel:
            this.api.network.Spells.spellForget(-1);
            this.unloadThis();
         default:
            return;
      }
   }
   function yes(oEvent)
   {
      var _loc0_;
      var _loc3_;
      if((_loc0_ = oEvent.target._name) === "AskYesNoSpellForget")
      {
         _loc3_ = oEvent.target.params.spell;
         this.api.network.Spells.spellForget(_loc3_.ID);
         this.unloadThis();
      }
   }
}
