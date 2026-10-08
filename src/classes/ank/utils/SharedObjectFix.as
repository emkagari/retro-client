class ank.utils.SharedObjectFix
{
   var _so;
   var data;
   static var _oLocalCache = {};
   static var _oRemoteCache = {};
   function SharedObjectFix(oParams)
   {
      if(oParams.persistence == undefined)
      {
         this._so = SharedObject.getLocal(oParams.name,oParams.localPath,oParams.secure);
      }
      else
      {
         this._so = SharedObject.getRemote(oParams.name,oParams.remotePath,oParams.persistence,oParams.secure);
      }
      if(this._so.data._Data == undefined)
      {
         this._so.data._Data = {};
      }
      this.data = this._so.data._Data;
      var self = this;
      this._so.onStatus = function(info)
      {
         if(self.onStatus != undefined)
         {
            self.onStatus(info);
         }
      };
      this._so.onSync = function(list)
      {
         if(self.onSync != undefined)
         {
            self.onSync(list);
         }
      };
   }
   function syncData()
   {
      this._so.data._Data = this.data;
   }
   function clear()
   {
      this._so.clear();
      this._so.data._Data = {};
      this.data = this._so.data._Data;
   }
   function close()
   {
      this.syncData();
      this._so.close();
   }
   function flush(nMinDiskSpace)
   {
      this.syncData();
      var self = this;
      var so = this._so;
      var prev = so.onStatus;
      so.onStatus = function(info)
      {
         if(prev != undefined)
         {
            prev(info);
         }
         if(self.onStatus != undefined)
         {
            self.onStatus(info);
         }
         so.onStatus = function(i_)
         {
            if(self.onStatus != undefined)
            {
               self.onStatus(i_);
            }
         };
      };
      fscommand("trapallkeys","false");
      Selection.setFocus(null);
      var _loc3_ = so.flush(nMinDiskSpace);
      if(_loc3_ != "pending")
      {
         fscommand("trapallkeys","true");
         so.onStatus = function(i_)
         {
            if(self.onStatus != undefined)
            {
               self.onStatus(i_);
            }
         };
      }
      return _loc3_;
   }
   function getSize()
   {
      this.syncData();
      return this._so.getSize();
   }
   function connect(myConnection)
   {
      this.syncData();
      return this._so.connect(myConnection);
   }
   function send()
   {
      this.syncData();
      this._so.send.apply(this._so,arguments);
   }
   function callSharedObject(oArgument)
   {
      this.syncData();
      return this._so.callSharedObject(oArgument);
   }
   function getNative()
   {
      return this._so;
   }
   static function getLocal(name, localPath, secure)
   {
      var _loc5_ = name + "|" + localPath + "|" + secure;
      if(ank.utils.SharedObjectFix._oLocalCache[_loc5_] == undefined)
      {
         ank.utils.SharedObjectFix._oLocalCache[_loc5_] = new ank.utils.SharedObjectFix({name:name,localPath:localPath,secure:secure});
      }
      return ank.utils.SharedObjectFix._oLocalCache[_loc5_];
   }
   static function getRemote(name, remotePath, persistence, secure)
   {
      var _loc6_ = name + "|" + remotePath + "|" + persistence + "|" + secure;
      if(ank.utils.SharedObjectFix._oRemoteCache[_loc6_] == undefined)
      {
         ank.utils.SharedObjectFix._oRemoteCache[_loc6_] = new ank.utils.SharedObjectFix({name:name,remotePath:remotePath,persistence:persistence,secure:secure});
      }
      return ank.utils.SharedObjectFix._oRemoteCache[_loc6_];
   }
   static function deleteAll(url)
   {
      SharedObject.deleteAll(url);
   }
   static function getDiskUsage(url)
   {
      return SharedObject.getDiskUsage(url);
   }
}
