class dofus.graphics.battlefield.TextOverHead extends dofus.graphics.battlefield.AbstractTextOverHead
{
   var _mcTxtBackground;
   var _oSprite;
   var _txtText;
   var _txtTitle;
   var addToQueue;
   var createTextField;
   function TextOverHead(sText, sFile, nColor, nFrame, oSprite, title)
   {
      super();
      this.initialize(title != undefined);
      this._oSprite = oSprite;
      this.addToQueue({object:this,method:this.addEventListeners});
      this.drawClip(sText,sFile,nColor,nFrame,this._oSprite.pvpGain,title);
   }
   function initialize(displayTitle)
   {
      super.initialize();
      this.createTextField("_txtText",30,0,-3 + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER,0,0);
      if(displayTitle)
      {
         this.createTextField("_txtTitle",31,0,-3 + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER,0,0);
         this._txtTitle.embedFonts = true;
      }
      this._txtText.embedFonts = true;
   }
   function addEventListeners()
   {
      this._oSprite.addEventListener("lpChanged",this);
   }
   function drawClip(sText, sFile, nColor, nFrame, nPvpGain, title)
   {
      var _loc8_ = sFile != undefined && nFrame != undefined;
      if(nPvpGain == undefined)
      {
         nPvpGain = 0;
      }
      this.initTextField(this._txtText,sText,nColor,dofus.graphics.battlefield.AbstractTextOverHead.TEXT_FORMAT);
      var _loc9_;
      var _loc10_;
      if(title)
      {
         this.initTextField(this._txtTitle,title.text,title.color,dofus.graphics.battlefield.AbstractTextOverHead.TEXT_FORMAT2);
         this._txtTitle._y = this._txtText._y + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER + this._txtText.textHeight;
         _loc9_ = Math.ceil(this._txtText.textHeight + this._txtTitle.textHeight + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER * 3);
         _loc10_ = Math.ceil(Math.max(this._txtText.textWidth,this._txtTitle.textWidth) + dofus.graphics.battlefield.AbstractTextOverHead.WIDTH_SPACER * 2);
      }
      else
      {
         _loc9_ = Math.ceil(this._txtText.textHeight + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER * 2);
         _loc10_ = Math.ceil(this._txtText.textWidth + dofus.graphics.battlefield.AbstractTextOverHead.WIDTH_SPACER * 2);
      }
      this.drawBackground(_loc10_,_loc9_,dofus.graphics.battlefield.AbstractTextOverHead.BACKGROUND_COLOR);
      if(_loc8_)
      {
         this.drawGfx(sFile,nFrame);
         this.addPvpGfxEffect(nPvpGain,nFrame);
      }
   }
   function initTextField(txtField, sText, nColor, textFormat)
   {
      txtField.autoSize = "center";
      txtField.text = sText;
      txtField.selectable = false;
      txtField.setTextFormat(textFormat);
      if(nColor != undefined)
      {
         txtField.textColor = nColor;
      }
   }
   function lpChanged(oEvent)
   {
      var _loc3_ = this._oSprite.name + " (" + this._oSprite.LP + ")";
      this.initTextField(this._txtText,_loc3_,undefined,dofus.graphics.battlefield.AbstractTextOverHead.TEXT_FORMAT);
      this._mcTxtBackground.clear();
      var _loc4_ = Math.ceil(this._txtText.textHeight + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER * 2);
      var _loc5_ = Math.ceil(this._txtText.textWidth + dofus.graphics.battlefield.AbstractTextOverHead.WIDTH_SPACER * 2);
      this.drawBackground(_loc5_,_loc4_,dofus.graphics.battlefield.AbstractTextOverHead.BACKGROUND_COLOR);
   }
}
