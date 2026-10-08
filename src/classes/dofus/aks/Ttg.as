class dofus.aks.Ttg extends dofus.aks.Handler
{
   var aks;
   var api;
   function Ttg(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function sendLeave()
   {
      this.aks.send("tc",true);
   }
   function sendGetAllDates(sTargetID)
   {
      this.aks.send("td" + sTargetID);
   }
   function sendShowCollection(sTargetName)
   {
      this.aks.send("ts" + sTargetName);
   }
   function sendRecycleCards(aToRecycle)
   {
      var _loc3_ = [];
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      while(_loc4_ < aToRecycle.length)
      {
         _loc5_ = aToRecycle[_loc4_];
         _loc6_ = _loc5_.itemGenericID;
         _loc7_ = _loc5_.quantity;
         if(!(_global.isNaN(_loc6_) || _global.isNaN(_loc7_)))
         {
            _loc8_ = String(_loc6_) + ";" + String(_loc7_);
            _loc3_.push(_loc8_);
         }
         _loc4_ = _loc4_ + 1;
      }
      if(_loc3_.length == 0)
      {
         return undefined;
      }
      this.aks.send("tr" + _loc3_.join("|"),undefined,undefined,true);
   }
   function sendUpgradeCard(nCardObjectGenericID)
   {
      this.aks.send("tu" + nCardObjectGenericID);
   }
   function onOpenMyCollection()
   {
      var _loc2_ = this.api.datacenter.Player.ID;
      var _loc3_ = this.api.datacenter.Player.ttgCollection;
      var _loc4_ = dofus.graphics.gapi.ui.CardsCollection(this.api.ui.getUIComponent("CardsCollection"));
      if(_loc4_ == undefined)
      {
         this.api.ui.loadUIAutoHideComponent("CardsCollection","CardsCollection",{playerID:_loc2_,ttgCollection:_loc3_},{nHideSprites:1});
      }
      else
      {
         _loc4_.setPlayerTtgCollection(_loc2_,_loc3_);
         _loc4_.onUpdatedData();
      }
   }
   function onCardsRecyclerLoots(sExtraData)
   {
      var _loc3_ = dofus.graphics.gapi.ui.CardsRecycler(this.api.ui.getUIComponent("CardsRecycler"));
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = sExtraData.split("|");
      var _loc5_ = new ank.utils.ExtendedArray();
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      if(sExtraData.length > 0)
      {
         _loc6_ = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc7_ = _loc4_[_loc6_].split(";");
            _loc8_ = Number(_loc7_[0]);
            _loc9_ = Number(_loc7_[1]);
            if(!(_global.isNaN(_loc8_) || _global.isNaN(_loc9_)))
            {
               _loc10_ = new dofus.datacenter.Item(undefined,_loc8_,_loc9_);
               _loc5_.push(_loc10_);
            }
            _loc6_ = _loc6_ + 1;
         }
      }
      _loc3_.setRewardMode(_loc5_);
   }
   function onOpenCardsUpgrader(nSkillId)
   {
      if(this.api.ui.getUIComponent("CardsUpgrader"))
      {
         return undefined;
      }
      this.api.ui.loadUIComponent("CardsUpgrader","CardsUpgrader",{skillId:nSkillId});
   }
   function onOpenCardsRecycler(nSkillId)
   {
      if(this.api.ui.getUIComponent("CardsRecycler"))
      {
         return undefined;
      }
      this.api.ui.loadUIComponent("CardsRecycler","CardsRecycler",{skillId:nSkillId});
   }
   function onAdd(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      var _loc4_ = this.api.datacenter.Player.ttgCollection.getTtgCard(_loc3_);
      if(_loc4_ == undefined)
      {
         return undefined;
      }
      var _loc5_ = _loc4_.entityName;
      if(_loc4_.isFoil)
      {
         _loc5_ += " (" + this.api.lang.getText("TTG_CARD_FOIL") + ")";
      }
      this.api.kernel.showMessage(undefined,this.api.lang.getText("TTG_USE_CARD",[_loc5_]),"INFO_CHAT");
      _loc4_.owned = true;
      var _loc6_ = dofus.graphics.gapi.ui.CardsCollection(this.api.ui.getUIComponent("CardsCollection"));
      if(_loc6_ != undefined)
      {
         _loc6_.refreshTtgCollectionStatistics();
         _loc6_.onUpdatedData();
      }
      var _loc7_;
      if(_loc4_.isFoil)
      {
         _loc7_ = dofus.graphics.gapi.ui.CardsUpgrader(this.api.ui.getUIComponent("CardsUpgrader"));
         if(_loc7_ != undefined)
         {
            _loc7_.playAnim();
            _loc7_.resetContainers();
         }
      }
   }
   function onList(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = _loc3_[0];
      var _loc5_ = _loc3_[1];
      var _loc6_ = _loc3_[2];
      var _loc7_ = new dofus.datacenter.ttg.TtgCollection(_loc4_,_loc5_,_loc6_);
      var _loc8_ = _loc4_ == this.api.datacenter.Player.ID;
      var _loc9_;
      if(_loc8_)
      {
         this.api.datacenter.Player.ttgCollection = _loc7_;
      }
      else
      {
         _loc9_ = dofus.graphics.gapi.ui.CardsCollection(this.api.ui.getUIComponent("CardsCollection"));
         if(_loc9_ == undefined)
         {
            this.api.ui.loadUIAutoHideComponent("CardsCollection","CardsCollection",{playerID:_loc4_,ttgCollection:_loc7_});
         }
         else
         {
            _loc9_.setPlayerTtgCollection(_loc4_,_loc7_);
            _loc9_.onUpdatedData();
         }
      }
   }
   function onDates(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = _loc3_[0];
      var _loc5_ = _loc3_[1];
      if(_loc5_ == undefined || _loc5_.length == 0)
      {
         return undefined;
      }
      this.parseDates(_loc4_,_loc5_);
   }
   function parseDates(sPlayerID, sCards)
   {
      var _loc5_ = dofus.graphics.gapi.ui.CardsCollection(this.api.ui.getUIComponent("CardsCollection"));
      var _loc4_;
      if(sPlayerID == this.api.datacenter.Player.ID)
      {
         _loc4_ = this.api.datacenter.Player.ttgCollection;
      }
      else
      {
         if(_loc5_ == undefined)
         {
            return undefined;
         }
         if(_loc5_.playerID != sPlayerID)
         {
            return undefined;
         }
         _loc4_ = _loc5_.ttgCollection;
      }
      var _loc6_ = false;
      var _loc7_ = sCards.split(";");
      var _loc8_ = 0;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      while(_loc8_ < _loc7_.length)
      {
         _loc9_ = _loc7_[_loc8_].split(",");
         _loc10_ = Number(_loc9_[0]);
         _loc11_ = Number(_loc9_[1]);
         _loc12_ = _loc4_.getTtgCard(_loc10_);
         if(_loc12_ != undefined)
         {
            if(!_loc12_.owned)
            {
               _loc6_ = true;
               _loc12_.owned = true;
            }
            _loc12_.ownedTimestamp = _loc11_;
         }
         _loc8_ = _loc8_ + 1;
      }
      if(_loc5_ != undefined)
      {
         if(_loc6_)
         {
            _loc5_.refreshTtgCollectionStatistics();
         }
         _loc5_.onUpdatedData();
      }
   }
   function onCreate(bSuccess, sExtraData)
   {
      if(!bSuccess)
      {
         return undefined;
      }
      var _loc4_ = Number(sExtraData);
      switch(_loc4_)
      {
         case 854:
            this.onOpenCardsRecycler(188);
            break;
         case 855:
            this.onOpenCardsUpgrader(189);
         default:
            return;
      }
   }
   function onLeave(bSuccess)
   {
      delete this.api.datacenter.Basics.aks_exchange_echangeType;
      delete this.api.datacenter.Exchange;
      this.api.ui.unloadUIComponent("AskYesNoIgnoreExchange");
      this.api.ui.unloadUIComponent("AskCancelExchange");
      this.api.ui.unloadUIComponent("CardsUpgrader");
      this.api.ui.unloadUIComponent("CardsRecycler");
      if(dofus.Constants.SAVING_THE_WORLD)
      {
         dofus.SaveTheWorld.getInstance().nextAction();
      }
   }
}
