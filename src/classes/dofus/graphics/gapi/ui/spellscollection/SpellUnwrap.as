class dofus.graphics.gapi.ui.spellscollection.SpellUnwrap extends ank.gapi.core.UIBasicComponent
{
   var _bOver;
   var _currentframe;
   var _lblName;
   var _lblType;
   var _ldrIcon;
   var _mcPlacer;
   var _oSpell;
   var _parent;
   var addToQueue;
   var dispatchEvent;
   var gotoAndPlay;
   var hitTest;
   var onEnterFrame;
   function SpellUnwrap()
   {
      super();
   }
   function setValue(bUsed, sSuggested, oSpell)
   {
      var _loc5_;
      if(bUsed)
      {
         _loc5_ = this._parent.api;
         this._oSpell = oSpell;
         this._ldrIcon.forceReload = true;
         this._ldrIcon.contentParams = this._oSpell.params;
         this._ldrIcon.contentPath = this._oSpell.iconFile;
         if(this._ldrIcon.loaded)
         {
            this._ldrIcon.content.applyColors();
         }
      }
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      ank.utils.MouseEvents.addListener(this);
      this._ldrIcon.addEventListener("complete",this);
      this._mcPlacer.onRelease = function()
      {
         this._parent.onClick();
      };
      this._mcPlacer.onRollOver = function()
      {
         this._parent.doOver();
      };
      this._mcPlacer.onRollOut = function()
      {
         this._parent.doOut();
      };
   }
   function declareOnEnterFrame(nEndFrame)
   {
      this.onEnterFrame = function()
      {
         this.initData();
         if(this._currentframe == nEndFrame)
         {
            delete this.onEnterFrame;
         }
      };
   }
   function initData()
   {
      var _loc2_ = this._parent.api;
      this._lblName.text = this._oSpell.name;
      this._lblType.text = !this._oSpell.isPassive ? _loc2_.lang.getText("ACTIVE") : _loc2_.lang.getText("PASSIVE");
   }
   function complete(oEvent)
   {
      var _loc3_ = this._parent.api;
      var _loc4_ = oEvent.clip;
      _loc4_.applyColors();
   }
   function doOver()
   {
      if(this._bOver)
      {
         return undefined;
      }
      this._bOver = true;
      this.onOver();
      this.declareOnEnterFrame(!dofus.Constants.TRIPLEFRAMERATE ? 7 : 20);
      this.gotoAndPlay(2);
   }
   function doOut()
   {
      if(!this._bOver)
      {
         return undefined;
      }
      this._bOver = false;
      this.onOut();
      this.declareOnEnterFrame(!dofus.Constants.TRIPLEFRAMERATE ? 15 : 43);
      this.gotoAndPlay(!dofus.Constants.TRIPLEFRAMERATE ? 8 : 23);
   }
   function onOver()
   {
      this.dispatchEvent({type:"overItem",spell:this._oSpell,isFromSpellUnwrap:true});
   }
   function onOut()
   {
      this.dispatchEvent({type:"outItem",spell:this._oSpell,isFromSpellUnwrap:true});
   }
   function onClick()
   {
      this.dispatchEvent({type:"selectItem",spell:this._oSpell,isFromSpellUnwrap:true});
   }
   function onMouseUp()
   {
      var _loc2_ = this.hitTest(_root._xmouse,_root._ymouse,true);
      if(!_loc2_)
      {
         this.doOut();
      }
   }
}
