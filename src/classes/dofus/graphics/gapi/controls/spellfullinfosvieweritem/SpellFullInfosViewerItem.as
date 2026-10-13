class dofus.graphics.gapi.controls.spellfullinfosvieweritem.SpellFullInfosViewerItem extends ank.gapi.core.UIBasicComponent
{
   var _btnViewSpell;
   var _ctrConditionalOver;
   var _ctrNotDispellable;
   var _ctrSpellArea;
   var _lbl;
   var _lblArea;
   var _ldrConditionalFalse;
   var _ldrElement;
   var _nOverTextLinesCount;
   var _oItem;
   var _sOverText;
   var addToQueue;
   var arrange;
   var gapi;
   var _nLabelWidth = 232;
   function SpellFullInfosViewerItem()
   {
      super();
      this._ctrSpellArea._visible = false;
      this._ctrConditionalOver._visible = false;
      this._ctrNotDispellable._visible = false;
      this._btnViewSpell._visible = false;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      var _loc5_ = _global.API;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      if(bUsed)
      {
         this._oItem = oItem;
         if(oItem.fx.description == undefined && oItem.description == undefined)
         {
            this._lbl.text = sSuggested;
         }
         else if(oItem.fx.description != undefined)
         {
            this._lbl.text = oItem.fx.description;
         }
         else if(oItem.description != undefined)
         {
            this._lbl.text = oItem.description;
         }
         if(oItem.fx.element != undefined)
         {
            _loc6_ = oItem.fx.element;
         }
         else if(oItem.element != undefined)
         {
            _loc6_ = oItem.element;
         }
         if(oItem.fx.characteristic != undefined)
         {
            _loc7_ = oItem.fx.characteristic;
         }
         else if(oItem.characteristic != undefined)
         {
            _loc7_ = oItem.characteristic;
         }
         if(_loc6_ != undefined)
         {
            this._ldrElement.contentPath = oItem.getIconNameFromID(_loc6_);
            if(this._ldrElement.contentPath == undefined)
            {
               this._ldrElement.contentPath = dofus.datacenter.Effect.getIconNameFromID(_loc6_);
            }
            org.flashdevelop.utils.FlashConnect.trace(dofus.datacenter.Effect.getIconNameFromID(_loc6_),"dofus.graphics.gapi.controls.spellfullinfosvieweritem.SpellFullInfosViewerItem::setValue","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/graphics/gapi/controls/spellfullinfosvieweritem/SpellFullInfosViewerItem.as",94);
         }
         else if(_loc7_ != undefined)
         {
            this._ldrElement.contentPath = oItem.getIconNameFromID(_loc7_);
            if(this._ldrElement.contentPath == undefined)
            {
               this._ldrElement.contentPath = dofus.datacenter.Effect.getIconNameFromID(_loc7_);
            }
         }
         this._ldrElement._visible = this._ldrElement.contentPath != "";
         _loc8_ = true;
         if(oItem.fx.isDispellable != undefined)
         {
            _loc8_ = oItem.fx.isDispellable;
         }
         else if(oItem.isDispellable != undefined)
         {
            _loc8_ = oItem.isDispellable;
         }
         if(!_loc8_)
         {
            this._ctrNotDispellable.contentPath = "NonDispellableIcon";
            this._ctrNotDispellable._visible = true;
            this._ctrNotDispellable.addEventListener("over",this);
            this._ctrNotDispellable.addEventListener("out",this);
         }
         else
         {
            this._ctrNotDispellable._visible = false;
            this._ctrNotDispellable.removeEventListener("over",this);
            this._ctrNotDispellable.removeEventListener("out",this);
         }
         if(oItem.ar > 0)
         {
            _loc9_ = oItem.at.charCodeAt(0);
            this._ctrSpellArea.contentPath = dofus.Constants.EMBLEMS_SPELL_AREAS_PATH + _loc9_ + ".swf";
            this._ctrSpellArea._visible = true;
            this._ctrSpellArea.addEventListener("over",this);
            this._ctrSpellArea.addEventListener("out",this);
            this._lblArea.text = oItem.ar != 63 ? oItem.ar : _global.API.lang.getText("INFINIT_SHORT");
         }
         else
         {
            this._ctrSpellArea._visible = false;
            this._ctrSpellArea.removeEventListener("over",this);
            this._ctrSpellArea.removeEventListener("out",this);
            this._lblArea.text = "";
         }
         this.showButton(this._btnViewSpell,oItem.fx._nType == 300,"ItemViewerSpell");
         this._ctrConditionalOver.addEventListener("over",this);
         this._ctrConditionalOver.addEventListener("out",this);
         if(oItem.fx.conditions != undefined)
         {
            _loc10_ = oItem.fx.conditions;
         }
         else if(oItem.conditions != undefined)
         {
            _loc10_ = oItem.conditions;
         }
         if(_loc10_ == undefined || _loc10_[0] == _loc5_.lang.getText("NO_CONDITIONS"))
         {
            this._ctrConditionalOver._visible = false;
            this._sOverText = undefined;
         }
         else
         {
            this._nOverTextLinesCount = _loc10_.length;
            this._sOverText = _loc10_.join("\n- ");
            _loc11_ = "QuestionMark";
            if(_loc10_.length == 1)
            {
               _loc12_ = oItem.fx.conditionalStateID;
               if(_loc12_ == undefined)
               {
                  _loc12_ = oItem.conditionalStateID;
               }
               if(_loc12_ != undefined)
               {
                  _loc11_ = dofus.Constants.STATESICON_FILE;
               }
               else
               {
                  _loc13_ = oItem.fx.conditionalAlignmentID;
                  if(_loc13_ == undefined)
                  {
                     _loc13_ = oItem.conditionalAlignmentID;
                  }
                  if(_loc13_ != undefined)
                  {
                     _loc11_ = dofus.Constants.ALIGNMENTS_MINI_PATH + _loc13_ + ".swf";
                  }
               }
            }
            delete this._ctrConditionalOver.tempVars;
            if(_loc11_ == dofus.Constants.STATESICON_FILE)
            {
               this.setFightStateOnContainer(this._ctrConditionalOver,_loc12_);
            }
            this._ldrConditionalFalse.contentPath = _loc10_[0].indexOf(_loc5_.lang.getText("ITEM_NO")) <= -1 ? "" : "ForbiddenState";
            this._ctrConditionalOver.addEventListener("onContentInitialized",this);
            this._ctrConditionalOver.contentPath = _loc11_;
            this._ctrConditionalOver._visible = true;
         }
         this.resizeLabel();
      }
      else if(this._lbl.text != undefined)
      {
         this._oItem = undefined;
         this._lbl.text = "";
         this._lblArea.text = "";
         this._ctrSpellArea._visible = false;
         this._ldrElement._visible = false;
         this._ldrElement.contentPath = "";
         this._ctrConditionalOver._visible = false;
         this._ctrNotDispellable._visible = false;
         this._btnViewSpell._visible = false;
         this._ldrConditionalFalse.contentPath = "";
      }
      else
      {
         this._oItem = undefined;
      }
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.arrange();
   }
   function size()
   {
      super.size();
      this.addToQueue({object:this,method:this.arrange});
   }
   function resizeLabel()
   {
      this._lbl.width = this._nLabelWidth;
      if(!this._ctrSpellArea._visible)
      {
         this._lbl.width += 35;
      }
   }
   function showButton(btnButton, bShow_, sIcon)
   {
      btnButton._visible = bShow_;
      btnButton.icon = sIcon;
      if(bShow_ == false)
      {
         btnButton.removeEventListener("click",this);
      }
      else
      {
         btnButton.addEventListener("click",this);
      }
   }
   function onContentInitialized(oEvent)
   {
      var _loc3_ = oEvent.target;
      if(_loc3_.tempVars)
      {
         this.setFightStateOnContainer(_loc3_,_loc3_.tempVars.fightStateToPut);
      }
   }
   function setFightStateOnContainer(ctr, nState)
   {
      var _loc4_;
      var _loc5_;
      if(ctr.contentLoaded)
      {
         delete ctr.tempVars;
         _loc4_ = "State_" + nState;
         ctr.content._mcState.removeMovieClip();
         _loc5_ = ctr.content.attachMovie(_loc4_,"_mcState",ctr.content.getNextHighestDepth());
         ctr.sizeContent();
         _loc5_._xscale += 70;
         _loc5_._yscale += 70;
         _loc5_._x += 6;
         _loc5_._y += 6;
      }
      else
      {
         ctr.tempVars = {fightStateToPut:nState};
      }
   }
   function click(oEvent_)
   {
      var _loc3_ = _global.API;
      var _loc0_;
      var _loc4_;
      var _loc5_;
      if((_loc0_ = oEvent_.target) === this._btnViewSpell)
      {
         _loc4_ = _loc3_.datacenter.Spell.getSpellFromLevelID(this._oItem.fx.param3);
         _loc5_ = new dofus.datacenter.Spell(_loc4_.id,_loc4_.level);
         this.gapi.loadUIAutoHideComponent("SpellInfos","SpellInfos",{spell:_loc5_},{bStayIfPresent:true});
      }
   }
   function over(oEvent)
   {
      var _loc3_ = _global.API;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      switch(oEvent.target)
      {
         case this._ctrConditionalOver:
            if(this._sOverText != undefined)
            {
               _loc4_ = _loc3_.lang.getText("CONDITIONS") + "\n- " + this._sOverText;
               _loc3_.ui.showTooltip(_loc4_);
            }
            break;
         case this._ctrSpellArea:
            _loc5_ = this._oItem.at.charCodeAt(0);
            _loc6_ = _loc3_.lang.getText("EFFECT_SHAPE_TYPE_" + _loc5_,[this._oItem.ar != 63 ? this._oItem.ar : _loc3_.lang.getText("INFINIT")]);
            _loc3_.ui.showTooltip(_loc6_);
            break;
         case this._ctrNotDispellable:
            _loc7_ = _loc3_.lang.getText("NOT_DISPELLABLE");
            _loc3_.ui.showTooltip(_loc7_);
         default:
            return;
      }
   }
   function out(oEvent)
   {
      _global.API.ui.hideTooltip();
   }
}
