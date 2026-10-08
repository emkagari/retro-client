class dofus.graphics.gapi.ui.Subway extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnClose2;
   var _eaData;
   var _lblCoords;
   var _lblCost;
   var _lblDescription;
   var _lblName;
   var _lstSubway;
   var _mcTabPlacer;
   var _tiSearch;
   var _winBg;
   var addToQueue;
   var attachMovie;
   var getNextHighestDepth;
   var initialized;
   static var CLASS_NAME = "Subway";
   var _nCurrentCategory = 0;
   var _sCurrentEntityNameSearch = "";
   function Subway()
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
      super.init(false,dofus.graphics.gapi.ui.Subway.CLASS_NAME);
   }
   function callClose()
   {
      this.api.network.Subway.leave();
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
      this._winBg.title = this.api.lang.getText("SUBWAY_LIST");
      this._lblCoords.text = this.api.lang.getText("COORDINATES_SMALL");
      this._lblName.text = this.api.lang.getText("PLACE");
      this._lblCost.text = this.api.lang.getText("COST");
      this._lblDescription.text = this.api.lang.getText("CLICK_ON_WAYPOINT");
      this._btnClose2.label = this.api.lang.getText("CLOSE");
      this._tiSearch.placeholder = ank.utils.PatternDecoder.combine(this.api.lang.getText("SEARCH_MINIMUM_CHARACTERS",[dofus.Constants.UI_SEARCH_MIN_CHARACTERS]),null,dofus.Constants.UI_SEARCH_MIN_CHARACTERS < 2);
      this._tiSearch.restrict = dofus.Constants.INV_SEARCH_RESTRICT;
      this._tiSearch.setFocus();
      var _loc2_;
      var _loc3_;
      for(var a in this._eaData)
      {
         _loc2_ = {};
         _loc2_._y = this._mcTabPlacer._y;
         _loc2_._height = 20;
         _loc2_.backgroundDown = "ButtonTabDown";
         _loc2_.backgroundUp = "ButtonTabUp";
         _loc2_.styleName = "BrownTabButton";
         _loc2_.toggle = true;
         _loc2_.selected = true;
         _loc2_.enabled = true;
         _loc2_.label = " " + this._eaData[a][0].category + " ";
         _loc3_ = ank.gapi.controls.Button(this.attachMovie("Button","_btnTab" + a,this.getNextHighestDepth(),_loc2_));
         _loc3_.addEventListener("click",this);
      }
      this.setCurrentTab(0);
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnClose2.addEventListener("click",this);
      this._lstSubway.addEventListener("itemSelected",this);
      this._tiSearch.addEventListener("change",this);
   }
   function initData()
   {
      if(this._eaData != undefined && this._eaData.length > 0)
      {
         for(var a in this._eaData)
         {
            this.setCurrentTab(Number(a));
            return undefined;
            break;
         }
      }
   }
   function updateCurrentTabInformations()
   {
      this._eaData[this._nCurrentCategory].sortOn("fieldToSort",Array.CASEINSENSITIVE);
      this._lstSubway.dataProvider = this._eaData[this._nCurrentCategory];
   }
   function setCurrentTab(nCategoryID)
   {
      var _loc3_ = this["_btnTab" + this._nCurrentCategory];
      var _loc4_ = this["_btnTab" + nCategoryID];
      _loc3_.selected = true;
      _loc3_.enabled = true;
      _loc4_.selected = false;
      _loc4_.enabled = false;
      this._nCurrentCategory = nCategoryID;
      this.updateCurrentTabInformations();
      this.setTabsPreferedSize();
      if(this._sCurrentEntityNameSearch != "")
      {
         this.searchSubway(this._sCurrentEntityNameSearch);
      }
   }
   function setTabsPreferedSize()
   {
      var _loc2_ = this._mcTabPlacer._x;
      var _loc3_;
      for(var a in this._eaData)
      {
         _loc3_ = ank.gapi.controls.Button(this["_btnTab" + a]);
         _loc3_._x = _loc2_;
         _loc3_.setPreferedSize();
         _loc2_ += _loc3_.width;
      }
   }
   function searchSubway(sSearch)
   {
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = this._eaData[this._nCurrentCategory];
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      while(_loc5_ < _loc4_.length)
      {
         _loc6_ = _loc4_[_loc5_];
         _loc7_ = new ank.utils.ExtendedString(_loc6_.name).removeAccents().toUpperCase();
         if(_loc7_.indexOf(sSearch) != -1)
         {
            _loc3_.push(_loc6_);
         }
         _loc5_ = _loc5_ + 1;
      }
      this._lstSubway.dataProvider = _loc3_;
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnClose:
         case this._btnClose2:
            this.callClose();
            return;
         default:
            this.setCurrentTab(Number(oEvent.target._name.substr(7)));
            return;
      }
   }
   function itemSelected(oEvent)
   {
      var _loc3_ = oEvent.row.item;
      var _loc4_ = _loc3_.cost;
      if(this.api.datacenter.Player.Kama < _loc4_)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("NOT_ENOUGH_RICH"),"ERROR_BOX");
      }
      else
      {
         this.api.network.Subway.use(_loc3_.mapID);
      }
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
            this.searchSubway(_loc3_);
            this._sCurrentEntityNameSearch = _loc3_;
         }
         else
         {
            this._lstSubway.dataProvider = this._eaData[this._nCurrentCategory];
            this._sCurrentEntityNameSearch = "";
         }
      }
   }
}
