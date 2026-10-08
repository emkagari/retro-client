class dofus.graphics.gapi.ui.CardsUpgrader extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnCraft;
   var _btnReset;
   var _cardAnim;
   var _ctr0;
   var _ivInventoryViewer;
   var _lblSkill;
   var _mcFiligrane;
   var _nSkillId;
   var _winCrafter;
   var _winInventory;
   var addToQueue;
   var gapi;
   var unloadThis;
   static var CLASS_NAME = "CardsUpgrader";
   function CardsUpgrader()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.CardsUpgrader.CLASS_NAME);
   }
   function callClose()
   {
      this.api.network.Ttg.sendLeave();
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
   }
   function addListeners()
   {
      this.resetContainers();
      this._btnClose.addEventListener("click",this);
      this._btnCraft.addEventListener("click",this);
      this._btnCraft.addEventListener("over",this);
      this._btnCraft.addEventListener("out",this);
      this._btnReset.addEventListener("click",this);
      this._ivInventoryViewer.addEventListener("dblClickItem",this);
      this._ivInventoryViewer.cgGrid.multipleContainerSelectionEnabled = false;
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < 3)
      {
         _loc3_ = ank.gapi.controls.Container(this["_ctr" + _loc2_]);
         _loc3_.addEventListener("dblClick",this);
         _loc3_.addEventListener("over",this);
         _loc3_.addEventListener("out",this);
         _loc3_.addEventListener("drop",this);
         _loc2_ = _loc2_ + 1;
      }
   }
   function initTexts()
   {
      this._winInventory.title = this.api.datacenter.Player.data.name;
      this._winCrafter.title = this.api.lang.getText("CARD_UPGRADER");
      this._btnCraft.label = this.api.lang.getText("FUSE_CARD");
      this._btnReset.label = this.api.lang.getText("REINIT_WORD");
      this._lblSkill.text = this.api.lang.getText("SKILL") + " : " + this.api.lang.getSkillText(this._nSkillId).d;
   }
   function initData()
   {
      this._ivInventoryViewer.hideNonCardsFilters();
      this._ivInventoryViewer.showKamas = false;
      this._ivInventoryViewer.dataProvider = this.api.datacenter.Player.Inventory;
   }
   function sendUpgradeCard(oItem)
   {
      if(oItem == undefined)
      {
         return undefined;
      }
      this.api.network.Ttg.sendUpgradeCard(oItem.unicID);
   }
   function playAnim()
   {
      var _loc2_ = this._ctr0.contentData;
      if(_loc2_ == undefined)
      {
         return undefined;
      }
      var _loc3_ = dofus.datacenter.Item(_loc2_);
      var _loc4_ = 1;
      var _loc5_;
      var _loc6_;
      while(_loc4_ <= 4)
      {
         _loc5_ = this._cardAnim["_mcCard" + _loc4_];
         _loc6_ = ank.gapi.controls.Loader(_loc5_.attachMovie("GAPILoader","_ldrCard" + _loc4_,_loc5_.getNextHighestDepth(),{_width:45,_height:45.55,_x:-22.5,_y:-22.75,scaleContent:true,autoLoad:true,contentPath:_loc3_.iconFile}));
         _loc4_ = _loc4_ + 1;
      }
      this._cardAnim.gotoAndPlay(2);
   }
   function fillContainersWithCard(oItemToPut)
   {
      if(!this.isCardItemUpgradable(oItemToPut))
      {
         return undefined;
      }
      var _loc3_ = new dofus.datacenter.Item(undefined,oItemToPut.unicID);
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < 3)
      {
         _loc5_ = ank.gapi.controls.Container(this["_ctr" + _loc4_]);
         _loc5_.contentData = _loc3_;
         _loc4_ = _loc4_ + 1;
      }
      this._mcFiligrane._visible = this.api.datacenter.Player.ttgCollection.isOwningTtgCard(oItemToPut.gfx);
      this._btnCraft.enabled = true;
   }
   function resetContainers()
   {
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < 3)
      {
         _loc3_ = ank.gapi.controls.Container(this["_ctr" + _loc2_]);
         _loc3_.contentData = undefined;
         _loc2_ = _loc2_ + 1;
      }
      this._mcFiligrane._visible = false;
      this._btnCraft.enabled = false;
   }
   function isCardItemUpgradable(oItem)
   {
      if(!oItem.isCardType)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("TTG_UPGRADER_ERROR_MUST_BE_CARD_TYPE",[this.api.datacenter.Player.Name]),"ERROR_CHAT");
         return false;
      }
      var _loc3_ = this.api.datacenter.Player.ttgCollection.getTtgCard(oItem.gfx);
      if(_loc3_ != undefined && (_loc3_.linkedFoil != undefined && this.api.datacenter.Player.ttgCollection.isOwningTtgCard(_loc3_.linkedFoil.cardID)))
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("TTG_UPGRADER_ERROR_FOIL_VARIANT_ALREADY_OWNED"),"ERROR_CHAT");
         return false;
      }
      var _loc4_ = this.api.datacenter.Player.ttgCollection.isOwningTtgCard(oItem.gfx);
      var _loc5_ = !_loc4_ ? 3 : 2;
      if(oItem.Quantity < _loc5_)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("TTG_UPGRADER_ERROR_MUST_OWN_X_QUANTITY_OF_CARD",[_loc5_]),"ERROR_CHAT");
         return false;
      }
      if(_loc4_)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("TTP_UPGRADER_CARD_TO_UPGRADE_OWNED"),"INFO_CHAT");
      }
      return true;
   }
   function set skillId(nSkillId)
   {
      this._nSkillId = Number(nSkillId);
   }
   function yes(oEvent)
   {
   }
   function click(oEvent)
   {
      var _loc3_;
      switch(oEvent.target)
      {
         case this._btnCraft:
            _loc3_ = this._ctr0.contentData;
            this.sendUpgradeCard(_loc3_ == undefined ? undefined : dofus.datacenter.Item(_loc3_));
            break;
         case this._btnClose:
            this.callClose();
            break;
         case this._btnReset:
            this.resetContainers();
         default:
            return;
      }
   }
   function dblClickItem(oEvent)
   {
      var _loc3_ = oEvent.item;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc0_;
      if((_loc0_ = oEvent.owner._name) === "_ivInventoryViewer")
      {
         this.fillContainersWithCard(dofus.datacenter.Item(_loc3_));
      }
   }
   function over(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(oEvent.target == this._btnCraft)
      {
         _loc3_ = dofus.datacenter.Item(this._ctr0.contentData);
         if(_loc3_ != undefined)
         {
            _loc4_ = this.api.datacenter.Player.ttgCollection.isOwningTtgCard(_loc3_.gfx);
            _loc5_ = !_loc4_ ? 3 : 2;
            _loc6_ = this.api.lang.getText("TTG_UPGRADER_USED_CARDS") + " : " + _loc5_;
            this.api.ui.showTooltip(_loc6_);
         }
      }
      else
      {
         _loc7_ = oEvent.target.contentData;
         _loc7_.showStatsTooltip(oEvent.target.contentData.style);
      }
   }
   function out(oEvent)
   {
      this.api.ui.hideTooltip();
   }
   function drop(oEvent)
   {
      var _loc3_ = this.gapi.getCursor();
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      if(_loc3_.isShortcut)
      {
         return undefined;
      }
      this.gapi.removeCursor();
      this.fillContainersWithCard(dofus.datacenter.Item(_loc3_));
   }
}
