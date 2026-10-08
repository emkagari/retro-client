class dofus.graphics.gapi.controls.temporis.TemporisItemUpgrader extends dofus.graphics.gapi.controls.InventoryViewer
{
   var _bFilterI;
   var _bFilterII;
   var _bFilterIII;
   var _btnFilterI;
   var _btnFilterII;
   var _btnFilterIII;
   var _btnFusion;
   var _cgGrid;
   var _ctr0;
   var _ctr1;
   var _ctr2;
   var _ctr3;
   var _ctr4;
   var _ctr5;
   var _currentOverContainer;
   var _eaDataProvider;
   var _fusionAnim;
   var _itemUpgrader;
   var _lblCost;
   var _lblCostTitle;
   var _lblItemMaster;
   var _lblPowder;
   var _lblRelic;
   var _lblSuccess;
   var _lblSuccessTitle;
   var _mcLeft;
   var _mcMaskCtr1;
   var _mcMaskCtr2;
   var _mcMaskCtr3;
   var _mcMaskCtr5;
   var _mcMaskSucceed;
   var _mcRight;
   var _nCurrentFilterID;
   var _oDataViewer;
   var _srcCtr;
   var addToQueue;
   var api;
   var dataProvider;
   var dispatchEvent;
   var gapi;
   static var CLASS_NAME = "TemporisItemUpgrader";
   function TemporisItemUpgrader()
   {
      super();
   }
   function get cgGrid()
   {
      return this._cgGrid;
   }
   function get itemUpgrader()
   {
      return this._itemUpgrader;
   }
   function get currentOverItem()
   {
      if(this._currentOverContainer != undefined && this._currentOverContainer.contentData != undefined)
      {
         return dofus.datacenter.Item(this._currentOverContainer.contentData);
      }
      return undefined;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.temporis.TemporisItemUpgrader.CLASS_NAME);
      this.setMaskDefault();
   }
   function createChildren()
   {
      this._oDataViewer = this._cgGrid;
      this._mcLeft._visible = this._mcRight._visible = false;
      this.addToQueue({object:this,method:this.addListeners});
      super.createChildren();
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
   }
   function addListeners()
   {
      super.addListeners();
      this._cgGrid.addEventListener("dropItem",this);
      this._cgGrid.addEventListener("dragItem",this);
      this._cgGrid.addEventListener("selectItem",this);
      this._cgGrid.addEventListener("overItem",this);
      this._cgGrid.addEventListener("outItem",this);
      this._cgGrid.addEventListener("dblClickItem",this);
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < 6)
      {
         _loc4_ = ank.gapi.controls.Container(this["_ctr" + _loc3_]);
         _loc4_.addEventListener("dblClick",this);
         _loc4_.addEventListener("over",this);
         _loc4_.addEventListener("out",this);
         _loc4_.addEventListener("drop",this);
         _loc4_.addEventListener("drag",this);
         _loc3_ = _loc3_ + 1;
      }
      this._btnFusion.addEventListener("click",this);
      this._btnFilterI.addEventListener("click",this);
      this._btnFilterII.addEventListener("click",this);
      this._btnFilterIII.addEventListener("click",this);
      this._mcMaskCtr5.mouseEnabled = false;
      this._mcMaskCtr5.hitArea = undefined;
      var ref = this;
      this._lblPowder.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._lblPowder.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._lblRelic.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._lblRelic.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._lblItemMaster.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._lblItemMaster.onRollOut = function()
      {
         ref.out({target:this});
      };
   }
   function initTexts()
   {
      this._lblItemMaster.text = this.api.lang.getText("EQUIPEMENT");
      this._lblCostTitle.text = this.api.lang.getText("COST");
      this._lblSuccessTitle.text = this.api.lang.getText("SUCCESS_PROBABILITY");
      this._lblRelic.text = this.api.lang.getText("RELIC");
      this._lblPowder.text = this.api.lang.getText("FRAGMENTS");
   }
   function initData()
   {
      this._itemUpgrader = new dofus.datacenter.evenemential.ItemUpgrader(this.api,this);
      this.dataProvider = this._itemUpgrader.dataProvider;
      this.updateDataView();
   }
   function updateDataView()
   {
      var _loc2_ = this._itemUpgrader.itemMaster;
      var _loc3_ = this._itemUpgrader.nUpgradeLevel;
      this._ctr0.contentData = _loc2_;
      this._ctr0.enabled = true;
      switch(_loc3_)
      {
         case -1:
         case 0:
            this._ctr3.enabled = false;
            this._mcMaskCtr3._visible = true;
            this._btnFusion.label = this.api.lang.getText("UPGRADE");
            break;
         case 1:
            this._ctr3.enabled = true;
            this._mcMaskCtr3._visible = false;
            this._btnFusion.label = this.api.lang.getText("REFINE");
      }
      var _loc4_ = 0;
      while(_loc4_ < 5)
      {
         this["_ctr" + _loc4_].selected = false;
         _loc4_ = _loc4_ + 1;
      }
      this._ctr1.enabled = _loc3_ != -1;
      this._mcMaskCtr1._visible = _loc3_ == -1;
      this._ctr2.enabled = _loc3_ != -1;
      this._mcMaskCtr2._visible = _loc3_ == -1;
      this._lblCostTitle._visible = _loc2_ != undefined;
      this._lblSuccessTitle._visible = _loc2_ != undefined;
      this._ctr1.contentData = this._itemUpgrader.item1;
      this._ctr2.contentData = this._itemUpgrader.item2;
      this._ctr3.contentData = this._itemUpgrader.relic;
      this._ctr4.contentData = this._itemUpgrader.frag;
      this._ctr4.enabled = true;
      this._ctr5.contentData = this._itemUpgrader.resultPreview;
      this._btnFusion.enabled = this._itemUpgrader.isFusionReady();
      this._mcLeft._visible = this._ctr1.contentData != undefined;
      this._mcRight._visible = this._ctr2.contentData != undefined;
      this._lblSuccess.text = !(this.api.datacenter.Temporis.actualUpgradeRecipe != undefined && _loc2_ != undefined) ? "" : Math.min(this.api.datacenter.Temporis.actualUpgradeRecipe.proba + this._itemUpgrader.getBonusFromRelic(this._itemUpgrader.relic),100) + "%";
      this._lblCost.text = !(this.api.datacenter.Temporis.actualUpgradeRecipe != undefined && _loc2_ != undefined) ? "" : this.api.lang.getText("TR3_COST_FRAGMENTS",[this.api.datacenter.Temporis.actualUpgradeRecipe.cost,this._itemUpgrader.getTierLabel(_loc2_)]);
   }
   function updateData()
   {
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      while(_loc4_ < this._eaDataProvider.length)
      {
         _loc5_ = this._eaDataProvider[_loc4_];
         if(_loc5_ != undefined)
         {
            _loc6_ = _loc5_.position;
            if(_loc6_ == -1)
            {
               if(this._nCurrentFilterID == dofus.Constants.FILTER_ID_RESSOURCES)
               {
                  if(this._itemUpgrader.isFragment(_loc5_) || this._itemUpgrader.isRelic(_loc5_))
                  {
                     _loc3_.push(_loc5_);
                  }
               }
               if(this._nCurrentFilterID == dofus.Constants.FILTER_ID_EQUIPEMENT)
               {
                  if(this._bFilterI && _loc5_.unicID < dofus.datacenter.evenemential.ItemUpgrader.UPGRADE_MULTIPLICATOR || (this._bFilterII && (_loc5_.unicID > dofus.datacenter.evenemential.ItemUpgrader.UPGRADE_MULTIPLICATOR && _loc5_.unicID < 2 * dofus.datacenter.evenemential.ItemUpgrader.UPGRADE_MULTIPLICATOR) || (this._bFilterIII && _loc5_.unicID > 2 * dofus.datacenter.evenemential.ItemUpgrader.UPGRADE_MULTIPLICATOR || !this._bFilterI && (!this._bFilterII && !this._bFilterIII))))
                  {
                     _loc3_.push(_loc5_);
                  }
               }
            }
         }
         _loc4_ = _loc4_ + 1;
      }
      super.updateDataGrid(_loc3_);
   }
   function setMaskDefault()
   {
      this._mcMaskCtr5._visible = true;
      this._mcMaskSucceed._visible = false;
   }
   function setMaskGreen()
   {
      this._mcMaskCtr5._visible = false;
      this._mcMaskSucceed._visible = true;
   }
   function playAnim()
   {
      var _loc2_ = this._itemUpgrader.itemMaster;
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
         _loc5_ = this._fusionAnim["_mcCard" + _loc4_];
         _loc6_ = ank.gapi.controls.Loader(_loc5_.attachMovie("GAPILoader","_ldrCard" + _loc4_,_loc5_.getNextHighestDepth(),{_width:45,_height:45.55,_x:-22.5,_y:-22.75,scaleContent:true,autoLoad:true,contentPath:_loc3_.iconFile}));
         _loc4_ = _loc4_ + 1;
      }
      this._fusionAnim.gotoAndPlay(2);
   }
   function getContainerIndex(ctr)
   {
      var _loc3_ = 0;
      while(_loc3_ < 5)
      {
         if(this["_ctr" + _loc3_] == ctr)
         {
            return _loc3_;
         }
         _loc3_ = _loc3_ + 1;
      }
      return -1;
   }
   function showOneItem(nUnicID)
   {
      var _loc3_ = 0;
      while(_loc3_ < this._cgGrid.dataProvider.length)
      {
         if(nUnicID == this._cgGrid.dataProvider[_loc3_].ID)
         {
            this._cgGrid.setVPosition(_loc3_ / this._cgGrid.visibleColumnCount);
            this._cgGrid.selectedIndex = _loc3_;
            return true;
         }
         _loc3_ = _loc3_ + 1;
      }
      return false;
   }
   function showDroppableCtr(oItem, oCtr)
   {
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < 5)
      {
         _loc5_ = this["_ctr" + _loc4_];
         _loc5_.selected = false;
         _loc5_.enabled = false;
         _loc4_ = _loc4_ + 1;
      }
      if(this._srcCtr != undefined)
      {
         return undefined;
      }
      var _loc6_ = this._itemUpgrader.ctrToAddItem(oItem);
      switch(_loc6_)
      {
         case dofus.datacenter.evenemential.ItemUpgrader.FRAGMENT_INDEX:
            this._ctr4.selected = true;
            this._ctr4.enabled = true;
            break;
         case dofus.datacenter.evenemential.ItemUpgrader.RELIC_INDEX:
            if(this._itemUpgrader.nUpgradeLevel == 1)
            {
               this._ctr3.selected = true;
               this._ctr3.enabled = true;
            }
            break;
         case 1:
         case 2:
            this._ctr1.selected = true;
            this._ctr1.enabled = true;
            this._ctr2.selected = true;
            this._ctr2.enabled = true;
            break;
         case dofus.datacenter.evenemential.ItemUpgrader.MASTER_INDEX:
            break;
         default:
            return;
      }
      this._ctr0.selected = true;
      this._ctr0.enabled = true;
   }
   function onMouseUp()
   {
      this.updateDataView();
   }
   function over(oEvent)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent.target)
      {
         case this._lblItemMaster:
            this.gapi.showTooltip(this.api.lang.getText("TR3_EQUIPEMENT_MASTER"));
            return;
         case this._lblPowder:
            this.gapi.showTooltip(this.api.lang.getText("TR3_ADD_FRAGMENT"));
            return;
         case this._lblRelic:
            this.gapi.showTooltip(this.api.lang.getText("TR3_ADD_RELIC"));
            return;
         default:
            if(oEvent.target == this._mcMaskCtr5)
            {
               _loc3_ = this._ctr5;
            }
            else
            {
               _loc3_ = oEvent.target;
            }
            _loc4_ = dofus.datacenter.Item(_loc3_.contentData);
            if(_loc4_ == undefined)
            {
               switch(_loc3_)
               {
                  case this._ctr0:
                     this.gapi.showTooltip(this.api.lang.getText("TR3_EQUIPEMENT_MASTER"));
                     break;
                  case this._ctr1:
                  case this._ctr2:
                     if(this._itemUpgrader.itemMaster == undefined)
                     {
                        return undefined;
                     }
                     this.gapi.showTooltip(this.api.lang.getText("TR3_ADD_ITEM",[this._itemUpgrader.itemMaster.name]));
                     break;
                  case this._ctr3:
                     this.gapi.showTooltip(this.api.lang.getText("TR3_ADD_RELIC"));
                     break;
                  case this._ctr4:
                     this.gapi.showTooltip(this.api.lang.getText("TR3_ADD_FRAGMENT"));
               }
               return;
            }
            _loc4_.showStatsTooltip(_loc4_.style);
            this._currentOverContainer = _loc3_;
            return;
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
      this._currentOverContainer = undefined;
   }
   function dblClick(oEvent)
   {
      this._itemUpgrader.moveToInventory(this.getContainerIndex(oEvent.target));
   }
   function click(oEvent)
   {
      if(oEvent.target == this._btnFusion)
      {
         this._itemUpgrader.askFusion();
         return undefined;
      }
      if(oEvent.target == this._btnFilterI)
      {
         this._bFilterI = !this._bFilterI;
         this._btnFilterI.selected = this._bFilterI;
         if(this._btnFilterI.selected && this._bFilterIII)
         {
            this._bFilterIII = false;
            this._btnFilterIII.selected = false;
         }
         if(this._btnFilterI.selected && this._bFilterII)
         {
            this._bFilterII = false;
            this._btnFilterII.selected = false;
         }
         this.updateData();
         return undefined;
      }
      if(oEvent.target == this._btnFilterII)
      {
         this._bFilterII = !this._bFilterII;
         this._btnFilterII.selected = this._bFilterII;
         if(this._btnFilterII.selected && this._bFilterIII)
         {
            this._bFilterIII = false;
            this._btnFilterIII.selected = false;
         }
         if(this._btnFilterII.selected && this._bFilterI)
         {
            this._bFilterI = false;
            this._btnFilterI.selected = false;
         }
         this.updateData();
         return undefined;
      }
      if(oEvent.target == this._btnFilterIII)
      {
         this._bFilterIII = !this._bFilterIII;
         this._btnFilterIII.selected = this._bFilterIII;
         if(this._btnFilterIII.selected && this._bFilterII)
         {
            this._bFilterII = false;
            this._btnFilterII.selected = false;
         }
         if(this._btnFilterIII.selected && this._bFilterI)
         {
            this._bFilterI = false;
            this._btnFilterI.selected = false;
         }
         this.updateData();
         return undefined;
      }
      super.click(oEvent);
   }
   function drop(oEvent)
   {
      if(this._srcCtr != undefined)
      {
         return undefined;
      }
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
      var _loc4_ = this.getContainerIndex(oEvent.target);
      if(_loc4_ == -1)
      {
         return undefined;
      }
      this._itemUpgrader.moveToUpgrader(dofus.datacenter.Item(_loc3_),_loc4_);
   }
   function drag(oEvent)
   {
      if(oEvent.target.contentData == undefined)
      {
         return undefined;
      }
      this.gapi.removeCursor();
      var _loc3_ = oEvent.target.contentData;
      this.gapi.setCursor(_loc3_);
      this._srcCtr = oEvent.target;
      this.showDroppableCtr(dofus.datacenter.Item(_loc3_));
   }
   function dragItem(oEvent)
   {
      this._srcCtr = undefined;
      if(oEvent.target.contentData == undefined)
      {
         return undefined;
      }
      this.gapi.removeCursor();
      var _loc3_ = oEvent.target.contentData;
      this.gapi.setCursor(_loc3_);
      this.showDroppableCtr(dofus.datacenter.Item(_loc3_));
   }
   function dropItem(oEvent)
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
      var _loc4_ = this.getContainerIndex(this._srcCtr);
      this._srcCtr = undefined;
      this._itemUpgrader.moveToInventory(_loc4_);
   }
   function selectItem(oEvent)
   {
      if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY) && oEvent.target.contentData != undefined)
      {
         this.api.kernel.GameManager.insertItemInChat(oEvent.target.contentData);
         return undefined;
      }
      this.dispatchEvent({type:"selectedItem",item:oEvent.target.contentData});
   }
   function dblClickItem(oEvent)
   {
      var _loc3_ = dofus.datacenter.Item(oEvent.item);
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      this._itemUpgrader.moveToUpgrader(_loc3_);
   }
   function overItem(oEvent)
   {
      var _loc3_ = oEvent.target;
      var _loc4_ = dofus.datacenter.Item(_loc3_.contentData);
      _loc4_.showStatsTooltip(_loc4_.style);
      this._currentOverContainer = _loc3_;
   }
   function outItem(oEvent)
   {
      this.gapi.hideTooltip();
      this._currentOverContainer = undefined;
   }
}
