110894067 - 1;
class dofus.sounds.AudioEvents
{
   static var api;
   static var instance;
   function AudioEvents()
   {
   }
   static function getInstance()
   {
      if(dofus.sounds.AudioEvents.instance == null)
      {
         dofus.sounds.AudioEvents.instance = new dofus.sounds.AudioEvents();
      }
      dofus.sounds.AudioEvents.api = _global.API;
      return dofus.sounds.AudioEvents.instance;
   }
   function getAudioManager()
   {
      return dofus.sounds.AudioManager.getInstance();
   }
   function onGameStart(aMusicList)
   {
      if(aMusicList == undefined)
      {
         return undefined;
      }
      var _loc3_ = Math.floor(Math.random() * aMusicList.length);
      this.getAudioManager().playMusic(aMusicList[_loc3_],false,true);
   }
   function onGameEnd()
   {
   }
   function onTurnStart()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("TURN_START"),undefined,true);
      }
   }
   function onGameInvitation()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("BIP"),undefined,true);
      }
   }
   function onGameCriticalHit()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("BIP"));
      }
   }
   function onGameCriticalMiss()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("COUP_CRITIQUE"));
      }
   }
   function onBannerRoundButtonClick()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("CLICK2"),undefined,true);
      }
   }
   function onBannerChatButtonClick()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("CLICK"),undefined,true);
      }
   }
   function onBannerSpellItemButtonClick()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("CLICK"),undefined,true);
      }
   }
   function onBannerTimer()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("TAK"),undefined,true);
      }
   }
   function onBannerSpellSelect()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("CLICK2"),undefined,true);
      }
   }
   function onStatsJobBoostButtonClick()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("CLICK2"),undefined,true);
      }
   }
   function onSpellCollectionButtonClick()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("CLICK2"),undefined,true);
      }
   }
   function onSpellsBoostButtonClick()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("CLICK2"),undefined,true);
      }
   }
   function onInventoryFilterButtonClick()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("CLICK3"),undefined,true);
      }
   }
   function onMapButtonClick()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("CLICK3"),undefined,true);
      }
   }
   function onGuildButtonClick()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("CLICK"),undefined,true);
      }
   }
   function onMapFlag()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("POSE2"),undefined,true);
      }
   }
   function onChatWisper()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("BIP"),undefined,true);
      }
   }
   function onChatGameEvent()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("GAME_EVENT"));
      }
   }
   function onStartHunt()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("START_FIGHT"),undefined,true);
      }
   }
   function onTaxcollectorAttack()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("CLANG"),undefined,true);
      }
   }
   function onError()
   {
      if(dofus.sounds.AudioEvents.api.kernel.XTRA_LANG_FILES_LOADED)
      {
         this.getAudioManager().playEffect(dofus.sounds.AudioEvents.api.lang.getEffectFromKeyname("ERROR"),undefined,true);
      }
   }
   function onEnterVillage()
   {
   }
}
