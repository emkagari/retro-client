class dofus.aks.extend.GameIn extends dofus.aks.Handler
{
   var addToQueue;
   var aks;
   var api;
   var _aGameSpriteLeftHistory = [];
   function GameIn(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function onMovement(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = _loc3_.length - 1;
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
      var _loc49_;
      var _loc48_;
      var _loc50_;
      var _loc51_;
      var _loc52_;
      var _loc53_;
      var _loc54_;
      var _loc55_;
      var _loc56_;
      var _loc57_;
      var _loc58_;
      var _loc59_;
      var _loc60_;
      var _loc61_;
      var _loc62_;
      var _loc63_;
      var _loc29_;
      var _loc64_;
      var _loc65_;
      var _loc66_;
      var _loc67_;
      var _loc68_;
      var _loc69_;
      var _loc70_;
      var _loc71_;
      var _loc72_;
      var _loc73_;
      var _loc74_;
      var _loc75_;
      var _loc76_;
      var _loc77_;
      var _loc78_;
      var _loc79_;
      var _loc80_;
      var _loc81_;
      var _loc82_;
      var _loc83_;
      var _loc84_;
      for(; _loc4_ >= 0; _loc4_ = _loc4_ - 1)
      {
         _loc5_ = _loc3_[_loc4_];
         if(_loc5_.length != 0)
         {
            _loc6_ = false;
            _loc7_ = false;
            _loc8_ = _loc5_.charAt(0);
            if(_loc8_ == "+")
            {
               _loc7_ = true;
            }
            else if(_loc8_ == "~")
            {
               _loc7_ = true;
               _loc6_ = true;
            }
            else if(_loc8_ != "-")
            {
               continue;
            }
            if(_loc7_)
            {
               _loc9_ = _loc5_.substr(1).split(";");
               _loc10_ = _loc9_[0];
               if(_loc10_ == "-1")
               {
                  _loc10_ = String(this.api.datacenter.Player.data.cellNum);
               }
               _loc11_ = _loc9_[1];
               _loc12_ = Number(_loc9_[2]);
               _loc13_ = _loc9_[3];
               _loc14_ = _loc9_[4];
               _loc15_ = _loc9_[5];
               _loc16_ = _loc9_[6];
               _loc17_ = false;
               _loc18_ = true;
               if(_loc16_.charAt(_loc16_.length - 1) == "*")
               {
                  _loc16_ = _loc16_.substr(0,_loc16_.length - 1);
                  _loc17_ = true;
               }
               if(_loc16_.charAt(0) == "*")
               {
                  _loc18_ = false;
                  _loc16_ = _loc16_.substr(1);
               }
               _loc19_ = _loc16_.split("^");
               _loc20_ = _loc19_.length != 2 ? _loc16_ : _loc19_[0];
               _loc21_ = _loc15_.split(",");
               _loc22_ = _loc21_[0];
               _loc23_ = _loc21_[1];
               _loc24_ = 100;
               _loc25_ = 100;
               if(_loc19_.length == 2)
               {
                  _loc26_ = _loc19_[1];
                  if(_global.isNaN(Number(_loc26_)))
                  {
                     _loc27_ = _loc26_.split("x");
                     _loc24_ = _loc27_.length != 2 ? 100 : Number(_loc27_[0]);
                     _loc25_ = _loc27_.length != 2 ? 100 : Number(_loc27_[1]);
                  }
                  else
                  {
                     _loc24_ = _loc25_ = Number(_loc26_);
                  }
               }
               if(_loc6_)
               {
                  _loc28_ = this.api.datacenter.Sprites.getItemAt(_loc13_);
                  this.onSpriteMovement(false,_loc28_);
               }
               switch(_loc22_)
               {
                  case "-1":
                  case "-2":
                     _loc30_ = {};
                     _loc30_.spriteType = _loc22_;
                     _loc30_.gfxID = _loc20_;
                     _loc30_.scaleX = _loc24_;
                     _loc30_.scaleY = _loc25_;
                     _loc30_.noFlip = _loc17_;
                     _loc30_.cell = _loc10_;
                     _loc30_.dir = _loc11_;
                     _loc30_.powerLevel = _loc9_[7];
                     _loc30_.color1 = _loc9_[8];
                     _loc30_.color2 = _loc9_[9];
                     _loc30_.color3 = _loc9_[10];
                     _loc30_.accessories = _loc9_[11];
                     if(this.api.datacenter.Game.isFight)
                     {
                        _loc30_.LP = _loc9_[12];
                        _loc30_.AP = _loc9_[13];
                        _loc30_.MP = _loc9_[14];
                        if(_loc9_.length > 18)
                        {
                           _loc30_.resistances = [Number(_loc9_[15]),Number(_loc9_[16]),Number(_loc9_[17]),Number(_loc9_[18]),Number(_loc9_[19]),Number(_loc9_[20]),Number(_loc9_[21]),Number(_loc9_[22]),Number(_loc9_[23]),Number(_loc9_[24]),Number(_loc9_[25]),Number(_loc9_[26])];
                           _loc30_.summoned = _loc9_[27] == "1";
                           _loc30_.team = _loc9_[28];
                           _loc30_.LPmax = _loc9_[29];
                        }
                        else
                        {
                           _loc30_.summoned = _loc9_[15] == "1";
                           _loc30_.team = _loc9_[16];
                           _loc30_.LPmax = _loc9_[17];
                        }
                     }
                     if(_loc22_ == -1)
                     {
                        _loc28_ = this.api.kernel.CharactersManager.createCreature(_loc13_,_loc14_,_loc30_);
                     }
                     else
                     {
                        _loc28_ = this.api.kernel.CharactersManager.createMonster(_loc13_,_loc14_,_loc30_);
                     }
                     break;
                  case "-3":
                     _loc31_ = {};
                     _loc31_.spriteType = _loc22_;
                     _loc31_.level = _loc9_[7];
                     _loc31_.scaleX = _loc24_;
                     _loc31_.scaleY = _loc25_;
                     _loc31_.noFlip = _loc17_;
                     _loc31_.cell = Number(_loc10_);
                     _loc31_.dir = _loc11_;
                     _loc32_ = _loc9_[8].split(",");
                     _loc31_.color1 = _loc32_[0];
                     _loc31_.color2 = _loc32_[1];
                     _loc31_.color3 = _loc32_[2];
                     _loc31_.accessories = _loc9_[9];
                     _loc31_.bonusValue = _loc12_;
                     _loc33_ = this.sliptGfxData(_loc16_);
                     _loc34_ = _loc33_.gfx;
                     this.splitGfxForScale(_loc34_[0],_loc31_);
                     _loc28_ = this.api.kernel.CharactersManager.createMonsterGroup(_loc13_,_loc14_,_loc31_);
                     if(this.api.kernel.OptionsManager.getOption("ViewAllMonsterInGroup"))
                     {
                        _loc35_ = _loc13_;
                        _loc36_ = 1;
                        while(_loc36_ < _loc34_.length)
                        {
                           if(_loc34_[_loc4_] != "")
                           {
                              this.splitGfxForScale(_loc34_[_loc36_],_loc31_);
                              _loc32_ = _loc9_[8 + 2 * _loc36_].split(",");
                              _loc31_.color1 = _loc32_[0];
                              _loc31_.color2 = _loc32_[1];
                              _loc31_.color3 = _loc32_[2];
                              _loc31_.dir = random(4) * 2 + 1;
                              _loc31_.accessories = _loc9_[9 + 2 * _loc36_];
                              _loc37_ = _loc13_ + "_" + _loc36_;
                              _loc38_ = this.api.kernel.CharactersManager.createMonsterGroup(_loc37_,undefined,_loc31_);
                              _loc39_ = _loc35_;
                              if(random(3) != 0 && _loc36_ != 1)
                              {
                                 _loc39_ = _loc13_ + "_" + (random(_loc36_ - 1) + 1);
                              }
                              _loc40_ = random(8);
                              this.api.gfx.addLinkedSprite(_loc37_,_loc39_,_loc40_,_loc38_);
                              if(!_global.isNaN(_loc38_.scaleX))
                              {
                                 this.api.gfx.setSpriteScale(_loc38_.id,_loc38_.scaleX,_loc38_.scaleY);
                              }
                              switch(_loc33_.shape)
                              {
                                 case "circle":
                                    _loc40_ = _loc36_;
                                    break;
                                 case "line":
                                    _loc39_ = _loc37_;
                                    _loc40_ = 2;
                              }
                           }
                           _loc36_ = _loc36_ + 1;
                        }
                     }
                     break;
                  case "-4":
                     _loc41_ = {};
                     _loc41_.spriteType = _loc22_;
                     _loc41_.gfxID = _loc20_;
                     _loc41_.scaleX = _loc24_;
                     _loc41_.scaleY = _loc25_;
                     _loc41_.cell = _loc10_;
                     _loc41_.dir = _loc11_;
                     _loc41_.sex = _loc9_[7];
                     _loc41_.color1 = _loc9_[8];
                     _loc41_.color2 = _loc9_[9];
                     _loc41_.color3 = _loc9_[10];
                     _loc41_.accessories = _loc9_[11];
                     _loc41_.extraClipID = !(_loc9_[12] != undefined && !_global.isNaN(Number(_loc9_[12]))) ? -1 : Number(_loc9_[12]);
                     _loc41_.customArtwork = Number(_loc9_[13]);
                     _loc28_ = this.api.kernel.CharactersManager.createNonPlayableCharacter(_loc13_,Number(_loc14_),_loc41_);
                     break;
                  case "-5":
                     _loc42_ = {};
                     _loc42_.spriteType = _loc22_;
                     _loc42_.gfxID = _loc20_;
                     _loc42_.scaleX = _loc24_;
                     _loc42_.scaleY = _loc25_;
                     _loc42_.cell = _loc10_;
                     _loc42_.dir = _loc11_;
                     _loc42_.color1 = _loc9_[7];
                     _loc42_.color2 = _loc9_[8];
                     _loc42_.color3 = _loc9_[9];
                     _loc42_.accessories = _loc9_[10];
                     _loc42_.guildName = _loc9_[11];
                     _loc42_.emblem = _loc9_[12];
                     _loc42_.offlineType = _loc9_[13];
                     _loc42_.characterID = _loc9_[14];
                     _loc28_ = this.api.kernel.CharactersManager.createOfflineCharacter(_loc13_,_loc14_,_loc42_);
                     break;
                  case "-6":
                     _loc43_ = {};
                     _loc43_.spriteType = _loc22_;
                     _loc43_.gfxID = _loc20_;
                     _loc43_.scaleX = _loc24_;
                     _loc43_.scaleY = _loc25_;
                     _loc43_.cell = _loc10_;
                     _loc43_.dir = _loc11_;
                     _loc43_.level = _loc9_[7];
                     if(this.api.datacenter.Game.isFight)
                     {
                        _loc43_.LP = _loc9_[8];
                        _loc43_.AP = _loc9_[9];
                        _loc43_.MP = _loc9_[10];
                        _loc43_.resistances = [Number(_loc9_[11]),Number(_loc9_[12]),Number(_loc9_[13]),Number(_loc9_[14]),Number(_loc9_[15]),Number(_loc9_[16]),Number(_loc9_[17]),Number(_loc9_[18]),Number(_loc9_[19]),Number(_loc9_[20]),Number(_loc9_[21]),Number(_loc9_[22])];
                        _loc43_.team = _loc9_[23];
                        _loc43_.LPmax = _loc9_[24];
                     }
                     else
                     {
                        _loc43_.guildName = _loc9_[8];
                        _loc43_.emblem = _loc9_[9];
                        _loc43_.isMine = _loc9_[10] == "1";
                     }
                     _loc28_ = this.api.kernel.CharactersManager.createTaxCollector(_loc13_,_loc14_,_loc43_);
                     break;
                  case "-7":
                  case "-8":
                     _loc44_ = {};
                     _loc44_.spriteType = _loc22_;
                     _loc44_.gfxID = _loc20_;
                     _loc44_.scaleX = _loc24_;
                     _loc44_.scaleY = _loc25_;
                     _loc44_.cell = _loc10_;
                     _loc44_.dir = _loc11_;
                     _loc44_.sex = _loc9_[7];
                     _loc44_.powerLevel = _loc9_[8];
                     _loc44_.accessories = _loc9_[9];
                     if(this.api.datacenter.Game.isFight)
                     {
                        _loc44_.LP = _loc9_[10];
                        _loc44_.AP = _loc9_[11];
                        _loc44_.MP = _loc9_[12];
                        _loc44_.team = _loc9_[13];
                        _loc44_.glowFilter = _loc9_[18];
                        _loc44_.LPmax = _loc9_[21];
                     }
                     else
                     {
                        _loc44_.emote = _loc9_[10];
                        _loc44_.emoteTimer = _loc9_[11];
                        _loc44_.restrictions = Number(_loc9_[12]);
                        _loc44_.glowFilter = _loc9_[14];
                     }
                     if(_loc22_ == "-8")
                     {
                        _loc44_.showIsPlayer = true;
                        _loc45_ = _loc14_.split("~");
                        _loc44_.monsterID = _loc45_[0];
                        _loc44_.playerName = _loc45_[1];
                     }
                     else
                     {
                        _loc44_.showIsPlayer = false;
                        _loc44_.monsterID = _loc14_;
                     }
                     _loc28_ = this.api.kernel.CharactersManager.createMutant(_loc13_,_loc44_);
                     break;
                  case "-9":
                     _loc46_ = {};
                     _loc46_.spriteType = _loc22_;
                     _loc46_.gfxID = _loc20_;
                     _loc46_.scaleX = _loc24_;
                     _loc46_.scaleY = _loc25_;
                     _loc46_.cell = _loc10_;
                     _loc46_.dir = _loc11_;
                     _loc46_.ownerName = _loc9_[7];
                     _loc46_.level = _loc9_[8];
                     _loc46_.modelID = _loc9_[9];
                     _loc28_ = this.api.kernel.CharactersManager.createParkMount(_loc13_,_loc14_ == "" ? this.api.lang.getText("NO_NAME") : _loc14_,_loc46_);
                     break;
                  case "-10":
                     _loc47_ = {};
                     _loc47_.spriteType = _loc22_;
                     _loc47_.gfxID = _loc20_;
                     _loc47_.scaleX = _loc24_;
                     _loc47_.scaleY = _loc25_;
                     _loc47_.cell = _loc10_;
                     _loc47_.dir = _loc11_;
                     _loc47_.level = _loc9_[7];
                     _loc47_.alignment = new dofus.datacenter.Alignment(Number(_loc9_[9]),Number(_loc9_[8]));
                     _loc28_ = this.api.kernel.CharactersManager.createPrism(_loc13_,_loc14_,_loc47_);
                     break;
                  default:
                     _loc49_ = {};
                     _loc49_.spriteType = _loc22_;
                     _loc49_.cell = _loc10_;
                     _loc49_.scaleX = _loc24_;
                     _loc49_.scaleY = _loc25_;
                     _loc49_.dir = _loc11_;
                     _loc49_.sex = _loc9_[7];
                     if(this.api.datacenter.Game.isFight)
                     {
                        _loc49_.level = _loc9_[8];
                        _loc48_ = _loc9_[9];
                        _loc49_.color1 = _loc9_[10];
                        _loc49_.color2 = _loc9_[11];
                        _loc49_.color3 = _loc9_[12];
                        _loc49_.accessories = _loc9_[13];
                        _loc49_.LP = _loc9_[14];
                        _loc49_.AP = _loc9_[15];
                        _loc49_.MP = _loc9_[16];
                        _loc49_.resistances = [Number(_loc9_[17]),Number(_loc9_[18]),Number(_loc9_[19]),Number(_loc9_[20]),Number(_loc9_[21]),Number(_loc9_[22]),Number(_loc9_[23]),Number(_loc9_[24]),Number(_loc9_[25]),Number(_loc9_[26]),Number(_loc9_[27]),Number(_loc9_[28])];
                        _loc49_.team = _loc9_[29];
                        if(_loc9_[30].indexOf(",") != -1)
                        {
                           _loc50_ = _loc9_[30].split(",");
                           _loc51_ = Number(_loc50_[0]);
                           _loc52_ = _global.parseInt(_loc50_[1],16);
                           _loc53_ = _global.parseInt(_loc50_[2],16);
                           _loc54_ = _global.parseInt(_loc50_[3],16);
                           if(!_global.isNaN(_loc51_))
                           {
                              _loc55_ = new dofus.datacenter.Mount(_loc51_,Number(_loc20_));
                              _loc55_.customColor1 = _loc52_;
                              _loc55_.customColor2 = _loc53_;
                              _loc55_.customColor3 = _loc54_;
                              _loc49_.mount = _loc55_;
                           }
                        }
                        else
                        {
                           _loc56_ = Number(_loc9_[30]);
                           if(!_global.isNaN(_loc56_))
                           {
                              _loc49_.mount = new dofus.datacenter.Mount(_loc56_,Number(_loc20_));
                           }
                        }
                        _loc49_.hasCandy = _loc9_[31];
                        _loc49_.hasBuff = _loc9_[32];
                        _loc49_.LPmax = _loc9_[33];
                        _loc49_.glowFilter = _loc9_[34];
                        if(this.api.datacenter.Player.ID == _loc13_)
                        {
                           this.api.datacenter.Player.LPmax = _loc49_.LPmax;
                           this.api.datacenter.Player.LP = _loc49_.LP;
                        }
                     }
                     else
                     {
                        _loc48_ = _loc9_[8];
                        _loc49_.color1 = _loc9_[9];
                        _loc49_.color2 = _loc9_[10];
                        _loc49_.color3 = _loc9_[11];
                        _loc49_.accessories = _loc9_[12];
                        _loc49_.aura = _loc9_[13];
                        _loc49_.emote = _loc9_[14];
                        _loc49_.emoteTimer = _loc9_[15];
                        _loc49_.guildName = _loc9_[16];
                        _loc49_.emblem = _loc9_[17];
                        _loc49_.restrictions = _loc9_[18];
                        _loc49_.hasTtgCollection = _loc9_[21] == "1";
                        _loc49_.glowFilter = _loc9_[22];
                        if(_loc9_[19].indexOf(",") != -1)
                        {
                           _loc57_ = _loc9_[19].split(",");
                           _loc58_ = Number(_loc57_[0]);
                           _loc59_ = _global.parseInt(_loc57_[1],16);
                           _loc60_ = _global.parseInt(_loc57_[2],16);
                           _loc61_ = _global.parseInt(_loc57_[3],16);
                           if(!_global.isNaN(_loc58_))
                           {
                              _loc62_ = new dofus.datacenter.Mount(_loc58_,Number(_loc20_));
                              _loc62_.customColor1 = _loc59_;
                              _loc62_.customColor2 = _loc60_;
                              _loc62_.customColor3 = _loc61_;
                              _loc49_.mount = _loc62_;
                           }
                        }
                        else
                        {
                           _loc63_ = Number(_loc9_[19]);
                           if(!_global.isNaN(_loc63_))
                           {
                              _loc49_.mount = new dofus.datacenter.Mount(_loc63_,Number(_loc20_));
                           }
                        }
                     }
                     if(_loc6_)
                     {
                        _loc29_ = [_loc13_,this.createTransitionEffect(),_loc10_,10];
                     }
                     _loc64_ = _loc48_.split(",");
                     _loc49_.alignment = new dofus.datacenter.Alignment(Number(_loc64_[0]),Number(_loc64_[1]));
                     _loc49_.rank = new dofus.datacenter.Rank(Number(_loc64_[2]));
                     _loc49_.alignment.fallenAngelDemon = _loc64_[4] == 1;
                     if(_loc64_.length > 3 && _loc13_ != this.api.datacenter.Player.ID)
                     {
                        if(this.api.lang.getAlignmentCanViewPvpGain(this.api.datacenter.Player.alignment.index,Number(_loc49_.alignment.index)))
                        {
                           _loc65_ = Number(_loc64_[3]) - Number(_loc13_);
                           _loc66_ = this.api.lang.getConfigText("PVP_VIEW_BONUS_MINOR_LIMIT");
                           _loc67_ = this.api.lang.getConfigText("PVP_VIEW_BONUS_MINOR_LIMIT_PRC");
                           _loc68_ = this.api.lang.getConfigText("PVP_VIEW_BONUS_MAJOR_LIMIT");
                           _loc69_ = this.api.lang.getConfigText("PVP_VIEW_BONUS_MAJOR_LIMIT_PRC");
                           _loc70_ = 0;
                           if(this.api.datacenter.Player.Level * (1 - _loc67_ / 100) > _loc65_)
                           {
                              _loc70_ = -1;
                           }
                           if(this.api.datacenter.Player.Level - _loc65_ > _loc66_)
                           {
                              _loc70_ = -1;
                           }
                           if(this.api.datacenter.Player.Level * (1 + _loc69_ / 100) < _loc65_)
                           {
                              _loc70_ = 1;
                           }
                           if(this.api.datacenter.Player.Level - _loc65_ < _loc68_)
                           {
                              _loc70_ = 1;
                           }
                           _loc49_.pvpGain = _loc70_;
                        }
                     }
                     if(!this.api.datacenter.Game.isFight && (_global.parseInt(_loc13_,10) != this.api.datacenter.Player.ID && ((this.api.datacenter.Player.alignment.index == 1 || this.api.datacenter.Player.alignment.index == 2) && ((_loc49_.alignment.index == 1 || _loc49_.alignment.index == 2) && (_loc49_.alignment.index != this.api.datacenter.Player.alignment.index && (_loc49_.rank.value && this.api.datacenter.Map.bCanAttack))))))
                     {
                        if(this.api.datacenter.Player.rank.value > _loc49_.rank.value)
                        {
                           this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_NEW_ENEMY_WEAK);
                        }
                        if(this.api.datacenter.Player.rank.value < _loc49_.rank.value)
                        {
                           this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_NEW_ENEMY_STRONG);
                        }
                     }
                     _loc71_ = this.sliptGfxData(_loc16_);
                     _loc72_ = _loc71_.gfx;
                     this.splitGfxForScale(_loc72_[0],_loc49_);
                     if(_loc23_.length)
                     {
                        _loc74_ = _loc23_.split("*");
                        _loc73_ = new dofus.datacenter.Title(Number(_loc74_[0]),_loc74_[1],undefined,_loc49_.sex);
                     }
                     _loc49_.title = _loc73_;
                     // Retro: the ornament id follows the title ("class,title,ornament").
                     _loc49_.ornament = Number(_loc21_[2]);
                     _loc28_ = this.api.kernel.CharactersManager.createCharacter(_loc13_,_loc14_,_loc49_);
                     dofus.datacenter.Character(_loc28_).isClear = false;
                     _loc28_.allowGhostMode = _loc18_;
                     _loc75_ = _loc13_;
                     _loc76_ = _loc71_.shape != "circle" ? 2 : 0;
                     _loc77_ = 1;
                     while(_loc77_ < _loc72_.length)
                     {
                        if(_loc72_[_loc77_] != "")
                        {
                           _loc78_ = _loc13_ + "_" + _loc77_;
                           _loc79_ = {};
                           this.splitGfxForScale(_loc72_[_loc77_],_loc79_);
                           _loc80_ = new ank.battlefield.datacenter.Sprite(_loc78_,ank.battlefield.mc.Sprite,dofus.Constants.CLIPS_PERSOS_PATH + _loc79_.gfxID + ".swf");
                           _loc80_.allDirections = false;
                           this.api.gfx.addLinkedSprite(_loc78_,_loc75_,_loc76_,_loc80_);
                           if(!_global.isNaN(_loc79_.scaleX))
                           {
                              this.api.gfx.setSpriteScale(_loc80_.id,_loc79_.scaleX,_loc79_.scaleY);
                           }
                           switch(_loc71_.shape)
                           {
                              case "circle":
                                 _loc76_ = _loc77_;
                                 break;
                              case "line":
                                 _loc75_ = _loc78_;
                                 _loc76_ = 2;
                           }
                        }
                        _loc77_ = _loc77_ + 1;
                     }
               }
               this.onSpriteMovement(_loc7_,_loc28_,_loc29_);
            }
            else
            {
               _loc81_ = _loc5_.substr(1);
               _loc82_ = this.api.datacenter.Sprites.getItemAt(_loc81_);
               if(!this.api.datacenter.Game.isRunning && this.api.datacenter.Game.isLoggingMapDisconnections)
               {
                  _loc83_ = _loc82_.name;
                  _loc84_ = this._aGameSpriteLeftHistory[_loc81_];
                  if(!_global.isNaN(_loc84_) && getTimer() - _loc84_ < 300)
                  {
                     this.api.kernel.showMessage(undefined,this.api.kernel.DebugManager.getTimestamp() + " (Map) " + this.api.kernel.ChatManager.getLinkName(_loc81_,_loc83_) + " s\'est déconnecté (" + _loc81_ + ")","ADMIN_CHAT");
                  }
                  this._aGameSpriteLeftHistory[_loc81_] = getTimer();
               }
               this.onSpriteMovement(_loc7_,_loc82_);
            }
         }
      }
   }
   function onCellData(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_].split(";");
         _loc6_ = Number(_loc5_[0]);
         _loc7_ = _loc5_[1].substring(0,10);
         _loc8_ = _loc5_[1].substr(10);
         _loc9_ = _loc5_[2] != "0" ? 1 : 0;
         this.api.gfx.updateCell(_loc6_,_loc7_,_loc8_,_loc9_);
         _loc4_ = _loc4_ + 1;
      }
   }
   function onZoneData(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_];
         _loc6_ = _loc5_.charAt(0) != "+" ? false : true;
         _loc7_ = _loc5_.substr(1).split(";");
         _loc8_ = Number(_loc7_[0]);
         _loc9_ = Number(_loc7_[1]);
         _loc10_ = _loc7_[2];
         _loc11_ = Number(_loc7_[3]);
         if(_loc6_)
         {
            this.api.gfx.drawZone(_loc8_,0,_loc9_,_loc10_,dofus.Constants.ZONE_COLOR[_loc10_],_loc11_);
         }
         else
         {
            this.api.gfx.clearZone(_loc8_,_loc9_,_loc10_);
         }
         _loc4_ = _loc4_ + 1;
      }
   }
   function onCellObject(sExtraData)
   {
      var _loc3_ = sExtraData.charAt(0) == "+";
      var _loc4_ = sExtraData.substr(1).split("|");
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      while(_loc5_ < _loc4_.length)
      {
         _loc6_ = _loc4_[_loc5_].split(";");
         _loc7_ = Number(_loc6_[0]);
         _loc8_ = Number(_loc6_[1]);
         if(_loc3_)
         {
            _loc9_ = new dofus.datacenter.Item(0,_loc8_);
            _loc10_ = Number(_loc6_[2]);
            switch(_loc10_)
            {
               case 0:
                  this.api.gfx.updateCellObjectExternalWithExternalClip(_loc7_,_loc9_.iconFile,1,true,true,_loc9_);
                  break;
               case 1:
                  if(this.api.gfx.mapHandler.getCellData(_loc7_).layerObjectExternalData.unicID != _loc8_)
                  {
                     this.api.gfx.updateCellObjectExternalWithExternalClip(_loc7_,_loc9_.iconFile,1,true,false,_loc9_);
                  }
                  else
                  {
                     _loc9_ = this.api.gfx.mapHandler.getCellData(_loc7_).layerObjectExternalData;
                  }
                  _loc9_.rideItemDurability = Number(_loc6_[3]);
                  _loc9_.rideItemDurabilityMax = Number(_loc6_[4]);
            }
         }
         else
         {
            _loc11_ = this.api.gfx.mapHandler.getCellData(_loc7_);
            if(_loc11_ != undefined && (_loc11_.mcObjectExternal != undefined && _loc11_.mcObjectExternal == this.api.gfx.rollOverMcObject))
            {
               this.api.gfx.onObjectRollOut(_loc11_.mcObjectExternal);
            }
            this.api.gfx.initializeCell(_loc7_,1);
         }
         _loc5_ = _loc5_ + 1;
      }
   }
   function onFrameObject2(sExtraData)
   {
      var _loc3_ = ank.gapi.controls.PopupMenu.currentPopupMenu;
      var _loc4_ = sExtraData.split("|");
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      while(_loc5_ < _loc4_.length)
      {
         _loc6_ = _loc4_[_loc5_].split(";");
         _loc7_ = Number(_loc6_[0]);
         _loc8_ = _loc6_[1];
         _loc9_ = _loc6_[2] != undefined;
         _loc10_ = _loc6_[2] != "1" ? false : true;
         if(_loc3_ != undefined && (_loc3_.gatherCellNum == _loc7_ && (!_loc10_ && _loc8_ == "3")))
         {
            _loc3_.removePopupMenu();
         }
         if(_loc9_)
         {
            this.api.gfx.setObject2Interactive(_loc7_,_loc10_,2);
         }
         this.api.gfx.setObject2Frame(_loc7_,_loc8_);
         _loc5_ = _loc5_ + 1;
      }
   }
   function onFrameObjectExternal(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_].split(";");
         _loc6_ = Number(_loc5_[0]);
         _loc7_ = Number(_loc5_[1]);
         this.api.gfx.setObjectExternalFrame(_loc6_,_loc7_);
         _loc4_ = _loc4_ + 1;
      }
   }
   function onEffect(sExtraData)
   {
      var _loc3_ = sExtraData.split(";");
      var _loc4_ = _loc3_[0];
      var _loc5_ = _loc3_[1].split(",");
      var _loc6_ = _loc3_[2];
      var _loc7_ = _loc3_[3];
      var _loc8_ = _loc3_[4];
      var _loc9_ = _loc3_[5];
      var _loc10_ = Number(_loc3_[6]);
      var _loc11_ = _loc3_[7];
      var _loc12_ = _loc3_[8];
      var _loc13_ = Number(_loc3_[9]) == 1;
      var _loc14_ = 0;
      var _loc15_;
      var _loc16_;
      var _loc17_;
      while(_loc14_ < _loc5_.length)
      {
         _loc15_ = _loc5_[_loc14_];
         if(_loc15_ == this.api.datacenter.Game.currentPlayerID && _loc10_ != -1)
         {
            _loc10_ = _loc10_ + 1;
         }
         _loc16_ = new dofus.datacenter.Effect(_loc12_,Number(_loc4_),Number(_loc6_),Number(_loc7_),Number(_loc8_),_loc9_,Number(_loc10_),Number(_loc11_),undefined,undefined,_loc13_);
         _loc17_ = this.api.datacenter.Sprites.getItemAt(_loc15_);
         _loc17_.EffectsManager.addEffect(_loc16_);
         _loc14_ = _loc14_ + 1;
      }
   }
   function onClearAllEffect(sExtraData)
   {
      var _loc3_ = this.api.datacenter.Sprites;
      for(var a in _loc3_)
      {
         _loc3_[a].EffectsManager.terminateAllEffects();
      }
   }
   function onChallenge(sExtraData)
   {
      var _loc3_ = sExtraData.charAt(0) == "+";
      var _loc4_ = sExtraData.substr(1).split("|");
      var _loc5_ = _loc4_.shift().split(";");
      var _loc6_ = Number(_loc5_[0]);
      var _loc7_ = Number(_loc5_[1]);
      var _loc8_ = Math.floor(Math.random() * 16777215);
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
      if(_loc3_)
      {
         _loc9_ = new dofus.datacenter.Challenge(_loc6_,_loc7_);
         this.api.datacenter.Challenges.addItemAt(_loc6_,_loc9_);
         _loc10_ = 0;
         while(_loc10_ < _loc4_.length)
         {
            _loc11_ = _loc4_[_loc10_].split(";");
            _loc12_ = _loc11_[0];
            _loc13_ = Number(_loc11_[1]);
            _loc14_ = Number(_loc11_[2]);
            _loc15_ = Number(_loc11_[3]);
            _loc16_ = dofus.Constants.getTeamFileFromType(_loc14_,_loc15_);
            _loc17_ = new dofus.datacenter.Team(_loc12_,ank.battlefield.mc.Sprite,_loc16_,_loc13_,_loc8_,_loc14_,_loc15_);
            _loc9_.addTeam(_loc17_);
            this.api.gfx.addSprite(_loc17_.id,_loc17_);
            _loc10_ = _loc10_ + 1;
         }
      }
      else
      {
         _loc18_ = this.api.datacenter.Challenges.getItemAt(_loc6_).teams;
         for(var k in _loc18_)
         {
            _loc19_ = _loc18_[k];
            this.api.gfx.removeSprite(_loc19_.id);
         }
         this.api.datacenter.Challenges.removeItemAt(_loc6_);
      }
   }
   function onTeam(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_.shift());
      var _loc5_ = dofus.datacenter.Team(this.api.datacenter.Sprites.getItemAt(_loc4_));
      var _loc6_ = 0;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      while(_loc6_ < _loc3_.length)
      {
         _loc7_ = _loc3_[_loc6_].split(";");
         _loc8_ = _loc7_[0].charAt(0) == "+";
         _loc9_ = _loc7_[0].substr(1);
         _loc10_ = _loc7_[1];
         _loc11_ = _loc7_[2];
         _loc12_ = _loc10_.split(",");
         _loc13_ = Number(_loc10_);
         if(_loc12_.length > 1)
         {
            _loc10_ = this.api.lang.getFullNameText(_loc12_);
         }
         else if(!_global.isNaN(_loc13_))
         {
            _loc10_ = this.api.lang.getMonstersText(_loc13_).n;
         }
         if(_loc8_)
         {
            _loc14_ = {};
            _loc14_.id = _loc9_;
            _loc14_.name = _loc10_;
            _loc14_.level = _loc11_;
            _loc5_.addPlayer(_loc14_);
         }
         else
         {
            _loc5_.removePlayer(_loc9_);
         }
         _loc6_ = _loc6_ + 1;
      }
      _loc5_.refreshSwordSprite();
   }
   function onFightOption(sExtraData)
   {
      var _loc3_ = sExtraData.substr(2);
      var _loc4_ = this.api.datacenter.Sprites.getItemAt(_loc3_);
      var _loc5_;
      var _loc6_;
      if(_loc4_ != undefined)
      {
         _loc5_ = sExtraData.charAt(0) == "+";
         _loc6_ = sExtraData.charAt(1);
         switch(_loc6_)
         {
            case "H":
               _loc4_.options[dofus.datacenter.Team.OPT_NEED_HELP] = _loc5_;
               break;
            case "S":
               _loc4_.options[dofus.datacenter.Team.OPT_BLOCK_SPECTATOR] = _loc5_;
               break;
            case "A":
               _loc4_.options[dofus.datacenter.Team.OPT_BLOCK_JOINER] = _loc5_;
               break;
            case "P":
               _loc4_.options[dofus.datacenter.Team.OPT_BLOCK_JOINER_EXCEPT_PARTY_MEMBER] = _loc5_;
         }
         this.api.gfx.addSpriteOverHeadItem(_loc3_,"FightOptions",dofus.graphics.battlefield.FightOptionsOverHead,[_loc4_],undefined);
      }
   }
   function onLeave()
   {
      this.api.datacenter.Game.currentPlayerID = undefined;
      this.api.ui.getUIComponent("Banner").hideRightPanel(true);
      this.api.ui.unloadUIComponent("Timeline");
      this.api.ui.unloadUIComponent("StringCourse");
      this.api.ui.unloadUIComponent("PlayerInfos");
      this.api.ui.unloadUIComponent("SpriteInfos");
      this.aks.GameActions.onActionsFinish(String(this.api.datacenter.Player.ID));
      this.api.datacenter.Player.reset();
      this.api.datacenter.Player.isDead = false;
      this.api.datacenter.Game.isRunning = false;
      this.api.datacenter.Game.destroy();
      var _loc2_ = dofus.graphics.gapi.ui.FightChallenge(dofus.graphics.gapi.ui.FightChallenge(this.api.ui.getUIComponent("FightChallenge")));
      _loc2_.cleanChallenge();
      this.aks.Game.create();
   }
   function onEnd(sExtraData)
   {
      if(this.api.kernel.MapsServersManager.isBuilding)
      {
         this.addToQueue({object:this,method:this.onEnd,params:[sExtraData]});
         return undefined;
      }
      this.aks.Game.isBusy = true;
      var _loc3_ = dofus.graphics.gapi.ui.FightChallenge(dofus.graphics.gapi.ui.FightChallenge(this.api.ui.getUIComponent("FightChallenge")));
      this.api.kernel.StreamingDisplayManager.onFightEnd();
      var _loc4_ = {winners:[],loosers:[],collectors:[],challenges:_loc3_.challenges.deepClone(),currentTableTurn:-1,currentPlayerInfos:[],currentPlayerInfosWithChest:[]};
      if(!this.api.datacenter.Game.isSpectator)
      {
         this.api.datacenter.Basics.currentSessionFightCount++;
         _loc4_.id = this.api.datacenter.Basics.currentSessionFightCount;
         this.api.datacenter.Game.storeFightResults(_loc4_);
      }
      _loc3_.cleanChallenge();
      var _loc5_ = sExtraData.split("|");
      var _loc6_ = _loc5_[0].split(";");
      _loc4_.duration = Number(_loc6_[0]);
      this.api.datacenter.Basics.aks_game_end_bonus = _loc6_[1] != "" ? Number(_loc6_[1]) : -1;
      _loc4_.currentTableTurn = Number(_loc6_[2]);
      var _loc7_ = Number(_loc5_[1]);
      var _loc8_ = Number(_loc5_[2]);
      _loc4_.fightType = _loc8_;
      var _loc9_ = new ank.utils.ExtendedArray();
      var _loc10_ = 0;
      this.api.datacenter.Player.isDead = false;
      this.api.datacenter.Game.results = _loc4_;
      this.parsePlayerData(_loc4_,3,_loc7_,_loc5_,_loc8_,_loc10_,_loc9_,false,false);
   }
   function parsePlayerData(oResults, nStartIndex, nSenderID, aTmp, nFightType, nKamaDrop, eaFightDrop, bAlreadyParsed, bIsChest)
   {
      var _loc11_ = nStartIndex;
      var _loc12_ = aTmp[_loc11_].split(";");
      var _loc13_ = {};
      var _loc15_;
      var _loc16_;
      var _loc14_;
      if(Number(_loc12_[0]) != 6)
      {
         _loc13_.id = Number(_loc12_[1]);
         if(_loc13_.id == this.api.datacenter.Player.ID)
         {
            if(Number(_loc12_[0]) == 0)
            {
               this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_FIGHT_LOST);
            }
            else
            {
               this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_FIGHT_WON);
            }
         }
         _loc15_ = this.api.kernel.CharactersManager.getNameFromData(_loc12_[2]);
         _loc13_.name = _loc15_.name;
         _loc13_.type = _loc15_.type;
         _loc13_.level = Number(_loc12_[3]);
         _loc13_.bDead = _loc12_[5] != "1" ? false : true;
         _loc13_.gfx = Number(_loc12_[4]);
         _loc16_ = 6;
         switch(nFightType)
         {
            case 0:
               _loc13_.minxp = Number(_loc12_[_loc16_++]);
               _loc13_.xp = Number(_loc12_[_loc16_++]);
               _loc13_.maxxp = Number(_loc12_[_loc16_++]);
               _loc13_.winxp = Math.max(Number(_loc12_[_loc16_++]),0);
               _loc13_.guildxp = Number(_loc12_[_loc16_++]);
               _loc13_.mountxp = Number(_loc12_[_loc16_++]);
               _loc14_ = _loc12_[_loc16_++].split(",");
               if(_loc13_.id == this.api.datacenter.Player.ID && _loc14_.length > 10)
               {
                  this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_GREAT_DROP);
               }
               _loc13_.kama = _loc12_[_loc16_++];
               break;
            case 1:
               _loc13_.minhonour = Number(_loc12_[_loc16_++]);
               _loc13_.honour = Number(_loc12_[_loc16_++]);
               _loc13_.maxhonour = Number(_loc12_[_loc16_++]);
               _loc13_.winhonour = Number(_loc12_[_loc16_++]);
               _loc13_.rank = Number(_loc12_[_loc16_++]);
               _loc13_.disgrace = Number(_loc12_[_loc16_++]);
               _loc13_.windisgrace = Number(_loc12_[_loc16_++]);
               _loc13_.maxdisgrace = this.api.lang.getMaxDisgracePoints();
               _loc13_.mindisgrace = 0;
               _loc13_.alignment = Number(_loc12_[_loc16_++]);
               _loc14_ = _loc12_[_loc16_++].split(",");
               if(_loc13_.id == this.api.datacenter.Player.ID && _loc14_.length > 10)
               {
                  this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_GREAT_DROP);
               }
               _loc13_.kama = _loc12_[_loc16_++];
               _loc13_.minxp = Number(_loc12_[_loc16_++]);
               _loc13_.xp = Number(_loc12_[_loc16_++]);
               _loc13_.maxxp = Number(_loc12_[_loc16_++]);
               _loc13_.winxp = Number(_loc12_[_loc16_++]);
         }
         _loc13_.xpMultiplicator = Number(_loc12_[_loc16_++]);
         _loc13_.xpLocked = _loc12_[_loc16_++] == "1";
      }
      else
      {
         _loc14_ = _loc12_[1].split(",");
         _loc13_.kama = _loc12_[2];
         nKamaDrop += Number(_loc13_.kama);
      }
      _loc13_.items = [];
      _loc13_.items = this.parseItems(_loc14_);
      switch(Number(_loc12_[0]))
      {
         case 0:
            oResults.loosers.push(_loc13_);
            break;
         case 2:
            oResults.winners.push(_loc13_);
            break;
         case 5:
            oResults.collectors.push(_loc13_);
            break;
         case 6:
            eaFightDrop = eaFightDrop.concat(_loc13_.items);
      }
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
      if(!bAlreadyParsed && (_loc13_.id == this.api.datacenter.Player.ID || bIsChest))
      {
         if(bIsChest)
         {
            _loc17_ = new ank.utils.ExtendedObject();
            _loc18_ = [];
            _loc19_ = oResults.currentPlayerInfos[0].items;
            _loc20_ = 0;
            while(_loc20_ < _loc19_.length)
            {
               _loc21_ = _loc19_[_loc20_];
               _loc22_ = new dofus.datacenter.Item(undefined,_loc21_.unicID,_loc21_.Quantity);
               _loc18_.push(_loc22_);
               _loc17_.addItemAt(_loc21_.unicID,_loc22_);
               _loc20_ = _loc20_ + 1;
            }
            _loc23_ = _loc13_.items;
            _loc24_ = 0;
            while(_loc24_ < _loc23_.length)
            {
               _loc25_ = _loc23_[_loc24_];
               if(_loc17_.getItemAt(_loc25_.unicID) != undefined)
               {
                  _loc26_ = dofus.datacenter.Item(_loc17_.getItemAt(_loc25_.unicID));
                  _loc26_.Quantity += _loc25_.Quantity;
               }
               else
               {
                  _loc18_.push(_loc25_);
               }
               _loc24_ = _loc24_ + 1;
            }
            this.api.datacenter.Basics.kamas_lastGained = Number(this.api.datacenter.Basics.kamas_lastGained) + Number(_loc12_[13]);
            _loc27_ = {};
            _loc27_.type = oResults.currentPlayerInfos[0].type;
            _loc27_.winxp = this.api.datacenter.Basics.exp_lastGained;
            _loc27_.guildxp = this.api.datacenter.Basics.guildExp_lastGained;
            _loc27_.mountxp = this.api.datacenter.Basics.mountExp_lastGained;
            _loc27_.kama = this.api.datacenter.Basics.kamas_lastGained;
            _loc27_.items = _loc18_;
            oResults.currentPlayerInfosWithChest.push(_loc27_);
            bAlreadyParsed = true;
         }
         else
         {
            if(this.api.datacenter.Player.Guild == 3 && nFightType == 0)
            {
               if(aTmp[_loc11_ + 1].split(";")[2] == 285)
               {
                  bIsChest = true;
               }
               else
               {
                  bAlreadyParsed = true;
               }
            }
            else
            {
               bAlreadyParsed = true;
            }
            this.api.datacenter.Basics.exp_lastGained = _loc13_.winxp;
            this.api.datacenter.Basics.kamas_lastGained = _loc13_.kama;
            this.api.datacenter.Basics.guildExp_lastGained = _loc13_.guildxp;
            this.api.datacenter.Basics.mountExp_lastGained = _loc13_.mountxp;
            oResults.currentPlayerInfos.push(_loc13_);
         }
      }
      _loc11_ = _loc11_ + 1;
      if(_loc11_ < aTmp.length)
      {
         this.addToQueue({object:this,method:this.parsePlayerData,params:[oResults,_loc11_,nSenderID,aTmp,nFightType,nKamaDrop,eaFightDrop,bAlreadyParsed,bIsChest]});
      }
      else
      {
         this.onParseItemEnd(nSenderID,oResults,eaFightDrop,nKamaDrop);
      }
   }
   function parseItems(aItems)
   {
      var _loc3_ = [];
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      while(_loc4_ < aItems.length)
      {
         _loc5_ = aItems[_loc4_].split("~");
         _loc6_ = Number(_loc5_[0]);
         _loc7_ = Number(_loc5_[1]);
         if(_global.isNaN(_loc6_))
         {
            break;
         }
         if(_loc6_ != 0)
         {
            _loc8_ = new dofus.datacenter.Item(0,_loc6_,_loc7_);
            _loc3_.push(_loc8_);
         }
         _loc4_ = _loc4_ + 1;
      }
      return _loc3_;
   }
   function onParseItemEnd(nSenderID, oResults, eaFightDrop, nKamaDrop)
   {
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      if(eaFightDrop.length)
      {
         _loc6_ = Math.ceil(eaFightDrop.length / oResults.winners.length);
         _loc7_ = 0;
         while(_loc7_ < oResults.winners.length)
         {
            _loc8_ = eaFightDrop.length;
            oResults.winners[_loc7_].kama = Math.ceil(nKamaDrop / _loc6_);
            if(_loc7_ == oResults.winners.length - 1)
            {
               _loc6_ = _loc8_;
            }
            _loc9_ = _loc8_ - _loc6_;
            while(_loc9_ < _loc8_)
            {
               oResults.winners[_loc7_].items.push(eaFightDrop.pop());
               _loc9_ = _loc9_ + 1;
            }
            _loc7_ = _loc7_ + 1;
         }
      }
      if(nSenderID == this.api.datacenter.Player.ID)
      {
         this.aks.GameActions.onActionsFinish(String(nSenderID));
      }
      this.api.datacenter.Game.isRunning = false;
      this.api.datacenter.Game.destroy();
      var _loc10_ = this.api.datacenter.Sprites.getItemAt(nSenderID).sequencer;
      this.aks.Game.isBusy = false;
      if(_loc10_ != undefined)
      {
         _loc10_.addAction(26,false,this.api.kernel.GameManager,this.api.kernel.GameManager.terminateFight);
         _loc10_.execute(false);
      }
      else
      {
         ank.utils.Logger.err("[AKS.Game.onEnd] Impossible de trouver le sequencer");
         ank.utils.Timer.setTimer(this,"game",this.api.kernel.GameManager,this.api.kernel.GameManager.terminateFight,500);
      }
      this.api.kernel.TipsManager.showNewTip(dofus.managers.TipsManager.TIP_FIGHT_ENDFIGHT);
   }
   function onExtraClip(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = _loc3_[0];
      var _loc5_ = _loc3_[1].split(";");
      var _loc6_ = dofus.Constants.EXTRA_PATH + _loc4_ + ".swf";
      var _loc7_ = _loc4_ == "-";
      var _loc8_;
      for(var k in _loc5_)
      {
         _loc8_ = _loc5_[k];
         if(_loc7_)
         {
            this.api.gfx.removeSpriteExtraClip(_loc8_,false);
         }
         else
         {
            this.api.gfx.addSpriteExtraClip(_loc8_,_loc6_,undefined,false);
         }
      }
   }
   function onGameOver()
   {
      this.api.network.softDisconnect();
      this.api.ui.loadUIComponent("GameOver","GameOver",undefined,{bAlwaysOnTop:true});
   }
   function onSpriteMovement(bAdd, oSprite, aEffect)
   {
      if(oSprite instanceof dofus.datacenter.Character)
      {
         this.api.datacenter.Game.playerCount += !bAdd ? -1 : 1;
      }
      var _loc5_ = oSprite.id;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      if(bAdd)
      {
         if(aEffect != undefined)
         {
            this.api.gfx.spriteLaunchVisualEffect.apply(this.api.gfx,aEffect);
         }
         this.api.gfx.addSprite(_loc5_);
         if(!_global.isNaN(oSprite.scaleX))
         {
            this.api.gfx.setSpriteScale(_loc5_,oSprite.scaleX,oSprite.scaleY);
         }
         if(oSprite instanceof dofus.datacenter.OfflineCharacter)
         {
            oSprite.mc.addExtraClip(dofus.Constants.EXTRA_PATH + oSprite.offlineType + ".swf",undefined,true);
            return undefined;
         }
         if(oSprite instanceof dofus.datacenter.NonPlayableCharacter)
         {
            if(!_global.isNaN(oSprite.extraClipID))
            {
               this.api.gfx.addSpriteExtraClip(_loc5_,dofus.Constants.EXTRA_PATH + oSprite.extraClipID + ".swf",undefined,false);
               return undefined;
            }
         }
         if(this.api.datacenter.Game.isRunning)
         {
            this.api.gfx.addSpriteExtraClip(_loc5_,oSprite.circleFilePath,dofus.Constants.TEAMS_COLOR[oSprite.Team]);
            if(this.api.datacenter.Game.isCreatureMode)
            {
               this.addToQueue({object:this.api.kernel.GameManager,method:this.api.kernel.GameManager.applyCreatureModeFight,params:[true,_loc5_]});
            }
         }
         else if(oSprite.Aura != 0 && (oSprite.Aura != undefined && this.api.kernel.OptionsManager.getOption("Aura")))
         {
            this.api.gfx.addSpriteExtraClip(_loc5_,dofus.Constants.AURA_PATH + oSprite.Aura + ".swf",undefined,true);
         }
         if(oSprite.glowFilter != undefined && oSprite.glowFilter != "")
         {
            _loc6_ = Number("0x" + oSprite.glowFilter);
            this.api.gfx.setGlowOnPlayer(_loc5_,_loc6_);
         }
         if(_loc5_ == this.api.datacenter.Player.ID)
         {
            this.api.datacenter.Player.data = oSprite;
            this.api.ui.getUIComponent("Banner").updateLocalPlayer();
         }
         else if(this.api.gfx.spriteHandler.isPlayerSpritesHidden && (oSprite instanceof dofus.datacenter.Character || (oSprite instanceof dofus.datacenter.PlayerShop || oSprite instanceof dofus.datacenter.MonsterGroup)))
         {
            this.api.gfx.spriteHandler.hideSprite(_loc5_,true);
         }
         else if(this.api.gfx.spriteHandler.isShowingMonstersTooltip && oSprite instanceof dofus.datacenter.MonsterGroup)
         {
            oSprite.mc._rollOver(true);
         }
         oSprite.onWindowFocusChanged({isFocused:this.api.electron.isWindowFocused});
      }
      else if(!this.api.datacenter.Game.isRunning)
      {
         this.api.gfx.removeSprite(_loc5_);
      }
      else
      {
         _loc7_ = oSprite.sequencer;
         _loc8_ = oSprite.mc;
         _loc7_.addAction(27,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("LEAVE_GAME",[oSprite.name]),"INFO_CHAT"]);
         _loc7_.addAction(28,false,this.api.ui.getUIComponent("Timeline"),this.api.ui.getUIComponent("Timeline").hideItem,[_loc5_]);
         _loc9_ = this.api.electron.isWindowFocused || !this.api.kernel.OptionsManager.getOption("AntiLagHideDie");
         _loc7_.addAction(29,true,_loc8_,_loc8_.setAnim,[!_loc9_ ? "Static" : "Die"],1500,true);
         if(oSprite.hasCarriedChild())
         {
            this.api.gfx.uncarriedSprite(oSprite.carriedChild.id,oSprite.cellNum,false,_loc7_);
            _loc7_.addAction(30,false,this.api.gfx,this.api.gfx.addSpriteExtraClip,[oSprite.carriedChild.id,oSprite.carriedChild.circleFilePath,dofus.Constants.TEAMS_COLOR[oSprite.carriedChild.Team]]);
         }
         _loc7_.addAction(31,false,_loc8_,_loc8_.clear);
         _loc7_.execute();
         if(this.api.datacenter.Game.currentPlayerID == _loc5_)
         {
            this.api.ui.getUIComponent("Banner").stopTimer();
            this.api.ui.getUIComponent("Timeline").stopChrono();
         }
      }
      if(!this.api.datacenter.Game.isRunning)
      {
         this.api.kernel.GameManager.applyCreatureMode();
      }
   }
   function sliptGfxData(sGfx)
   {
      var _loc3_;
      if(sGfx.indexOf(",") != -1)
      {
         _loc3_ = sGfx.split(",");
         return {shape:"circle",gfx:_loc3_};
      }
      var _loc4_;
      if(sGfx.indexOf(":") != -1)
      {
         _loc4_ = sGfx.split(":");
         return {shape:"line",gfx:_loc4_};
      }
      return {shape:"none",gfx:[sGfx]};
   }
   function splitGfxForScale(sGfxInput, oData)
   {
      var _loc4_ = sGfxInput.split("^");
      var _loc5_ = _loc4_.length != 2 ? sGfxInput : _loc4_[0];
      var _loc6_ = 100;
      var _loc7_ = 100;
      var _loc8_;
      var _loc9_;
      if(_loc4_.length == 2)
      {
         _loc8_ = _loc4_[1];
         if(_global.isNaN(Number(_loc8_)))
         {
            _loc9_ = _loc8_.split("x");
            _loc6_ = _loc9_.length != 2 ? 100 : Number(_loc9_[0]);
            _loc7_ = _loc9_.length != 2 ? 100 : Number(_loc9_[1]);
         }
         else
         {
            _loc6_ = _loc7_ = Number(_loc8_);
         }
      }
      oData.gfxID = _loc5_;
      oData.scaleX = _loc6_;
      oData.scaleY = _loc7_;
   }
   function createTransitionEffect()
   {
      var _loc2_ = new ank.battlefield.datacenter.VisualEffect();
      _loc2_.id = 5;
      _loc2_.file = dofus.Constants.SPELLS_PATH + "transition.swf";
      _loc2_.level = 5;
      _loc2_.params = [];
      _loc2_.bInFrontOfSprite = true;
      _loc2_.bTryToBypassContainerColor = false;
      return _loc2_;
   }
}
