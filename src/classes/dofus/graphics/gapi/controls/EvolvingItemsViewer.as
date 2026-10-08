179182802 - 1;
class dofus.graphics.gapi.controls.EvolvingItemsViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnDissociate;
   var _btnSkin;
   var _ctrItem;
   var _lblLevel;
   var _lblXplTitle;
   var _oItemData;
   var addToQueue;
   static var CLASS_NAME = "EvolvingItemsViewer";
   function EvolvingItemsViewer()
   {
      super();
   }
   function set itemData(o_)
   {
      this._oItemData = o_;
      this.updateData();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.EvolvingItemsViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.updateData});
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._btnDissociate.addEventListener("click",this);
      this._btnSkin.addEventListener("click",this);
   }
   function initTexts()
   {
      this._lblXplTitle.text = this.api.lang.getText("LEVEL");
      this._lblLevel.text = String(this._oItemData.maxSkin) + " / " + this._oItemData.nbSkin;
      this._btnDissociate.label = this.api.lang.getText("DISSOCIATE");
      this._btnSkin.label = this.api.lang.getText("CHOOSE_SKIN");
   }
   function updateData()
   {
      this._ctrItem.contentPath = this._oItemData.gfx;
      this._ctrItem.contentData = this._oItemData;
      this._btnDissociate.enabled = this._oItemData.hasCeremonialSkinItem;
      this.initTexts();
   }
   function click(oEvent_)
   {
      switch(oEvent_.target)
      {
         case this._btnSkin:
            this.api.ui.loadUIComponent("ChooseItemSkin","ChooseItemSkin",{item:this._oItemData});
            break;
         case this._btnDissociate:
            this.api.network.Items.destroyMimibiote(this._oItemData.ID);
         default:
            return;
      }
   }
}
