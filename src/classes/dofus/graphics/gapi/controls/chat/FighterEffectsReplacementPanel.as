class dofus.graphics.gapi.controls.chat.FighterEffectsReplacementPanel extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _lblName;
   var _lstEffects;
   var _oSpriteData;
   var addToQueue;
   static var CLASS_NAME = "FighterEffectsReplacementPanel";
   function FighterEffectsReplacementPanel()
   {
      super();
   }
   function set spriteData(oSpriteData)
   {
      this._oSpriteData = oSpriteData;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.chat.FighterEffectsReplacementPanel.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
   }
   function update(oSpriteData)
   {
      this.api.ui.hideTooltip();
      this._oSpriteData = oSpriteData;
      this.addToQueue({object:this,method:this.initData});
   }
   function initData()
   {
      if(this._oSpriteData == undefined)
      {
         return undefined;
      }
      this._lblName.text = this.api.lang.getText("EFFECTS") + " " + this._oSpriteData.name + " (" + this.api.lang.getText("LEVEL_SMALL") + this._oSpriteData.Level + ")";
      this._lstEffects.dataProvider = this._oSpriteData.EffectsManager.getEffects();
   }
   function initTexts()
   {
   }
   function addListeners()
   {
   }
}
