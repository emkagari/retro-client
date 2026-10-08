class dofus.utils.DofusTranslator extends dofus.utils.ApiElement
{
   var _nLastServerID;
   var fetchIn;
   var fetchOut;
   static var STANDARD_DATA_BANK = 0;
   static var TEMPORIS_DATA_BANK = 1;
   var _aSOXtraCache = [];
   function DofusTranslator()
   {
      super();
   }
   function getLangVersion()
   {
      return this.getValueFromSOLang("VERSIONS").lang;
   }
   function getXtraVersion()
   {
      return Number(this.getValueFromSOXtra("VERSION"));
   }
   function getText(sKey, aParams)
   {
      if(aParams == undefined)
      {
         aParams = [];
      }
      var _loc4_ = [];
      var _loc5_ = [];
      var _loc6_ = 0;
      while(_loc6_ < aParams.length)
      {
         _loc4_.push("%" + (_loc6_ + 1));
         _loc5_.push(aParams[_loc6_]);
         _loc6_ = _loc6_ + 1;
      }
      var _loc7_ = this.getValueFromSOLang(sKey);
      if(_loc7_ == "" || _loc7_ == undefined)
      {
         return "!" + sKey + "!";
      }
      return new ank.utils.ExtendedString(_loc7_).replace(_loc4_,_loc5_);
   }
   function getConfigText(sKey)
   {
      var _loc3_ = this.getValueFromSOLang("C")[sKey];
      var _loc4_;
      var _loc5_;
      if(typeof _loc3_ == "string")
      {
         _loc4_ = _loc3_;
         _loc5_ = new ank.utils.ExtendedString(_loc4_);
         return _loc5_.replace(["%CMNT%","%CMNTT%"],[this.api.datacenter.Basics.aks_community_id,this.api.datacenter.Basics.aks_detected_country.toLowerCase()]);
      }
      return _loc3_;
   }
   function getAllMapsInfos()
   {
      return this.getValueFromSOXtra("MA").m;
   }
   function getMapMaxChallenge(nMapID)
   {
      var _loc3_ = this.getValueFromSOXtra("MA").m[nMapID].c;
      if(_loc3_ == undefined || _global.isNaN(_loc3_))
      {
         return dofus.Constants.MAX_PLAYERS_IN_CHALLENGE;
      }
      return _loc3_;
   }
   function getMapMaxTeam(nMapID)
   {
      var _loc3_ = this.getValueFromSOXtra("MA").m[nMapID].t;
      if(_loc3_ == undefined || _global.isNaN(_loc3_))
      {
         return dofus.Constants.MAX_PLAYERS_IN_TEAM;
      }
      return _loc3_;
   }
   function getMapText(sKey)
   {
      return this.getValueFromSOXtra("MA").m[sKey];
   }
   function getMapAreas()
   {
      return this.getValueFromSOXtra("MA").a;
   }
   function getMapSuperAreaText(sKey)
   {
      return this.getValueFromSOXtra("MA").sua[sKey];
   }
   function getMapAreaText(sKey)
   {
      return this.getValueFromSOXtra("MA").a[sKey];
   }
   function getMapSubAreas()
   {
      return this.getValueFromSOXtra("MA").sa;
   }
   function getMapSubAreaText(nKey)
   {
      return this.getValueFromSOXtra("MA").sa[nKey];
   }
   function getMapSubareaTacticColors(nKey)
   {
      return this.getValueFromSOXtra("MA").sa[nKey].tc;
   }
   function getMapSubareaTacticTheme(nKey)
   {
      return this.getValueFromSOXtra("MA").sa[nKey].tt;
   }
   function getMapSubAreaName(nKey)
   {
      return String(this.getValueFromSOXtra("MA").sa[nKey].n);
   }
   function getMapAreaInfos(nSubAreaID)
   {
      var _loc3_ = this.getValueFromSOXtra("MA").sa[nSubAreaID];
      var _loc4_ = this.getValueFromSOXtra("MA").a[_loc3_.a];
      var _loc5_ = this.getValueFromSOXtra("MA").a[_loc4_.sua];
      return {superareaID:_loc4_.sua,superarea:_loc5_,areaID:_loc3_.a,area:_loc4_,subArea:_loc3_};
   }
   function getItemSetText(nKey)
   {
      return this.getValueFromSOXtra("IS")[nKey];
   }
   function getItemStats(nKey)
   {
      return this.getValueFromSOXtra("ISTA")[nKey];
   }
   function getItemUnicText(nKey)
   {
      return this.getValueFromSOXtra("I").u[nKey];
   }
   function getItemUnics()
   {
      return this.getValueFromSOXtra("I").u;
   }
   function getItemUnicStringText()
   {
      return this.getValueFromSOXtra("I").us;
   }
   function getItemTypeText(nTypeID)
   {
      return this.getValueFromSOXtra("I").t[nTypeID];
   }
   function getItemSuperTypeText(nSuperTypeID)
   {
      return this.getValueFromSOXtra("I").st[nSuperTypeID];
   }
   function getAllItemTypes()
   {
      return this.getValueFromSOXtra("I").t;
   }
   function getSlotsFromSuperType(nSuperTypeID)
   {
      return this.getValueFromSOXtra("I").ss[nSuperTypeID];
   }
   function getInteractiveObjectDataByGfxText(nKey)
   {
      return this.getInteractiveObjectDataText(this.getValueFromSOXtra("IO").g[nKey]);
   }
   function getInteractiveObjectDataTexts()
   {
      return this.getValueFromSOXtra("IO").d;
   }
   function getInteractiveObjectDataText(nKey)
   {
      return this.getValueFromSOXtra("IO").d[nKey];
   }
   function getHouseText(nID)
   {
      return this.getValueFromSOXtra("H").h[nID];
   }
   function getHousesMapText(nMapID)
   {
      return this.getValueFromSOXtra("H").m[nMapID];
   }
   function getHousesDoorText(nMapID, nCellNum)
   {
      return this.getValueFromSOXtra("H").d[nMapID]["c" + nCellNum];
   }
   function getHousesIndoorSkillsText()
   {
      return this.getValueFromSOXtra("H").ids;
   }
   function getTtgObject()
   {
      return this.getValueFromSOXtra("TTG");
   }
   function getTtgCards()
   {
      return this.getTtgObject().c;
   }
   function getTtgCardObject(nCardID)
   {
      return this.getTtgObject().c[nCardID];
   }
   function getTtgEntityObject(nEntityID)
   {
      return this.getTtgObject().e[nEntityID];
   }
   function getTtgFamilyObject(nFamilyID)
   {
      return this.getTtgObject().f[nFamilyID];
   }
   function getDungeonText(nID)
   {
      return this.getValueFromSOXtra("DU")[nID];
   }
   function getDungeonTextFromSubarea(nSubareaID)
   {
      if(nSubareaID == undefined)
      {
         return undefined;
      }
      var _loc3_ = this.getValueFromSOXtra("DU");
      var _loc4_;
      for(var nDungeonID in _loc3_)
      {
         _loc4_ = _loc3_[nDungeonID];
         if(Number(_loc4_.sba) == nSubareaID)
         {
            return _loc4_;
         }
      }
      return undefined;
   }
   function getSpellText(nSpellID)
   {
      return this.getValueFromSOXtra("S")[nSpellID];
   }
   function getSpells()
   {
      return this.getValueFromSOXtra("S");
   }
   function getAllEffectText()
   {
      return this.getValueFromSOXtra("E");
   }
   function getEffectText(nEffectID)
   {
      return this.getValueFromSOXtra("E")[nEffectID];
   }
   function getBoostedDamagingEffects()
   {
      return this.getValueFromSOXtra("EDMG");
   }
   function getBoostedHealingEffects()
   {
      return this.getValueFromSOXtra("EHEL");
   }
   function getAllJobsText()
   {
      return this.getValueFromSOXtra("J");
   }
   function getJobText(nJobID)
   {
      return this.getAllJobsText()[nJobID];
   }
   function getCraftText(nID)
   {
      return this.getValueFromSOXtra("CR")[nID];
   }
   function getAllCrafts()
   {
      return this.getValueFromSOXtra("CR");
   }
   function getSkillText(nID)
   {
      return this.getValueFromSOXtra("SK")[nID];
   }
   function getSkillForgemagus(nID)
   {
      return Number(this.getValueFromSOXtra("SK")[nID].f);
   }
   function getDialogQuestionText(nQuestionID)
   {
      return this.getValueFromSOXtra("D").q[nQuestionID];
   }
   function getDialogResponseText(nAnswerID)
   {
      return this.getValueFromSOXtra("D").a[nAnswerID];
   }
   function getNonPlayableCharactersTexts()
   {
      return this.getValueFromSOXtra("N").d;
   }
   function getNonPlayableCharactersText(nNpcID)
   {
      return this.getNonPlayableCharactersTexts()[nNpcID];
   }
   function getNonPlayableCharactersActionText(nActionID)
   {
      return this.getValueFromSOXtra("N").a[nActionID];
   }
   function getMonstersText(nMonsterID)
   {
      return this.getValueFromSOXtra("M")[nMonsterID];
   }
   function getMonsters()
   {
      return this.getValueFromSOXtra("M");
   }
   function getMonstersRaceText(nRaceMonsterID)
   {
      return this.getValueFromSOXtra("MR")[nRaceMonsterID];
   }
   function getMonstersRace()
   {
      return this.getValueFromSOXtra("MR");
   }
   function getMonstersSuperRaceText(nSuperRaceMonsterID)
   {
      return this.getValueFromSOXtra("MSR")[nSuperRaceMonsterID];
   }
   function getMonstersSuperRace()
   {
      return this.getValueFromSOXtra("MSR");
   }
   function getMonsterDrops(nMonsterID)
   {
      var _loc3_ = this.getValueFromSOXtra("MD")[nMonsterID];
      var _loc4_ = {};
      for(var sDrop in _loc3_)
      {
         _loc4_[sDrop] = _loc3_[sDrop];
      }
      return _loc4_;
   }
   function getMonsterDrop(nMonsterID, nItemID)
   {
      return this.getValueFromSOXtra("MD")[nMonsterID][nItemID];
   }
   function getMonsterDropStaticCriterion(nMonsterID, nItemID)
   {
      return this.getValueFromSOXtra("MD")[nMonsterID][nItemID].sc;
   }
   function getTimeZoneText()
   {
      return this.getValueFromSOXtra("T");
   }
   function getMonthText(nMonthID)
   {
      return this.getValueFromSOXtra("T").m[nMonthID][1];
   }
   function getAllClassText()
   {
      return this.getValueFromSOXtra("G");
   }
   function getClassText(nClassID)
   {
      return this.getAllClassText()[nClassID];
   }
   function getEmoteText(nEmoteID)
   {
      return this.getValueFromSOXtra("EM")[nEmoteID];
   }
   function getEmoteID(sEmoteShortcut)
   {
      var _loc3_ = this.getValueFromSOXtra("EM");
      for(var k in _loc3_)
      {
         if(_loc3_[k].s == sEmoteShortcut)
         {
            return Number(k);
         }
      }
      return null;
   }
   function getGuildBoosts(sCharacteristics)
   {
      return this.getValueFromSOXtra("GU").b[sCharacteristics];
   }
   function getGuildBoostsMax(sCharacteristics)
   {
      return this.getValueFromSOXtra("GU").b[sCharacteristics + "m"];
   }
   function getNameText(nID)
   {
      return this.getValueFromSOXtra("NF").n[nID];
   }
   function getFirstnameText(nID)
   {
      return this.getValueFromSOXtra("NF").f[nID];
   }
   function getFullNameText(aIDs)
   {
      aIDs[0] = _global.parseInt(aIDs[0],36);
      aIDs[1] = _global.parseInt(aIDs[1],36);
      return this.getFirstnameText(aIDs[0]) + " " + this.getNameText(aIDs[1]);
   }
   function getRankInfos(nID)
   {
      return this.getValueFromSOXtra("R")[nID];
   }
   function getRanks()
   {
      return this.getValueFromSOXtra("R");
   }
   function getAlignments()
   {
      return this.getValueFromSOXtra("A").a;
   }
   function getAlignment(nID)
   {
      return this.getValueFromSOXtra("A").a[nID];
   }
   function getAlignmentCanJoin(nIDa, nIDb)
   {
      return this.getValueFromSOXtra("A").jo[nIDa][nIDb];
   }
   function getAlignmentCanAttack(nIDa, nIDb)
   {
      return this.getValueFromSOXtra("A").at[nIDa][nIDb];
   }
   function getAlignmentSpecializations()
   {
      return this.getValueFromSOXtra("A").s;
   }
   function getAlignmentSpecialization(nID)
   {
      return this.getValueFromSOXtra("A").s[nID];
   }
   function getAlignmentOrder(nID)
   {
      return this.getValueFromSOXtra("A").o[nID];
   }
   function getAlignmentFeat(nID)
   {
      return this.getValueFromSOXtra("A").f[nID];
   }
   function getAlignmentFeatEffect(nID)
   {
      return this.getValueFromSOXtra("A").fe[nID];
   }
   function getAlignmentBalance()
   {
      return this.getValueFromSOXtra("A").b;
   }
   function getAlignmentCanViewPvpGain(nIDa, nIDb)
   {
      return this.getValueFromSOXtra("A").g[nIDa][nIDb];
   }
   function getTips()
   {
      return this.getValueFromSOXtra("TI");
   }
   function getTip(nID)
   {
      return this.getValueFromSOXtra("TI")[nID];
   }
   function getKeyboardShortcutsCategories()
   {
      return this.getValueFromSOXtra("SSC");
   }
   function getKeyboardShortcuts()
   {
      return this.getValueFromSOXtra("SH");
   }
   function getKeyboardShortcutsSets()
   {
      return this.getValueFromSOXtra("SST");
   }
   function getKeyboardShortcutsKeys(nSetID, sShortCut)
   {
      return this.getValueFromSOXtra("SSK")[String(nSetID) + "|" + sShortCut];
   }
   function getControlKeyString(nCtrlKeyCode)
   {
      switch(nCtrlKeyCode)
      {
         case 1:
            return this.getText("KEY_CONTROL") + "+";
         case 2:
            return this.getText("KEY_SHIFT") + "+";
         case 3:
            return this.getText("KEY_CONTROL") + "+" + this.getText("KEY_SHIFT") + "+";
         default:
            return "";
      }
   }
   function getKeyStringFromKeyCode(nKeyCode)
   {
      switch(nKeyCode)
      {
         case 112:
            return this.getText("KEY_F1");
         case 113:
            return this.getText("KEY_F2");
         case 114:
            return this.getText("KEY_F3");
         case 115:
            return this.getText("KEY_F4");
         case 116:
            return this.getText("KEY_F5");
         case 117:
            return this.getText("KEY_F6");
         case 118:
            return this.getText("KEY_F7");
         case 119:
            return this.getText("KEY_F8");
         case 120:
            return this.getText("KEY_F9");
         case 121:
            return this.getText("KEY_F10");
         case 122:
            return this.getText("KEY_F11");
         case 123:
            return this.getText("KEY_F12");
         case 145:
            return this.getText("KEY_SCROLL_LOCK");
         case 19:
            return this.getText("KEY_PAUSE");
         case 45:
            return this.getText("KEY_INSERT");
         case 36:
            return this.getText("KEY_HOME");
         case 33:
            return this.getText("KEY_PAGE_UP");
         case 34:
            return this.getText("KEY_PAGE_DOWN");
         case 35:
            return this.getText("KEY_END");
         case 37:
            return this.getText("KEY_LEFT");
         case 38:
            return this.getText("KEY_UP");
         case 39:
            return this.getText("KEY_RIGHT");
         case 40:
            return this.getText("KEY_DOWN");
         case 27:
            return this.getText("KEY_ESCAPE");
         case 8:
            return this.getText("KEY_BACKSPACE");
         case 20:
            return this.getText("KEY_CAPS_LOCK");
         case 13:
            return this.getText("KEY_ENTER");
         case 32:
            return this.getText("KEY_SPACE");
         case 46:
            return this.getText("KEY_DELETE");
         case 144:
            return this.getText("KEY_NUM_LOCK");
         case -1:
            return this.getText("KEY_UNDEFINED");
         default:
            return "(#" + String(nKeyCode) + ")";
      }
   }
   function getDefaultConsoleShortcuts()
   {
      return this.getValueFromSOLang("CNS");
   }
   function getServerInfos(nID)
   {
      return this.getValueFromSOXtra("SR",dofus.utils.DofusTranslator.STANDARD_DATA_BANK)[nID];
   }
   function getServerPopulation(nID)
   {
      return this.getValueFromSOXtra("SRP")[nID];
   }
   function getServerPopulationWeight(nID)
   {
      return Number(this.getValueFromSOXtra("SRPW")[nID]);
   }
   function getServerCommunities()
   {
      return this.getValueFromSOLang("COM");
   }
   function getServerCommunity(nID)
   {
      return this.getValueFromSOXtra("SRC")[nID].n;
   }
   function getServerCommunityDisplayed(nID)
   {
      return this.getValueFromSOXtra("SRC")[nID].d;
   }
   function getServerSpecificTexts()
   {
      return this.getValueFromSOXtra("SRVT");
   }
   function getServerSpecificText(nTextID, nServerID)
   {
      return this.getValueFromSOXtra("SRVC")[nTextID + "|" + nServerID];
   }
   function getQuests()
   {
      return this.getValueFromSOXtra("Q").q;
   }
   function getQuest(nID)
   {
      return this.getQuests()[nID];
   }
   function getQuestText(nID)
   {
      return this.getQuests()[nID].n;
   }
   function getQuestSteps()
   {
      return this.getValueFromSOXtra("Q").s;
   }
   function getQuestStepText(nID)
   {
      return this.getValueFromSOXtra("Q").s[nID];
   }
   function getQuestObjectiveText(nID)
   {
      return this.getValueFromSOXtra("Q").o[nID];
   }
   function getQuestObjectiveTypeText(nID)
   {
      return this.getValueFromSOXtra("Q").t[nID];
   }
   function getDailyQuestData(nId_)
   {
      return this.getValueFromSOXtra("DQ")[nId_];
   }
   function getDailyQuestID(nPoolQuestID)
   {
      return this.getValueFromSOXtra("DQI")[nPoolQuestID];
   }
   function getState(nID)
   {
      return this.getValueFromSOXtra("ST")[nID];
   }
   function getStateText(nID)
   {
      return this.getValueFromSOXtra("ST")[nID].n;
   }
   function getStateIsDisplayedBanner(nID)
   {
      return this.getValueFromSOXtra("ST")[nID].d;
   }
   function getStateShortText(nID)
   {
      return this.getValueFromSOXtra("ST")[nID].s;
   }
   function getGradeHonourPointsBounds(g)
   {
      var _loc3_ = this.getValueFromSOXtra("PP").hp;
      return {min:_loc3_[g - 1],max:_loc3_[g]};
   }
   function getMaxDisgracePoints()
   {
      return this.getValueFromSOXtra("PP").maxdp;
   }
   function getRankLongName(nSide, nRank)
   {
      return this.getValueFromSOXtra("PP").grds[nSide][nRank].nl;
   }
   function getRankShortName(nSide, nRank)
   {
      return this.getValueFromSOXtra("PP").grds[nSide][nRank].nc;
   }
   function getHintsByMapID(mapID)
   {
      return this.getHintsBy("m",mapID);
   }
   function getHintsByCategory(categoryID)
   {
      return this.getHintsBy("c",categoryID);
   }
   function getHintsBy(prop, value)
   {
      var _loc4_ = this.getValueFromSOXtra("HI");
      var _loc5_ = [];
      var _loc6_ = 0;
      var _loc7_;
      while(_loc6_ < _loc4_.length)
      {
         _loc7_ = _loc4_[_loc6_];
         if(_loc7_[prop] == value)
         {
            _loc5_.push(_loc7_);
         }
         _loc6_ = _loc6_ + 1;
      }
      return _loc5_;
   }
   function getHintsCategory(nID)
   {
      return this.getValueFromSOXtra("HIC")[nID];
   }
   function getHintsCategories()
   {
      return this.getValueFromSOXtra("HIC");
   }
   function getMountText(nID)
   {
      return this.getValueFromSOXtra("RI")[nID];
   }
   function getMountCapacity(nID)
   {
      return this.getValueFromSOXtra("RIA")[nID];
   }
   function getKnownledgeBaseCategories()
   {
      return this.getValueFromSOXtra("KBC");
   }
   function getKnownledgeBaseCategory(nID)
   {
      return this.getValueFromSOXtra("KBC")[nID];
   }
   function getKnownledgeBaseArticles()
   {
      return this.getValueFromSOXtra("KBA");
   }
   function getKnownledgeBaseArticle(nID)
   {
      return this.getValueFromSOXtra("KBA")[nID];
   }
   function getKnownledgeBaseTriggers()
   {
      return this.getValueFromSOXtra("KBD");
   }
   function getKnownledgeBaseTip(nTipID)
   {
      return this.getValueFromSOXtra("KBT")[nTipID];
   }
   function getMusicFromKeyname(sKeyName)
   {
      return Number(this.getValueFromSOXtra("AUMC")[sKeyName]);
   }
   function getEffectFromKeyname(sKeyName)
   {
      return Number(this.getValueFromSOXtra("AUEC")[sKeyName]);
   }
   function getEnvironmentFromKeyname(sKeyName)
   {
      return Number(this.getValueFromSOXtra("AUAC")[sKeyName]);
   }
   function getMusic(nMusic)
   {
      return this.getValueFromSOXtra("AUM")[nMusic];
   }
   function getEffect(nEffect)
   {
      return this.getValueFromSOXtra("AUE")[nEffect];
   }
   function getEnvironment(nEnvironment)
   {
      return this.getValueFromSOXtra("AUA")[nEnvironment];
   }
   function getSubtitle(nTrailer, nIndex)
   {
      return this.getValueFromSOXtra("SUB")[nTrailer][nIndex];
   }
   function getTutorialText(nTextID)
   {
      return this.getValueFromSOXtra("SCR")[nTextID];
   }
   function getCensoredWords()
   {
      return this.getValueFromSOLang("CSR");
   }
   function getAbuseReasons()
   {
      return this.getValueFromSOLang("ABR");
   }
   function getSpeakingItemsTexts()
   {
      return this.getValueFromSOXtra("SIM");
   }
   function getSpeakingItemsText(nID)
   {
      return this.getValueFromSOXtra("SIM")[nID];
   }
   function getSpeakingItemsTriggers()
   {
      return this.getValueFromSOXtra("SIT");
   }
   function getSpeakingItemsTrigger(nID)
   {
      return this.getValueFromSOXtra("SIT")[nID];
   }
   function getFightChallenge(nID)
   {
      return this.getValueFromSOXtra("FC")[nID];
   }
   function getTitle(nID)
   {
      return this.getValueFromSOXtra("PT")[nID];
   }
   function getTitles()
   {
      return this.getValueFromSOXtra("PT");
   }
   function getWantedParchment(nID)
   {
      return this.getValueFromSOXtra("DW")[nID];
   }
   function getAchievements()
   {
      return this.getValueFromSOXtra("AC");
   }
   function getAchievementsCategories()
   {
      return this.getValueFromSOXtra("ACC");
   }
   function getAchievement(nID)
   {
      return this.getValueFromSOXtra("AC")[nID];
   }
   function getAchievementDescription(nID)
   {
      return this.getValueFromSOXtra("ACT")[nID];
   }
   function getAchievementCategory(nID)
   {
      return this.getValueFromSOXtra("ACC")[nID];
   }
   function getAchievementObjective(nID)
   {
      return this.getValueFromSOXtra("ACO")[nID];
   }
   function getLangFileSize(nDataBank, sLangFile)
   {
      var _loc4_ = new String();
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(sLangFile.toUpperCase() == "LANG")
      {
         _loc4_ = dofus.Constants.GLOBAL_SO_LANG_NAME + "_" + nDataBank;
      }
      else
      {
         if(sLangFile.toUpperCase() == "TOTAL")
         {
            _loc5_ = this.getLangFileSize(nDataBank,"lang");
            _loc6_ = _global.API.lang.getConfigText("XTRA_FILE");
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               _loc5_ += this.getLangFileSize(_loc6_[_loc7_]);
               _loc7_ = _loc7_ + 1;
            }
            return _loc5_;
         }
         _loc4_ = dofus.Constants.GLOBAL_SO_XTRA_NAME + "_" + nDataBank;
      }
      var _loc8_ = _global[_loc4_].data.WEIGHTS[sLangFile.toUpperCase()];
      if(_loc8_ == undefined || _global.isNaN(_loc8_))
      {
         return 0;
      }
      return _loc8_;
   }
   function fetchString(s)
   {
      var _loc3_ = new ank.utils.ExtendedString(s);
      var _loc4_;
      var _loc5_;
      if(this.fetchIn == undefined || (this.fetchOut == undefined || this._nLastServerID != this.api.datacenter.Basics.aks_current_server.id))
      {
         this.fetchIn = [];
         this.fetchOut = [];
         _loc4_ = this.getServerSpecificTexts();
         this._nLastServerID = this.api.datacenter.Basics.aks_current_server.id;
         for(var i in _loc4_)
         {
            _loc5_ = this.getServerSpecificText(Number(i),this._nLastServerID);
            if(_loc5_ == undefined)
            {
               _loc5_ = _loc4_[i].d;
            }
            this.fetchIn.push("`SRVT:" + _loc4_[i].l + "`");
            this.fetchOut.push(_loc5_);
         }
      }
      return _loc3_.replace(this.fetchIn,this.fetchOut);
   }
   function clearSOXtraCache()
   {
      this._aSOXtraCache = [];
   }
   function getDataBank()
   {
      var _loc2_ = this.api.datacenter.Basics.aks_current_server;
      if(_loc2_ == undefined)
      {
         return dofus.utils.DofusTranslator.STANDARD_DATA_BANK;
      }
      return !_loc2_.isTemporis() ? dofus.utils.DofusTranslator.STANDARD_DATA_BANK : dofus.utils.DofusTranslator.TEMPORIS_DATA_BANK;
   }
   function getValueFromSOLang(sKey)
   {
      var _loc3_ = this.getDataBank();
      var _loc4_ = dofus.Constants.GLOBAL_SO_LANG_NAME + "_" + _loc3_;
      return _global[_loc4_].data[sKey];
   }
   function getValueFromSOXtra(sKey, nForcedDataBank)
   {
      var _loc4_;
      if(nForcedDataBank != undefined)
      {
         _loc4_ = nForcedDataBank;
      }
      else
      {
         _loc4_ = this.getDataBank();
      }
      var _loc5_ = dofus.Constants.XTRA_SHAREDOBJECT_NAME + "_" + _loc4_ + "_" + sKey;
      var _loc6_ = _global[_loc5_];
      if(_loc6_ == undefined)
      {
         _global[_loc5_] = ank.utils.SharedObjectFix.getLocal(_loc5_);
         _loc6_ = _global[_loc5_];
      }
      var _loc7_ = _loc6_.data[sKey];
      var _loc8_;
      var _loc9_;
      if(_loc7_ instanceof Array)
      {
         _loc8_ = this._aSOXtraCache[_loc4_];
         if(_loc8_ == undefined)
         {
            _loc8_ = [];
            this._aSOXtraCache[_loc4_] = _loc8_;
         }
         _loc9_ = _loc8_[sKey];
         if(_loc9_ == undefined)
         {
            _loc9_ = _loc7_.slice();
            _loc8_[sKey] = _loc9_;
         }
         return _loc9_;
      }
      return _loc7_;
   }
}
