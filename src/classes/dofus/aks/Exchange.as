class dofus.aks.Exchange extends dofus.aks.Handler
{
   var _lastMovedItemAdd;
   var _nItemsToCraft;
   var aks;
   var api;
   var _lastMovedItemId = -1;
   function Exchange(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function leave()
   {
      this.aks.send("EV",true);
   }
   function request(type, id, cellNum)
   {
      this.aks.send("ER" + type + "|" + (!(id == undefined || _global.isNaN(id)) ? id : "") + (!(cellNum == undefined || _global.isNaN(cellNum)) ? "|" + cellNum : ""),true);
   }
   function shop(nID)
   {
      this.aks.send("Es" + nID);
   }
   function accept()
   {
      this.aks.send("EA",false);
   }
   function ready()
   {
      this.aks.send("EK",true);
   }
   function movementItem(bAdd, oItem, nQuantity, nPrice)
   {
      if(this._lastMovedItemId == oItem.ID && bAdd == this._lastMovedItemAdd)
      {
         return undefined;
      }
      if(nQuantity == oItem.Quantity)
      {
         this._lastMovedItemId = oItem.ID;
         this._lastMovedItemAdd = bAdd;
      }
      else
      {
         this._lastMovedItemId = -1;
      }
      this.aks.send("EMO" + (!bAdd ? "-" : "+") + oItem.ID + "|" + nQuantity + (nPrice != undefined ? "|" + nPrice : ""),true);
   }
   function movementItems(aItems)
   {
      var _loc3_ = "";
      var _loc8_ = 0;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      while(_loc8_ < aItems.length)
      {
         _loc4_ = aItems[_loc8_].Add;
         _loc5_ = aItems[_loc8_].ID;
         _loc6_ = aItems[_loc8_].Quantity;
         _loc7_ = aItems[_loc8_].Price;
         _loc3_ += (!_loc4_ ? "-" : "+") + _loc5_ + "|" + _loc6_ + (_loc7_ != undefined ? "|" + _loc7_ : "");
         _loc8_ = _loc8_ + 1;
      }
      this.aks.send("EMO" + _loc3_,true,undefined,true);
   }
   function movementPayItem(nGarbage, bAdd, nID, nQuantity, nPrice)
   {
      this.aks.send("EP" + nGarbage + "O" + (!bAdd ? "-" : "+") + nID + "|" + nQuantity + (nPrice != undefined ? "|" + nPrice : ""),true);
   }
   function movementKama(nQuantity)
   {
      this.aks.send("EMG" + nQuantity,true);
   }
   function movementPayKama(nGarbage, nQuantity)
   {
      this.aks.send("EP" + nGarbage + "G" + nQuantity,true);
   }
   function sell(id, quantity)
   {
      this.aks.send("ES" + id + "|" + quantity,true);
   }
   function buy(nID, nQuantity)
   {
      this.aks.send("EB" + nID + "|" + nQuantity,true);
   }
   function offlineExchange()
   {
      this.aks.send("EQ",true);
   }
   function askOfflineExchange()
   {
      this.aks.send("Eq",true);
   }
   function bigStoreType(nTypeID)
   {
      this.aks.send("EHT" + nTypeID);
   }
   function bigStoreItemList(nUnicID)
   {
      this.aks.send("EHl" + nUnicID);
   }
   function bigStoreSoulList(sMonstersList)
   {
      this.aks.send("EHM" + sMonstersList);
   }
   function bigStoreBuy(nID, nQuantityIndex, nPrice)
   {
      this.aks.send("EHB" + nID + "|" + nQuantityIndex + "|" + nPrice,true);
   }
   function bigStoreSearch(nType, nUnicID)
   {
      this.aks.send("EHS" + nType + "|" + nUnicID);
   }
   function setPublicMode(b)
   {
      this.aks.send("EW" + (!b ? "-" : "+"),false);
   }
   function getCrafterForJob(nJobId)
   {
      this.aks.send("EJF" + nJobId,true);
   }
   function putInShedFromInventory(nMountID)
   {
      this.aks.send("Erp" + nMountID,true);
   }
   function putInInventoryFromShed(nMountID)
   {
      this.aks.send("Erg" + nMountID,true);
   }
   function putInCertificateFromShed(nMountID)
   {
      this.aks.send("Erc" + nMountID,true);
   }
   function putInShedFromCertificate(nCertifID)
   {
      this.aks.send("ErC" + nCertifID,true);
   }
   function putInMountParkFromShed(nMountID)
   {
      this.aks.send("Efp" + nMountID,true);
   }
   function putInShedFromMountPark(nMountID)
   {
      this.aks.send("Efg" + nMountID,true);
   }
   function killMountInPark(nMountID)
   {
      this.aks.send("Eff" + nMountID,false);
   }
   function killMount(nMountID)
   {
      this.aks.send("Erf" + nMountID,false);
   }
   function getItemMiddlePriceInBigStore(nItemID)
   {
      this.aks.send("EHP" + nItemID,false);
   }
   function replayCraft()
   {
      this.aks.send("EL",false);
   }
   function repeatCraft(nHowManyTimes)
   {
      this._nItemsToCraft = nHowManyTimes;
      this.aks.send("EMR" + nHowManyTimes,false);
      this.api.datacenter.Basics.isCraftLooping = true;
   }
   function stopRepeatCraft()
   {
      this.aks.send("EMr",false);
   }
   function transferAll(sParams)
   {
      this.aks.send("ET" + sParams,false);
   }
   function setQuantity(nQty)
   {
      this.aks.send("Ec" + nQty,true);
   }
   function markCraft(bMarked)
   {
      this.aks.send("Em" + (!bMarked ? "0" : "1"),true);
   }
   function onRequest(bSuccess, sExtraData)
   {
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
      if(bSuccess)
      {
         _loc4_ = sExtraData.split("|");
         _loc5_ = _loc4_[0];
         _loc6_ = _loc4_[1];
         _loc7_ = Number(_loc4_[2]);
         _loc8_ = this.api.datacenter.Player.ID != _loc5_ ? _loc5_ : _loc6_;
         if(_loc7_ == 12 || _loc7_ == 13)
         {
            _loc9_ = new dofus.datacenter.SecureCraftExchange(_loc8_);
         }
         else
         {
            _loc9_ = new dofus.datacenter.Exchange(_loc8_);
         }
         this.api.datacenter.Exchange = _loc9_;
         if(this.api.datacenter.Player.ID == _loc5_)
         {
            _loc10_ = this.api.datacenter.Sprites.getItemAt(_loc6_);
            switch(_loc7_)
            {
               case 1:
                  _loc11_ = "WAIT_FOR_EXCHANGE";
                  break;
               case 12:
                  _loc11_ = "WAIT_FOR_CRAFT_CLIENT";
                  break;
               case 13:
                  _loc11_ = "WAIT_FOR_CRAFT_ARTISAN";
            }
            this.api.kernel.showMessage(this.api.lang.getText("EXCHANGE"),this.api.lang.getText(_loc11_,[_loc10_.name]),"INFO_CANCEL",{name:"Exchange",listener:this});
         }
         else
         {
            _loc12_ = this.api.datacenter.Sprites.getItemAt(_loc5_);
            if(this.api.kernel.ChatManager.isBlacklisted(_loc12_.name))
            {
               this.leave();
               return undefined;
            }
            this.api.kernel.showMessage(undefined,this.api.lang.getText("CHAT_A_WANT_EXCHANGE",[this.api.kernel.ChatManager.getLinkName(_loc12_.id,_loc12_.name)]),"INFO_CHAT");
            switch(_loc7_)
            {
               case 1:
                  _loc13_ = "A_WANT_EXCHANGE";
                  break;
               case 12:
                  _loc13_ = "A_WANT_CRAFT_CLIENT";
                  break;
               case 13:
                  _loc13_ = "A_WANT_CRAFT_ARTISAN";
            }
            this.api.electron.makeNotification(this.api.lang.getText(_loc13_,[_loc12_.name]));
            this.api.kernel.showMessage(this.api.lang.getText("EXCHANGE"),this.api.lang.getText(_loc13_,[_loc12_.name]),"CAUTION_YESNOIGNORE",{name:"Exchange",player:_loc12_.name,listener:this,params:{player:_loc12_.name}});
         }
      }
      else
      {
         _loc14_ = sExtraData.charAt(0);
         switch(_loc14_)
         {
            case "O":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("ALREADY_EXCHANGE"),"ERROR_CHAT");
               return;
            case "T":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("NOT_NEAR_CRAFT_TABLE"),"ERROR_CHAT");
               return;
            case "J":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_85"),"ERROR_CHAT");
               return;
            case "o":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_70"),"ERROR_CHAT");
               return;
            case "S":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_62"),"ERROR_CHAT");
               return;
            case "I":
            default:
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_EXCHANGE"),"ERROR_CHAT");
               return;
         }
      }
   }
   function onAskOfflineExchange(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]) / 10;
      var _loc6_ = Number(_loc3_[2]);
      this.api.kernel.GameManager.askOfflineExchange(_loc4_,_loc5_,_loc6_);
   }
   function onReady(sExtraData)
   {
      var _loc3_ = sExtraData.charAt(0) == "1";
      var _loc4_ = Number(sExtraData.substr(1));
      var _loc5_ = _loc4_ != this.api.datacenter.Player.ID ? 1 : 0;
      this.api.datacenter.Exchange.readyStates.updateItem(_loc5_,_loc3_);
   }
   function onLeave(bSuccess, sExtraData)
   {
      delete this.api.datacenter.Basics.aks_exchange_echangeType;
      delete this.api.datacenter.Exchange;
      this.api.ui.unloadUIComponent("AskYesNoIgnoreExchange");
      this.api.ui.unloadUIComponent("AskCancelExchange");
      if(this.api.ui.getUIComponent("Exchange"))
      {
         if(sExtraData == "a")
         {
            this.api.kernel.showMessage(undefined,this.api.lang.getText("EXCHANGE_OK"),"INFO_CHAT");
         }
         else
         {
            this.api.kernel.showMessage(undefined,this.api.lang.getText("EXCHANGE_CANCEL"),"INFO_CHAT");
         }
      }
      this.api.ui.unloadUIComponent("Exchange");
      this.api.ui.unloadUIComponent("Craft");
      this.api.ui.unloadUIComponent("NpcShop");
      this.api.ui.unloadUIComponent("PlayerShop");
      this.api.ui.unloadUIComponent("TaxCollectorStorage");
      this.api.ui.unloadUIComponent("PlayerShopModifier");
      this.api.ui.unloadUIComponent("Storage");
      this.api.ui.unloadUIComponent("BigStoreSell");
      this.api.ui.unloadUIComponent("BigStoreBuy");
      this.api.ui.unloadUIComponent("SecureCraft");
      this.api.ui.unloadUIComponent("CrafterList");
      this.api.ui.unloadUIComponent("ItemUtility");
      this.api.ui.unloadUIComponent("MountStorage");
      this.api.ui.unloadUIComponent("MountParkSale");
      this.api.ui.unloadUIComponent("HouseSale");
      this.api.ui.unloadUIComponent("CardsRecycler");
      this.api.ui.unloadUIComponent("CardsUpgrader");
      if(dofus.Constants.SAVING_THE_WORLD)
      {
         dofus.SaveTheWorld.getInstance().nextAction();
      }
   }
   function onCreate(bSuccess, sExtraData)
   {
      if(!bSuccess)
      {
         return undefined;
      }
      this._lastMovedItemId = -1;
      var _loc4_ = sExtraData.split("|");
      var _loc5_ = Number(_loc4_[0]);
      var _loc6_ = _loc4_[1];
      this.api.datacenter.Basics.aks_exchange_echangeType = _loc5_;
      var _loc7_ = this.api.datacenter.Temporary;
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
      var _loc19_;
      var _loc20_;
      var _loc21_;
      var _loc22_;
      var _loc23_;
      var _loc24_;
      var _loc25_;
      var _loc26_;
      var _loc27_;
      switch(_loc5_)
      {
         case 0:
         case 4:
            _loc7_.Shop = new dofus.datacenter.Shop();
            _loc8_ = this.api.datacenter.Sprites.getItemAt(_loc6_);
            _loc7_.Shop.id = _loc8_.id;
            _loc7_.Shop.name = _loc8_.name;
            _loc7_.Shop.gfx = _loc8_.gfxID;
            _loc9_ = [];
            _loc9_[1] = _loc8_.color1 != undefined ? _loc8_.color1 : -1;
            _loc9_[2] = _loc8_.color2 != undefined ? _loc8_.color2 : -1;
            _loc9_[3] = _loc8_.color3 != undefined ? _loc8_.color3 : -1;
            if(_loc5_ == 0)
            {
               this.api.ui.loadUIComponent("NpcShop","NpcShop",{data:_loc7_.Shop,colors:_loc9_});
            }
            else if(_loc5_ == 4)
            {
               _loc7_.Shop.characterID = _loc8_.characterID;
               this.api.ui.loadUIComponent("PlayerShop","PlayerShop",{data:_loc7_.Shop,colors:_loc9_});
            }
            break;
         case 1:
            this.api.datacenter.Exchange.inventory = this.api.datacenter.Player.Inventory.deepClone();
            this.api.ui.unloadUIComponent("AskYesNoIgnoreExchange");
            this.api.ui.unloadUIComponent("AskCancelExchange");
            this.api.ui.loadUIComponent("Exchange","Exchange");
            break;
         case 2:
         case 9:
         case 17:
         case 18:
         case 3:
            if(_loc5_ == 3)
            {
               this.api.datacenter.Exchange = new dofus.datacenter.Exchange();
            }
            else
            {
               this.api.datacenter.Exchange = new dofus.datacenter.Exchange(Number(_loc6_));
            }
            this.api.datacenter.Exchange.inventory = this.api.datacenter.Player.Inventory.deepClone();
            if(_loc5_ == 3)
            {
               _loc4_ = _loc6_.split(";");
               _loc10_ = Number(_loc4_[0]);
               _loc11_ = Number(_loc4_[1]);
               if(_global.API.lang.getSkillForgemagus(_loc11_) > 0)
               {
                  this.api.ui.loadUIComponent("ForgemagusCraft","Craft",{skillId:_loc11_,maxItem:_loc10_},{nHideSprites:1});
               }
               else if(_loc11_ == 181)
               {
                  this.api.ui.loadUIComponent("Decraft","Craft",{skillId:_loc11_,maxItem:_loc10_},{nHideSprites:1});
               }
               else
               {
                  this.api.ui.loadUIComponent("Craft","Craft",{skillId:_loc11_,maxItem:_loc10_});
               }
            }
            else
            {
               this.api.ui.unloadUIComponent("AskYesNoIgnoreExchange");
               this.api.ui.unloadUIComponent("AskCancelExchange");
               this.api.ui.loadUIComponent("Exchange","Exchange");
            }
            break;
         case 5:
            _loc7_.Storage = new dofus.datacenter.Storage();
            this.api.ui.loadUIComponent("Storage","Storage",{data:_loc7_.Storage},{nHideSprites:1});
            break;
         case 8:
            _loc7_.Storage = new dofus.datacenter.TaxCollectorStorage();
            _loc12_ = this.api.datacenter.Sprites.getItemAt(_loc6_);
            _loc7_.Storage.name = _loc12_.name;
            _loc7_.Storage.gfx = _loc12_.gfxID;
            this.api.ui.loadUIComponent("TaxCollectorStorage","TaxCollectorStorage",{data:_loc7_.Storage});
            break;
         case 6:
            _loc7_.Shop = new dofus.datacenter.Shop();
            this.api.ui.loadUIComponent("PlayerShopModifier","PlayerShopModifier",{data:_loc7_.Shop});
            break;
         case 10:
            _loc7_.Shop = new dofus.datacenter.BigStore();
            _loc4_ = _loc6_.split(";");
            _loc13_ = _loc4_[0].split(",");
            _loc7_.Shop.quantity1 = Number(_loc13_[0]);
            _loc7_.Shop.quantity2 = Number(_loc13_[1]);
            _loc7_.Shop.quantity3 = Number(_loc13_[2]);
            _loc7_.Shop.types = _loc4_[1].split(",");
            _loc7_.Shop.tax = Number(_loc4_[2]);
            _loc7_.Shop.maxLevel = Number(_loc4_[3]);
            _loc7_.Shop.maxItemCount = Number(_loc4_[4]);
            _loc7_.Shop.npcID = Number(_loc4_[5]);
            _loc7_.Shop.maxSellTime = Number(_loc4_[6]);
            this.api.ui.loadUIComponent("BigStoreSell","BigStoreSell",{data:_loc7_.Shop},{nHideSprites:1});
            break;
         case 11:
            _loc7_.Shop = new dofus.datacenter.BigStore();
            _loc4_ = _loc6_.split(";");
            _loc14_ = _loc4_[0].split(",");
            _loc7_.Shop.quantity1 = Number(_loc14_[0]);
            _loc7_.Shop.quantity2 = Number(_loc14_[1]);
            _loc7_.Shop.quantity3 = Number(_loc14_[2]);
            _loc7_.Shop.types = _loc4_[1].split(",");
            _loc7_.Shop.tax = Number(_loc4_[2]);
            _loc7_.Shop.maxLevel = Number(_loc4_[3]);
            _loc7_.Shop.maxItemCount = Number(_loc4_[4]);
            _loc7_.Shop.npcID = Number(_loc4_[5]);
            _loc7_.Shop.maxSellTime = Number(_loc4_[6]);
            this.api.ui.loadUIComponent("BigStoreBuy","BigStoreBuy",{data:_loc7_.Shop},{nHideSprites:1});
            break;
         case 12:
         case 13:
            this.api.datacenter.Exchange.inventory = this.api.datacenter.Player.Inventory.deepClone();
            _loc4_ = _loc6_.split(";");
            _loc15_ = Number(_loc4_[0]);
            _loc16_ = Number(_loc4_[1]);
            _loc17_ = Number(_loc4_[2]);
            this.api.ui.unloadUIComponent("AskYesNoIgnoreExchange");
            this.api.ui.unloadUIComponent("AskCancelExchange");
            if(_global.API.lang.getSkillForgemagus(_loc16_) > 0)
            {
               this.api.ui.loadUIComponent("SecureForgemagusCraft","SecureCraft",{skillId:_loc16_,maxItem:_loc15_,jobLevel:_loc17_},{nHideSprites:1});
            }
            else
            {
               this.api.ui.loadUIComponent("SecureCraft","SecureCraft",{skillId:_loc16_,maxItem:_loc15_,jobLevel:_loc17_});
            }
            if(!dofus.graphics.gapi.ui.SecureCraft.secureCraftNotified)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("SECURECRAFT_NOTIFICATION"),"ERROR_CHAT");
               dofus.graphics.gapi.ui.SecureCraft.secureCraftNotified = true;
            }
            break;
         case 14:
            _loc18_ = new ank.utils.ExtendedArray();
            _loc19_ = _loc6_.split(";");
            _loc20_ = 0;
            while(_loc20_ < _loc19_.length)
            {
               _loc21_ = Number(_loc19_[_loc20_]);
               _loc18_.push({label:this.api.lang.getJobText(_loc21_).n,id:_loc21_});
               _loc20_ = _loc20_ + 1;
            }
            this.api.ui.loadUIComponent("CrafterList","CrafterList",{crafters:new ank.utils.ExtendedArray(),jobs:_loc18_},{nHideSprites:1});
            break;
         case 15:
            this.api.ui.unloadUIComponent("Mount");
            _loc7_.Storage = new dofus.datacenter.Storage();
            this.api.ui.loadUIComponent("Storage","Storage",{isMount:true,data:_loc7_.Storage});
            break;
         case 16:
            _loc22_ = new ank.utils.ExtendedArray();
            _loc23_ = new ank.utils.ExtendedArray();
            _loc4_ = _loc6_.split("~");
            _loc24_ = _loc4_[0].split(";");
            _loc25_ = _loc4_[1].split(";");
            if(_loc24_ != undefined)
            {
               _loc26_ = 0;
               while(_loc26_ < _loc24_.length)
               {
                  if(_loc24_[_loc26_] != "")
                  {
                     _loc22_.push(this.api.network.Mount.createMount(_loc24_[_loc26_]));
                  }
                  _loc26_ = _loc26_ + 1;
               }
            }
            if(_loc25_ != undefined)
            {
               _loc27_ = 0;
               while(_loc27_ < _loc25_.length)
               {
                  if(_loc25_[_loc27_] != "")
                  {
                     _loc23_.push(this.api.network.Mount.createMount(_loc25_[_loc27_]));
                  }
                  _loc27_ = _loc27_ + 1;
               }
            }
            this.api.ui.loadUIComponent("MountStorage","MountStorage",{mounts:_loc22_,parkMounts:_loc23_});
         default:
            return;
      }
   }
   function onCrafterReference(sExtraData)
   {
      var _loc3_ = sExtraData.charAt(0) == "+";
      var _loc4_ = sExtraData.substr(1).split(",");
      var _loc5_ = "";
      var _loc6_ = 0;
      var _loc7_;
      while(_loc6_ < _loc4_.length)
      {
         _loc7_ = Number(_loc4_[_loc6_]);
         if(_loc5_.length > 0)
         {
            _loc5_ += ", ";
         }
         _loc5_ += "<b>" + this.api.lang.getJobText(_loc7_).n + "</b>";
         _loc6_ = _loc6_ + 1;
      }
      this.api.kernel.showMessage(undefined,this.api.lang.getText(!_loc3_ ? "CRAFTER_REFERENCE_REMOVE" : "CRAFTER_REFERENCE_ADD",[_loc5_]),"INFO_CHAT");
   }
   function onCrafterListChanged(sExtraData)
   {
      var _loc3_ = sExtraData.charAt(0) == "+";
      var _loc4_ = sExtraData.substr(1).split(";");
      var _loc5_ = this.api.ui.getUIComponent("CrafterList").crafters;
      var _loc6_ = Number(_loc4_[0]);
      var _loc7_ = _loc4_[1];
      var _loc8_ = _loc5_.findFirstItem("id",_loc7_);
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
      if(_loc3_)
      {
         _loc9_ = _loc4_[2];
         _loc10_ = Number(_loc4_[3]);
         _loc11_ = Number(_loc4_[4]);
         _loc12_ = _loc4_[5] == "1";
         _loc13_ = Number(_loc4_[6]);
         _loc14_ = Number(_loc4_[7]);
         _loc15_ = _loc4_[8].split(",");
         _loc16_ = _loc4_[9];
         _loc17_ = _loc4_[10].split(",");
         _loc18_ = new dofus.datacenter.Crafter(_loc7_,_loc9_);
         _loc18_.job = new dofus.datacenter.Job(_loc6_,new ank.utils.ExtendedArray(),new dofus.datacenter.JobOptions(Number(_loc17_[0]),Number(_loc17_[1])));
         _loc18_.job.level = _loc10_;
         _loc18_.mapId = _loc11_;
         _loc18_.inWorkshop = _loc12_;
         _loc18_.breedId = _loc13_;
         _loc18_.sex = _loc14_;
         _loc18_.color1 = _loc15_[0];
         _loc18_.color2 = _loc15_[1];
         _loc18_.color3 = _loc15_[2];
         this.api.kernel.CharactersManager.setSpriteAccessories(_loc18_,_loc16_);
         if(_loc8_.index != -1)
         {
            _loc5_.updateItem(_loc8_.index,_loc18_);
         }
         else
         {
            _loc5_.push(_loc18_);
         }
      }
      else if(_loc8_.index != -1)
      {
         _loc5_.removeItems(_loc8_.index,1);
      }
   }
   function onMountStorage(sExtraData)
   {
      var _loc3_ = sExtraData.charAt(0);
      var _loc4_ = false;
      var _loc5_;
      var _loc6_;
      switch(_loc3_)
      {
         case "~":
            _loc4_ = true;
            break;
         case "+":
            break;
         case "-":
            _loc5_ = Number(sExtraData.substr(1));
            _loc6_ = this.api.ui.getUIComponent("MountStorage").mounts;
            for(var a in _loc6_)
            {
               if(_loc6_[a].ID == _loc5_)
               {
                  _loc6_.removeItems(Number(a),1);
               }
            }
            break;
         case "E":
         default:
            return;
      }
      this.api.ui.getUIComponent("MountStorage").mounts.push(this.api.network.Mount.createMount(sExtraData.substr(1),_loc4_));
   }
   function onMountPark(sExtraData)
   {
      var _loc3_ = sExtraData.charAt(0);
      var _loc4_;
      var _loc5_;
      switch(_loc3_)
      {
         case "+":
            this.api.ui.getUIComponent("MountStorage").parkMounts.push(this.api.network.Mount.createMount(sExtraData.substr(1)));
            break;
         case "-":
            _loc4_ = Number(sExtraData.substr(1));
            _loc5_ = this.api.ui.getUIComponent("MountStorage").parkMounts;
            for(var a in _loc5_)
            {
               if(_loc5_[a].ID == _loc4_)
               {
                  _loc5_.removeItems(Number(a),1);
               }
            }
            break;
         case "E":
         default:
            return;
      }
   }
   function onCraft(bSuccess, sExtraData)
   {
      if(this.api.datacenter.Basics.aks_exchange_isForgemagus || !this.api.datacenter.Basics.isCraftLooping)
      {
         this.api.datacenter.Exchange.clearLocalGarbage();
      }
      var _loc4_ = this.api.datacenter.Basics.aks_exchange_echangeType;
      if((_loc4_ == 12 || _loc4_ == 13) && !this.api.datacenter.Basics.isCraftLooping)
      {
         this.api.ui.getUIComponent("SecureCraft").reset();
      }
      var _loc5_ = !this.api.datacenter.Basics.aks_exchange_isForgemagus;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      switch(sExtraData.substr(0,1))
      {
         case "I":
            if(!bSuccess)
            {
               this.api.kernel.showMessage(this.api.lang.getText("CRAFT"),this.api.lang.getText("NO_CRAFT_RESULT"),"ERROR_BOX",{name:"Impossible"});
            }
            break;
         case "F":
            if(!bSuccess && _loc5_)
            {
               this.api.kernel.showMessage(this.api.lang.getText("CRAFT"),this.api.lang.getText("CRAFT_FAILED"),"ERROR_BOX",{name:"CraftFailed"});
            }
            this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_CRAFT_KO);
            break;
         case ";":
            if(bSuccess)
            {
               _loc6_ = sExtraData.substr(1).split(";");
               if(_loc6_.length == 1)
               {
                  _loc7_ = new dofus.datacenter.Item(0,Number(_loc6_[0]),undefined,undefined,undefined);
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("CRAFT_SUCCESS_SELF",[_loc7_.name]),"INFO_CHAT");
                  this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_CRAFT_KO);
               }
               else
               {
                  _loc8_ = _loc6_[1].substr(0,1);
                  _loc9_ = _loc6_[1].substr(1);
                  _loc10_ = Number(_loc6_[0]);
                  _loc11_ = _loc6_[2];
                  _loc12_ = [];
                  _loc12_.push(_loc10_);
                  _loc12_.push(_loc11_);
                  switch(_loc8_)
                  {
                     case "T":
                        this.api.kernel.showMessage(undefined,this.api.kernel.ChatManager.parseInlineItems(this.api.lang.getText("CRAFT_SUCCESS_TARGET",[_loc9_]),_loc12_),"INFO_CHAT");
                        break;
                     case "B":
                        this.api.kernel.showMessage(undefined,this.api.kernel.ChatManager.parseInlineItems(this.api.lang.getText("CRAFT_SUCCESS_OTHER",[_loc9_]),_loc12_),"INFO_CHAT");
                  }
               }
            }
      }
      if(!bSuccess && !(this.api.ui.getUIComponent("SecureCraft") instanceof dofus.graphics.gapi.ui.craft.SecureForgemagusCraft))
      {
         this.api.datacenter.Exchange.clearCoopGarbage();
      }
   }
   function onCraftLoop(sExtraData)
   {
      var _loc3_ = sExtraData.split(";");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      this.api.kernel.showMessage(undefined,ank.utils.PatternDecoder.combine(this.api.lang.getText("CRAFT_LOOP_PROCESS",_loc3_),null,_loc5_ < 2),"INFO_CHAT");
      var _loc6_ = this.api.datacenter.Basics.aks_exchange_echangeType;
      switch(_loc6_)
      {
         case 3:
            this.api.ui.getUIComponent("Craft").onCraftLoop(_loc4_);
            break;
         case 12:
         case 13:
            this.api.ui.getUIComponent("SecureCraft").onCraftLoop(_loc4_);
         default:
            return;
      }
   }
   function onCraftLoopStart(sExtraData)
   {
      var _loc3_ = this.api.datacenter.Basics.aks_exchange_echangeType;
      switch(_loc3_)
      {
         case 3:
            this.api.ui.getUIComponent("Craft").onCraftLoopStart();
            break;
         case 12:
         case 13:
            this.api.ui.getUIComponent("SecureCraft").onCraftLoopStart();
      }
      this.api.kernel.showMessage(undefined,this.api.lang.getText("CRAFT_LOOP_START",[sExtraData]),"INFO_CHAT");
   }
   function onCraftLoopEnd(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      this.api.datacenter.Basics.isCraftLooping = false;
      var _loc4_;
      switch(_loc3_)
      {
         case 1:
            this.api.electron.makeNotification(this.api.lang.getText("CRAFT_LOOP_END_OK"));
            _loc4_ = this.api.lang.getText("CRAFT_LOOP_END_OK");
            break;
         case 2:
            _loc4_ = this.api.lang.getText("CRAFT_LOOP_END_INTERRUPT");
            break;
         case 3:
            _loc4_ = this.api.lang.getText("CRAFT_LOOP_END_FAIL");
            break;
         case 4:
            _loc4_ = this.api.lang.getText("CRAFT_LOOP_END_INVALID");
      }
      this.api.kernel.showMessage(undefined,_loc4_,"INFO_CHAT");
      this.api.kernel.showMessage(this.api.lang.getText("CRAFT"),_loc4_,"ERROR_BOX");
      var _loc5_ = this.api.datacenter.Basics.aks_exchange_echangeType;
      switch(_loc5_)
      {
         case 3:
            this.api.ui.getUIComponent("Craft").onCraftLoopEnd();
            break;
         case 12:
         case 13:
            this.api.ui.getUIComponent("SecureCraft").onCraftLoopEnd();
      }
      if(!this.api.datacenter.Basics.aks_exchange_isForgemagus)
      {
         this.api.datacenter.Exchange.clearLocalGarbage();
      }
   }
   function onLocalMovement(bSuccess, sExtraData)
   {
      this.modifyLocal(sExtraData,this.api.datacenter.Exchange.localGarbage,"localKama");
   }
   function onDistantMovement(bSuccess, sExtraData)
   {
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
      switch(this.api.datacenter.Basics.aks_exchange_echangeType)
      {
         case 1:
         case 2:
         case 3:
         case 9:
         case 12:
         case 13:
            this.modifyDistant(sExtraData,this.api.datacenter.Exchange.distantGarbage,"distantKama");
            break;
         case 10:
            _loc4_ = sExtraData.charAt(0) == "+";
            _loc5_ = sExtraData.substr(1).split("|");
            _loc6_ = Number(_loc5_[0]);
            _loc7_ = Number(_loc5_[1]);
            _loc8_ = Number(_loc5_[2]);
            _loc9_ = _loc5_[3];
            _loc10_ = Number(_loc5_[4]);
            _loc11_ = Number(_loc5_[5]);
            _loc12_ = this.api.datacenter.Temporary.Shop;
            _loc13_ = _loc12_.inventory.findFirstItem("ID",_loc6_);
            _loc14_ = dofus.graphics.gapi.ui.BigStoreSell(this.api.ui.getUIComponent("BigStoreSell"));
            if(_loc4_)
            {
               _loc15_ = new dofus.datacenter.Item(_loc6_,_loc8_,_loc7_,-1,_loc9_,_loc10_);
               _loc15_.remainingHours = _loc11_;
               if(_loc13_.index != -1)
               {
                  _loc12_.inventory.updateItem(_loc13_.index,_loc15_);
               }
               else
               {
                  _loc12_.inventory.push(_loc15_);
               }
            }
            else if(_loc13_.index != -1)
            {
               _loc12_.inventory.removeItems(_loc13_.index,1);
            }
            else
            {
               ank.utils.Logger.err("[onDistantMovement] cet objet n\'existe pas id=" + _loc6_);
            }
            if(_loc14_ != undefined)
            {
               _loc14_.updateItemCount();
               _loc14_.refreshRemoveButton();
            }
         default:
            return;
      }
   }
   function onCoopMovement(bSuccess, sExtraData)
   {
      this.api.datacenter.Exchange.clearCoopGarbage();
      switch(this.api.datacenter.Basics.aks_exchange_echangeType)
      {
         case 12:
            this.modifyDistant(sExtraData,this.api.datacenter.Exchange.coopGarbage,"distantKama",false);
            break;
         case 13:
            this.modifyDistant(sExtraData,this.api.datacenter.Exchange.coopGarbage,"distantKama",true);
         default:
            return;
      }
   }
   function onPayMovement(bSuccess, sExtraData)
   {
      var _loc4_ = Number(sExtraData.charAt(0));
      var _loc5_ = _loc4_ != 1 ? this.api.datacenter.Exchange.payGarbage : this.api.datacenter.Exchange.payIfSuccessGarbage;
      var _loc6_ = _loc4_ != 1 ? "payIfSuccessKama" : "payKama";
      switch(this.api.datacenter.Basics.aks_exchange_echangeType)
      {
         case 12:
            this.modifyDistant(sExtraData.substr(2),_loc5_,_loc6_,false);
            break;
         case 13:
            this.modifyLocal(sExtraData.substr(2),_loc5_,_loc6_);
         default:
            return;
      }
   }
   function modifyLocal(sExtraData, ea, sKamaLocation)
   {
      var _loc5_ = sExtraData.charAt(0);
      var _loc6_ = this.api.datacenter.Exchange;
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
      switch(_loc5_)
      {
         case "O":
            _loc7_ = sExtraData.charAt(1) == "+";
            _loc8_ = sExtraData.substr(2).split("|");
            _loc9_ = Number(_loc8_[0]);
            _loc10_ = Number(_loc8_[1]);
            _loc11_ = this.api.datacenter.Player.Inventory.findFirstItem("ID",_loc9_);
            _loc12_ = _loc6_.inventory.findFirstItem("ID",_loc9_);
            _loc13_ = ea.findFirstItem("ID",_loc9_);
            if(_loc7_)
            {
               _loc14_ = _loc12_.item;
               _loc15_ = new dofus.datacenter.Item(_loc9_,_loc14_.unicID,_loc10_,-2,_loc14_.compressedEffects);
               _loc16_ = -1;
               _loc17_ = _loc11_.item.Quantity - _loc10_;
               if(_loc17_ == 0)
               {
                  _loc16_ = -3;
               }
               _loc12_.item.Quantity = _loc17_;
               _loc12_.item.position = _loc16_;
               _loc6_.inventory.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
               _loc6_.inventory.updateItem(_loc12_.index,_loc12_.item);
               if(_loc13_.index != -1)
               {
                  ea.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
                  ea.updateItem(_loc13_.index,_loc15_);
               }
               else
               {
                  ea.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
                  ea.push(_loc15_);
               }
            }
            else if(_loc13_.index != -1)
            {
               _loc12_.item.position = -1;
               _loc12_.item.Quantity = _loc11_.item.Quantity;
               _loc6_.inventory.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
               _loc6_.inventory.updateItem(_loc12_.index,_loc12_.item);
               ea.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
               ea.removeItems(_loc13_.index,1);
            }
            break;
         case "G":
            _loc18_ = Number(sExtraData.substr(1));
            _loc6_[sKamaLocation] = _loc18_;
         default:
            return;
      }
   }
   function modifyDistant(sExtraData, ea, sKamaLocation, bForceModifyInventory)
   {
      var _loc6_ = sExtraData.charAt(0);
      var _loc7_ = this.api.datacenter.Exchange;
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
      switch(_loc6_)
      {
         case "O":
            _loc8_ = sExtraData.charAt(1) == "+";
            _loc9_ = sExtraData.substr(2).split("|");
            _loc10_ = Number(_loc9_[0]);
            _loc11_ = Number(_loc9_[1]);
            _loc12_ = Number(_loc9_[2]);
            _loc13_ = _loc9_[3];
            _loc14_ = ea.findFirstItem("ID",_loc10_);
            if(_loc8_)
            {
               _loc15_ = new dofus.datacenter.Item(_loc10_,_loc12_,_loc11_,-1,_loc13_);
               _loc16_ = bForceModifyInventory == undefined ? _loc7_.distantPlayerID == undefined : bForceModifyInventory;
               if(_loc14_.index != -1)
               {
                  ea.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
                  ea.updateItem(_loc14_.index,_loc15_);
               }
               else
               {
                  ea.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
                  ea.push(_loc15_);
               }
               if(_loc16_)
               {
                  _loc17_ = _loc7_.inventory.findFirstItem("ID",_loc10_);
                  if(_loc17_.index != -1)
                  {
                     _loc17_.item.position = -1;
                     _loc17_.item.Quantity = Number(_loc17_.item.Quantity) + Number(_loc11_);
                     _loc7_.inventory.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
                     _loc7_.inventory.updateItem(_loc17_.index,_loc17_.item);
                  }
                  else
                  {
                     _loc7_.inventory.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
                     _loc7_.inventory.push(_loc15_);
                     _global.API.ui.getUIComponent("Craft").updateForgemagusResult(_loc15_);
                  }
               }
            }
            else if(_loc14_.index != -1)
            {
               ea.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
               ea.removeItems(_loc14_.index,1);
            }
            break;
         case "G":
            _loc18_ = Number(sExtraData.substr(1));
            _loc7_[sKamaLocation] = _loc18_;
         default:
            return;
      }
   }
   function onStorageMovement(bSuccess, sExtraData)
   {
      var _loc4_ = sExtraData.charAt(0);
      var _loc5_ = this.api.datacenter.Temporary.Storage;
      var _loc6_ = _loc5_.inventory;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      switch(_loc4_)
      {
         case "O":
            _loc7_ = sExtraData.charAt(1) == "+";
            _loc8_ = sExtraData.substr(2).split("|");
            _loc9_ = Number(_loc8_[0]);
            _loc10_ = Number(_loc8_[1]);
            _loc11_ = Number(_loc8_[2]);
            _loc12_ = _loc8_[3];
            _loc13_ = _loc6_.findFirstItem("ID",_loc9_);
            if(_loc7_)
            {
               _loc14_ = new dofus.datacenter.Item(_loc9_,_loc11_,_loc10_,-1,_loc12_);
               if(_loc13_.index != -1)
               {
                  _loc6_.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
                  _loc6_.updateItem(_loc13_.index,_loc14_);
               }
               else
               {
                  _loc6_.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
                  _loc6_.push(_loc14_);
               }
            }
            else if(_loc13_.index != -1)
            {
               _loc6_.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
               _loc6_.removeItems(_loc13_.index,1);
            }
            else
            {
               ank.utils.Logger.err("[onStorageMovement] cet objet n\'existe pas id=" + _loc9_);
            }
            break;
         case "G":
            _loc15_ = Number(sExtraData.substr(1));
            _loc5_.Kama = _loc15_;
         default:
            return;
      }
   }
   function onPlayerShopMovement(bSuccess, sExtraData)
   {
      var _loc4_ = sExtraData.charAt(0) == "+";
      var _loc5_ = sExtraData.substr(1).split("|");
      var _loc6_ = Number(_loc5_[0]);
      var _loc7_ = Number(_loc5_[1]);
      var _loc8_ = Number(_loc5_[2]);
      var _loc9_ = _loc5_[3];
      var _loc10_ = Number(_loc5_[4]);
      var _loc11_ = this.api.datacenter.Temporary.Shop;
      var _loc12_ = _loc11_.inventory.findFirstItem("ID",_loc6_);
      var _loc13_ = dofus.graphics.gapi.ui.PlayerShopModifier(this.api.ui.getUIComponent("PlayerShopModifier"));
      var _loc14_;
      if(_loc4_)
      {
         _loc14_ = new dofus.datacenter.Item(_loc6_,_loc8_,_loc7_,-1,_loc9_,_loc10_);
         if(_loc12_.index != -1)
         {
            _loc11_.inventory.updateItem(_loc12_.index,_loc14_);
         }
         else
         {
            _loc11_.inventory.push(_loc14_);
         }
      }
      else if(_loc12_.index != -1)
      {
         _loc11_.inventory.removeItems(_loc12_.index,1);
      }
      else
      {
         ank.utils.Logger.err("[onPlayerShopMovement] cet objet n\'existe pas id=" + _loc6_);
      }
      _loc13_.refreshRemoveButton();
   }
   function onList(sExtraData)
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
      var _loc16_;
      var _loc17_;
      var _loc18_;
      var _loc19_;
      var _loc20_;
      var _loc21_;
      var _loc22_;
      var _loc23_;
      var _loc24_;
      var _loc25_;
      var _loc26_;
      var _loc27_;
      var _loc28_;
      var _loc29_;
      var _loc30_;
      var _loc31_;
      var _loc32_;
      var _loc33_;
      var _loc34_;
      var _loc35_;
      var _loc36_;
      var _loc37_;
      var _loc38_;
      var _loc39_;
      var _loc40_;
      var _loc41_;
      var _loc42_;
      var _loc43_;
      var _loc44_;
      var _loc45_;
      var _loc46_;
      var _loc47_;
      var _loc48_;
      var _loc49_;
      var _loc50_;
      switch(this.api.datacenter.Basics.aks_exchange_echangeType)
      {
         case 0:
            _loc3_ = this.api.datacenter.Player.Inventory;
            _loc4_ = {};
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc6_ = _loc3_[_loc5_];
               _loc6_.resellCustomPrice = undefined;
               _loc6_.customMoneyItemId = undefined;
               _loc7_ = String(_loc6_.unicID);
               if(_loc4_[_loc7_] == undefined)
               {
                  _loc4_[_loc7_] = [];
               }
               _loc4_[_loc7_].push(_loc6_);
               _loc5_ = _loc5_ + 1;
            }
            _loc8_ = sExtraData.split("|");
            _loc9_ = new ank.utils.ExtendedArray();
            _loc10_ = _loc8_.length - 1;
            while(_loc10_ >= 0)
            {
               _loc11_ = _loc8_[_loc10_].split(";");
               _loc12_ = Number(_loc11_[0]);
               _loc13_ = _loc11_[1];
               _loc14_ = Number(_loc11_[2]);
               _loc15_ = Number(_loc11_[3]);
               if(_global.isNaN(_loc14_))
               {
                  _loc14_;
               }
               if(_global.isNaN(_loc15_))
               {
                  _loc15_;
               }
               _loc16_ = Number(_loc11_[4]);
               if(_global.isNaN(_loc16_))
               {
                  _loc16_;
               }
               else
               {
                  _loc17_ = _loc4_[String(_loc12_)];
                  if(_loc17_ != undefined)
                  {
                     _loc18_ = 0;
                     while(_loc18_ < _loc17_.length)
                     {
                        _loc19_ = _loc17_[_loc18_];
                        _loc19_.resellCustomPrice = _loc16_;
                        _loc19_.customMoneyItemId = _loc14_;
                        _loc18_ = _loc18_ + 1;
                     }
                  }
               }
               _loc20_ = _loc11_[5] == "1";
               if(!_loc20_)
               {
                  _loc21_ = new dofus.datacenter.Item(0,_loc12_,undefined,undefined,_loc13_,_loc15_);
                  _loc21_.customMoneyItemId = _loc14_;
                  _loc21_.resellCustomPrice = _loc16_;
                  _loc21_.priceMultiplicator = this.api.lang.getConfigText("BUY_PRICE_MULTIPLICATOR");
                  _loc9_.push(_loc21_);
               }
               _loc10_ = _loc10_ - 1;
            }
            this.api.datacenter.Temporary.Shop.inventory = _loc9_;
            break;
         case 5:
         case 15:
         case 8:
            _loc22_ = sExtraData.split(";");
            _loc23_ = new ank.utils.ExtendedArray();
            _loc24_ = _loc22_.length - 1;
            while(_loc24_ >= 0)
            {
               _loc25_ = _loc22_[_loc24_];
               _loc26_ = _loc25_.charAt(0);
               _loc27_ = _loc25_.substr(1);
               switch(_loc26_)
               {
                  case "O":
                     _loc28_ = this.api.kernel.CharactersManager.getItemObjectFromData(_loc27_);
                     _loc23_.push(_loc28_);
                     break;
                  case "G":
                     this.onStorageKama(_loc27_);
               }
               _loc24_ = _loc24_ - 1;
            }
            this.api.datacenter.Temporary.Storage.inventory = _loc23_;
            if(dofus.Constants.SAVING_THE_WORLD)
            {
               dofus.SaveTheWorld.getInstance().newItems(sExtraData);
               dofus.SaveTheWorld.getInstance().nextAction();
            }
            break;
         case 4:
         case 6:
            _loc29_ = sExtraData.split("|");
            _loc30_ = new ank.utils.ExtendedArray();
            _loc31_ = 0;
            while(_loc31_ < _loc29_.length)
            {
               _loc32_ = _loc29_[_loc31_].split(";");
               _loc33_ = Number(_loc32_[0]);
               _loc34_ = Number(_loc32_[1]);
               _loc35_ = Number(_loc32_[2]);
               _loc36_ = _loc32_[3];
               _loc37_ = Number(_loc32_[4]);
               _loc38_ = Number(_loc32_[5]);
               _loc39_ = new dofus.datacenter.Item(_loc33_,_loc35_,_loc34_,-1,_loc36_,_loc37_);
               if(!_global.isNaN(_loc38_))
               {
                  _loc39_.averagePrice = _loc38_;
               }
               _loc30_.push(_loc39_);
               _loc31_ = _loc31_ + 1;
            }
            this.api.datacenter.Temporary.Shop.inventory = _loc30_;
            break;
         case 10:
            _loc40_ = sExtraData.split("|");
            _loc41_ = new ank.utils.ExtendedArray();
            if(sExtraData.length != 0)
            {
               _loc42_ = _loc40_.length - 1;
               while(_loc42_ >= 0)
               {
                  _loc43_ = _loc40_[_loc42_].split(";");
                  _loc44_ = Number(_loc43_[0]);
                  _loc45_ = Number(_loc43_[1]);
                  _loc46_ = Number(_loc43_[2]);
                  _loc47_ = _loc43_[3];
                  _loc48_ = Number(_loc43_[4]);
                  _loc49_ = Number(_loc43_[5]);
                  _loc50_ = new dofus.datacenter.Item(_loc44_,_loc46_,_loc45_,-1,_loc47_,_loc48_);
                  _loc50_.remainingHours = _loc49_;
                  _loc41_.push(_loc50_);
                  _loc42_ = _loc42_ - 1;
               }
            }
            this.api.datacenter.Temporary.Shop.inventory = _loc41_;
         default:
            return;
      }
   }
   function onSell(bSuccess)
   {
      if(bSuccess)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("SELL_DONE"),"INFO_CHAT");
      }
      else
      {
         this.api.kernel.showMessage(this.api.lang.getText("EXCHANGE"),this.api.lang.getText("CANT_SELL"),"ERROR_BOX",{name:"Sell"});
      }
   }
   function onBuy(bSuccess)
   {
      if(bSuccess)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("BUY_DONE"),"INFO_CHAT");
      }
      else
      {
         this.api.kernel.showMessage(this.api.lang.getText("EXCHANGE"),this.api.lang.getText("CANT_BUY"),"ERROR_BOX",{name:"Buy"});
      }
   }
   function onStorageKama(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      this.api.datacenter.Temporary.Storage.Kama = _loc3_;
   }
   function onBigStoreTypeItemsList(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = _loc3_[1].split(";");
      var _loc6_ = new ank.utils.ExtendedArray();
      var _loc7_;
      var _loc8_;
      var _loc9_;
      if(_loc3_[1].length != 0)
      {
         _loc7_ = 0;
         while(_loc7_ < _loc5_.length)
         {
            _loc8_ = Number(_loc5_[_loc7_]);
            if(dofus.datacenter.Item.isFullSoul(_loc4_))
            {
               _loc9_ = new dofus.datacenter.MonsterInBidHouse(_loc8_,_loc4_);
            }
            else
            {
               _loc9_ = new dofus.datacenter.Item(0,_loc8_,1,-1,"",0);
               _loc9_.label = this.api.lang.getText("LEVEL_SMALL") + " " + _loc9_.level;
            }
            _loc6_.push(_loc9_);
            _loc7_ = _loc7_ + 1;
         }
      }
      this.api.datacenter.Temporary.Shop.inventory = _loc6_;
      var _loc10_ = this.api.ui.getUIComponent("BigStoreBuy").isFullSoul;
      if(_loc10_)
      {
         this.api.ui.getUIComponent("BigStoreBuy").setType(_loc4_);
      }
   }
   function onItemMiddlePriceInBigStore(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      this.api.ui.getUIComponent("BigStoreBuy").setMiddlePrice(_loc4_,_loc5_);
      this.api.ui.getUIComponent("BigStoreSell").setMiddlePrice(_loc4_,_loc5_);
   }
   function onBigStoreTypeItemsMovement(sExtraData)
   {
      var _loc3_ = sExtraData.charAt(0) == "+";
      var _loc4_ = Number(sExtraData.substr(1));
      var _loc5_ = this.api.datacenter.Temporary.Shop;
      var _loc6_ = _loc5_.inventory.findFirstItem("unicID",_loc4_);
      var _loc7_;
      if(_loc3_)
      {
         _loc7_ = new dofus.datacenter.Item(0,_loc4_,0,-1,"",0);
         if(_loc6_.index != -1)
         {
            _loc5_.inventory.updateItem(_loc6_.index,_loc7_);
         }
         else
         {
            _loc5_.inventory.push(_loc7_);
         }
      }
      else if(_loc6_.index != -1)
      {
         _loc5_.inventory.removeItems(_loc6_.index,1);
      }
      else
      {
         ank.utils.Logger.err("[onBigStoreTypeItemsMovement] cet objet n\'existe pas unicID=" + _loc4_);
      }
   }
   function onBigStoreItemsList(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      this.api.ui.getUIComponent("BigStoreBuy").setItem(_loc4_);
      var _loc5_ = new ank.utils.ExtendedArray();
      if(_loc3_[1].length == 0)
      {
         return this.api.datacenter.Temporary.Shop.inventory2 = _loc5_;
      }
      var _loc6_ = 1;
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
      var _loc19_;
      var _loc20_;
      var _loc21_;
      while(_loc6_ < _loc3_.length)
      {
         _loc7_ = _loc3_[_loc6_].split(";");
         _loc8_ = Number(_loc7_[0]);
         _loc9_ = _loc7_[1];
         _loc10_ = _loc7_[2].split(",");
         _loc11_ = Number(_loc10_[0]);
         _loc12_ = _loc10_[1] == "1";
         _loc13_ = _loc7_[3].split(",");
         _loc14_ = Number(_loc13_[0]);
         _loc15_ = _loc13_[1] == "1";
         _loc16_ = _loc7_[4].split(",");
         _loc17_ = Number(_loc16_[0]);
         _loc18_ = _loc16_[1] == "1";
         _loc19_ = Number(_loc7_[5]);
         _loc20_ = new dofus.datacenter.Item(_loc8_,_loc19_,0,-1,_loc9_,0);
         _loc21_ = {id:_loc8_,item:_loc20_,priceSet1:_loc11_,priceSet2:_loc14_,priceSet3:_loc17_,isMySale1:_loc12_,isMySale2:_loc15_,isMySale3:_loc18_};
         _loc5_.push(_loc21_);
         _loc6_ = _loc6_ + 1;
      }
      _loc5_.sortOn("priceSet1",Array.NUMERIC);
      this.api.datacenter.Temporary.Shop.inventory2 = _loc5_;
   }
   function onBigStoreItemsMovement(sExtraData)
   {
      var _loc3_ = sExtraData.charAt(0) == "+";
      var _loc4_ = sExtraData.substr(1).split("|");
      var _loc5_ = Number(_loc4_[0]);
      var _loc6_ = Number(_loc4_[1]);
      var _loc7_ = _loc4_[2];
      var _loc8_ = _loc4_[3].split(",");
      var _loc9_ = Number(_loc8_[0]);
      var _loc10_ = _loc8_[1] == "1";
      var _loc11_ = _loc4_[4].split(",");
      var _loc12_ = Number(_loc11_[0]);
      var _loc13_ = _loc11_[1] == "1";
      var _loc14_ = _loc4_[5].split(",");
      var _loc15_ = Number(_loc14_[0]);
      var _loc16_ = _loc14_[1] == "1";
      var _loc17_ = this.api.datacenter.Temporary.Shop;
      var _loc18_ = _loc17_.inventory2.findFirstItem("id",_loc5_);
      var _loc19_;
      var _loc20_;
      if(_loc3_)
      {
         _loc19_ = new dofus.datacenter.Item(_loc5_,_loc6_,0,-1,_loc7_,0);
         _loc20_ = {id:_loc5_,item:_loc19_,priceSet1:_loc9_,priceSet2:_loc12_,priceSet3:_loc15_,isMySale1:_loc10_,isMySale2:_loc13_,isMySale3:_loc16_};
         if(_loc18_.index != -1)
         {
            _loc17_.inventory2.updateItem(_loc18_.index,_loc20_);
         }
         else
         {
            _loc17_.inventory2.push(_loc20_);
         }
         _loc17_.refreshInventory("modelChanged2");
         return undefined;
      }
      if(_loc18_.index != -1)
      {
         _loc17_.inventory2.removeItems(_loc18_.index,1);
         _loc17_.refreshInventory("modelChanged2");
      }
      else
      {
         ank.utils.Logger.err("[onBigStoreItemsMovement] cet objet n\'existe pas id=" + _loc5_);
      }
   }
   function onSearch(sExtraData)
   {
      this.api.ui.getUIComponent("BigStoreBuy").onSearchResult(sExtraData == "K");
   }
   function onCraftPublicMode(sExtraData)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      if(sExtraData.length == 1)
      {
         _loc3_ = sExtraData;
         this.api.datacenter.Player.craftPublicMode = _loc3_ != "+" ? false : true;
      }
      else
      {
         _loc4_ = sExtraData.charAt(0);
         _loc5_ = sExtraData.substr(1).split("|");
         _loc6_ = _loc5_[0];
         _loc7_ = this.api.datacenter.Sprites.getItemAt(_loc6_);
         if(_loc4_ == "+" && _loc5_[1].length > 0)
         {
            _loc8_ = _loc5_[1].split(";");
            _loc7_.multiCraftSkillsID = _loc8_;
         }
         else
         {
            _loc7_.multiCraftSkillsID = undefined;
         }
      }
   }
   function onMountPods(sExtraData)
   {
      var _loc3_ = sExtraData.split(";");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      this.api.datacenter.Player.mount.podsMax = _loc5_;
      this.api.datacenter.Player.mount.pods = _loc4_;
   }
   function onCraftQuantity(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      switch(this.api.datacenter.Basics.aks_exchange_echangeType)
      {
         case 3:
            this.api.ui.getUIComponent("Craft").onQuantityChange(_loc3_);
            break;
         case 12:
         case 13:
            this.api.ui.getUIComponent("SecureCraft").onQuantityChange(_loc3_);
         default:
            return;
      }
   }
   function onCraftMark(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      switch(this.api.datacenter.Basics.aks_exchange_echangeType)
      {
         case 12:
         case 13:
            this.api.ui.getUIComponent("SecureCraft").onMarkChange(_loc3_ == 1);
         default:
            return;
      }
   }
   function cancel(oEvent)
   {
      this.leave();
   }
   function yes(oEvent)
   {
      this.accept();
   }
   function no(oEvent)
   {
      this.leave();
   }
   function ignore(oEvent)
   {
      this.api.kernel.ChatManager.addToBlacklist(oEvent.params.player);
      this.api.kernel.showMessage(undefined,this.api.lang.getText("TEMPORARY_BLACKLISTED",[oEvent.params.player]),"INFO_CHAT");
      this.leave();
   }
}
