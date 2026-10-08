class dofus.aks.Houses extends dofus.aks.Handler
{
   var api;
   function Houses(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function kick(nID)
   {
      this.aks.send("hQ" + nID);
   }
   function leave()
   {
      this.aks.send("hV");
   }
   function sell(nPrice)
   {
      this.aks.send("hS" + nPrice,true);
   }
   function buy(nPrice)
   {
      this.aks.send("hB" + nPrice,true);
   }
   function state()
   {
      this.aks.send("hG",true);
   }
   function share()
   {
      this.aks.send("hG+",true);
   }
   function unshare()
   {
      this.aks.send("hG-",true);
   }
   function rights(nRights)
   {
      this.aks.send("hG" + nRights,true);
   }
   function onProperties(sExtraData)
   {
      var _loc3_ = new ank.utils.ExtendedObject();
      var _loc4_ = sExtraData.split("|");
      var _loc5_ = Number(_loc4_[0]);
      _loc4_.shift();
      _loc4_.reverse();
      var _loc6_ = 0;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      while(_loc6_ < _loc4_.length)
      {
         _loc7_ = _loc4_[_loc6_].split(";");
         _loc8_ = _loc7_[0];
         _loc9_ = _loc7_[1];
         _loc10_ = _loc7_[2];
         _loc11_ = _loc7_[3];
         _loc12_ = this.api.kernel.CharactersManager.createGuildEmblem(_loc7_[4]);
         _loc13_ = _loc7_[5] == "1";
         _loc14_ = _loc7_[6] == "1";
         _loc15_ = this.api.kernel.HouseManager.getHouseByInstance(_loc5_,_loc8_);
         _loc15_.instanceID = _loc8_;
         _loc15_.ownerName = _loc9_;
         _loc15_.price = _loc10_;
         _loc15_.isForSale = _loc10_ > 0;
         _loc15_.guildName = _loc11_;
         _loc15_.guildEmblem = _loc12_;
         _loc15_.isHuntTargetInside = _loc13_;
         _loc15_.isLocked = _loc14_;
         _loc15_.localOwner = _loc9_ == this.api.datacenter.Basics.dofusPseudo;
         _loc3_.addItemAt(_loc8_,_loc15_);
         _loc6_ = _loc6_ + 1;
      }
      this.api.datacenter.Houses.addItemAt(_loc5_,_loc3_);
   }
   function onLockedProperty(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      var _loc6_ = _loc3_[2] == "1";
      var _loc7_ = this.api.kernel.HouseManager.getHouseByInstance(_loc4_,_loc5_);
      _loc7_.isLocked = _loc6_;
   }
   function onCreate(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      var _loc6_ = Number(_loc3_[2]);
      var _loc7_ = this.api.kernel.HouseManager.getHouseByInstance(_loc4_,_loc5_);
      _loc7_.price = _loc6_;
      this.api.ui.loadUIComponent("HouseSale","HouseSale",{house:_loc7_});
   }
   function onSell(bSuccess, sExtraData)
   {
      var _loc4_ = sExtraData.split("|");
      var _loc5_ = Number(_loc4_[0]);
      var _loc6_ = Number(_loc4_[1]);
      var _loc7_ = Number(_loc4_[2]);
      var _loc8_ = this.api.kernel.HouseManager.getHouseByInstance(_loc5_,_loc6_);
      var _loc9_ = _loc7_ > 0;
      _loc8_.isForSale = _loc9_;
      _loc8_.price = _loc7_;
      var _loc10_ = new ank.utils.ExtendedString(_loc7_).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
      if(_loc9_)
      {
         if(bSuccess)
         {
            this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("HOUSE_SELL",[_loc8_.name,_loc10_]),"ERROR_BOX",{name:"SellHouse"});
         }
         else
         {
            this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_SELL_HOUSE"),"ERROR_BOX",{name:"SellHouse"});
         }
      }
      else
      {
         this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("HOUSE_NOSELL",[_loc8_.name]),"ERROR_BOX",{name:"NoSellHouse"});
      }
   }
   function onBuy(bSuccess, sExtraData)
   {
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc0_;
      if(bSuccess)
      {
         _loc4_ = sExtraData.split("|");
         _loc5_ = Number(_loc4_[0]);
         _loc6_ = Number(_loc4_[1]);
         _loc7_ = Number(_loc4_[2]);
         _loc8_ = this.api.kernel.HouseManager.getHouseByInstance(_loc5_,_loc6_);
         _loc9_ = new ank.utils.ExtendedString(_loc7_).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
         this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("HOUSE_BUY",[_loc8_.name,_loc9_]),"ERROR_BOX",{name:"BuyHouse"});
         _loc8_.isForSale = false;
         _loc8_.price = 0;
      }
      else if((_loc0_ = sExtraData.charAt(0)) === "C")
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_BUY_HOUSE",[sExtraData.substr(1)]),"ERROR_BOX",{name:"BuyHouse"});
      }
   }
   function onLeave()
   {
      this.api.ui.unloadUIComponent("HouseSale");
   }
   function onGuildInfos(sExtraData)
   {
      var _loc3_ = sExtraData.split(";");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      var _loc6_ = _loc3_[2];
      var _loc7_ = this.api.kernel.CharactersManager.createGuildEmblem(_loc3_[3]);
      var _loc8_ = Number(_loc3_[4]);
      var _loc9_ = !_global.isNaN(_loc8_);
      var _loc10_ = this.api.kernel.HouseManager.getHouseByInstance(_loc4_,_loc5_);
      _loc10_.isShared = _loc9_;
      _loc10_.guildName = _loc6_;
      _loc10_.guildEmblem = _loc7_;
      _loc10_.guildRights = _loc8_;
   }
   function onInformations(sExtraData)
   {
      var _loc3_ = sExtraData.split(";");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      var _loc6_ = _loc3_[2] == "1";
      var _loc7_ = _loc3_[3] == "1";
      var _loc8_ = _loc3_[4] == "1";
      var _loc9_ = this.api.kernel.HouseManager.getHouseByInstance(_loc4_,_loc5_);
      _loc9_.ownerName = this.api.datacenter.Basics.dofusPseudo;
      _loc9_.instanceID = _loc5_;
      _loc9_.isForSale = _loc6_;
      _loc9_.localOwner = true;
      _loc9_.isLocked = _loc7_;
      _loc9_.isShared = _loc8_;
      this.api.datacenter.Map.isMyHome = _loc9_.localOwner;
      var _loc10_ = this.api.lang.getHousesIndoorSkillsText();
      this.api.ui.loadUIComponent("HouseIndoor","HouseIndoor",{skills:_loc10_,house:_loc9_},{bStayIfPresent:true});
   }
}
