class dofus.graphics.gapi.ui.Prism extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnClose2;
   var _btnTeleport;
   var _eaData;
   var _lblArea;
   var _lblCoords;
   var _lblCost;
   var _lblName;
   var _lblNotice;
   var _lstPrism;
   var _oSelectedRow;
   var _tiSearch;
   var _winBg;
   var addToQueue;
   var initialized;
   static var CLASS_NAME = "Prism";
   var _sCurrentEntityNameSearch = "";
   function Prism()
   {
      super();
   }
   function set data(eaData)
   {
      this.addToQueue({object:this,method:function(d_)
      {
         this._eaData = d_;
         if(this.initialized)
         {
            this.initData();
         }
      },params:[eaData]});
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Prism.CLASS_NAME);
   }
   function callClose()
   {
      this.api.network.Subway.prismLeave();
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
      this._winBg.title = this.api.lang.getText("PRISM_LIST");
      this._lblNotice.text = this.api.lang.getText("PRISM_NOTICE");
      this._lblCoords.text = this.api.lang.getText("COORDINATES_SMALL");
      this._lblName.text = this.api.lang.getText("SUBAREA");
      this._lblArea.text = this.api.lang.getText("AREA");
      this._lblCost.text = this.api.lang.getText("COST");
      this._btnClose2.label = this.api.lang.getText("CLOSE");
      this._btnTeleport.label = this.api.lang.getText("TELEPORT");
      this._tiSearch.placeholder = ank.utils.PatternDecoder.combine(this.api.lang.getText("SEARCH_MINIMUM_CHARACTERS",[dofus.Constants.UI_SEARCH_MIN_CHARACTERS]),null,dofus.Constants.UI_SEARCH_MIN_CHARACTERS < 2);
      this._tiSearch.restrict = dofus.Constants.INV_SEARCH_RESTRICT;
      this._tiSearch.setFocus();
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnClose2.addEventListener("click",this);
      this._btnTeleport.addEventListener("click",this);
      this._lstPrism.addEventListener("itemdblClick",this);
      this._lstPrism.addEventListener("itemSelected",this);
      this._tiSearch.addEventListener("change",this);
   }
   function initData()
   {
      if(this._eaData != undefined)
      {
         this._eaData.sortOn("fieldToSort",Array.CASEINSENSITIVE);
         this._lstPrism.dataProvider = this._eaData;
      }
   }
   function teleport()
   {
      var _loc2_ = this._oSelectedRow;
      var _loc3_ = _loc2_.cost;
      if(this.api.datacenter.Player.Kama >= _loc3_)
      {
         this.api.network.Subway.prismUse(_loc2_.mapID);
      }
      else
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("NOT_ENOUGH_RICH"),"ERROR_CHAT");
      }
   }
   function searchPrism(sSearch)
   {
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      while(_loc4_ < this._eaData.length)
      {
         _loc5_ = this._eaData[_loc4_];
         _loc6_ = new ank.utils.ExtendedString(_loc5_.name).removeAccents().toUpperCase();
         _loc7_ = new ank.utils.ExtendedString(_loc5_.areaName).removeAccents().toUpperCase();
         if(_loc6_.indexOf(sSearch) != -1 || _loc7_.indexOf(sSearch) != -1)
         {
            _loc3_.push(_loc5_);
         }
         _loc4_ = _loc4_ + 1;
      }
      this._lstPrism.dataProvider = _loc3_;
   }
   function click(oEvent_)
   {
      switch(oEvent_.target)
      {
         case this._btnClose:
         case this._btnClose2:
            this.callClose();
            break;
         case this._btnTeleport:
            this.teleport();
         default:
            return;
      }
   }
   function itemSelected(oEvent_)
   {
      this._oSelectedRow = oEvent_.row.item;
      this._btnTeleport.enabled = true;
   }
   function itemdblClick(oEvent_)
   {
      this.teleport();
   }
   function change(oEvent_)
   {
      var _loc0_;
      var _loc3_;
      if((_loc0_ = oEvent_.target) === this._tiSearch)
      {
         _loc3_ = new ank.utils.ExtendedString(this._tiSearch.text).removeAccents().toUpperCase();
         if(_loc3_ == this._sCurrentEntityNameSearch)
         {
            return undefined;
         }
         if(this._tiSearch.text.length > dofus.Constants.UI_SEARCH_MIN_CHARACTERS)
         {
            this.searchPrism(_loc3_);
            this._sCurrentEntityNameSearch = _loc3_;
         }
         else
         {
            this._lstPrism.dataProvider = this._eaData;
            this._sCurrentEntityNameSearch = "";
         }
      }
   }
}
