class dofus.graphics.battlefield.HealthBarOverHead extends dofus.graphics.battlefield.AbstractTextOverHead
{
   var _oSprite;
   var _txtSpriteName;
   var attachMovie;
   var createTextField;
   function HealthBarOverHead(oSprite, nBarWidth, sFile, nFrame)
   {
      super();
      this._oSprite = oSprite;
      this.initialize();
      this.drawClip(this._oSprite.name,this._oSprite.LP,0,this._oSprite.LPmax,nBarWidth,sFile,nFrame,this._oSprite.pvpGain);
   }
   function initialize()
   {
      super.initialize();
      this.createTextField("_txtSpriteName",40,0,-2 + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER,0,0);
   }
   function drawClip(sSpriteName, nCurrentValue, nMinValue, nMaxValue, nBarWidth, sFile, nFrame, nPvpGain)
   {
      var _loc10_ = sFile != undefined && nFrame != undefined;
      if(nPvpGain == undefined)
      {
         nPvpGain = 0;
      }
      this._txtSpriteName.embedFonts = true;
      this._txtSpriteName.autoSize = "center";
      this._txtSpriteName.text = sSpriteName;
      this._txtSpriteName.selectable = false;
      this._txtSpriteName.setTextFormat(dofus.graphics.battlefield.AbstractTextOverHead.TEXT_FORMAT);
      var _loc11_ = Math.ceil(32 + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER * 2);
      var _loc12_ = Math.ceil(Math.max(this._txtSpriteName.textWidth,nBarWidth) + dofus.graphics.battlefield.AbstractTextOverHead.WIDTH_SPACER * 3);
      this.drawBackground(_loc12_,_loc11_,dofus.graphics.battlefield.AbstractTextOverHead.BACKGROUND_COLOR);
      this.attachMovie("SpriteHealthBar","_mcSpriteHealthBar",100,{realWidth:nBarWidth,_x:(- nBarWidth) / 2,_y:16 + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER,lifeCurrentValue:nCurrentValue,lifeMinValue:nMinValue,lifeMaxValue:nMaxValue});
      if(_loc10_)
      {
         this.drawGfx(sFile,nFrame);
         this.addPvpGfxEffect(nPvpGain,nFrame);
      }
   }
}
