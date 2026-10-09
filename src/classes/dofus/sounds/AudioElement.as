class dofus.sounds.AudioElement extends Sound implements com.ankamagames.interfaces.IDisposable
{
   var _bLoaded;
   var _bLoading;
   var _bMute;
   var _bStartWhenLoaded;
   var _bStreaming;
   var _mcLinkedClip;
   var _nKillTimer;
   var _nLoops;
   var _nMaxLength;
   var _nOffset;
   var _nUniqID;
   var _sFile;
   var baseVolume;
   var volume;
   static var INFINITE_LOOP = 999999;
   static var ONESHOT_SAMPLE = 1;
   static var UNLIMITED_LENGTH = 0;
   var _nVolumeBeforeMute = -1;
   function AudioElement(uniqID, file, linkedClip, streaming)
   {
      if(uniqID == undefined)
      {
         return;
      }
      if(file == undefined)
      {
         return;
      }
      if(linkedClip == undefined)
      {
         return;
      }
      this._nUniqID = uniqID;
      this._mcLinkedClip = linkedClip;
      this._sFile = file;
      this._bStreaming = streaming == undefined ? false : streaming;
      super(linkedClip);
      this._bLoading = true;
      if(dofus.Constants.USING_PACKED_SOUNDS)
      {
         super.attachSound(file.substr(3));
         this.onLoad(true);
      }
      else
      {
         super.loadSound(file,this._bStreaming);
      }
   }
   function get uniqID()
   {
      return this._nUniqID;
   }
   function get linkedClip()
   {
      return this._mcLinkedClip;
   }
   function get file()
   {
      return this._sFile;
   }
   function get streaming()
   {
      return this._bStreaming;
   }
   function get volume()
   {
      return super.getVolume();
   }
   function set volume(nValue)
   {
      if(nValue < 0 || nValue > 100)
      {
         return undefined;
      }
      if(!this._bMute && super.setVolume != undefined)
      {
         super.setVolume(nValue);
      }
      else if(super.setVolume != undefined)
      {
         super.setVolume(0);
         this._nVolumeBeforeMute = nValue;
      }
      return this.volume;
   }
   function get mute()
   {
      return this._bMute;
   }
   function set mute(bValue)
   {
      this._bMute = bValue;
      if(this._bMute && super.setVolume != undefined)
      {
         this._nVolumeBeforeMute = this.volume;
         super.setVolume(0);
      }
      else if(super.setVolume != undefined)
      {
         if(this._nVolumeBeforeMute > 0)
         {
            super.setVolume(this._nVolumeBeforeMute);
         }
      }
   }
   function get loops()
   {
      return this._nLoops;
   }
   function set loops(nValue)
   {
      if(nValue < dofus.sounds.AudioElement.ONESHOT_SAMPLE || nValue > dofus.sounds.AudioElement.INFINITE_LOOP)
      {
         return;
      }
      this._nLoops = nValue;
   }
   function get offset()
   {
      return this._nOffset;
   }
   function set offset(nValue)
   {
      if(nValue < 0 || this._nMaxLength != null && nValue > this._nMaxLength)
      {
         return;
      }
      this._nOffset = nValue;
   }
   function get maxLength()
   {
      return this._nMaxLength;
   }
   function set maxLength(nValue)
   {
      if(nValue < 0)
      {
         return;
      }
      this._nMaxLength = nValue;
   }
   function dispose(Void)
   {
      this.onKill();
      this._mcLinkedClip.onEnterFrame = null;
      delete this._mcLinkedClip.onEnterFrame;
      this._mcLinkedClip.unloadMovie();
      this._mcLinkedClip.removeMovieClip();
      delete this._mcLinkedClip;
   }
   function getVolume()
   {
      return this.volume;
   }
   function setVolume(nVolume)
   {
      this.volume = nVolume;
   }
   function startElement()
   {
      if(this._bStreaming && !this._bLoading || !this._bStreaming && !this._bLoaded)
      {
         this._bStartWhenLoaded = true;
      }
      else
      {
         if(this._nMaxLength != dofus.sounds.AudioElement.UNLIMITED_LENGTH)
         {
            _global.clearInterval(this._nKillTimer);
            this._nKillTimer = _global.setInterval(this,this.onKill,this._nMaxLength * 1000);
         }
         super.start(this._nOffset,this._nLoops);
      }
   }
   function stop()
   {
      super.stop();
   }
   function fadeOut(nDuration, bAutoDestroy)
   {
      var volume = this.volume;
      var t = volume / nDuration / dofus.Constants.AVERAGE_FRAMES_PER_SECOND;
      var parentElement = this;
      var parentNode_ = super;
      var myself = this._mcLinkedClip;
      var destroy = bAutoDestroy;
      this._mcLinkedClip.onEnterFrame = function()
      {
         volume -= t;
         parentNode_.setVolume(volume);
         if(volume <= 0)
         {
            parentElement.stop();
            myself.onEnterFrame = undefined;
            delete myself.onEnterFrame;
            if(destroy)
            {
               parentElement.dispose();
            }
         }
      };
   }
   function toString()
   {
      var _loc2_ = "[AudioElement = " + this._nUniqID + "]\n";
      _loc2_ += " > Linked clip  : " + this._mcLinkedClip + "\n";
      _loc2_ += " > File         : " + this._sFile + "\n";
      _loc2_ += " > Loops        : " + this._nLoops + "\n";
      _loc2_ += " > Start offset : " + this._nOffset + "\n";
      _loc2_ += " > Max length   : " + this._nMaxLength + "\n";
      _loc2_ += " > Base vol.    : " + this.baseVolume + "\n";
      _loc2_ += " > Volume       : " + this.getVolume() + "\n";
      _loc2_ += " > Mute         : " + this._bMute + "\n";
      return _loc2_;
   }
   function onLoad(bSuccess)
   {
      if(!bSuccess)
      {
         return undefined;
      }
      this._bLoaded = true;
      if(this._bStartWhenLoaded)
      {
         this.startElement();
      }
   }
   function onSoundComplete()
   {
      this.dispose();
   }
   function onKill()
   {
      _global.clearInterval(this._nKillTimer);
      this.stop();
   }
}
