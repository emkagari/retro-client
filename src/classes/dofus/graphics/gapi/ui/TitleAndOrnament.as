656506150 - 1;
class dofus.graphics.gapi.ui.TitleAndOrnament extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnReset;
   var _btnSave;
   var _btnShowWings;
   var _lblShowWings;
   var _lblTitle;
   var _lstTitle;
   var _mcPreview;
   var _nSelectedId;
   var _previewCenter;
   var _sCurrentEntityNameSearch;
   var _svCharacterViewer;
   var _tiSearch;
   var _winBg;
   var addToQueue;
   var createEmptyMovieClip;
   var drawRoundRect;
   var gapi;
   var getNextHighestDepth;
   var unloadThis;
   static var BACKGROUND_ALPHA = 70;
   static var BACKGROUND_COLOR = 0;
   static var TEXT_SMALL_FORMAT = new TextFormat("Verdana",10,16777215,false,false,false,null,null,"left");
   static var TEXT_SMALL_FORMAT2 = new TextFormat("Verdana",9,16777215,false,false,false,null,null,"left");
   static var TEXT_FORMAT2 = new TextFormat("Verdana",9,16777215,false,false,false,null,null,"center");
   static var TEXT_FORMAT = new TextFormat("Verdana",10,16777215,true,false,false,null,null,"center");
   static var CORNER_RADIUS = 0;
   static var WIDTH_SPACER = 4;
   static var HEIGHT_SPACER = 4;
   static var TEXT_HEIGHT = 16;
   static var EMBLEM_WIDTH = 30;
   static var CLASS_NAME = "TitleAndOrnament";
   function TitleAndOrnament()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.TitleAndOrnament.CLASS_NAME);
   }
   function destroy()
   {
      this.gapi.hideTooltip();
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function initTexts()
   {
      this._winBg.title = this.api.lang.getText("TITLES");
      this._lblTitle.text = this.api.lang.getText("TITLES");
      this._lblShowWings.text = this.api.lang.getText("WINGS_IN_PREVIEW");
      this._btnSave.label = this.api.lang.getText("SAVE");
      this._btnReset.label = this.api.lang.getText("REINIT_WORD");
      this._tiSearch.placeholder = this.api.lang.getText("SEARCH");
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnShowWings.addEventListener("click",this);
      this._btnSave.addEventListener("click",this);
      this._btnReset.addEventListener("click",this);
      this._lstTitle.addEventListener("itemSelected",this);
      this.api.datacenter.NameCustomization.addEventListener("updateData",this);
      this._tiSearch.addEventListener("change",this);
   }
   function initData()
   {
      this._sCurrentEntityNameSearch = "";
      this._btnShowWings.enabled = !this.api.datacenter.Player._nCriticalHitBonus ? this.api.datacenter.Player.alignment.index > 0 : this.api.datacenter.Player.fakeAlignment.index > 0;
      this._btnShowWings.selected = this.api.datacenter.Player.rank.enable;
      this.refreshSpriteViewer();
      this.api.network.NameCustomization.getTitles();
   }
   function get selectedIndex()
   {
      var _loc2_ = 0;
      while(_loc2_ < this._lstTitle.dataProvider.length)
      {
         if(this._lstTitle.dataProvider[_loc2_].id == this._nSelectedId)
         {
            return _loc2_;
         }
         _loc2_ = _loc2_ + 1;
      }
      return -1;
   }
   function get selectedTitle()
   {
      return this._lstTitle.dataProvider[this.selectedIndex];
   }
   function updateData()
   {
      this._nSelectedId = this.api.datacenter.NameCustomization.selectedId;
      this.updateTitleList();
      this.drawPreview();
   }
   function updateTitleList()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = this.api.datacenter.NameCustomization.titles;
      var _loc4_;
      for(var i in _loc3_)
      {
         _loc4_ = _loc3_[i];
         if(!(this._sCurrentEntityNameSearch.length >= 2 && !ank.utils.ExtendedString.searchWordsInName(this._sCurrentEntityNameSearch.split(" "),_loc4_.text.toUpperCase())))
         {
            _loc2_.push(_loc3_[i]);
         }
      }
      var _loc5_ = function(a_, b_)
      {
         return ank.utils.ExtendedString.compare(a_.text,b_.text);
      };
      _loc2_.sort(_loc5_);
      _loc2_.unshift({id:-1,text:this.api.lang.getText("NONE")});
      this._lstTitle.dataProvider = _loc2_;
      this._lstTitle.selectedIndex = this.selectedIndex;
   }
   function refreshSpriteViewer()
   {
      var _loc2_ = ank.battlefield.datacenter.Sprite(this.api.datacenter.Player.data);
      if(_loc2_ == undefined)
      {
         return undefined;
      }
      var _loc3_ = new ank.battlefield.datacenter.Sprite("viewer",ank.battlefield.mc.Sprite,_loc2_.gfxFile,undefined,5);
      _loc3_.color1 = _loc2_.color1;
      _loc3_.color2 = _loc2_.color2;
      _loc3_.color3 = _loc2_.color3;
      _loc3_.accessories = _loc2_.accessories;
      _loc3_.mount = _loc2_.mount;
      this._svCharacterViewer.sourceSpriteData = _loc2_;
      this._svCharacterViewer.spriteData = _loc3_;
   }
   function drawPreview()
   {
      if(this._mcPreview != undefined)
      {
         this._mcPreview.removeMovieClip();
      }
      this.createEmptyMovieClip("_mcPreview",this.getNextHighestDepth());
      var _loc2_ = dofus.Constants.OVERHEAD_TEXT_CHARACTER;
      var _loc3_ = 0;
      var _loc4_ = 0;
      var _loc5_ = this.api.datacenter.Player.guildInfos != undefined;
      this._mcPreview.createTextField("_txtText",40,0,-3 + dofus.graphics.gapi.ui.TitleAndOrnament.HEIGHT_SPACER + (!_loc5_ ? 0 : dofus.graphics.gapi.ui.TitleAndOrnament.TEXT_HEIGHT),0,0);
      var _loc6_ = TextField(this._mcPreview._txtText);
      _loc6_.embedFonts = true;
      _loc6_.autoSize = !_loc5_ ? "center" : "left";
      _loc6_.text = this.api.datacenter.Player.Name;
      _loc6_.selectable = false;
      _loc6_.setTextFormat(dofus.graphics.gapi.ui.TitleAndOrnament.TEXT_FORMAT);
      if(_loc2_ != undefined)
      {
         _loc6_.textColor = _loc2_;
      }
      _loc3_ = Math.max(_loc3_,_loc6_.textWidth + (!_loc5_ ? 0 : dofus.graphics.gapi.ui.TitleAndOrnament.EMBLEM_WIDTH + dofus.graphics.gapi.ui.TitleAndOrnament.WIDTH_SPACER * 2));
      _loc4_ += _loc6_.textHeight + dofus.graphics.gapi.ui.TitleAndOrnament.HEIGHT_SPACER;
      var _loc7_;
      var _loc8_;
      if(this._nSelectedId != -1)
      {
         this._mcPreview.createTextField("_txtTitle",50,0,-3 + dofus.graphics.gapi.ui.TitleAndOrnament.HEIGHT_SPACER + dofus.graphics.gapi.ui.TitleAndOrnament.TEXT_HEIGHT + (!_loc5_ ? 0 : dofus.graphics.gapi.ui.TitleAndOrnament.TEXT_HEIGHT + dofus.graphics.gapi.ui.TitleAndOrnament.HEIGHT_SPACER),0,0);
         _loc7_ = this.selectedTitle;
         _loc8_ = TextField(this._mcPreview._txtTitle);
         _loc6_.embedFonts = true;
         _loc8_.autoSize = "center";
         _loc8_.text = _loc7_.text;
         _loc8_.selectable = false;
         _loc8_.setTextFormat(dofus.graphics.gapi.ui.TitleAndOrnament.TEXT_FORMAT2);
         if(_loc7_.color != undefined)
         {
            _loc8_.textColor = _loc7_.color;
         }
         _loc3_ = Math.max(_loc3_,_loc8_.textWidth);
         _loc4_ += _loc8_.textHeight + dofus.graphics.gapi.ui.TitleAndOrnament.HEIGHT_SPACER;
      }
      var _loc9_;
      var _loc10_;
      if(_loc5_)
      {
         this._mcPreview.createTextField("_txtGuildName",60,0,-2 + dofus.graphics.gapi.ui.TitleAndOrnament.HEIGHT_SPACER,0,0);
         _loc9_ = TextField(this._mcPreview._txtGuildName);
         _loc9_.embedFonts = true;
         _loc9_.autoSize = "left";
         _loc9_.text = this.api.datacenter.Player.guildInfos.name;
         _loc9_.selectable = false;
         _loc9_.setTextFormat(dofus.graphics.gapi.ui.TitleAndOrnament.TEXT_SMALL_FORMAT);
         _loc3_ = Math.max(_loc3_,_loc9_.textWidth + dofus.graphics.gapi.ui.TitleAndOrnament.WIDTH_SPACER * 2 + dofus.graphics.gapi.ui.TitleAndOrnament.EMBLEM_WIDTH);
         _loc4_ += _loc9_.textHeight + dofus.graphics.gapi.ui.TitleAndOrnament.HEIGHT_SPACER * 2;
         _loc10_ = Math.ceil((- _loc3_) / 2);
         this._mcPreview.attachMovie("Emblem","_eEmblem",100,{_x:_loc10_,_y:dofus.graphics.gapi.ui.TitleAndOrnament.HEIGHT_SPACER,_height:dofus.graphics.gapi.ui.TitleAndOrnament.EMBLEM_WIDTH,_width:dofus.graphics.gapi.ui.TitleAndOrnament.EMBLEM_WIDTH,data:this.api.datacenter.Player.guildInfos.emblem,shadow:true});
         _loc6_._x = _loc10_ + dofus.graphics.gapi.ui.TitleAndOrnament.EMBLEM_WIDTH + dofus.graphics.gapi.ui.TitleAndOrnament.WIDTH_SPACER;
         _loc9_._x = _loc10_ + dofus.graphics.gapi.ui.TitleAndOrnament.EMBLEM_WIDTH + dofus.graphics.gapi.ui.TitleAndOrnament.WIDTH_SPACER;
      }
      var _loc11_ = Math.ceil(_loc4_ + dofus.graphics.gapi.ui.TitleAndOrnament.HEIGHT_SPACER);
      var _loc12_ = Math.ceil(_loc3_ + dofus.graphics.gapi.ui.TitleAndOrnament.WIDTH_SPACER * 2);
      this._mcPreview.createEmptyMovieClip("_background",20);
      this.drawRoundRect(this._mcPreview._background,(- _loc12_) / 2,0,_loc12_,_loc11_,3,dofus.graphics.gapi.ui.TitleAndOrnament.BACKGROUND_COLOR,dofus.graphics.gapi.ui.TitleAndOrnament.BACKGROUND_ALPHA);
      this._mcPreview._x = this._previewCenter._x;
      this._mcPreview._y = this._previewCenter._y - _loc11_ / 2;
      var _loc13_ = !this.api.datacenter.Player._nCriticalHitBonus ? this.api.datacenter.Player.alignment.index : this.api.datacenter.Player.fakeAlignment.index;
      var _loc14_;
      var _loc16_;
      var _loc15_;
      if(_loc13_ != 0 && this._btnShowWings.selected)
      {
         this._mcPreview.createEmptyMovieClip("_alignGFX",10);
         this._mcPreview._alignGFX.attachClassMovie(ank.utils.SWFLoader,"_mcSwfLoader",10);
         _loc14_ = dofus.Constants.DEMON_ANGEL_FILE;
         if(this.api.datacenter.Player.alignment.fallenAngelDemon)
         {
            _loc14_ = dofus.Constants.FALLEN_DEMON_ANGEL_FILE;
         }
         _loc16_ = this.api.datacenter.Player.rank.value <= 0 ? 1 : this.api.datacenter.Player.rank.value;
         if(_loc13_ == 1)
         {
            _loc15_ = _loc16_;
         }
         else if(_loc13_ == 2)
         {
            _loc15_ = 10 + _loc16_;
         }
         else if(_loc13_ == 3)
         {
            _loc15_ = 20 + _loc16_;
         }
         this._mcPreview._alignGFX._mcSwfLoader.loadSWF(_loc14_,_loc15_);
      }
   }
   function click(oEvent_)
   {
      switch(oEvent_.target)
      {
         case this._btnClose:
            this.callClose();
            break;
         case this._btnSave:
            this.api.network.NameCustomization.setTitle(this._nSelectedId);
            break;
         case this._btnReset:
            this._nSelectedId = this.api.datacenter.NameCustomization.selectedId;
            this.updateData();
            break;
         case this._btnShowWings:
            this.drawPreview();
         default:
            return;
      }
   }
   function itemSelected(oEvent_)
   {
      var _loc0_;
      if((_loc0_ = oEvent_.target) === this._lstTitle)
      {
         this._nSelectedId = oEvent_.item.id;
         this.drawPreview();
      }
   }
   function change(oEvent_)
   {
      var _loc0_;
      if((_loc0_ = oEvent_.target) === this._tiSearch)
      {
         if(this._tiSearch.text == this._sCurrentEntityNameSearch)
         {
            return undefined;
         }
         if(this._tiSearch.text.length > 0)
         {
            this._sCurrentEntityNameSearch = this._tiSearch.text.toUpperCase();
         }
         else
         {
            this._sCurrentEntityNameSearch = "";
         }
         this.updateTitleList();
      }
   }
}
