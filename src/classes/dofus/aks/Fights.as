class dofus.aks.Fights extends dofus.aks.Handler
{
   var aks;
   var api;
   function Fights(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function getList()
   {
      this.aks.send("fL");
   }
   function getDetails(nID)
   {
      this.aks.send("fD" + nID,false);
   }
   function blockSpectators()
   {
      this.aks.send("fS");
   }
   function blockJoinerExceptParty()
   {
      this.aks.send("fP");
   }
   function blockJoiner()
   {
      this.aks.send("fN");
   }
   function needHelp()
   {
      this.aks.send("fH");
   }
   function exchangeStartPosition(sPlayerID)
   {
      this.aks.send("fE" + sPlayerID);
   }
   function onFightsOpenAndAutoSelect(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      if(this.api.ui.getUIComponent("FightsInfos") == undefined)
      {
         this.api.ui.loadUIComponent("FightsInfos","FightsInfos",{autoSelectFightID:_loc3_},{bAlwaysOnTop:true});
      }
   }
   function onCount(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      if(_global.isNaN(_loc3_) || (sExtraData.length == 0 || _loc3_ == 0))
      {
         this.api.ui.getUIComponent("Banner").fightsCount = 0;
      }
      else if(_loc3_ < 0)
      {
         if(this.api.ui.getUIComponent("Banner").fightsCount >= _loc3_)
         {
            this.api.ui.getUIComponent("Banner").fightsCount = this.api.ui.getUIComponent("Banner").fightsCount + _loc3_;
         }
      }
      else
      {
         this.api.ui.getUIComponent("Banner").fightsCount = _loc3_;
      }
   }
   function onList(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = [];
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      var _loc17_;
      var _loc18_;
      while(_loc5_ < _loc3_.length)
      {
         if(String(_loc3_[_loc5_]).length != 0)
         {
            _loc6_ = _loc3_[_loc5_].split(";");
            _loc7_ = Number(_loc6_[0]);
            _loc8_ = Number(_loc6_[1]);
            _loc9_ = _loc8_ != -1 ? this.api.kernel.NightManager.getDiffDate(_loc8_) : -1;
            _loc10_ = new dofus.datacenter.FightInfos(_loc7_,_loc9_);
            _loc11_ = String(_loc6_[2]).split(",");
            _loc12_ = Number(_loc11_[0]);
            _loc13_ = Number(_loc11_[1]);
            _loc14_ = Number(_loc11_[2]);
            _loc10_.addTeam(1,_loc12_,_loc13_,_loc14_);
            _loc15_ = String(_loc6_[3]).split(",");
            _loc16_ = Number(_loc15_[0]);
            _loc17_ = Number(_loc15_[1]);
            _loc18_ = Number(_loc15_[2]);
            _loc10_.addTeam(2,_loc16_,_loc17_,_loc18_);
            _loc4_.push(_loc10_);
         }
         _loc5_ = _loc5_ + 1;
      }
      var _loc19_ = dofus.graphics.gapi.ui.FightsInfos(this.api.ui.getUIComponent("FightsInfos"));
      if(_loc19_ == undefined)
      {
         return undefined;
      }
      var _loc20_ = _loc19_.fights;
      if(_loc20_ != null)
      {
         _loc20_.splice(0,_loc20_.length);
         _loc20_.replaceAll(0,_loc4_);
      }
      _loc19_.doAutoSelectFightIDRow();
   }
   function onDetails(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = new ank.utils.ExtendedArray();
      var _loc6_ = _loc3_[1].split(";");
      var _loc7_ = 0;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      while(_loc7_ < _loc6_.length)
      {
         if(_loc6_[_loc7_] != "")
         {
            _loc8_ = _loc6_[_loc7_].split("~");
            _loc9_ = this.api.kernel.CharactersManager.getNameFromData(_loc8_[0]);
            _loc10_ = Number(_loc8_[1]);
            _loc11_ = _loc8_[2];
            _loc12_ = Number(_loc8_[3]);
            _loc13_ = _loc8_[4] == "1";
            _loc5_.push({name:_loc9_.name,level:_loc10_,type:_loc9_.type,id:_loc11_,icon:_loc12_,alive:_loc13_});
         }
         _loc7_ = _loc7_ + 1;
      }
      var _loc14_ = new ank.utils.ExtendedArray();
      var _loc15_ = _loc3_[2].split(";");
      var _loc16_ = 0;
      var _loc17_;
      var _loc18_;
      var _loc19_;
      var _loc20_;
      var _loc21_;
      var _loc22_;
      while(_loc16_ < _loc15_.length)
      {
         if(_loc15_[_loc16_] != "")
         {
            _loc17_ = _loc15_[_loc16_].split("~");
            _loc18_ = this.api.kernel.CharactersManager.getNameFromData(_loc17_[0]);
            _loc19_ = Number(_loc17_[1]);
            _loc20_ = _loc17_[2];
            _loc21_ = Number(_loc17_[3]);
            _loc22_ = _loc17_[4] == "1";
            _loc14_.push({name:_loc18_.name,level:_loc19_,type:_loc18_.type,id:_loc20_,icon:_loc21_,alive:_loc22_});
         }
         _loc16_ = _loc16_ + 1;
      }
      this.api.ui.getUIComponent("FightsInfos").addFightTeams(_loc4_,_loc5_,_loc14_);
   }
}
