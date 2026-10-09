class dofus.graphics.gapi.ui.FightsInfos extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnClose2;
   var _btnJoin;
   var _dgFights;
   var _eaFights;
   var _lblPlayers;
   var _lblTeam1Level;
   var _lblTeam2Level;
   var _lstTeam1;
   var _lstTeam2;
   var _mcBackTeam;
   var _mcSquare1;
   var _mcSquare2;
   var _nAutoSelectFightID;
   var _oSelectedFight;
   var _txtSelectFight;
   var _winBg;
   var addToQueue;
   var setMovieClipColor;
   var unloadThis;
   static var CLASS_NAME = "FightsInfos";
   function FightsInfos()
   {
      super();
   }
   function get fights()
   {
      return this._eaFights;
   }
   function set autoSelectFightID(nFightID)
   {
      this._nAutoSelectFightID = nFightID;
   }
   function addFightTeams(nFightID, eaTeam1, eaTeam2)
   {
      var _loc6_ = this._eaFights.findFirstItem("id",nFightID);
      var _loc5_;
      if(_loc6_.index != -1)
      {
         _loc5_ = _loc6_.item;
      }
      _loc5_.addPlayers(1,eaTeam1);
      _loc5_.addPlayers(2,eaTeam2);
      this.showTeamInfos(true,this._oSelectedFight);
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.FightsInfos.CLASS_NAME);
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this._eaFights = new ank.utils.ExtendedArray();
      this.showTeamInfos(false);
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this.api.network.Fights,method:this.api.network.Fights.getList});
      this.setMovieClipColor(this._mcSquare1,dofus.Constants.TEAMS_COLOR[0]);
      this.setMovieClipColor(this._lblPlayers,dofus.Constants.TEAMS_COLOR[1]);
   }
   function initTexts()
   {
      this._btnClose2.label = this.api.lang.getText("CLOSE");
      this._btnJoin.label = this.api.lang.getText("JOIN_SMALL");
      this._winBg.title = this.api.lang.getText("CURRENT_FIGTHS");
      this._dgFights.columnsNames = [this.api.lang.getText("FIGHTERS_COUNT"),this.api.lang.getText("DURATION")];
      this._mcBackTeam.text = this.api.lang.getText("FIGHTERS");
      this._txtSelectFight.text = this.api.lang.getText("SELECT_FIGHT_FOR_SPECTATOR");
      if(this._lblTeam1Level.text != undefined)
      {
         this._lblTeam1Level.text = "";
      }
      if(this._lblTeam2Level.text != undefined)
      {
         this._lblTeam2Level.text = "";
      }
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnClose2.addEventListener("click",this);
      this._btnJoin.addEventListener("click",this);
      this._dgFights.addEventListener("itemSelected",this);
      this._dgFights.addEventListener("itemdblClick",this);
      this._lstTeam1.addEventListener("itemSelected",this);
      this._lstTeam2.addEventListener("itemSelected",this);
   }
   function initData()
   {
      this._dgFights.dataProvider = this._eaFights;
   }
   function showTeamInfos(bShow, oFight)
   {
      this._lblTeam1Level._visible = bShow;
      this._lblTeam2Level._visible = bShow;
      this._lstTeam1._visible = bShow;
      this._lstTeam2._visible = bShow;
      this._mcSquare2._visible = bShow;
      this._mcSquare1._visible = bShow;
      this._lblPlayers._visible = bShow;
      this._txtSelectFight._visible = !bShow;
      this._btnJoin.enabled = bShow;
      if(bShow)
      {
         this._lblTeam1Level.text = this.api.lang.getText("LEVEL") + " " + oFight.team1Level;
         this._lblTeam2Level.text = this.api.lang.getText("LEVEL") + " " + oFight.team2Level;
         this._lstTeam1.dataProvider = oFight.team1Players;
         this._lstTeam2.dataProvider = oFight.team2Players;
      }
   }
   function doAutoSelectFightIDRow()
   {
      var _loc2_ = this._nAutoSelectFightID;
      this._nAutoSelectFightID = undefined;
      if(_global.isNaN(_loc2_))
      {
         return undefined;
      }
      var _loc3_ = this._eaFights.findFirstItem("id",_loc2_);
      var _loc4_ = _loc3_.index;
      if(_loc4_ == -1)
      {
         return undefined;
      }
      var _loc5_ = _loc3_.item;
      this._dgFights.selectedIndex = _loc4_;
      this._oSelectedFight = _loc5_;
      if(this._oSelectedFight.hasTeamPlayers)
      {
         this.showTeamInfos(true,this._oSelectedFight);
      }
      else
      {
         this.api.network.Fights.getDetails(this._oSelectedFight.id);
         this.showTeamInfos(false);
      }
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnClose:
         case this._btnClose2:
            this.callClose();
            break;
         case this._btnJoin:
            this.api.network.GameActions.joinChallengeAsSpectator(this._oSelectedFight.id);
            this.callClose();
         default:
            return;
      }
   }
   function itemSelected(oEvent)
   {
      var _loc0_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      if((_loc0_ = oEvent.target) !== this._dgFights)
      {
         if(oEvent.row.item.type == "player")
         {
            _loc3_ = oEvent.row.item.id;
            _loc4_ = oEvent.row.item.name;
            if(this.api.datacenter.Player.isAuthorized && Key.isDown(Key.SHIFT))
            {
               _loc5_ = "";
               _loc6_ = false;
               _loc7_ = 0;
               while(_loc7_ < this._lstTeam1.dataProvider.length)
               {
                  _loc8_ = this._lstTeam1.dataProvider[_loc7_].name;
                  if(_loc8_ == _loc4_)
                  {
                     _loc6_ = true;
                  }
                  _loc5_ += _loc8_ + ",";
                  _loc7_ = _loc7_ + 1;
               }
               if(!_loc6_)
               {
                  _loc5_ = "";
                  _loc9_ = 0;
                  while(_loc9_ < this._lstTeam2.dataProvider.length)
                  {
                     _loc10_ = this._lstTeam2.dataProvider[_loc9_].name;
                     if(_loc10_ == _loc4_)
                     {
                        _loc6_ = true;
                     }
                     _loc5_ += _loc10_ + ",";
                     _loc9_ = _loc9_ + 1;
                  }
               }
               if(_loc6_)
               {
                  _loc5_ = _loc5_.substring(0,_loc5_.length - 1);
                  this.api.kernel.GameManager.showTeamAdminPopupMenu(_loc5_);
               }
            }
            else
            {
               this.api.kernel.GameManager.showPlayerPopupMenu(undefined,{sPlayerName:_loc4_,sPlayerID:_loc3_});
            }
         }
      }
      else
      {
         this._oSelectedFight = oEvent.row.item;
         if(this._oSelectedFight.hasTeamPlayers)
         {
            this.showTeamInfos(true,this._oSelectedFight);
         }
         else
         {
            this.api.network.Fights.getDetails(this._oSelectedFight.id);
            this.showTeamInfos(false);
         }
      }
   }
   function itemdblClick(oEvent_)
   {
      if(this._btnJoin.enabled)
      {
         this.click({target:this._btnJoin});
      }
   }
}
