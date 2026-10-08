class dofus.datacenter.Team extends ank.battlefield.datacenter.Sprite
{
   var _aPlayers;
   var _nType;
   var _oAlignment;
   var _oChallenge;
   var api;
   var color1;
   var gfxFile;
   var id;
   var mc;
   var options;
   static var OPT_BLOCK_JOINER = "BlockJoiner";
   static var OPT_BLOCK_SPECTATOR = "BlockSpectator";
   static var OPT_BLOCK_JOINER_EXCEPT_PARTY_MEMBER = "BlockJoinerExceptPartyMember";
   static var OPT_NEED_HELP = "NeedHelp";
   function Team(sID, fClipClass, sGfxFile, nCellNum, nColor1, nType, nAlignment)
   {
      super();
      this.initialize(sID,fClipClass,sGfxFile,nCellNum,nColor1,nType,nAlignment);
   }
   function initialize(sID, fClipClass, sGfxFile, nCellNum, nColor1, nType, nAlignment)
   {
      super.initialize(sID,fClipClass,sGfxFile,nCellNum);
      this.color1 = nColor1;
      this._nType = Number(nType);
      this._oAlignment = new dofus.datacenter.Alignment(Number(nAlignment));
      this._aPlayers = {};
      this.options = {};
      this.api = _global.API;
   }
   function setChallenge(oChallenge)
   {
      this._oChallenge = oChallenge;
   }
   function addPlayer(oPlayer)
   {
      this._aPlayers[oPlayer.id] = oPlayer;
   }
   function removePlayer(sPlayerID)
   {
      delete this._aPlayers[sPlayerID];
   }
   function get type()
   {
      return this._nType;
   }
   function get alignment()
   {
      return this._oAlignment;
   }
   function get name()
   {
      var _loc2_ = new String();
      for(var k in this._aPlayers)
      {
         _loc2_ += "\n" + this._aPlayers[k].name + "(" + this._aPlayers[k].level + ")";
      }
      return _loc2_.substr(1);
   }
   function get _nBonusValue()
   {
      var _loc2_ = 0;
      for(var k in this._aPlayers)
      {
         _loc2_ += Number(this._aPlayers[k].level);
      }
      return _loc2_;
   }
   function get count()
   {
      var _loc2_ = 0;
      for(var k in this._aPlayers)
      {
         _loc2_ = _loc2_ + 1;
      }
      return _loc2_;
   }
   function get challenge()
   {
      return this._oChallenge;
   }
   function get enemyTeam()
   {
      var _loc2_ = this._oChallenge.teams;
      var _loc3_;
      for(var k in _loc2_)
      {
         if(k != this.id)
         {
            _loc3_ = k;
            break;
         }
      }
      return _loc2_[_loc3_];
   }
   function refreshSwordSprite()
   {
      if(this.type != 0)
      {
         return undefined;
      }
      var _loc2_ = this.isPartyMemberInTeam();
      var _loc3_ = dofus.Constants.getTeamFileFromType(this.type,this.alignment.index,_loc2_);
      if(_loc3_ != this.gfxFile)
      {
         this.gfxFile = _loc3_;
         this.mc.draw();
      }
   }
   function isPartyMemberInTeam()
   {
      var _loc2_ = dofus.graphics.gapi.ui.Party(this.api.ui.getUIComponent("Party"));
      var _loc3_;
      for(var k in this._aPlayers)
      {
         _loc3_ = this._aPlayers[k];
         if(_loc2_.getMember(_loc3_.id) != undefined)
         {
            return true;
         }
      }
      return false;
   }
}
