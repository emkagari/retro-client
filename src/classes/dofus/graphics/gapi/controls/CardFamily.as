class dofus.graphics.gapi.controls.CardFamily extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _ldrFamilyIcon;
   var _mcFamilyCardBackground;
   var _mcFamilyCardForeground;
   var _nFamilyCompletionPercentage;
   var _nFamilyFoilCompletionPercentage;
   var _nFamilyID;
   var _pbCompletion;
   var addToQueue;
   static var CLASS_NAME = "CardFamily";
   function CardFamily()
   {
      super();
   }
   function Card()
   {
      this.initialize();
   }
   function get familyID()
   {
      return this._nFamilyID;
   }
   function set familyID(nFamilyID)
   {
      this._nFamilyID = nFamilyID;
   }
   function get familyCompletionPercentage()
   {
      return this._nFamilyCompletionPercentage;
   }
   function set familyCompletionPercentage(nFamilyCompletionPercentage)
   {
      this._nFamilyCompletionPercentage = nFamilyCompletionPercentage;
   }
   function get familyFoilCompletionPercentage()
   {
      return this._nFamilyFoilCompletionPercentage;
   }
   function set familyFoilCompletionPercentage(nFamilyFoilCompletionPercentage)
   {
      this._nFamilyFoilCompletionPercentage = nFamilyFoilCompletionPercentage;
   }
   function get iconFamilyFile()
   {
      return dofus.Constants.FAMILY_CLIP_FOLDER + this.familyID + ".swf";
   }
   function initialize()
   {
      this.api = _global.API;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.CardFamily.CLASS_NAME);
      this._mcFamilyCardBackground._visible = false;
      this._mcFamilyCardForeground._visible = false;
      this._pbCompletion.styleName = "TtgProgressBar";
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
   }
   function initData()
   {
      this._ldrFamilyIcon.contentPath = dofus.Constants.FAMILY_CLIP_FOLDER + this.familyID + ".swf";
      this._mcFamilyCardBackground._visible = true;
      this._mcFamilyCardForeground._visible = true;
      this._pbCompletion.value = this._nFamilyCompletionPercentage;
      this._pbCompletion.uberValue = this._nFamilyFoilCompletionPercentage;
   }
   function addListeners()
   {
      this._pbCompletion.addEventListener("over",this);
      this._pbCompletion.addEventListener("out",this);
   }
   function initTexts()
   {
   }
   function over(oEvent)
   {
      var _loc0_;
      var _loc3_;
      if((_loc0_ = oEvent.target) === this._pbCompletion)
      {
         _loc3_ = oEvent.target;
         this.api.ui.showTooltip(this.api.lang.getText("TTG_EQUIP_FAMILY_COMPLETED",[_loc3_.value]) + "%" + "\n" + this.api.lang.getText("TTG_EQUIP_FOIL_FAMILY_COMPLETED",[_loc3_.uberValue]) + "%");
      }
   }
   function out(oEvent)
   {
      this.api.ui.hideTooltip();
   }
}
