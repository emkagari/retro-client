class dofus.graphics.gapi.ui.DailyQuests extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnLocate;
   var _lblTimeReset;
   var _lblTitleDailyMission;
   var _ldrAboutMission;
   var _ldrAboutQuest;
   var _lstDailyQuests;
   var _svCharacterViewer;
   var _txtMissionDescription;
   var _winBgMission;
   var _winBgQuest;
   var addToQueue;
   var unloadThis;
   static var CLASS_NAME = "DailyQuests";
   static var NB_CHECK = 7;
   function DailyQuests()
   {
      super();
   }
   function updateData()
   {
      this._lblTimeReset.text = this.getTimeToPrint();
      var _loc2_ = this.api.datacenter.DailyQuests.completedTask;
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < dofus.graphics.gapi.ui.DailyQuests.NB_CHECK)
      {
         _loc4_ = this["_mcCheck" + _loc3_];
         _loc4_._visible = _loc3_ < _loc2_;
         _loc3_ = _loc3_ + 1;
      }
      var _loc5_ = this.api.lang.getNonPlayableCharactersText(this.api.datacenter.DailyQuests.missionNpc.npc.id).n;
      this._txtMissionDescription.text = this.api.lang.getText("MISSION_TYPE_" + this.api.datacenter.DailyQuests.missionType,[_loc5_]);
      this._lstDailyQuests.dataProvider = this.api.datacenter.DailyQuests.dailyQuests;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.DailyQuests.CLASS_NAME);
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < dofus.graphics.gapi.ui.DailyQuests.NB_CHECK)
      {
         _loc4_ = this["_mcCheck" + _loc3_];
         _loc4_._visible = false;
         _loc3_ = _loc3_ + 1;
      }
   }
   function createChildren()
   {
      this.api.network.Quests.getDailies();
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.initializeSprite});
      this.addToQueue({object:this,method:this.addListeners});
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function initTexts()
   {
      this._lblTitleDailyMission.text = this.api.lang.getText("MISSION_OF_THE_DAY");
      this._winBgMission.title = this.api.lang.getText("DAILY_MISSIONS");
      this._winBgQuest.title = this.api.lang.getText("DAILY_QUESTS");
   }
   function initializeSprite()
   {
      var _loc2_ = this.api.datacenter.DailyQuests.missionNpc.npc;
      var _loc3_ = new ank.battlefield.datacenter.Sprite("viewer",ank.battlefield.mc.Sprite,dofus.Constants.CLIPS_PERSOS_PATH + _loc2_.gfx + ".swf",undefined,5);
      _loc3_.color1 = _loc2_.c1;
      _loc3_.color2 = _loc2_.c2;
      _loc3_.color3 = _loc2_.c3;
      this.api.kernel.CharactersManager.setSpriteAccessories(_loc3_,_loc2_.a);
      _loc3_.accessories = _loc2_.a;
      this._svCharacterViewer.spriteData = _loc3_;
      this._svCharacterViewer.useSingleLoader = true;
      this._svCharacterViewer.spriteAnims = ["emoteStatic14R"];
      this._svCharacterViewer.noDelay = true;
   }
   function addListeners()
   {
      this._btnLocate.addEventListener("click",this);
      this._btnLocate.addEventListener("over",this);
      this._btnLocate.addEventListener("out",this);
      this._ldrAboutMission.addEventListener("over",this);
      this._ldrAboutMission.addEventListener("out",this);
      this._ldrAboutQuest.addEventListener("over",this);
      this._ldrAboutQuest.addEventListener("out",this);
      this.api.datacenter.DailyQuests.addEventListener("updateData",this);
   }
   function getTimeToPrint()
   {
      var _loc2_ = new Date(this.api.datacenter.DailyQuests.timeReset);
      var _loc3_ = _loc2_.getDate();
      var _loc4_ = _loc2_.getMonth() + 1;
      var _loc5_ = _loc2_.getHours();
      var _loc6_ = _loc2_.getMinutes();
      return this.api.lang.getText("NEXT_DAILY_RESET",[_loc3_ >= 10 ? _loc3_ : "0" + _loc3_,_loc4_ >= 10 ? _loc4_ : "0" + _loc4_,_loc5_ >= 10 ? _loc5_ : "0" + _loc5_,_loc6_ >= 10 ? _loc6_ : "0" + _loc6_]);
   }
   function getTimeBeforeReset()
   {
      var _loc2_ = new Date().getTime();
      var _loc3_ = this.api.datacenter.DailyQuests.timeReset - _loc2_;
      var _loc4_ = new Date(_loc3_);
      var _loc5_ = _loc4_.getHours();
      var _loc6_ = _loc4_.getMinutes();
      return (_loc5_ >= 10 ? _loc5_ : "0" + _loc5_) + ":" + (_loc6_ >= 10 ? _loc6_ : "0" + _loc6_);
   }
   function click(oEvent_)
   {
      var _loc0_;
      if((_loc0_ = oEvent_.target) === this._btnLocate)
      {
         this.api.ui.loadUIComponent("MapExplorer","MapExplorer",{mapID:this.api.datacenter.DailyQuests.missionNpc.mapId});
      }
   }
   function over(oEvent_)
   {
      var _loc3_;
      switch(oEvent_.target)
      {
         case this._btnLocate:
            _loc3_ = this.api.lang.getMapText(this.api.datacenter.DailyQuests.missionNpc.mapId);
            this.api.ui.showTooltip(this.api.lang.getText("LOCATE") + " " + "[" + _loc3_.x + ", " + _loc3_.y + "]");
            break;
         case this._ldrAboutMission:
            this.api.ui.showTooltip(this.api.lang.getText("DAILY_MISSIONS_INFOS"));
            break;
         case this._ldrAboutQuest:
            this.api.ui.showTooltip(this.api.lang.getText("DAILY_MISSIONS_INFOS_QUESTS"));
         default:
            return;
      }
   }
   function out(oEvent_)
   {
      this.api.ui.hideTooltip();
   }
}
