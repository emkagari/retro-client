class dofus.managers.CharactersManager extends dofus.utils.ApiElement
{
   static var _sSelf = null;
   function CharactersManager(oAPI)
   {
      dofus.managers.CharactersManager._sSelf = this;
      super.initialize(oAPI);
   }
   static function getInstance()
   {
      return dofus.managers.CharactersManager._sSelf;
   }
   function setLocalPlayerData(nID, sName, oData)
   {
      var _loc5_ = this.api.datacenter.Player;
      _loc5_.clean();
      _loc5_.ID = nID;
      _loc5_.Name = sName;
      _loc5_.Guild = oData.guild;
      _loc5_.Level = oData.level;
      _loc5_.Sex = oData.sex;
      _loc5_.color1 = oData.color1 != -1 ? Number("0x" + oData.color1) : oData.color1;
      _loc5_.color2 = oData.color2 != -1 ? Number("0x" + oData.color2) : oData.color2;
      _loc5_.color3 = oData.color3 != -1 ? Number("0x" + oData.color3) : oData.color3;
      var _loc6_ = oData.items.split(";");
      var _loc7_ = 0;
      var _loc8_;
      var _loc9_;
      while(_loc7_ < _loc6_.length)
      {
         _loc8_ = _loc6_[_loc7_];
         if(_loc8_.length != 0)
         {
            _loc9_ = this.getItemObjectFromData(_loc8_);
            if(_loc9_ != undefined)
            {
               _loc5_.addItem(_loc9_);
            }
         }
         _loc7_ = _loc7_ + 1;
      }
      _loc5_.updateCloseCombat();
   }
   function updateLocalPlayerData(oSprite)
   {
      var _loc3_ = this.api.datacenter.Player;
      if(_loc3_.Name != oSprite.name)
      {
         _loc3_.Name = oSprite.name;
         this.api.electron.updateWindowTitle(_loc3_.Name);
         this.api.electron.setIngameDiscordActivity();
      }
      if(_loc3_.color1 != oSprite.color1 || (_loc3_.color2 != oSprite.color2 || _loc3_.color3 != oSprite.color3))
      {
         _loc3_.color1 = oSprite.color1;
         _loc3_.color2 = oSprite.color2;
         _loc3_.color3 = oSprite.color3;
         this.api.ui.getUIComponent("Banner").circleXtra.updateArtwork(true);
         this.api.ui.getUIComponent("Inventory").refreshSpriteViewer();
      }
      if(_loc3_.Sex != oSprite.Sex)
      {
         _loc3_.Sex = oSprite.Sex;
         this.api.ui.getUIComponent("Inventory").refreshSpriteViewer();
      }
      if(_loc3_.title != oSprite.title)
      {
         _loc3_.title = oSprite.title;
      }
   }
   function createCharacter(sID, sName, oData)
   {
      if(this.api.datacenter.Player.isAuthorized && oData.gfxID == ank.battlefield.datacenter.Sprite.ANGELS_OF_THE_WORLD_SPRITE_ID)
      {
         oData.gfxID = ank.battlefield.datacenter.Sprite.ANGELS_OF_THE_WORLD_REPLACEMENT_SPRITE_ID;
      }
      var _loc5_ = this.api.datacenter.Sprites.getItemAt(sID);
      if(_loc5_ == undefined)
      {
         _loc5_ = new dofus.datacenter.Character(sID,ank.battlefield.mc.Sprite,dofus.Constants.CLIPS_PERSOS_PATH + oData.gfxID + ".swf",oData.cell,oData.dir,oData.gfxID,oData.title);
         this.api.datacenter.Sprites.addItemAt(sID,_loc5_);
      }
      _loc5_.GameActionsManager.init();
      _loc5_.cellNum = Number(oData.cell);
      _loc5_.scaleX = oData.scaleX;
      _loc5_.scaleY = oData.scaleY;
      _loc5_.name = sName;
      _loc5_.Guild = Number(oData.spriteType);
      _loc5_.Level = Number(oData.level);
      _loc5_.Sex = oData.sex == undefined ? 1 : oData.sex;
      _loc5_.color1 = oData.color1 != -1 ? Number("0x" + oData.color1) : oData.color1;
      _loc5_.color2 = oData.color2 != -1 ? Number("0x" + oData.color2) : oData.color2;
      _loc5_.color3 = oData.color3 != -1 ? Number("0x" + oData.color3) : oData.color3;
      _loc5_.Aura = oData.aura == undefined ? 0 : oData.aura;
      _loc5_.Merchant = oData.merchant != "1" ? false : true;
      _loc5_.serverID = Number(oData.serverID);
      _loc5_.alignment = oData.alignment;
      _loc5_.rank = oData.rank;
      _loc5_.mount = oData.mount;
      _loc5_.isDead = oData.isDead == 1;
      _loc5_.deathState = Number(oData.isDead);
      _loc5_.deathCount = Number(oData.deathCount);
      _loc5_.lvlMax = Number(oData.lvlMax);
      _loc5_.pvpGain = Number(oData.pvpGain);
      _loc5_.hasTtgCollection = oData.hasTtgCollection;
      _loc5_.hasCandy = oData.hasCandy;
      _loc5_.hasBuff = oData.hasBuff;
      _loc5_.xpMultiplicator = oData.xpMultiplicator;
      _loc5_.glowFilter = oData.glowFilter;
      _loc5_.ornament = oData.ornament;
      this.setSpriteAccessories(_loc5_,oData.accessories);
      if(oData.LP != undefined)
      {
         _loc5_.LP = oData.LP;
      }
      if(oData.LPmax != undefined)
      {
         _loc5_.LPmax = oData.LPmax;
      }
      if(oData.AP != undefined)
      {
         _loc5_.AP = oData.AP;
      }
      if(oData.AP != undefined)
      {
         _loc5_.APinit = oData.AP;
      }
      if(oData.MP != undefined)
      {
         _loc5_.MP = oData.MP;
      }
      if(oData.MP != undefined)
      {
         _loc5_.MPinit = oData.MP;
      }
      if(oData.resistances != undefined)
      {
         _loc5_.resistances = oData.resistances;
      }
      _loc5_.Team = oData.team != undefined ? oData.team : null;
      if(oData.emote != undefined && oData.emote.length != 0)
      {
         _loc5_.direction = ank.battlefield.utils.Pathfinding.convertHeightToFourDirection(oData.dir);
         if(oData.emoteTimer != undefined && oData.emote.length != 0)
         {
            _loc5_.startAnimationTimer = oData.emoteTimer;
         }
         _loc5_.startAnimation = "EmoteStatic" + oData.emote;
      }
      if(oData.guildName != undefined)
      {
         _loc5_.guildName = oData.guildName;
      }
      _loc5_.emblem = this.createGuildEmblem(oData.emblem);
      if(oData.restrictions != undefined)
      {
         _loc5_.restrictions = _global.parseInt(oData.restrictions,36);
      }
      if(sID == this.api.datacenter.Player.ID)
      {
         this.updateLocalPlayerData(_loc5_);
      }
      return _loc5_;
   }
   function createCreature(sID, sName, oData)
   {
      var _loc5_ = this.api.datacenter.Sprites.getItemAt(sID);
      if(_loc5_ == undefined)
      {
         _loc5_ = new dofus.datacenter.Creature(sID,ank.battlefield.mc.Sprite,dofus.Constants.CLIPS_PERSOS_PATH + oData.gfxID + ".swf",oData.cell,oData.dir,oData.gfxID);
         this.api.datacenter.Sprites.addItemAt(sID,_loc5_);
      }
      _loc5_.GameActionsManager.init();
      _loc5_.cellNum = oData.cell;
      _loc5_.name = sName;
      _loc5_.powerLevel = oData.powerLevel;
      _loc5_.scaleX = oData.scaleX;
      _loc5_.scaleY = oData.scaleY;
      _loc5_.noFlip = oData.noFlip;
      _loc5_.color1 = oData.color1 != -1 ? Number("0x" + oData.color1) : oData.color1;
      _loc5_.color2 = oData.color2 != -1 ? Number("0x" + oData.color2) : oData.color2;
      _loc5_.color3 = oData.color3 != -1 ? Number("0x" + oData.color3) : oData.color3;
      this.setSpriteAccessories(_loc5_,oData.accessories);
      if(oData.LP != undefined)
      {
         _loc5_.LP = oData.LP;
      }
      if(oData.LPmax != undefined)
      {
         _loc5_.LPmax = oData.LPmax;
      }
      if(oData.AP != undefined)
      {
         _loc5_.AP = oData.AP;
      }
      if(oData.AP != undefined)
      {
         _loc5_.APinit = oData.AP;
      }
      if(oData.MP != undefined)
      {
         _loc5_.MP = oData.MP;
      }
      if(oData.MP != undefined)
      {
         _loc5_.MPinit = oData.MP;
      }
      if(oData.resistances != undefined)
      {
         _loc5_.resistances = oData.resistances;
      }
      if(oData.summoned != undefined)
      {
         _loc5_.isSummoned = oData.summoned;
      }
      _loc5_.Team = oData.team != undefined ? oData.team : null;
      return _loc5_;
   }
   function createMonster(sID, sName, oData)
   {
      var _loc5_ = this.api.datacenter.Sprites.getItemAt(sID);
      if(_loc5_ == undefined)
      {
         _loc5_ = new dofus.datacenter.Monster(sID,ank.battlefield.mc.Sprite,dofus.Constants.CLIPS_PERSOS_PATH + oData.gfxID + ".swf",oData.cell,oData.dir,oData.gfxID);
         this.api.datacenter.Sprites.addItemAt(sID,_loc5_);
      }
      _loc5_.GameActionsManager.init();
      _loc5_.cellNum = oData.cell;
      _loc5_.name = sName;
      _loc5_.scaleX = oData.scaleX;
      _loc5_.scaleY = oData.scaleY;
      _loc5_.noFlip = oData.noFlip;
      _loc5_.powerLevel = oData.powerLevel;
      _loc5_.color1 = oData.color1 != -1 ? Number("0x" + oData.color1) : oData.color1;
      _loc5_.color2 = oData.color2 != -1 ? Number("0x" + oData.color2) : oData.color2;
      _loc5_.color3 = oData.color3 != -1 ? Number("0x" + oData.color3) : oData.color3;
      this.setSpriteAccessories(_loc5_,oData.accessories);
      if(oData.LP != undefined)
      {
         _loc5_.LP = oData.LP;
      }
      if(oData.LPmax != undefined)
      {
         _loc5_.LPmax = oData.LPmax;
      }
      if(oData.AP != undefined)
      {
         _loc5_.AP = oData.AP;
      }
      if(oData.AP != undefined)
      {
         _loc5_.APinit = oData.AP;
      }
      if(oData.MP != undefined)
      {
         _loc5_.MP = oData.MP;
      }
      if(oData.MP != undefined)
      {
         _loc5_.MPinit = oData.MP;
      }
      if(oData.summoned != undefined)
      {
         _loc5_.isSummoned = oData.summoned;
      }
      _loc5_.Team = oData.team != undefined ? oData.team : null;
      return _loc5_;
   }
   function createMonsterGroup(sID, sName, oData)
   {
      var _loc5_ = this.api.datacenter.Sprites.getItemAt(sID);
      if(_loc5_ == undefined)
      {
         _loc5_ = new dofus.datacenter.MonsterGroup(sID,ank.battlefield.mc.Sprite,dofus.Constants.CLIPS_PERSOS_PATH + oData.gfxID + ".swf",oData.cell,oData.dir,oData.bonusValue);
         this.api.datacenter.Sprites.addItemAt(sID,_loc5_);
      }
      _loc5_.GameActionsManager.init();
      _loc5_.cellNum = oData.cell;
      _loc5_.name = sName;
      _loc5_.Level = oData.level;
      _loc5_.scaleX = oData.scaleX;
      _loc5_.scaleY = oData.scaleY;
      _loc5_.noFlip = oData.noFlip;
      _loc5_.color1 = oData.color1 != -1 ? Number("0x" + oData.color1) : oData.color1;
      _loc5_.color2 = oData.color2 != -1 ? Number("0x" + oData.color2) : oData.color2;
      _loc5_.color3 = oData.color3 != -1 ? Number("0x" + oData.color3) : oData.color3;
      this.setSpriteAccessories(_loc5_,oData.accessories);
      return _loc5_;
   }
   function createNonPlayableCharacter(sID, nUnicID, oData)
   {
      var _loc5_ = this.api.datacenter.Sprites.getItemAt(sID);
      if(_loc5_ == undefined)
      {
         _loc5_ = new dofus.datacenter.NonPlayableCharacter(sID,ank.battlefield.mc.Sprite,dofus.Constants.CLIPS_PERSOS_PATH + oData.gfxID + ".swf",oData.cell,oData.dir,oData.gfxID,oData.customArtwork);
         this.api.datacenter.Sprites.addItemAt(sID,_loc5_);
      }
      _loc5_.GameActionsManager.init();
      _loc5_.cellNum = oData.cell;
      _loc5_.unicID = nUnicID;
      _loc5_.scaleX = oData.scaleX;
      _loc5_.scaleY = oData.scaleY;
      _loc5_.color1 = oData.color1 != -1 ? Number("0x" + oData.color1) : oData.color1;
      _loc5_.color2 = oData.color2 != -1 ? Number("0x" + oData.color2) : oData.color2;
      _loc5_.color3 = oData.color3 != -1 ? Number("0x" + oData.color3) : oData.color3;
      this.setSpriteAccessories(_loc5_,oData.accessories);
      if(oData.extraClipID >= 0)
      {
         _loc5_.extraClipID = oData.extraClipID;
      }
      return _loc5_;
   }
   function createOfflineCharacter(sID, sName, oData)
   {
      var _loc5_ = this.api.datacenter.Sprites.getItemAt(sID);
      if(_loc5_ == undefined)
      {
         _loc5_ = new dofus.datacenter.OfflineCharacter(sID,ank.battlefield.mc.Sprite,dofus.Constants.CLIPS_PERSOS_PATH + oData.gfxID + ".swf",oData.cell,oData.dir,oData.gfxID);
         this.api.datacenter.Sprites.addItemAt(sID,_loc5_);
      }
      _loc5_.GameActionsManager.init();
      _loc5_.cellNum = oData.cell;
      _loc5_.name = sName;
      _loc5_.scaleX = oData.scaleX;
      _loc5_.scaleY = oData.scaleY;
      _loc5_.color1 = oData.color1 != -1 ? Number("0x" + oData.color1) : oData.color1;
      _loc5_.color2 = oData.color2 != -1 ? Number("0x" + oData.color2) : oData.color2;
      _loc5_.color3 = oData.color3 != -1 ? Number("0x" + oData.color3) : oData.color3;
      this.setSpriteAccessories(_loc5_,oData.accessories);
      if(oData.guildName != undefined)
      {
         _loc5_.guildName = oData.guildName;
      }
      _loc5_.emblem = this.createGuildEmblem(oData.emblem);
      _loc5_.offlineType = oData.offlineType;
      _loc5_.characterID = oData.characterID;
      return _loc5_;
   }
   function createTaxCollector(sID, sName, oData)
   {
      var _loc5_ = this.api.datacenter.Sprites.getItemAt(sID);
      if(_loc5_ == undefined)
      {
         _loc5_ = new dofus.datacenter.TaxCollector(sID,ank.battlefield.mc.Sprite,dofus.Constants.CLIPS_PERSOS_PATH + oData.gfxID + ".swf",oData.cell,oData.dir,oData.gfxID,oData.isMine);
         this.api.datacenter.Sprites.addItemAt(sID,_loc5_);
      }
      _loc5_.GameActionsManager.init();
      _loc5_.cellNum = oData.cell;
      _loc5_.scaleX = oData.scaleX;
      _loc5_.scaleY = oData.scaleY;
      _loc5_.name = this.api.lang.getFullNameText(sName.split(","));
      _loc5_.Level = oData.level;
      _loc5_.isMine = oData.isMine;
      if(oData.guildName != undefined)
      {
         _loc5_.guildName = oData.guildName;
      }
      _loc5_.emblem = this.createGuildEmblem(oData.emblem);
      if(oData.LP != undefined)
      {
         _loc5_.LP = oData.LP;
      }
      if(oData.LPmax != undefined)
      {
         _loc5_.LPmax = oData.LPmax;
      }
      if(oData.AP != undefined)
      {
         _loc5_.AP = oData.AP;
      }
      if(oData.AP != undefined)
      {
         _loc5_.APinit = oData.AP;
      }
      if(oData.MP != undefined)
      {
         _loc5_.MP = oData.MP;
      }
      if(oData.MP != undefined)
      {
         _loc5_.MPinit = oData.MP;
      }
      if(oData.resistances != undefined)
      {
         _loc5_.resistances = oData.resistances;
      }
      _loc5_.Team = oData.team != undefined ? oData.team : null;
      return _loc5_;
   }
   function createPrism(sID, sName, oData)
   {
      var _loc5_ = this.api.datacenter.Sprites.getItemAt(sID);
      if(_loc5_ == undefined)
      {
         _loc5_ = new dofus.datacenter.PrismSprite(sID,ank.battlefield.mc.Sprite,dofus.Constants.CLIPS_PERSOS_PATH + oData.gfxID + ".swf",oData.cell,oData.dir,oData.gfxID);
         this.api.datacenter.Sprites.addItemAt(sID,_loc5_);
      }
      _loc5_.GameActionsManager.init();
      _loc5_.cellNum = oData.cell;
      _loc5_.scaleX = oData.scaleX;
      _loc5_.scaleY = oData.scaleY;
      _loc5_.linkedMonster = Number(sName);
      _loc5_.Level = oData.level;
      _loc5_.alignment = oData.alignment;
      return _loc5_;
   }
   function createParkMount(sID, sName, oData)
   {
      var _loc5_ = this.api.datacenter.Sprites.getItemAt(sID);
      if(_loc5_ == undefined)
      {
         _loc5_ = new dofus.datacenter.ParkMount(sID,ank.battlefield.mc.Sprite,dofus.Constants.CLIPS_PERSOS_PATH + oData.gfxID + ".swf",oData.cell,oData.dir,oData.gfxID,oData.modelID);
         this.api.datacenter.Sprites.addItemAt(sID,_loc5_);
      }
      _loc5_.GameActionsManager.init();
      _loc5_.cellNum = oData.cell;
      _loc5_.name = sName;
      _loc5_.scaleX = oData.scaleX;
      _loc5_.scaleY = oData.scaleY;
      _loc5_.ownerName = oData.ownerName;
      _loc5_.level = oData.level;
      return _loc5_;
   }
   function createMutant(sID, oData)
   {
      var _loc4_ = this.api.datacenter.Sprites.getItemAt(sID);
      if(_loc4_ == undefined)
      {
         _loc4_ = new dofus.datacenter.Mutant(sID,ank.battlefield.mc.Sprite,dofus.Constants.CLIPS_PERSOS_PATH + oData.gfxID + ".swf",oData.cell,oData.dir,oData.gfxID);
         this.api.datacenter.Sprites.addItemAt(sID,_loc4_);
      }
      _loc4_.GameActionsManager.init();
      _loc4_.scaleX = oData.scaleX;
      _loc4_.scaleY = oData.scaleY;
      _loc4_.cellNum = Number(oData.cell);
      _loc4_.Guild = Number(oData.spriteType);
      _loc4_.powerLevel = Number(oData.powerLevel);
      _loc4_.Sex = oData.sex == undefined ? 1 : oData.sex;
      _loc4_.showIsPlayer = oData.showIsPlayer;
      _loc4_.monsterID = oData.monsterID;
      _loc4_.playerName = oData.playerName;
      _loc4_.glowFilter = oData.glowFilter;
      this.setSpriteAccessories(_loc4_,oData.accessories);
      if(oData.LP != undefined)
      {
         _loc4_.LP = oData.LP;
      }
      if(oData.LPmax != undefined)
      {
         _loc4_.LPmax = oData.LPmax;
      }
      if(oData.AP != undefined)
      {
         _loc4_.AP = oData.AP;
      }
      if(oData.AP != undefined)
      {
         _loc4_.APinit = oData.AP;
      }
      if(oData.MP != undefined)
      {
         _loc4_.MP = oData.MP;
      }
      if(oData.MP != undefined)
      {
         _loc4_.MPinit = oData.MP;
      }
      _loc4_.Team = oData.team != undefined ? oData.team : null;
      if(oData.emote != undefined && oData.emote.length != 0)
      {
         _loc4_.direction = ank.battlefield.utils.Pathfinding.convertHeightToFourDirection(oData.dir);
         if(oData.emoteTimer != undefined && oData.emote.length != 0)
         {
            _loc4_.startAnimationTimer = oData.emoteTimer;
         }
         _loc4_.startAnimation = "EmoteStatic" + oData.emote;
      }
      if(oData.restrictions != undefined)
      {
         _loc4_.restrictions = _global.parseInt(oData.restrictions,36);
      }
      return _loc4_;
   }
   function getItemObjectFromData(sData)
   {
      if(sData.length == 0)
      {
         return null;
      }
      var _loc3_ = sData.split("~");
      var _loc4_ = _global.parseInt(_loc3_[0],16);
      var _loc5_ = _global.parseInt(_loc3_[1],16);
      var _loc6_ = _global.parseInt(_loc3_[2],16);
      var _loc7_ = _loc3_[3].length != 0 ? _global.parseInt(_loc3_[3],16) : -1;
      var _loc8_ = _loc3_[4];
      var _loc9_ = new dofus.datacenter.Item(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
      _loc9_.priceMultiplicator = this.api.lang.getConfigText("SELL_PRICE_MULTIPLICATOR");
      return _loc9_;
   }
   function getSpellObjectFromData(sData)
   {
      var _loc3_ = sData.split("~");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      var _loc6_ = _loc3_[2];
      var _loc7_ = new dofus.datacenter.Spell(_loc4_,_loc5_,_loc6_);
      return _loc7_;
   }
   function getNameFromData(sData)
   {
      var _loc3_ = {};
      var _loc4_ = sData.split(",");
      if(_loc4_.length == 2)
      {
         _loc3_.name = this.api.lang.getFullNameText(_loc4_);
         _loc3_.type = "taxcollector";
      }
      else if(_global.isNaN(Number(sData)))
      {
         _loc3_.name = sData;
         _loc3_.type = "player";
      }
      else
      {
         _loc3_.name = this.api.lang.getMonstersText(Number(sData)).n;
         _loc3_.type = "monster";
      }
      return _loc3_;
   }
   function setSpriteAccessories(oSprite, sAccessories)
   {
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc10_;
      var _loc11_;
      var _loc7_;
      var _loc9_;
      var _loc12_;
      var _loc8_;
      var _loc13_;
      var _loc14_;
      if(sAccessories.length != 0)
      {
         _loc4_ = [];
         _loc5_ = sAccessories.split(",");
         _loc6_ = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc10_ = false;
            if(_loc5_[_loc6_].indexOf("~") != -1)
            {
               _loc11_ = _loc5_[_loc6_].split("~");
               _loc7_ = _global.parseInt(_loc11_[0],16);
               _loc9_ = Number(_loc11_[1]);
               _loc12_ = _loc11_[2];
               if(_loc12_.charAt(_loc12_.length - 1) == "#")
               {
                  _loc10_ = true;
                  _loc12_ = _loc12_.substring(0,_loc12_.length - 1);
               }
               _loc8_ = Number(_loc12_) - 1;
               if(_loc8_ < 0)
               {
                  _loc8_ = 0;
               }
            }
            else
            {
               _loc13_ = _loc5_[_loc6_];
               if(_loc13_.charAt(_loc13_.length - 1) == "#")
               {
                  _loc10_ = true;
                  _loc13_ = _loc13_.substring(0,_loc13_.length - 1);
               }
               _loc7_ = _global.parseInt(_loc13_,16);
               _loc9_;
               _loc8_;
            }
            if(!_global.isNaN(_loc7_))
            {
               _loc14_ = new dofus.datacenter.Accessory(_loc7_,_loc9_,_loc8_,_loc10_);
               _loc4_[_loc6_] = _loc14_;
            }
            _loc6_ = _loc6_ + 1;
         }
         oSprite.accessories = _loc4_;
      }
   }
   function createGuildEmblem(sEmblem)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if(sEmblem != undefined)
      {
         _loc3_ = sEmblem.split(",");
         _loc4_ = _global.parseInt(_loc3_[0],36);
         _loc5_ = _global.parseInt(_loc3_[2],36);
         if(_loc4_ < 1 || _loc4_ > dofus.Constants.EMBLEM_BACKS_COUNT)
         {
            _loc4_ = 1;
         }
         if(_loc5_ < 1 && _loc5_ != -1 || _loc5_ > dofus.Constants.EMBLEM_UPS_COUNT)
         {
            _loc5_ = 1;
         }
         _loc6_ = {};
         _loc6_.backID = _loc4_;
         _loc6_.backColor = _global.parseInt(_loc3_[1],36);
         _loc6_.upID = _loc5_;
         _loc6_.upColor = _global.parseInt(_loc3_[3],36);
         return _loc6_;
      }
      return undefined;
   }
}
