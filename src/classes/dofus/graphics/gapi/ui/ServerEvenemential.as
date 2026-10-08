class dofus.graphics.gapi.ui.ServerEvenemential extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aTabComponents;
   var _btnClose;
   var _ctrAlignment;
   var _lblLevel;
   var _lblName;
   var _ldrClassIcon;
   var _mcPlacer;
   var _mcTabViewer;
   var _svCharacter;
   var _winBg;
   var addToQueue;
   var attachMovie;
   var gapi;
   var getNextHighestDepth;
   var unloadThis;
   static var CLASS_NAME = "ServerEvenemential";
   static var MAXIMUM_TABS = 5;
   var _sCurrentTab = "Component0";
   function ServerEvenemential()
   {
      super();
   }
   function set currentTab(sTab)
   {
      this._sCurrentTab = sTab;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.ServerEvenemential.CLASS_NAME);
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
      this.addToQueue({object:this,method:this.initTabs});
      this.addToQueue({object:this,method:this.initSprite});
      this.addToQueue({object:this,method:this.setCurrentTab,params:[this.api.datacenter.ServerEvenemential.lastTab == undefined ? this._sCurrentTab : this.api.datacenter.ServerEvenemential.lastTab]});
      this._svCharacter._visible = false;
      this._mcPlacer._visible = false;
   }
   function initTexts()
   {
      this._lblName.text = this.api.datacenter.Player.Name;
      this._lblLevel.text = this.api.lang.getText("LEVEL") + " " + this.api.datacenter.Player.ShowedLevel;
   }
   function addListeners()
   {
      this._ldrClassIcon.addEventListener("over",this);
      this._ldrClassIcon.addEventListener("out",this);
      this._ctrAlignment.addEventListener("over",this);
      this._ctrAlignment.addEventListener("out",this);
      this._btnClose.addEventListener("click",this);
   }
   function initData()
   {
      var _loc2_ = this.api.lang.getConfigText("SERVER_EVENEMENTIAL_UI");
      this._aTabComponents = this.api.lang.getConfigText(_loc2_);
      this._winBg.title = this.api.lang.getText("SERVER_EVENEMENTIAL_TITLE");
      this._ctrAlignment.contentPath = this.api.datacenter.Player.alignment.iconFile;
   }
   function initTabs()
   {
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < dofus.graphics.gapi.ui.ServerEvenemential.MAXIMUM_TABS)
      {
         _loc3_ = this["_btnTabComponent" + _loc2_];
         if(this._aTabComponents[_loc2_] == undefined)
         {
            _loc3_._visible = false;
         }
         else
         {
            _loc3_.label = this.api.lang.getText(this._aTabComponents[_loc2_].toUpperCase());
            _loc3_.addEventListener("click",this);
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function initSprite()
   {
      var _loc2_ = ank.battlefield.datacenter.Sprite(this.api.datacenter.Player.data);
      var _loc3_ = this.api.datacenter.Player.Guild;
      if(_loc2_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = new ank.battlefield.datacenter.Sprite("viewer",ank.battlefield.mc.Sprite,_loc2_.gfxFile,undefined,5);
      _loc4_.color1 = _loc2_.color1;
      _loc4_.color2 = _loc2_.color2;
      _loc4_.color3 = _loc2_.color3;
      _loc4_.accessories = _loc2_.accessories;
      _loc4_.mount = _loc2_.mount;
      this._svCharacter.sourceSpriteData = _loc2_;
      this._svCharacter.spriteData = _loc4_;
      this._svCharacter.spriteAnims = ["StaticF","StaticR","StaticS","StaticL"];
      this._svCharacter._xscale = 50;
      this._svCharacter._yscale = 50;
      this._svCharacter._visible = true;
      this._ldrClassIcon.contentPath = dofus.Constants.BREEDS_SYMBOL_PATH + _loc3_ + ".swf";
   }
   function updateCurrentTabInformations()
   {
      this._mcTabViewer.removeMovieClip();
      this.api.datacenter.ServerEvenemential.lastTab = this._sCurrentTab;
      var _loc2_ = this._aTabComponents[Number(this._sCurrentTab.substr(-1))];
      if(_loc2_ == "Temporis_ItemUpgrader" && dofus.Constants.TRIPLEFRAMERATE)
      {
         _loc2_ += "_TripleFramerate";
      }
      this.attachMovie(_loc2_,"_mcTabViewer",this.getNextHighestDepth(),{_x:this._mcPlacer._x,_y:this._mcPlacer._y});
   }
   function setCurrentTab(sNewTab)
   {
      var _loc3_ = this["_btnTab" + this._sCurrentTab];
      var _loc4_ = this["_btnTab" + sNewTab];
      _loc3_.selected = true;
      _loc3_.enabled = true;
      _loc4_.selected = false;
      _loc4_.enabled = false;
      this._sCurrentTab = sNewTab;
      var _loc5_ = this._aTabComponents[Number(sNewTab.substr(9))];
      switch(_loc5_)
      {
         case "Temporis_Invades":
            this.api.network.Temporis.episodeThree.askInvadeInfo();
            return;
         case "Temporis_Dungeons":
            this.api.network.Temporis.episodeThree.askDungeonInfo();
            return;
         default:
            this.updateCurrentTabInformations();
            return;
      }
   }
   function getCurrentTab()
   {
      return this._mcTabViewer;
   }
   function over(oEvent_)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent_.target)
      {
         case this._ctrAlignment:
            _loc3_ = "<b>" + this.api.datacenter.Player.alignment.name + "</b>";
            if(this.api.datacenter.Player.rank.value > 0)
            {
               _loc3_ += "\n" + this.api.datacenter.Player.rank.value + " (" + this.api.lang.getRankLongName(this.api.datacenter.Player.alignment.index,this.api.datacenter.Player.rank.value) + ")";
            }
            this.gapi.showTooltip(_loc3_);
            break;
         case this._ldrClassIcon:
            _loc4_ = this.api.lang.getClassText(this.api.datacenter.Player.Guild);
            this.gapi.showTooltip("<b>" + _loc4_.ln + "</b>");
         default:
            return;
      }
   }
   function out(oEvent_)
   {
      this.gapi.hideTooltip();
   }
   function click(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) !== this._btnClose)
      {
         this.setCurrentTab(oEvent.target._name.substr(7));
      }
      else
      {
         this.callClose();
      }
   }
}
