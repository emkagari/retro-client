class dofus.aks.ChooseReward extends dofus.aks.Handler
{
   var aks;
   var api;
   static var TOKENS_ARRAY;
   static var ICONS_NEEDED = 6;
   function ChooseReward(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function sendBuyReward(nIndex_)
   {
      this.aks.send("wb" + nIndex_);
   }
   function sendResetShop()
   {
      this.aks.send("wu");
   }
   function sendSellTonic(nIndex_)
   {
      this.aks.send("wd" + nIndex_);
   }
   function onData(sExtraData)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
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
      if(sExtraData.length != 0)
      {
         _loc3_ = [];
         _loc4_ = sExtraData.split("|");
         _loc5_ = _loc4_[3];
         _loc6_ = 0;
         while(_loc6_ < 3)
         {
            _loc7_ = [];
            _loc8_ = _loc4_[_loc6_].split(";");
            _loc9_ = new dofus.datacenter.Item(undefined,_loc8_[0]);
            _loc10_ = _loc8_[2].slice(14);
            _loc11_ = new dofus.datacenter.Item(undefined,undefined,1,0,String(_loc10_));
            _loc12_ = _loc8_[1].split(",");
            _loc13_ = 0;
            while(_loc13_ < dofus.aks.ChooseReward.ICONS_NEEDED)
            {
               _loc7_.push(new dofus.datacenter.Item(undefined,_loc12_[_loc13_]));
               _loc13_ = _loc13_ + 1;
            }
            _loc14_ = {};
            _loc14_.fakeItems = _loc7_;
            _loc14_.realItem = _loc9_;
            _loc14_.bonusEffects = _loc11_;
            _loc3_.push(_loc14_);
            _loc6_ = _loc6_ + 1;
         }
         if(dofus.aks.ChooseReward.TOKENS_ARRAY == undefined)
         {
            dofus.aks.ChooseReward.TOKENS_ARRAY = _loc4_[4].split(";");
            _loc15_ = 1;
            while(_loc15_ < dofus.aks.ChooseReward.TOKENS_ARRAY.length)
            {
               dofus.aks.ChooseReward.TOKENS_ARRAY[_loc15_] = Number(dofus.aks.ChooseReward.TOKENS_ARRAY[_loc15_ - 1]) + Number(dofus.aks.ChooseReward.TOKENS_ARRAY[_loc15_]);
               _loc15_ = _loc15_ + 1;
            }
         }
         if(this.api.ui.getUIComponent("ChooseReward") == undefined)
         {
            this.api.ui.loadUIComponent("ChooseReward","ChooseReward",{items:_loc3_,tokens:dofus.aks.ChooseReward.TOKENS_ARRAY,currentRoom:_loc5_},{bAlwaysOnTop:true});
         }
      }
   }
   function onShopData(sExtraData)
   {
      if(sExtraData == "c")
      {
         this.api.ui.unloadUIComponent("GladiatroolShop");
         return undefined;
      }
      var _loc3_ = [];
      var _loc4_ = sExtraData.split("|");
      var _loc5_ = Number(_loc4_.shift());
      var _loc6_ = Number(_loc4_.shift());
      this.api.datacenter.Gladiatrool.resetPrice = _loc5_;
      this.api.datacenter.Gladiatrool.resetNumber = _loc6_;
      var _loc7_ = 0;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      while(_loc7_ < 6)
      {
         _loc8_ = [];
         _loc9_ = _loc4_[_loc7_].split(";");
         _loc10_ = new dofus.datacenter.Item(undefined,_loc9_[0],undefined,undefined,String(this.api.lang.getItemStats(_loc9_[0])));
         _loc11_ = _loc9_[1].split(",");
         _loc12_ = 0;
         while(_loc12_ < dofus.aks.ChooseReward.ICONS_NEEDED)
         {
            _loc8_.push(new dofus.datacenter.Item(undefined,_loc11_[_loc12_]));
            _loc12_ = _loc12_ + 1;
         }
         _loc13_ = {};
         _loc13_.fakeItems = _loc8_;
         _loc13_.realItem = _loc10_;
         _loc13_.price = Number(_loc9_[2]);
         _loc3_.push(_loc13_);
         _loc7_ = _loc7_ + 1;
      }
      this.api.datacenter.Gladiatrool.shopItems = _loc3_;
      if(this.api.ui.getUIComponent("GladiatroolShop") == undefined)
      {
         this.api.ui.loadUIComponent("GladiatroolShop","GladiatroolShop");
      }
   }
   function onPlayerData(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      this.api.datacenter.Gladiatrool.currentRoom = Number(_loc3_[0]);
      var _loc4_ = _loc3_[1].split(";");
      var _loc5_ = 1;
      while(_loc5_ < _loc4_.length)
      {
         _loc4_[_loc5_] = Number(_loc4_[_loc5_ - 1]) + Number(_loc4_[_loc5_]);
         _loc5_ = _loc5_ + 1;
      }
      this.api.datacenter.Gladiatrool.tokens = _loc4_;
      this.api.datacenter.Gladiatrool.shopTokens = Number(_loc3_[2]);
      var _loc6_ = new dofus.datacenter.Item(undefined,undefined,1,0,String(_loc3_[3].split(",")));
      this.api.datacenter.Gladiatrool.effects = _loc6_;
      var _loc7_ = [];
      var _loc8_ = _loc3_[4].split(";");
      var _loc9_ = this.api.datacenter.Gladiatrool.getTonicItems();
      var _loc10_ = 0;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      while(_loc10_ < _loc8_.length)
      {
         _loc11_ = _loc8_[_loc10_].split(",");
         _loc12_ = _loc9_.findFirstItem("unicID",_loc11_[0]);
         if(_loc12_.index != -1)
         {
            _loc13_ = dofus.datacenter.Item(_loc12_.item);
            _loc9_.removeItems(_loc12_.index,1);
         }
         else
         {
            _loc13_ = new dofus.datacenter.Item(undefined,_loc11_[0],undefined,undefined,String(this.api.lang.getItemStats(_loc11_[0])));
         }
         _loc14_ = {};
         _loc14_.realItem = _loc13_;
         _loc14_.price = _loc11_[1];
         _loc7_.push(_loc14_);
         _loc10_ = _loc10_ + 1;
      }
      this.api.datacenter.Gladiatrool.items = _loc7_;
   }
   function onBought(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      this.api.datacenter.Gladiatrool.removeShopItem(_loc3_);
   }
}
