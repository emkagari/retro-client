class dofus.aks.Emotes extends dofus.aks.Handler
{
   var aks;
   var api;
   function Emotes(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function useEmote(nEmoteID)
   {
      if(this.api.datacenter.Game.isFight)
      {
         return undefined;
      }
      if(getTimer() - this.api.datacenter.Basics.aks_emote_lastActionTime < dofus.Constants.CLICK_MIN_DELAY)
      {
         return undefined;
      }
      this.api.datacenter.Basics.aks_emote_lastActionTime = getTimer();
      this.aks.send("eU" + nEmoteID,true);
   }
   function setDirection(nDir)
   {
      this.aks.send("eD" + nDir,true);
   }
   function onUse(bSuccess, sExtraData)
   {
      if(this.api.datacenter.Game.isFight)
      {
         return undefined;
      }
      if(!bSuccess)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_USE_EMOTE"),"ERROR_CHAT");
         return undefined;
      }
      var _loc4_ = sExtraData.split("|");
      var _loc5_ = _loc4_[0];
      var _loc6_ = Number(_loc4_[1]);
      var _loc7_ = Number(_loc4_[2]);
      var _loc8_ = this.api.datacenter.Sprites.getItemAt(_loc5_).name;
      var _loc9_ = this.api.kernel.ChatManager.isBlacklisted(_loc8_);
      var _loc10_ = this.api.electron.isWindowFocused || !this.api.kernel.OptionsManager.getOption("AntiLagHideEmotes");
      if(_loc6_ != 1 && (_loc6_ != 19 && !_loc10_) || _loc9_)
      {
         _loc6_ = _global.NaN;
      }
      var _loc11_ = !_global.isNaN(_loc6_) ? "emote" + _loc6_ : "static";
      this.api.gfx.convertHeightToFourSpriteDirection(_loc5_);
      if(_global.isNaN(_loc7_) && _global.isNaN(_loc6_))
      {
         this.api.gfx.setForcedSpriteAnim(_loc5_,_loc11_);
      }
      else
      {
         this.api.gfx.setSpriteTimerAnim(_loc5_,_loc11_,true,_loc7_);
      }
   }
   function onList(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      var _loc6_ = this.api.datacenter.Player;
      _loc6_.clearEmotes();
      var _loc7_ = 0;
      while(_loc7_ < 32)
      {
         if((_loc4_ >> _loc7_ & 1) == 1)
         {
            if(this.api.lang.getEmoteText(_loc7_ + 1) != undefined)
            {
               _loc6_.addEmote(_loc7_ + 1);
            }
         }
         _loc7_ = _loc7_ + 1;
      }
      var _loc8_ = 0;
      while(_loc8_ < 32)
      {
         if((_loc5_ >> _loc8_ & 1) == 1)
         {
            if(this.api.lang.getEmoteText(_loc8_ + 1) != undefined)
            {
               _loc6_.addEmote(_loc8_ + 1);
            }
         }
         _loc8_ = _loc8_ + 1;
      }
      this.refresh();
   }
   function onAdd(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = _loc3_[1] == "0";
      if(!_loc5_)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("NEW_EMOTE",[this.api.lang.getEmoteText(_loc4_).n]),"INFO_CHAT");
      }
      this.refresh();
   }
   function onRemove(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = _loc3_[1] == "0";
      if(!_loc5_)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("REMOVE_EMOTE",[this.api.lang.getEmoteText(_loc4_).n]),"INFO_CHAT");
      }
      this.refresh();
   }
   function onDirection(sExtraData)
   {
      if(this.api.datacenter.Game.isFight)
      {
         return undefined;
      }
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = _loc3_[0];
      var _loc5_ = Number(_loc3_[1]);
      var _loc6_ = this.api.gfx.getSprite(_loc4_).animation;
      this.api.gfx.setSpriteDirection(_loc4_,_loc5_);
      this.api.gfx.setSpriteAnim(_loc4_,_loc6_);
   }
   function refresh()
   {
      this.api.ui.getUIComponent("Banner").updateSmileysEmotes();
      this.api.ui.getUIComponent("Banner").showSmileysEmotesPanel(true);
   }
}
