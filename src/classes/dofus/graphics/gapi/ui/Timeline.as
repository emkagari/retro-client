class dofus.graphics.gapi.ui.Timeline extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnDown;
   var _btnUp;
   var _mcTableTurnDown;
   var _mcTableTurnUp;
   var _parent;
   var _tl;
   var _txtTableTurnDown;
   var _txtTableTurnUp;
   var _visible;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "Timeline";
   static var bTimelineUpPosition = false;
   static var OPTION_BUTTONS_MOVE_DISTANCE = 40;
   static var UI_TIMELINE_MOVE_DISTANCE = 350;
   static var UI_PARTY_MOVE_DISTANCE = 39;
   function Timeline()
   {
      super();
   }
   static function get isTimelineUpPosition()
   {
      return dofus.graphics.gapi.ui.Timeline.bTimelineUpPosition;
   }
   function update()
   {
      this._tl.update();
   }
   function nextTurn(id, bWithoutTween)
   {
      this.refreshCurrentTableTurnTxtFields();
      this._tl.nextTurn(id,bWithoutTween);
   }
   function get timelineControl()
   {
      return this._tl;
   }
   function hideItem(id)
   {
      this._tl.hideItem(id);
   }
   function showItem(id)
   {
      this._tl.showItem(id);
   }
   function startChrono(nDuration)
   {
      this._tl.startChrono(nDuration);
   }
   function stopChrono()
   {
      this._tl.stopChrono();
   }
   function itemOver(nObjectID)
   {
      this._tl.itemOver(nObjectID);
   }
   function itemOut(nObjectID)
   {
      this._tl.itemOut(nObjectID);
   }
   function refreshCurrentTableTurnTxtFields()
   {
      this._txtTableTurnDown.text = String(this.api.datacenter.Game.currentTableTurn);
      this._txtTableTurnUp.text = String(this.api.datacenter.Game.currentTableTurn);
   }
   function over(oEvent)
   {
      if(!this.gapi.isCursorHidden())
      {
         return undefined;
      }
      var _loc3_;
      switch(oEvent.target._name)
      {
         case "_mcTableTurnUp":
         case "_mcTableTurnDown":
            _loc3_ = this.api.lang.getText("TURNS_NUMBER") + " : " + this.api.datacenter.Game.currentTableTurn;
            this.gapi.showTooltip(_loc3_);
         default:
            return;
      }
   }
   function out()
   {
      this.gapi.hideTooltip();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Timeline.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      var _loc2_;
      var _loc3_;
      if(dofus.graphics.gapi.ui.Timeline.bTimelineUpPosition)
      {
         this.moveTimeline(- dofus.graphics.gapi.ui.Timeline.UI_TIMELINE_MOVE_DISTANCE);
         _loc2_ = this.api.ui.getUIComponent("FightOptionButtons");
         if(_loc2_ != undefined && _loc2_._btnFlag._y == 370)
         {
            _loc2_.moveButtons(dofus.graphics.gapi.ui.Timeline.OPTION_BUTTONS_MOVE_DISTANCE);
         }
         _loc3_ = this.api.ui.getUIComponent("Party");
         if(_loc3_ != undefined && _loc3_._btnBlockJoinerExceptParty._y == 41)
         {
            _loc3_.moveUI(dofus.graphics.gapi.ui.Timeline.UI_PARTY_MOVE_DISTANCE);
         }
         this._btnUp._visible = false;
         this._txtTableTurnDown._visible = false;
         this._mcTableTurnDown._visible = false;
      }
      else
      {
         this._btnDown._visible = false;
         this._txtTableTurnUp._visible = false;
         this._mcTableTurnUp._visible = false;
      }
      this.refreshCurrentTableTurnTxtFields();
   }
   function addListeners()
   {
      this._btnUp.addEventListener("click",this);
      this._btnDown.addEventListener("click",this);
      this._mcTableTurnDown.onRollOver = function()
      {
         this._parent.over({target:this});
      };
      this._mcTableTurnDown.onRollOut = function()
      {
         this._parent.out({target:this});
      };
      this._mcTableTurnUp.onRollOver = function()
      {
         this._parent.over({target:this});
      };
      this._mcTableTurnUp.onRollOut = function()
      {
         this._parent.out({target:this});
      };
      this.api.electron.addEventListener("onWindowFocusChanged",this);
   }
   function click(oEvent)
   {
      var _loc3_ = oEvent.target._name;
      switch(_loc3_)
      {
         case "_btnUp":
            dofus.graphics.gapi.ui.Timeline.bTimelineUpPosition = true;
            this._btnUp._visible = false;
            this._btnDown._visible = true;
            this._txtTableTurnUp._visible = true;
            this._txtTableTurnDown._visible = false;
            this._mcTableTurnUp._visible = true;
            this._mcTableTurnDown._visible = false;
            this.moveTimeline(- dofus.graphics.gapi.ui.Timeline.UI_TIMELINE_MOVE_DISTANCE);
            this.api.ui.getUIComponent("FightOptionButtons").moveButtons(dofus.graphics.gapi.ui.Timeline.OPTION_BUTTONS_MOVE_DISTANCE);
            this.api.ui.getUIComponent("Party").moveUI(dofus.graphics.gapi.ui.Timeline.UI_PARTY_MOVE_DISTANCE);
            break;
         case "_btnDown":
            dofus.graphics.gapi.ui.Timeline.bTimelineUpPosition = false;
            this._btnUp._visible = true;
            this._btnDown._visible = false;
            this._txtTableTurnUp._visible = false;
            this._txtTableTurnDown._visible = true;
            this._mcTableTurnUp._visible = false;
            this._mcTableTurnDown._visible = true;
            this.moveTimeline(dofus.graphics.gapi.ui.Timeline.UI_TIMELINE_MOVE_DISTANCE);
            this.api.ui.getUIComponent("FightOptionButtons").moveButtons(- dofus.graphics.gapi.ui.Timeline.OPTION_BUTTONS_MOVE_DISTANCE);
            this.api.ui.getUIComponent("Party").moveUI(- dofus.graphics.gapi.ui.Timeline.UI_PARTY_MOVE_DISTANCE);
         default:
            return;
      }
   }
   function destroy()
   {
      var _loc2_;
      var _loc3_;
      if(dofus.graphics.gapi.ui.Timeline.bTimelineUpPosition)
      {
         _loc2_ = this.api.ui.getUIComponent("FightOptionButtons");
         if(_loc2_ != undefined && _loc2_._btnFlag._y == 370 + dofus.graphics.gapi.ui.Timeline.OPTION_BUTTONS_MOVE_DISTANCE)
         {
            _loc2_.moveButtons(- dofus.graphics.gapi.ui.Timeline.OPTION_BUTTONS_MOVE_DISTANCE);
         }
         _loc3_ = this.api.ui.getUIComponent("Party");
         if(_loc3_ != undefined && _loc3_._btnBlockJoinerExceptParty._y == 41 + dofus.graphics.gapi.ui.Timeline.UI_PARTY_MOVE_DISTANCE)
         {
            _loc3_.moveUI(- dofus.graphics.gapi.ui.Timeline.UI_PARTY_MOVE_DISTANCE);
         }
      }
      this.api.electron.removeEventListener("onWindowFocusChanged",this);
   }
   function moveTimeline(nDistance)
   {
      this._tl._y += nDistance;
      this._btnUp._y += nDistance;
      this._btnDown._y += nDistance;
      this._txtTableTurnDown._y += nDistance;
      this._txtTableTurnUp._y += nDistance;
      this._mcTableTurnDown._y += nDistance;
      this._mcTableTurnUp._y += nDistance;
   }
   function onWindowFocusChanged(oEvent_)
   {
      if(this.api.kernel.OptionsManager.getOption("AntiLagHideTimeline"))
      {
         this._visible = oEvent_.isFocused;
      }
   }
}
