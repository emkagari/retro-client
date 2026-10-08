class ank.gapi.Gapi extends ank.utils.QueueEmbedMovieClip
{
   var _eaUIComponentsInstances;
   var _mcLayer_Cursor;
   var _mcLayer_Popup;
   var _mcLayer_UI;
   var _mcLayer_UI_Top;
   var _mcLayer_UI_Ultimate;
   var _nLastSetCursorTimer;
   var _nScreenHeight;
   var _nScreenWidth;
   var _oAPI;
   var _oUIComponentsList;
   var _sComponentHiddingSprites;
   var _sLastAutoHideComponent;
   var createEmptyMovieClip;
   var dispatchEvent;
   var nPopupMenuCnt;
   var pmPopupMenu;
   static var MAX_DELAY_CURSOR_SPELLS = 250;
   static var CURSOR_MAX_SIZE = 40;
   static var CURSOR_CENTER = [-20,-20];
   static var DBLCLICK_DELAY = 250;
   var _oDragClipsList = null;
   var _oCursorData = null;
   var _oCursorAligment = null;
   function Gapi()
   {
      super();
      this.initialize();
   }
   function get currentPopupMenu()
   {
      return this.pmPopupMenu;
   }
   function get uiComponents()
   {
      return this._eaUIComponentsInstances;
   }
   function set api(oAPI)
   {
      this._oAPI = oAPI;
   }
   function get api()
   {
      return this._oAPI;
   }
   function get screenWidth()
   {
      return this._nScreenWidth != undefined ? this._nScreenWidth : Stage.width;
   }
   function get screenHeight()
   {
      return this._nScreenHeight != undefined ? this._nScreenHeight : Stage.height;
   }
   function set isComponentHiddingSprites(Void)
   {
      this._sComponentHiddingSprites = undefined;
   }
   function get isComponentHiddingSprites()
   {
      return this._sComponentHiddingSprites != undefined;
   }
   function get lastOpenedComponent()
   {
      var _loc2_ = this._eaUIComponentsInstances.length - 1;
      return this.getUIComponent(this._eaUIComponentsInstances[_loc2_].name);
   }
   function clear()
   {
      this.createEmptyMovieClip("_mcLayer_UI",10).cacheAsBitmap = _global.CONFIG.cacheAsBitmap["GAPI/UI"];
      this.createEmptyMovieClip("_mcLayer_UI_Top",20).cacheAsBitmap = _global.CONFIG.cacheAsBitmap["GAPI/UITop"];
      this.createEmptyMovieClip("_mcLayer_UI_Ultimate",30).cacheAsBitmap = _global.CONFIG.cacheAsBitmap["GAPI/UIUltimate"];
      this.createEmptyMovieClip("_mcLayer_Popup",40).cacheAsBitmap = _global.CONFIG.cacheAsBitmap["GAPI/Popup"];
      this.createEmptyMovieClip("_mcLayer_Cursor",50).cacheAsBitmap = _global.CONFIG.cacheAsBitmap["GAPI/Cursor"];
      this._oUIComponentsList = {};
      this._eaUIComponentsInstances = new ank.utils.ExtendedArray();
   }
   function setScreenSize(nWidth, nHeight)
   {
      this._nScreenWidth = nWidth;
      this._nScreenHeight = nHeight;
   }
   function createPopupMenu(sStyleName, bAdminPopupMenu)
   {
      if(bAdminPopupMenu == undefined)
      {
         bAdminPopupMenu = false;
      }
      var _loc4_ = this.pmPopupMenu;
      if(sStyleName == undefined)
      {
         sStyleName = "BrownPopupMenu";
      }
      if(this.nPopupMenuCnt == undefined)
      {
         this.nPopupMenuCnt = 0;
      }
      var _loc5_ = this.nPopupMenuCnt++;
      this.pmPopupMenu = ank.gapi.controls.PopupMenu(this._mcLayer_Popup.attachMovie("PopupMenu","_mcPopupMenu" + _loc5_,_loc5_,{styleName:sStyleName,gapi:this}));
      _loc4_.removeMovieClip();
      this.pmPopupMenu.adminPopupMenu = bAdminPopupMenu;
      return this.pmPopupMenu;
   }
   function removePopupMenu()
   {
      this.pmPopupMenu.removeMovieClip();
   }
   function showTooltip(sText_, sStyleName)
   {
      if(sText_ == undefined)
      {
         return undefined;
      }
      var _loc4_;
      if(this._mcLayer_Popup._mcToolTip != undefined)
      {
         _loc4_ = this._mcLayer_Popup._mcToolTip;
         _loc4_.text = sText_;
      }
      else
      {
         this._mcLayer_Popup.attachMovie("ToolTip","_mcToolTip",this._mcLayer_Popup.getNextHighestDepth(),{text:sText_,gapi:this,styleName:sStyleName});
      }
   }
   function hideTooltip()
   {
      this._mcLayer_Popup._mcToolTip.removeMovieClip();
   }
   function onContentLoaded(oEvent)
   {
      var _loc3_ = oEvent.content;
      _loc3_.applyColors();
   }
   function setCursor(oData, oAlignment, bSpellCursor)
   {
      if(bSpellCursor == undefined)
      {
         bSpellCursor = false;
      }
      this._nLastSetCursorTimer = getTimer();
      this.removeCursor();
      if(oAlignment == undefined)
      {
         oAlignment = {};
      }
      oAlignment.width = oAlignment.width == undefined ? ank.gapi.Gapi.CURSOR_MAX_SIZE : oAlignment.width;
      oAlignment.height = oAlignment.height == undefined ? ank.gapi.Gapi.CURSOR_MAX_SIZE : oAlignment.height;
      oAlignment.x = oAlignment.x == undefined ? ank.gapi.Gapi.CURSOR_CENTER[0] : oAlignment.x;
      oAlignment.y = oAlignment.y == undefined ? ank.gapi.Gapi.CURSOR_CENTER[1] : oAlignment.y;
      var _loc5_ = ank.gapi.controls.Container(this._mcLayer_Cursor.attachMovie("Container","cursor1",10));
      if(bSpellCursor)
      {
         _loc5_.addEventListener("onContentLoaded",this);
      }
      _loc5_.setSize(oAlignment.width,oAlignment.height);
      _loc5_.move(oAlignment.x,oAlignment.y);
      _loc5_.contentData = oData;
      this._oCursorAligment = oAlignment;
      this._oCursorData = oData;
      this._mcLayer_Cursor.startDrag(true);
   }
   function setCursorForbidden(bForbidden, sCursorFile)
   {
      if(this.isCursorHidden())
      {
         return undefined;
      }
      if(bForbidden == undefined)
      {
         bForbidden = false;
      }
      var _loc4_;
      if(bForbidden)
      {
         if(this._mcLayer_Cursor.mcForbidden == undefined)
         {
            _loc4_ = this._mcLayer_Cursor.attachMovie("GAPILoader","mcForbidden",20,{scaleContent:true});
            _loc4_.setSize(this._oCursorAligment.width,this._oCursorAligment.height);
            _loc4_.move(this._oCursorAligment.x,this._oCursorAligment.y);
            _loc4_.contentPath = sCursorFile;
         }
      }
      else
      {
         this._mcLayer_Cursor.mcForbidden.removeMovieClip();
      }
   }
   function getCursor()
   {
      return this._oCursorData;
   }
   function isCursorHidden()
   {
      return this._mcLayer_Cursor.cursor1 == undefined;
   }
   function removeCursor(bDispatchEvent)
   {
      this.hideCursor(bDispatchEvent);
      if(this._oCursorData == undefined)
      {
         return false;
      }
      delete this._oCursorData;
      return true;
   }
   function hideCursor(bDispatchEvent)
   {
      this.setCursorForbidden(false);
      this._mcLayer_Cursor.stopDrag();
      this._mcLayer_Cursor.cursor1.removeMovieClip();
      if(bDispatchEvent == true)
      {
         this.dispatchEvent({type:"removeCursor"});
      }
   }
   function unloadLastUIAutoHideComponent()
   {
      return this.unloadUIComponent(this._sLastAutoHideComponent);
   }
   function loadUIAutoHideComponent(sLink, sInstanceName, oComponentParams, oUIParams)
   {
      if(this._sLastAutoHideComponent != sLink)
      {
         this.unloadUIComponent(this._sLastAutoHideComponent);
      }
      this._sLastAutoHideComponent = sLink;
      return this.loadUIComponent(sLink,sInstanceName,oComponentParams,oUIParams);
   }
   function loadUIComponent(sLink, sInstanceName, oComponentParams, oUIParams)
   {
      var _loc6_;
      if(oUIParams.bForceLoad == undefined)
      {
         _loc6_ = false;
      }
      else
      {
         _loc6_ = oUIParams.bForceLoad;
      }
      var _loc7_;
      if(oUIParams.bStayIfPresent == undefined)
      {
         _loc7_ = false;
      }
      else
      {
         _loc7_ = oUIParams.bStayIfPresent;
      }
      var _loc8_;
      if(oUIParams.bAlwaysOnTop == undefined)
      {
         _loc8_ = false;
      }
      else
      {
         _loc8_ = oUIParams.bAlwaysOnTop;
      }
      var _loc9_;
      if(oUIParams.bUltimateOnTop == undefined)
      {
         _loc9_ = false;
      }
      else
      {
         _loc9_ = oUIParams.bUltimateOnTop;
      }
      if(oUIParams.nHideSprites != undefined && (this.api.kernel.OptionsManager.getOption("HideSpritesUIFullscreen") && this._sComponentHiddingSprites == undefined))
      {
         this.api.gfx.spriteHandler.hideSprites(true,oUIParams.nHideSprites);
         this._sComponentHiddingSprites = sInstanceName;
      }
      if(dofus.Constants.TRIPLEFRAMERATE)
      {
         switch(sLink)
         {
            case "AutomaticServer":
            case "BigStoreBuy":
            case "JoinFriend":
            case "StringCourse":
            case "Waiting":
            case "AskGameBegin":
            case "Inventory":
            case "ChooseReward":
            case "CardsUpgrader":
            case "SpellUnwrap":
            case "SpellsCollection":
            case "GladiatroolShop":
               sLink += "_TripleFramerate";
         }
      }
      if(sLink.substring(0,3) == "Ask")
      {
         _loc9_ = true;
      }
      var _loc11_;
      if(this._oUIComponentsList[sInstanceName] != undefined)
      {
         if(_loc7_)
         {
            _loc11_ = this._oUIComponentsList[sInstanceName];
            for(var k in oComponentParams)
            {
               _loc11_[k] = oComponentParams[k];
            }
            return null;
         }
         this.unloadUIComponent(sInstanceName);
         if(!_loc6_)
         {
            return null;
         }
      }
      if(oComponentParams == undefined)
      {
         oComponentParams = {};
      }
      oComponentParams.api = this._oAPI;
      oComponentParams.gapi = this;
      oComponentParams.instanceName = sInstanceName;
      var _loc12_;
      if(_loc8_)
      {
         _loc12_ = this._mcLayer_UI_Top;
      }
      else if(_loc9_)
      {
         _loc12_ = this._mcLayer_UI_Ultimate;
      }
      else
      {
         _loc12_ = this._mcLayer_UI;
      }
      var _loc13_;
      switch(sInstanceName)
      {
         case "Banner":
            _loc13_ = 9;
            break;
         case "Debug":
            _loc13_ = 10;
            break;
         default:
            _loc13_ = _loc12_.getNextHighestDepth();
      }
      var _loc14_ = _loc12_.attachMovie("UI_" + sLink,sInstanceName,_loc13_,oComponentParams);
      this._oUIComponentsList[sInstanceName] = _loc14_;
      this._eaUIComponentsInstances.push({name:sInstanceName});
      return _loc14_;
   }
   function unloadUIComponent(sInstanceName)
   {
      var _loc3_ = this.getUIComponent(sInstanceName);
      delete this._oUIComponentsList[sInstanceName];
      var _loc4_ = this._eaUIComponentsInstances.findFirstItem("name",sInstanceName);
      if(_loc4_.index != -1)
      {
         this._eaUIComponentsInstances.removeItems(_loc4_.index,1);
      }
      if(_loc3_ == undefined)
      {
         return false;
      }
      _loc3_.destroy();
      if(sInstanceName == this._sComponentHiddingSprites)
      {
         this.api.gfx.spriteHandler.hideSprites(false);
         this._sComponentHiddingSprites = undefined;
      }
      Key.removeListener(_loc3_);
      this.api.kernel.KeyManager.removeShortcutsListener(_loc3_);
      this.api.kernel.KeyManager.removeKeysListener(_loc3_);
      ank.utils.MouseEvents.garbageCollector();
      _loc3_.removeMovieClip();
      return true;
   }
   function getUIComponent(sInstanceName)
   {
      var _loc3_ = this._mcLayer_UI[sInstanceName];
      if(_loc3_ == undefined)
      {
         _loc3_ = this._mcLayer_UI_Top[sInstanceName];
      }
      if(_loc3_ == undefined)
      {
         _loc3_ = this._mcLayer_UI_Ultimate[sInstanceName];
      }
      if(_loc3_ == undefined)
      {
         return null;
      }
      return _loc3_;
   }
   function callCloseOnLastUI(nIndex)
   {
      if(nIndex == undefined)
      {
         nIndex = this._eaUIComponentsInstances.length - 1;
      }
      if(nIndex < 0)
      {
         return false;
      }
      if(_global.isNaN(nIndex))
      {
         return false;
      }
      var _loc3_ = this.getUIComponent(this._eaUIComponentsInstances[nIndex].name);
      if(_loc3_.callClose() == true)
      {
         return true;
      }
      return this.callCloseOnLastUI(nIndex - 1);
   }
   function initialize()
   {
      this.clear();
      ank.gapi.styles.StylesManager.loadStylePackage(ank.gapi.styles.DefaultStylePackage);
      mx.events.EventDispatcher.initialize(this);
   }
   function addDragClip()
   {
   }
   function removeDragClip()
   {
   }
   function onMouseUp()
   {
      if(this._oCursorData == undefined)
      {
         return undefined;
      }
      var _loc2_ = getTimer() - this._nLastSetCursorTimer;
      if(_global.isNaN(_loc2_))
      {
         return undefined;
      }
      if(this._oCursorData instanceof dofus.datacenter.Spell && _loc2_ < ank.gapi.Gapi.MAX_DELAY_CURSOR_SPELLS)
      {
         return undefined;
      }
      if(this.api.datacenter.Player.currentUseObject != null && this.api.datacenter.Basics.gfx_canLaunch)
      {
         return undefined;
      }
      this.hideCursor(true);
   }
}
