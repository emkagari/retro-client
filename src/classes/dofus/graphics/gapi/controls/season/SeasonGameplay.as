class dofus.graphics.gapi.controls.season.SeasonGameplay extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _svCharacterViewer;
   var _txtIntroSign;
   var _txtSeasonGameplay;
   var _txtSeasonIntro;
   var _txtSeasonReward;
   var addToQueue;
   var api;
   static var CLASS_NAME = "SeasonProgress";
   function SeasonGameplay()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.season.SeasonGameplay.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initText});
      this.addToQueue({object:this,method:this.initData});
   }
   function initText()
   {
      this._txtSeasonGameplay.text = this.api.lang.getText("SEASON_1_GAMEPLAY");
      this._txtSeasonReward.text = this.api.lang.getText("SEASON_1_REWARD");
      this._txtSeasonIntro.text = this.api.lang.getText("SEASON_1_INTRO");
      this._txtIntroSign.text = "- " + this.api.lang.getNonPlayableCharactersText(1548).n + " (656)";
   }
   function initData()
   {
      var _loc2_ = ank.battlefield.datacenter.Sprite(this.api.datacenter.Player.data);
      var _loc3_ = this.api.datacenter.Player.Guild;
      if(_loc2_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = new ank.battlefield.datacenter.Sprite("viewer",ank.battlefield.mc.Sprite,_loc2_.gfxFile,undefined,5);
      _loc4_.color1 = _loc2_.color1;
      _loc4_.color2 = _loc2_.color2;
      _loc4_.color3 = _loc2_.color3;
      var _loc5_ = "0,3505,3507,3506,3508";
      this.api.kernel.CharactersManager.setSpriteAccessories(_loc4_,_loc5_);
      this._svCharacterViewer.spriteData = _loc4_;
      this._svCharacterViewer.noDelay = true;
      this._svCharacterViewer.useSingleLoader = true;
      this._svCharacterViewer.spriteAnims = ["StaticR","StaticF","StaticS","StaticL"];
      this._svCharacterViewer.filters = [new flash.filters.GlowFilter(16777215,1,20,20,1,2)];
   }
}
