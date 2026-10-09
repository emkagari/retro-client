489802560 - 1;
class dofus.graphics.gapi.ui.playerinfos.PlayerInfosEffectsItem extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _lblDescription;
   var _lblRemainingTurn;
   var _lblSpell;
   var _ldrIcon;
   var _mcInteractivity;
   var _mcNotDisplell;
   var _oItem;
   var addToQueue;
   function PlayerInfosEffectsItem()
   {
      super();
      this.api = _global.API;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      if(bUsed)
      {
         this._ldrIcon.forceNextLoad();
         this._ldrIcon.contentPath = dofus.Constants.EFFECTSICON_FILE;
         this._lblDescription.text = oItem.getDescription(false);
         this._lblRemainingTurn.text = oItem.remainingTurnStr;
         this._lblSpell.text = oItem.spellName;
         this._mcNotDisplell._visible = !oItem.isDispellable;
         var ref = this;
         this._mcInteractivity.onRollOver = function()
         {
            ref.over({target:this});
         };
         this._mcInteractivity.onRollOut = function()
         {
            ref.out({target:this});
         };
         this._mcNotDisplell.onRollOver = function()
         {
            ref.over({target:this});
         };
         this._mcNotDisplell.onRollOut = function()
         {
            ref.out({target:this});
         };
         this._oItem = oItem;
      }
      else if(this._lblSpell.text != undefined)
      {
         this._ldrIcon.contentPath = "";
         this._lblDescription.text = "";
         this._lblRemainingTurn.text = "";
         this._lblSpell.text = "";
         delete this._mcInteractivity.onRollOver;
         delete this._mcInteractivity.onRollOut;
         delete this._mcNotDisplell.onRollOver;
         delete this._mcNotDisplell.onRollOut;
         this._mcNotDisplell._visible = false;
      }
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this._mcNotDisplell._visible = false;
   }
   function addListeners()
   {
      this._ldrIcon.addEventListener("initialization",this);
   }
   function initialization(oEvent)
   {
      var _loc3_ = this._ldrIcon.content.attachMovie("Icon_" + this._oItem.characteristic,"_mcIcon",10,{operator:this._oItem.operator});
      _loc3_.__proto__ = dofus.graphics.battlefield.EffectIcon.prototype;
      var _loc4_ = dofus.graphics.battlefield.EffectIcon(_loc3_);
      _loc4_.initialize(this._oItem.operator,1);
   }
   function over(event)
   {
      switch(event.target)
      {
         case this._mcInteractivity:
            if(this._oItem.spellDescription.length > 0)
            {
               this.api.ui.showTooltip(this._oItem.spellDescription);
            }
            break;
         case this._mcNotDisplell:
            this.api.ui.showTooltip(this.api.lang.getText("NOT_DISPELLABLE"));
         default:
            return;
      }
   }
   function out(event)
   {
      this.api.ui.hideTooltip();
   }
}
