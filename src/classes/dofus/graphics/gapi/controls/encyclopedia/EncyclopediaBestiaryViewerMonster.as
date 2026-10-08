676219726 - 1;
class dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewerMonster extends ank.gapi.core.UIBasicComponent
{
   var _bUsed;
   var _lblCategory;
   var _lblLevel;
   var _lblName;
   var _ldrIcon;
   var _mcEncyclopedia;
   var _mcList;
   var _oItem;
   var addToQueue;
   var api;
   static var MAX_ITEMS_SHOW = 4;
   static var RARE_BORDER = {ra:0,rb:220,ga:0,gb:220,ba:0,bb:220,ab:255};
   static var VERY_RARE_BORDER = {ra:0,rb:255,ga:0,gb:210,ba:0,bb:0,ab:255};
   static var DEFAULT_BORDER = {ra:100,rb:0,ga:100,gb:0,ba:100,bb:0,ab:0};
   static var QUEST_BACKGROUND = {ra:50,rb:0,ga:100,gb:0,ba:50,bb:0};
   static var IMPOSSIBLE_BACKGROUND = {ra:100,rb:0,ga:50,gb:0,ba:50,bb:0};
   var _bLevelLabelMoved = false;
   var _aCtrs = ["_ctr0","_ctr1","_ctr2","_ctr3"];
   function EncyclopediaBestiaryViewerMonster()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem_)
   {
      var _loc5_;
      if(bUsed)
      {
         this._oItem = oItem_;
         this._lblName.text = oItem_.name;
         this._ldrIcon.contentPath = dofus.Constants.ARTWORKS_BIG_PATH + oItem_.gfxID + ".swf";
         this._lblCategory.text = oItem_.categoryName;
         this._lblLevel.text = oItem_.level;
         _loc5_ = this._lblLevel.textHeight > 20;
         if(_loc5_ != this._bLevelLabelMoved)
         {
            this._lblLevel._y += !_loc5_ ? 6 : -6;
            this._bLevelLabelMoved = _loc5_;
         }
         this.layoutCtrContent();
      }
      else if(this._lblName.text != undefined)
      {
         this._lblName.text = "";
         this._ldrIcon.contentPath = "";
         this._lblCategory.text = "";
         this._lblLevel.text = "";
         this.setCtrVisible(false);
      }
      this._bUsed = bUsed;
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.api = _global.API;
      this.setCtrVisible(false);
      this._mcEncyclopedia = this.api.ui.getUIComponent("Encyclopedia");
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._ldrIcon.addEventListener("initialization",this);
      this._ldrIcon.addEventListener("complete",this);
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < this._aCtrs.length)
      {
         _loc3_ = this[this._aCtrs[_loc2_]];
         _loc3_.addEventListener("click",this);
         _loc3_.addEventListener("over",this);
         _loc3_.addEventListener("out",this);
         _loc2_ = _loc2_ + 1;
      }
      this.api.datacenter.Player.addEventListener("updatePartyProspection",this);
      this.api.datacenter.Player.addEventListener("discernmentChanged",this);
   }
   function applyColor(mc_, nZone)
   {
      var _loc4_ = this._oItem.colors["c" + nZone];
      if(_loc4_ == -1 || _loc4_ == undefined)
      {
         return undefined;
      }
      var _loc5_ = (_loc4_ & 0xFF0000) >> 16;
      var _loc6_ = (_loc4_ & 0xFF00) >> 8;
      var _loc7_ = _loc4_ & 0xFF;
      var _loc8_ = new Color(mc_);
      var _loc9_ = {};
      _loc9_ = {ra:0,ga:0,ba:0,rb:_loc5_,gb:_loc6_,bb:_loc7_};
      _loc8_.setTransform(_loc9_);
   }
   function layoutCtrContent()
   {
      var _loc2_ = this._oItem.id;
      var _loc3_ = this._oItem.loot;
      var _loc4_ = 0;
      var _loc5_ = this._aCtrs.length;
      this.setCtrVisible(false);
      var _loc6_;
      var _loc7_;
      for(var k in _loc3_)
      {
         _loc6_ = Number(k);
         if(dofus.datacenter.ItemDrop.isEnabled(_loc2_,_loc6_))
         {
            _loc7_ = this[this._aCtrs[_loc4_]];
            _loc7_._visible = !_global.isNaN(_loc6_);
            if(_loc7_._visible)
            {
               _loc7_.contentData = new dofus.datacenter.ItemDrop(_loc2_,1,_loc6_,1,String(this.api.lang.getItemStats(_loc6_)));
               this.updateCtrBorder(_loc7_);
               _loc4_ = _loc4_ + 1;
            }
         }
      }
   }
   function updateCtrBorder(ctr)
   {
      var _loc3_ = dofus.datacenter.ItemDrop(ctr.contentData);
      var _loc4_ = _loc3_.getDropRate(false);
      if(_loc4_ < dofus.datacenter.ItemDrop.VERY_RARE_VALUE)
      {
         ctr.borderTransform = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewerMonster.VERY_RARE_BORDER;
      }
      else if(_loc4_ <= dofus.datacenter.ItemDrop.RARE_VALUE && _loc4_ != undefined)
      {
         ctr.borderTransform = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewerMonster.RARE_BORDER;
      }
      else
      {
         ctr.borderTransform = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewerMonster.DEFAULT_BORDER;
      }
      var _loc5_ = "";
      var _loc6_ = this.api.datacenter.Player.totalPartyProspection;
      if(_loc6_ < _loc3_.minimumProspection)
      {
         ctr.backgroundTransform = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewerMonster.IMPOSSIBLE_BACKGROUND;
      }
      else if(_loc3_.isQuest)
      {
         ctr.backgroundTransform = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewerMonster.QUEST_BACKGROUND;
         _loc5_ = "QuestBook";
      }
      else
      {
         ctr.backgroundTransform = dofus.Constants.NO_TRANSFORM;
      }
      if(_loc3_.hasDropConditions)
      {
         _loc5_ = "ExclamationBlue";
      }
      ctr.cornerIcon = _loc5_;
   }
   function setCtrVisible(bVisible)
   {
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewerMonster.MAX_ITEMS_SHOW)
      {
         _loc4_ = this[this._aCtrs[_loc3_]];
         _loc4_._visible = bVisible;
         _loc3_ = _loc3_ + 1;
      }
   }
   function click(oEvent_)
   {
      var _loc0_;
      §§push(_loc0_ = oEvent_.target);
      var _loc3_ = oEvent_.target.contentData;
      var _loc4_;
      var _loc5_;
      if(_loc3_ != undefined)
      {
         if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY))
         {
            this.api.kernel.GameManager.insertItemInChat(_loc3_);
         }
         else
         {
            _loc4_ = {id:_loc3_.unicID,effects:_loc3_.compressedEffects};
            _loc5_ = !_loc3_.isConsideredAsEquipementInEncyclopediaDetailWindow ? "Ressources" : "Equipments";
            this.api.ui.loadUIComponent("EncyclopediaDetailsWindow","EncyclopediaDetailsWindow",{component:_loc5_,data:_loc4_},{bStayIfPresent:true,bAlwaysOnTop:true});
         }
      }
      §§pop();
   }
   function initialization(oEvent_)
   {
      var _loc3_ = oEvent_.target;
      var _loc4_ = _loc3_.content;
      var _loc5_;
      if(_loc3_ == this._ldrIcon)
      {
         _loc5_ = _loc4_._mcMask;
         _loc4_._x = - _loc5_._x;
         _loc4_._y = - _loc5_._y;
         this._ldrIcon._xscale = 10000 / _loc5_._xscale;
         this._ldrIcon._yscale = 10000 / _loc5_._yscale;
      }
   }
   function complete(oEvent_)
   {
      var ref = this;
      this._ldrIcon.content.stringCourseColor = function(mc_, nColorIndex)
      {
         ref.applyColor(mc_,nColorIndex);
      };
   }
   function updatePartyProspection(oEvent_)
   {
      if(this._bUsed)
      {
         this.layoutCtrContent();
      }
   }
   function discernmentChanged(oEvent_)
   {
      if(this._bUsed)
      {
         this.layoutCtrContent();
      }
   }
   function over(oEvent_)
   {
      var _loc0_;
      §§push(_loc0_ = oEvent_.target);
      var _loc3_ = oEvent_.target.contentData;
      var _loc4_;
      if(_loc3_ != undefined)
      {
         _loc4_ = dofus.datacenter.ItemDrop(_loc3_);
         _loc4_.showStatsTooltip(_loc4_.style,_loc4_.getDropInfosString());
         this._mcEncyclopedia.currentOverItem = _loc4_;
      }
      else if(dofus.Constants.DEBUG)
      {
         this.api.ui.showTooltip("GFX : " + this._oItem.gfxID);
      }
      §§pop();
   }
   function out(oEvent_)
   {
      this._mcEncyclopedia.currentOverItem = undefined;
      this.api.ui.hideTooltip();
   }
}
