class dofus.graphics.gapi.ui.EncyclopediaDetailsWindow extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bInitialized;
   var _btnClose;
   var _currentOverItem;
   var _mcComponent;
   var _mcPlacer;
   var _oData;
   var addToQueue;
   var attachMovie;
   var getNextHighestDepth;
   var unloadThis;
   static var CLASS_NAME = "EncyclopediaDetailsWindow";
   var _sComponent = "Bestiary";
   function EncyclopediaDetailsWindow()
   {
      super();
   }
   function set component(sComponent)
   {
      this._sComponent = sComponent;
   }
   function set data(oData)
   {
      this._oData = oData;
      if(this._bInitialized)
      {
         this.initData();
      }
   }
   function get currentOverItem()
   {
      return this._currentOverItem;
   }
   function set currentOverItem(oItem_)
   {
      this._currentOverItem = oItem_;
   }
   function get itemViewer()
   {
      return new dofus.graphics.gapi.controls.RightClickContextItemViewer(this.api);
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.EncyclopediaDetailsWindow.CLASS_NAME);
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
   }
   function initData()
   {
      this._mcComponent.removeMovieClip();
      switch(this._sComponent)
      {
         case "Bestiary":
            this.attachMovie("EncyclopediaBestiaryMonsterDetails","_mcComponent",this.getNextHighestDepth(),{_x:this._mcPlacer._x,_y:this._mcPlacer._y,monsterID:this._oData.id,embeded:true});
            break;
         case "Ressources":
            this.attachMovie("EncyclopediaRessourceDetails","_mcComponent",this.getNextHighestDepth(),{_x:this._mcPlacer._x,_y:this._mcPlacer._y,itemID:this._oData.id,effects:this._oData.effects,embeded:true,displayWarning:this._oData.displayWarning});
            break;
         case "Equipments":
            this.attachMovie("EncyclopediaEquipmentDetails","_mcComponent",this.getNextHighestDepth(),{_x:this._mcPlacer._x,_y:this._mcPlacer._y,itemID:this._oData.id,effects:this._oData.effects,embeded:true,displayWarning:this._oData.displayWarning});
         default:
            return;
      }
   }
   function click(oEvent_)
   {
      var _loc0_;
      if((_loc0_ = oEvent_.target) === this._btnClose)
      {
         this.callClose();
      }
   }
}
