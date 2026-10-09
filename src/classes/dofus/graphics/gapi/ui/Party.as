class dofus.graphics.gapi.ui.Party extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aMembers;
   var _btnBlockJoinerExceptParty;
   var _btnOpenClose;
   var _mcInfo;
   var _nInitiativeTotal;
   var _nLvlTotal;
   var _nProspectionTotal;
   var _piMember0;
   var _piMember1;
   var _piMember2;
   var _piMember3;
   var _piMember4;
   var _piMember5;
   var _piMember6;
   var _piMember7;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "Party";
   var _sLeaderID = "0";
   var _sFollowID = "0";
   function Party()
   {
      super();
   }
   function get leaderID()
   {
      return this._sLeaderID;
   }
   function get followID()
   {
      return this._sFollowID;
   }
   function moveUI(nDistance)
   {
      this._btnOpenClose._y += nDistance;
      this._btnBlockJoinerExceptParty._y += nDistance;
      this._mcInfo._y += nDistance;
      this._piMember0._y += nDistance;
      this._piMember1._y += nDistance;
      this._piMember2._y += nDistance;
      this._piMember3._y += nDistance;
      this._piMember4._y += nDistance;
      this._piMember5._y += nDistance;
      this._piMember6._y += nDistance;
      this._piMember7._y += nDistance;
   }
   function addMember(oMember, bRefresh)
   {
      this._aMembers.push(oMember);
      if(bRefresh)
      {
         this.updateData();
      }
   }
   function getMember(sMemberID)
   {
      var _loc3_ = this._aMembers.findFirstItem("id",sMemberID);
      if(_loc3_.index != -1)
      {
         return _loc3_.item;
      }
      return null;
   }
   function getMemberById(nMemberID)
   {
      var _loc3_ = 0;
      while(_loc3_ < dofus.Constants.MEMBERS_COUNT_IN_PARTY)
      {
         if(this._aMembers[_loc3_].id == nMemberID)
         {
            return this._aMembers[_loc3_];
         }
         _loc3_ = _loc3_ + 1;
      }
      return null;
   }
   function removeMember(sMemberID, bRefresh)
   {
      var _loc4_ = this._aMembers.findFirstItem("id",sMemberID);
      if(this._sFollowID == sMemberID)
      {
         this.api.kernel.GameManager.updateCompass(this.api.datacenter.Basics.banner_targetCoords[0],this.api.datacenter.Basics.banner_targetCoords[1]);
         delete this._sFollowID;
      }
      if(_loc4_.index != -1)
      {
         this._aMembers.removeItems(_loc4_.index,1);
      }
      if(bRefresh)
      {
         this.updateData();
      }
   }
   function refresh()
   {
      this.addToQueue({object:this,method:this.updateData});
   }
   function setLeader(sLeaderID)
   {
      this._sLeaderID = sLeaderID;
      this.updateData();
      if(sLeaderID == undefined)
      {
         this.api.kernel.GameManager.updateCompass(this.api.datacenter.Basics.banner_targetCoords[0],this.api.datacenter.Basics.banner_targetCoords[0]);
      }
   }
   function setFollow(sFollowID)
   {
      this._sFollowID = sFollowID;
      this.updateData();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Party.CLASS_NAME);
      this._aMembers = new ank.utils.ExtendedArray();
   }
   function destroy()
   {
      this.api.datacenter.Player.totalPartyProspection = 0;
      this.gapi.hideTooltip();
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.updateData});
      this.addToQueue({object:this,method:this.initOption});
      if(this.api.ui.getUIComponent("Timeline") != undefined && dofus.graphics.gapi.ui.Timeline.isTimelineUpPosition)
      {
         this.moveUI(dofus.graphics.gapi.ui.Timeline.UI_PARTY_MOVE_DISTANCE);
      }
   }
   function addListeners()
   {
      this._btnOpenClose.addEventListener("click",this);
      this._btnOpenClose.addEventListener("over",this);
      this._btnOpenClose.addEventListener("out",this);
      this._btnBlockJoinerExceptParty.addEventListener("click",this);
      this._btnBlockJoinerExceptParty.addEventListener("over",this);
      this._btnBlockJoinerExceptParty.addEventListener("out",this);
   }
   function initOption()
   {
      this._btnBlockJoinerExceptParty.selected = this.api.kernel.OptionsManager.getOption("FightGroupAutoLock");
   }
   function updateData(oMemberTarget)
   {
      var _loc3_ = 0;
      this._nLvlTotal = 0;
      this._nProspectionTotal = 0;
      this._nInitiativeTotal = 0;
      var _loc5_ = false;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc4_;
      if(this._aMembers.length != 0)
      {
         _loc6_ = 0;
         while(_loc6_ < dofus.Constants.MEMBERS_COUNT_IN_PARTY)
         {
            _loc7_ = this._aMembers[_loc6_];
            _loc8_ = this["_piMember" + _loc3_++];
            if(oMemberTarget && oMemberTarget.id == _loc7_.id)
            {
               _loc7_ = oMemberTarget;
               this._aMembers[_loc6_] = oMemberTarget;
            }
            _loc8_.setData(_loc7_);
            _loc8_.following = _loc7_.id == this._sFollowID;
            _loc8_.isLeader = _loc7_.id == this._sLeaderID;
            if(_loc8_.isInGroup)
            {
               this._nLvlTotal += _loc7_.level;
               this._nProspectionTotal += _loc7_.prospection;
               this._nInitiativeTotal += _loc7_.initiative;
            }
            _loc6_ = _loc6_ + 1;
         }
         this.api.datacenter.Player.totalPartyProspection = this._nProspectionTotal;
         _loc9_ = true;
         while(_loc9_)
         {
            _loc9_ = false;
            _loc10_ = 0;
            while(_loc10_ < dofus.Constants.MEMBERS_COUNT_IN_PARTY)
            {
               if(this._aMembers[_loc10_ + 1] != undefined && this._aMembers[_loc10_].initiative < this._aMembers[_loc10_ + 1].initiative)
               {
                  _loc11_ = this._aMembers[_loc10_];
                  this._aMembers[_loc10_] = this._aMembers[_loc10_ + 1];
                  this._aMembers[_loc10_ + 1] = _loc11_;
                  _loc9_ = true;
               }
               _loc12_ = this["_piMember" + _loc10_];
               _loc12_._visible = !this._btnOpenClose.selected;
               _loc12_.setData(this._aMembers[_loc10_]);
               _loc12_.following = this._aMembers[_loc10_].id == this._sFollowID;
               _loc12_.isLeader = this._aMembers[_loc10_].id == this._sLeaderID;
               if(_loc12_.isInGroup)
               {
                  _loc4_ = _loc12_;
               }
               _loc10_ = _loc10_ + 1;
            }
         }
      }
      var ref = this;
      this._mcInfo.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._mcInfo.onRollOut = function()
      {
         ref.out({target:this});
      };
   }
   function click(oEvent)
   {
      var _loc0_;
      var _loc3_;
      if((_loc0_ = oEvent.target) !== this._btnBlockJoinerExceptParty)
      {
         this._piMember0._visible = !this._btnOpenClose.selected;
         this._piMember1._visible = !this._btnOpenClose.selected;
         this._piMember2._visible = !this._btnOpenClose.selected;
         this._piMember3._visible = !this._btnOpenClose.selected;
         this._piMember4._visible = !this._btnOpenClose.selected;
         this._piMember5._visible = !this._btnOpenClose.selected;
         this._piMember6._visible = !this._btnOpenClose.selected;
         this._piMember7._visible = !this._btnOpenClose.selected;
      }
      else
      {
         _loc3_ = !this.api.kernel.OptionsManager.getOption("FightGroupAutoLock");
         this.api.kernel.OptionsManager.setOption("FightGroupAutoLock",_loc3_);
      }
   }
   function over(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnOpenClose:
            this.gapi.showTooltip(this.api.lang.getText("PARTY_OPEN_CLOSE"));
            break;
         case this._mcInfo:
            this.gapi.showTooltip("<b>" + this.api.lang.getText("INFORMATIONS") + "</b>\n" + this.api.lang.getText("TOTAL_LEVEL") + " : " + "<b>" + this._nLvlTotal + "</b>\n" + this.api.lang.getText("TOTAL_INITIATIVE") + " : " + "<b>" + this._nInitiativeTotal + "</b>\n" + this.api.lang.getText("TOTAL_DISCERNMENT") + " : " + "<b>" + this._nProspectionTotal + "</b>\n");
            break;
         case this._btnBlockJoinerExceptParty:
            this.gapi.showTooltip(this.api.lang.getText("FIGHT_OPTION_BLOCKJOINEREXCEPTPARTY"));
         default:
            return;
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
