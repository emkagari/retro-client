class dofus.graphics.gapi.ui.Achievements extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aAchievements;
   var _btnClose;
   var _btnHideCompletedAchievements;
   var _btnReset;
   var _lblCategories;
   var _lblNoAchievementsFound;
   var _lstCategories;
   var _mcAchievements;
   var _mcFooter;
   var _mcPlacer;
   var _mcSynthesis;
   var _nLastAchievementID;
   var _nSearchInterval;
   var _nSelectedCategoryID;
   var _oCurrentOverItem;
   var _sbScrollbar;
   var _tiSearch;
   var _winBg;
   var addToQueue;
   var createEmptyMovieClip;
   var gapi;
   var getNextHighestDepth;
   var unloadThis;
   static var SCROLL_BY;
   static var CLASS_NAME = "Achievements";
   static var OBJECTIVE_SEARCH_CACHE = {};
   static var SYNTHESIS_CATEGORY = 1;
   var _sCurrentAchievementSearch = "";
   var _nCurrentParentID = -1;
   function Achievements()
   {
      super();
   }
   function set selectedCategory(nSelectedCategoryID)
   {
      this._nSelectedCategoryID = nSelectedCategoryID;
      if(this._lstCategories.dataProvider != undefined)
      {
         this.selectCategory(nSelectedCategoryID);
      }
   }
   function set displayAchievement(nAchievementID)
   {
      this.addToQueue({object:this,method:this.focusAchievement,params:[nAchievementID,true,false]});
   }
   function set displayAchievementWithoutToggle(nAchievementID)
   {
      this.addToQueue({object:this,method:this.focusAchievement,params:[nAchievementID,false,false]});
   }
   function get currentOverItem()
   {
      return this._oCurrentOverItem;
   }
   function set currentOverItem(oCurrentOverItem)
   {
      this._oCurrentOverItem = oCurrentOverItem;
   }
   function get currentParentID()
   {
      return this._nCurrentParentID;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Achievements.CLASS_NAME);
   }
   function destroy()
   {
      this.gapi.hideTooltip();
      ank.utils.MouseEvents.garbageCollector();
      this.api.datacenter.Player.Achievements.removeEventListener("achievementCompleted",this);
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function resetSearch(bShowSynthesisPage)
   {
      this._sCurrentAchievementSearch = "";
      this._tiSearch.clearText();
      _global.clearInterval(this._nSearchInterval);
      if(bShowSynthesisPage)
      {
         this.selectCategory(dofus.graphics.gapi.ui.Achievements.SYNTHESIS_CATEGORY);
      }
   }
   function createChildren()
   {
      this._mcSynthesis._visible = false;
      this._sbScrollbar._visible = false;
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function initTexts()
   {
      this._lblNoAchievementsFound._visible = false;
      this._mcFooter._visible = false;
      this._winBg.title = this.api.lang.getText("ACHIEVEMENTS");
      this._lblNoAchievementsFound.text = this.api.lang.getText("NO_ACHIEVEMENTS_FOUND");
      this._lblCategories.text = this.api.lang.getText("CATEGORIES");
      this._tiSearch.placeholder = ank.utils.PatternDecoder.combine(this.api.lang.getText("SEARCH_MINIMUM_CHARACTERS",[dofus.Constants.ACHIEVEMENT_SEARCH_MIN_CHARACTERS]),null,dofus.Constants.ACHIEVEMENT_SEARCH_MIN_CHARACTERS <= 1);
      this._tiSearch.restrict = dofus.Constants.INV_SEARCH_RESTRICT;
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnReset.addEventListener("click",this);
      this._btnHideCompletedAchievements.addEventListener("click",this);
      this._btnHideCompletedAchievements.addEventListener("over",this);
      this._btnHideCompletedAchievements.addEventListener("out",this);
      this._lstCategories.addEventListener("itemSelected",this);
      ank.utils.MouseEvents.addListener(this);
      this._sbScrollbar.addEventListener("scroll",this);
      this.api.datacenter.Player.Achievements.addEventListener("achievementCompleted",this);
      this._tiSearch.addEventListener("change",this);
   }
   function initData()
   {
      var _loc2_ = this.api.datacenter.Player.Achievements.getAllParentsCategories();
      this._lstCategories.dataProvider = _loc2_;
      var _loc3_ = [];
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < _loc2_.length)
      {
         _loc5_ = _loc2_[_loc4_];
         if(_loc5_.ID != dofus.graphics.gapi.ui.Achievements.SYNTHESIS_CATEGORY)
         {
            _loc3_.push(_loc5_);
         }
         _loc4_ = _loc4_ + 1;
      }
      this._mcSynthesis.data = _loc3_;
      if(this._nSelectedCategoryID != undefined)
      {
         this.addToQueue({object:this,method:this.selectCategory,params:[this._nSelectedCategoryID]});
      }
   }
   function getCategoryIndex(oCategory)
   {
      var _loc3_ = this._lstCategories.dataProvider;
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_];
         if(_loc5_ == oCategory || _loc5_.ID != undefined && _loc5_.ID == oCategory.ID)
         {
            return _loc4_;
         }
         _loc4_ = _loc4_ + 1;
      }
      return -1;
   }
   function addSubcategories(oParentCategory, nCategoryIndex)
   {
      var _loc4_ = this._lstCategories.dataProvider;
      var _loc5_ = this.api.datacenter.Player.Achievements.getSubcategories(oParentCategory.ID);
      var _loc6_ = 0;
      while(_loc6_ < _loc5_.length)
      {
         _loc4_.pushAt(_loc5_[_loc6_],nCategoryIndex = nCategoryIndex + 1);
         _loc6_ = _loc6_ + 1;
      }
      this._lstCategories.dataProvider = _loc4_;
   }
   function removeSubcategories()
   {
      var _loc2_ = this._lstCategories.dataProvider;
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      while(_loc3_ < _loc2_.length)
      {
         _loc4_ = _loc2_[_loc3_];
         if(_loc4_.isSubcategory)
         {
            _loc5_ = _loc3_ - 1;
            if(_loc5_ < 0)
            {
               break;
            }
            _loc6_ = _loc2_[_loc5_];
            _loc2_.removeItems(_loc3_,_loc6_.subCategories.length);
            break;
         }
         _loc3_ = _loc3_ + 1;
      }
      this._lstCategories.dataProvider = _loc2_;
   }
   function renderAchievementsList(aAchievements)
   {
      if(this._mcAchievements != undefined)
      {
         this._mcAchievements.removeMovieClip();
      }
      this._mcAchievements = this.createEmptyMovieClip("_mcAchievements",this.getNextHighestDepth());
      this._mcAchievements._x = this._mcPlacer._x;
      this._mcAchievements._y = this._mcPlacer._y;
      this._mcAchievements.setMask(this._mcPlacer);
      this._aAchievements = aAchievements;
      var _loc4_ = aAchievements.length;
      var _loc5_ = 0;
      var _loc6_;
      var _loc3_;
      while(_loc5_ < _loc4_)
      {
         _loc6_ = aAchievements[_loc5_];
         _loc3_ = this._mcAchievements.attachMovie("AchievementItem","Achievement_" + _loc6_.ID,this._mcAchievements.getNextHighestDepth(),{data:_loc6_});
         _loc3_._y = _loc5_ * _loc3_.height;
         _loc5_ = _loc5_ + 1;
      }
      if(_loc3_ != undefined)
      {
         dofus.graphics.gapi.ui.Achievements.SCROLL_BY = _loc3_._height / 2;
      }
      else
      {
         dofus.graphics.gapi.ui.Achievements.SCROLL_BY = 20;
      }
      this._sbScrollbar.scrollPosition = 0;
      this._lblNoAchievementsFound._visible = aAchievements.length == 0;
      this._nLastAchievementID = aAchievements[_loc4_ - 1].ID;
      this.updateAchievementsFooter();
      this._mcFooter._visible = !this._lblNoAchievementsFound._visible;
      this.refreshScrollbar(this._mcAchievements);
   }
   function refreshScrollbar(mc_)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if(mc_._height > this._mcPlacer._height)
      {
         this._sbScrollbar._visible = true;
         _loc3_ = this._sbScrollbar.scrollPosition;
         _loc4_ = 0;
         _loc5_ = mc_._height - this._mcPlacer._height;
         _loc6_ = _loc5_ * (this._mcPlacer._height / mc_._height);
         this._sbScrollbar.setScrollProperties(_loc6_,_loc4_,_loc5_);
         if(_loc3_ > _loc5_)
         {
            _loc3_ = _loc5_;
         }
         if(_loc3_ < _loc4_)
         {
            _loc3_ = _loc4_;
         }
         this._sbScrollbar.scrollPosition = _loc3_;
         this.scroll();
      }
      else
      {
         this._sbScrollbar._visible = false;
         this._sbScrollbar.scrollPosition = 0;
      }
   }
   function addObjectives(oAchievementItem)
   {
      var _loc3_ = oAchievementItem.data.objectivesCount - 1;
      var _loc4_ = oAchievementItem.data.objectives;
      var _loc5_;
      var _loc6_;
      for(var sID in _loc4_)
      {
         _loc5_ = _loc4_[sID];
         _loc6_ = oAchievementItem.attachMovie(this.getObjectiveComponent(_loc5_),"ObjectiveItem_" + _loc5_.ID,oAchievementItem.getNextHighestDepth(),{data:_loc5_});
         _loc6_._y = oAchievementItem.height + _loc3_ * _loc6_._height;
         _loc3_ = _loc3_ - 1;
      }
   }
   function addRewards(achievement)
   {
      var _loc3_ = achievement.attachMovie("AchievementItemRewards","AchievementItemRewards_" + achievement.data.ID,achievement.getNextHighestDepth(),{_y:achievement._height,data:achievement.data});
   }
   function shiftAchievementsBelow(nStartIndex, nOffset)
   {
      var _loc4_ = nStartIndex + 1;
      var _loc5_;
      var _loc6_;
      while(_loc4_ < this._aAchievements.length)
      {
         _loc5_ = this._aAchievements[_loc4_].ID;
         _loc6_ = dofus.graphics.gapi.ui.achievements.AchievementItem(this._mcAchievements["Achievement_" + _loc5_]);
         if(_loc6_ != undefined)
         {
            _loc6_._y += nOffset;
         }
         _loc4_ = _loc4_ + 1;
      }
   }
   function removeDetails(achievement)
   {
      for(var i in achievement)
      {
         if(typeof achievement[i] == "movieclip" && (i.indexOf("ObjectiveItem_") == 0 || i.indexOf("AchievementItemRewards_") == 0))
         {
            achievement[i].removeMovieClip();
         }
      }
   }
   function getObjectiveComponent(oAchievementObjective)
   {
      var _loc3_ = oAchievementObjective.parameters;
      var _loc4_ = oAchievementObjective.isCountType;
      var _loc5_ = oAchievementObjective.needsDetails;
      if(_loc4_)
      {
         if(_loc5_)
         {
            return "AchievementObjectiveProgressBarDetailsItem";
         }
         return "AchievementObjectiveProgressBarItem";
      }
      return "AchievementObjectiveCheckboxItem";
   }
   function displaySynthesisPage(bShow_)
   {
      this._mcSynthesis._visible = bShow_;
      this._mcAchievements._visible = !bShow_;
      this._sbScrollbar._visible = !bShow_;
      this._mcFooter._visible = !bShow_;
      if(bShow_)
      {
         this._lblNoAchievementsFound._visible = false;
      }
   }
   function focusAchievement(nAchievementID, bToggleAchievement, bLastRefresh)
   {
      var _loc5_ = this.api.lang.getAchievement(nAchievementID);
      if(nAchievementID == undefined || (_global.isNaN(nAchievementID) || _loc5_ == undefined))
      {
         this.selectCategory(dofus.graphics.gapi.ui.Achievements.SYNTHESIS_CATEGORY);
         return undefined;
      }
      var _loc6_ = "Achievement_" + nAchievementID;
      var _loc7_ = dofus.graphics.gapi.ui.achievements.AchievementItem(this._mcAchievements[_loc6_]);
      var _loc8_;
      if(_loc7_ == undefined)
      {
         if(bLastRefresh && this._btnHideCompletedAchievements.selected)
         {
            this._btnHideCompletedAchievements.selected = false;
            this.addToQueue({object:this,method:this.focusAchievement,params:[nAchievementID,bToggleAchievement,false]});
         }
         if(!bLastRefresh)
         {
            if(this._nCurrentParentID != -1)
            {
               this.removeSubcategories();
               this._nCurrentParentID = -1;
            }
            _loc8_ = this._nSelectedCategoryID;
            this.selectCategory(_loc5_.c);
            bLastRefresh = this._nSelectedCategoryID == _loc8_ && this._nSelectedCategoryID != undefined;
            this.addToQueue({object:this,method:this.focusAchievement,params:[nAchievementID,bToggleAchievement,bLastRefresh]});
         }
         return undefined;
      }
      if(bToggleAchievement && !_loc7_.isToggled)
      {
         this.toggleAchievementDetails(nAchievementID);
      }
      this.refreshScrollbar(this._mcAchievements);
      var _loc9_;
      if(this._sbScrollbar._visible)
      {
         _loc9_ = _loc7_._y;
         this._sbScrollbar.scrollPosition = Math.max(this._sbScrollbar.min,Math.min(this._sbScrollbar.max,_loc9_));
         this.scroll();
      }
   }
   function getAchievementIndexByID(nAchievementID)
   {
      var _loc3_ = 0;
      while(_loc3_ < this._aAchievements.length)
      {
         if(this._aAchievements[_loc3_].ID == nAchievementID)
         {
            return _loc3_;
         }
         _loc3_ = _loc3_ + 1;
      }
      return -1;
   }
   function refreshCategoriesProgress(aCategoriesID)
   {
      var _loc3_ = this._lstCategories.dataProvider;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = this._lstCategories.selectedIndex;
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      while(_loc5_ < _loc3_.length)
      {
         _loc6_ = _loc3_[_loc5_];
         _loc7_ = 0;
         while(_loc7_ < aCategoriesID.length)
         {
            if(_loc6_.ID == aCategoriesID[_loc7_])
            {
               _loc6_.refresh();
               break;
            }
            _loc7_ = _loc7_ + 1;
         }
         _loc5_ = _loc5_ + 1;
      }
      this._lstCategories.dataProvider = _loc3_;
      this._lstCategories.selectedIndex = _loc4_;
   }
   function clearAchievementsList()
   {
      if(this._mcAchievements != undefined)
      {
         this._mcAchievements.removeMovieClip();
      }
      this._lblNoAchievementsFound._visible = true;
      this._mcFooter._visible = false;
      this._aAchievements = [];
      this._sbScrollbar._visible = false;
      this._sbScrollbar.scrollPosition = 0;
      this._nSelectedCategoryID = undefined;
   }
   function searchAchievement(sText_)
   {
      var _loc3_ = 0;
      var _loc4_ = new ank.utils.ExtendedArray();
      sText_ = new ank.utils.ExtendedString(sText_).removeAccents().toUpperCase();
      var _loc5_ = this.api.lang.getAchievements();
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      for(var sID in _loc5_)
      {
         if(_loc3_ >= dofus.Constants.ACHIEVEMENT_SEARCH_MAX_RESULTS)
         {
            break;
         }
         _loc6_ = new ank.utils.ExtendedString(_loc5_[sID].n).removeAccents().toUpperCase();
         if(_loc6_.indexOf(sText_) != -1)
         {
            _loc4_.push(sID);
            _loc3_ = _loc3_ + 1;
         }
         else
         {
            _loc7_ = _loc5_[sID].o;
            if(_loc7_ != undefined)
            {
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length)
               {
                  _loc9_ = Number(_loc7_[_loc8_]);
                  _loc10_ = dofus.graphics.gapi.ui.Achievements.OBJECTIVE_SEARCH_CACHE[_loc9_];
                  if(_loc10_ == undefined)
                  {
                     _loc11_ = new dofus.datacenter.achievements.AchievementObjective(_loc9_);
                     _loc10_ = new ank.utils.ExtendedString(_loc11_.description).removeAccents().toUpperCase();
                     dofus.graphics.gapi.ui.Achievements.OBJECTIVE_SEARCH_CACHE[_loc9_] = _loc10_;
                  }
                  if(_loc10_.indexOf(sText_) != -1)
                  {
                     _loc4_.push(sID);
                     _loc3_ = _loc3_ + 1;
                     break;
                  }
                  _loc8_ = _loc8_ + 1;
               }
            }
         }
      }
      var _loc12_ = [];
      var _loc13_ = this._btnHideCompletedAchievements.selected;
      var _loc14_ = 0;
      var _loc15_;
      var _loc16_;
      while(_loc14_ < _loc4_.length)
      {
         _loc15_ = _loc4_[_loc14_];
         _loc16_ = this.api.datacenter.Player.Achievements.getOrInitAchievement(_loc15_);
         if(!_loc13_ || !_loc16_.isFinished)
         {
            _loc12_.unshift(_loc16_);
         }
         _loc14_ = _loc14_ + 1;
      }
      this.renderAchievementsList(_loc12_);
   }
   function closeOpenedParentIfNeeded(nSelectedCategoryID)
   {
      if(this._nCurrentParentID == -1)
      {
         return false;
      }
      var _loc3_ = this.getCategoryIndex({ID:nSelectedCategoryID});
      var _loc4_ = this._lstCategories.dataProvider[_loc3_];
      if(_loc4_ == undefined || _loc4_.isSubcategory)
      {
         return false;
      }
      if(this._nCurrentParentID == nSelectedCategoryID)
      {
         this.collapseCurrentParent();
         this.clearAchievementsList();
         return true;
      }
      this.collapseCurrentParent();
      _loc3_ = this.getCategoryIndex({ID:nSelectedCategoryID});
      this._lstCategories.selectedIndex = _loc3_;
      return false;
   }
   function openParentAndSelectSubcategory(nSelectedCategoryID, nIndex_)
   {
      var _loc4_ = this._lstCategories.dataProvider;
      var _loc5_ = nIndex_ != -1 ? undefined : nSelectedCategoryID;
      var _loc6_;
      if(nIndex_ == -1)
      {
         _loc6_ = this.api.lang.getAchievementCategory(nSelectedCategoryID).p;
         nIndex_ = this.getCategoryIndex({ID:_loc6_});
         if(nIndex_ == -1)
         {
            return undefined;
         }
      }
      var _loc7_ = _loc4_[nIndex_];
      this._nCurrentParentID = _loc7_.ID;
      this.addSubcategories(_loc7_,nIndex_);
      var _loc8_;
      if(_loc5_ != undefined)
      {
         _loc8_ = this.getCategoryIndex({ID:_loc5_});
         if(_loc8_ != -1)
         {
            this._lstCategories.scrollToAndSelectIndex(_loc8_);
            return _loc5_;
         }
      }
      _loc7_ = _loc4_[nIndex_ + 1];
      var _loc9_ = _loc7_.ID;
      this._lstCategories.selectedIndex = nIndex_ + 1;
      return _loc9_;
   }
   function collapseCurrentParent()
   {
      if(this._nCurrentParentID == -1)
      {
         return undefined;
      }
      var _loc2_ = this.getCategoryIndex({ID:this._nCurrentParentID});
      this.removeSubcategories();
      this._nCurrentParentID = -1;
      this._lstCategories.refreshRowByIndex(_loc2_);
   }
   function refreshAchievementListByCategory(nCategoryID_)
   {
      var _loc3_ = this.api.datacenter.Player.Achievements.getAchievementsByCategory(nCategoryID_,this._btnHideCompletedAchievements.selected);
      this.renderAchievementsList(_loc3_);
   }
   function updateAchievementsFooter()
   {
      var _loc2_ = dofus.graphics.gapi.ui.achievements.AchievementItem(this._mcAchievements["Achievement_" + this._nLastAchievementID]);
      var _loc3_ = false;
      if(_loc2_ != undefined)
      {
         _loc3_ = _loc2_.isToggled;
      }
      if(_loc3_)
      {
         this._mcFooter._width = this._mcPlacer._width - 8;
         this._mcFooter._x = this._mcPlacer._x + 8;
      }
      else
      {
         this._mcFooter._width = this._mcPlacer._width;
         this._mcFooter._x = this._mcPlacer._x;
      }
      this._mcFooter._y = this._mcPlacer._y + this._mcAchievements._height;
   }
   function toggleAchievementDetails(nAchievementID)
   {
      var _loc3_ = dofus.graphics.gapi.ui.achievements.AchievementItem(this._mcAchievements["Achievement_" + nAchievementID]);
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = this.getAchievementIndexByID(nAchievementID);
      if(_loc4_ == -1)
      {
         return undefined;
      }
      var _loc5_ = _loc3_.height;
      _loc3_.isToggled = !_loc3_.isToggled;
      if(_loc3_.isToggled)
      {
         this.addObjectives(_loc3_);
         this.addRewards(_loc3_);
         this.shiftAchievementsBelow(_loc4_,_loc3_._height - _loc5_);
      }
      else
      {
         this.shiftAchievementsBelow(_loc4_,- (_loc3_._height - _loc5_));
         this.removeDetails(_loc3_);
      }
      this.updateAchievementsFooter();
      this.refreshScrollbar(this._mcAchievements);
   }
   function selectCategory(nSelectedCategoryID)
   {
      var _loc3_ = this.getCategoryIndex({ID:nSelectedCategoryID});
      if(this._lstCategories.selectedIndex == -1 && _loc3_ != -1)
      {
         this._lstCategories.selectedIndex = _loc3_;
      }
      var _loc4_ = nSelectedCategoryID == dofus.graphics.gapi.ui.Achievements.SYNTHESIS_CATEGORY;
      this.displaySynthesisPage(_loc4_);
      if(_loc4_)
      {
         this.collapseCurrentParent();
         this._nSelectedCategoryID = dofus.graphics.gapi.ui.Achievements.SYNTHESIS_CATEGORY;
         this._lstCategories.selectedIndex = _loc3_;
         this._mcAchievements.removeMovieClip();
         return undefined;
      }
      if(this.closeOpenedParentIfNeeded(nSelectedCategoryID))
      {
         return undefined;
      }
      _loc3_ = this.getCategoryIndex({ID:nSelectedCategoryID});
      var _loc5_ = this._lstCategories.dataProvider;
      var _loc6_ = _loc3_ == -1 ? undefined : _loc5_[_loc3_];
      var _loc7_;
      if(_loc3_ == -1 || _loc6_.hasSubcategories)
      {
         _loc7_ = this.openParentAndSelectSubcategory(nSelectedCategoryID,_loc3_);
         if(_loc7_ == undefined)
         {
            return undefined;
         }
         nSelectedCategoryID = _loc7_;
      }
      this.resetSearch(false);
      this._nSelectedCategoryID = nSelectedCategoryID;
      this.refreshAchievementListByCategory(nSelectedCategoryID);
   }
   function createActionPopupMenu(oItem_)
   {
      var _loc3_ = this.api.ui.createPopupMenu();
      _loc3_.addStaticItem(oItem_.name);
      _loc3_.addItem(this.api.lang.getText("CLICK_TO_INSERT"),this.api.kernel.GameManager,this.api.kernel.GameManager.insertAchievementInChat,[oItem_]);
      _loc3_.show(_root._xmouse,_root._ymouse);
   }
   function click(oEvent_)
   {
      switch(oEvent_.target)
      {
         case this._btnClose:
            this.callClose();
            break;
         case this._btnReset:
            if(this._sCurrentAchievementSearch != "")
            {
               this.resetSearch(true);
            }
            break;
         case this._btnHideCompletedAchievements:
            if(this._sCurrentAchievementSearch != "")
            {
               this.searchAchievement(this._sCurrentAchievementSearch);
            }
            else if(this._nSelectedCategoryID != undefined && this._nSelectedCategoryID != dofus.graphics.gapi.ui.Achievements.SYNTHESIS_CATEGORY)
            {
               this.refreshAchievementListByCategory(this._nSelectedCategoryID);
            }
         default:
            return;
      }
   }
   function over(oEvent_)
   {
      switch(oEvent_.target)
      {
         case this._btnHideCompletedAchievements:
            this.api.ui.showTooltip(this.api.lang.getText("ACHIEVEMENTS_HIDE_COMPLETED"));
            break;
         case this._btnReset:
            this.api.ui.showTooltip(this.api.lang.getText("RESET_SEARCH"));
         default:
            return;
      }
   }
   function out(oEvent_)
   {
      this.api.ui.hideTooltip();
   }
   function itemSelected(oEvent_)
   {
      var _loc0_;
      if((_loc0_ = oEvent_.target) === this._lstCategories)
      {
         this.selectCategory(oEvent_.row.item.ID);
      }
   }
   function scroll(oEvent_)
   {
      var _loc3_ = !this._mcSynthesis._visible ? this._mcAchievements : this._mcSynthesis;
      _loc3_._y = this._mcPlacer._y - this._sbScrollbar.scrollPosition;
   }
   function onMouseWheel(nDelta, mc_)
   {
      if(dofus.graphics.gapi.ui.Zoom.isZooming())
      {
         return undefined;
      }
      if(this._sbScrollbar._visible && (String(mc_._target).indexOf(this._mcAchievements._name) != -1 || String(mc_._target).indexOf(this._sbScrollbar._name) != -1))
      {
         this._sbScrollbar.scrollPosition -= nDelta <= 0 ? - dofus.graphics.gapi.ui.Achievements.SCROLL_BY : dofus.graphics.gapi.ui.Achievements.SCROLL_BY;
      }
   }
   function achievementCompleted(oEvent_)
   {
      var _loc3_ = [oEvent_.categoryID];
      if(oEvent_.parentCategoryID != -1 && oEvent_.parentCategoryID != undefined)
      {
         _loc3_.push(oEvent_.parentCategoryID);
      }
      this.refreshCategoriesProgress(_loc3_);
   }
   function change(oEvent_)
   {
      var _loc3_ = this._tiSearch.text;
      if(_loc3_ == this._sCurrentAchievementSearch)
      {
         return undefined;
      }
      this._sCurrentAchievementSearch = _loc3_;
      if(this._nSearchInterval != undefined)
      {
         _global.clearInterval(this._nSearchInterval);
         this._nSearchInterval = undefined;
      }
      if(_loc3_.length < dofus.Constants.ACHIEVEMENT_SEARCH_MIN_CHARACTERS)
      {
         this.selectCategory(dofus.graphics.gapi.ui.Achievements.SYNTHESIS_CATEGORY);
         return undefined;
      }
      var self = this;
      this._nSearchInterval = _global.setInterval(function()
      {
         _global.clearInterval(self._nSearchInterval);
         self._nSearchInterval = undefined;
         self.displaySynthesisPage(false);
         self.searchAchievement(self._sCurrentAchievementSearch);
         self._lstCategories.selectedIndex = -1;
      }
      ,300);
   }
}
