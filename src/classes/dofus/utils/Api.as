class dofus.utils.Api extends Object
{
   var _oColors;
   var _oConfig;
   var _oDatacenter;
   var _oElectron;
   var _oGfx;
   var _oKernel;
   var _oLang;
   var _oMouseClicksMemorizer;
   var _oNetwork;
   var _oSounds;
   var _oUI;
   static var _oLastInstance;
   function Api()
   {
      super();
      dofus.utils.Api._oLastInstance = this;
   }
   static function getInstance()
   {
      return dofus.utils.Api._oLastInstance;
   }
   function get config()
   {
      return this._oConfig;
   }
   function get kernel()
   {
      return this._oLang;
   }
   function get datacenter()
   {
      return this._oDatacenter;
   }
   function get network()
   {
      return this._oUI;
   }
   function get gfx()
   {
      return this._oGfx;
   }
   function get ui()
   {
      return this._oNetwork;
   }
   function get sounds()
   {
      return this._oMouseClicksMemorizer;
   }
   function get lang()
   {
      return this._oKernel;
   }
   function get colors()
   {
      return this._oColors;
   }
   function get electron()
   {
      return this._oElectron;
   }
   function get mouseClicksMemorizer()
   {
      return this._oSounds;
   }
   function initialize()
   {
      this._oConfig = _global.CONFIG;
      this._oKernel = new dofus.utils.DofusTranslator();
      var _loc2_ = dofus.DofusCore.getClip();
      this._oNetwork = _loc2_.GAPI;
      this._oNetwork.api = this;
      this._oElectron = new dofus.Electron(this);
      this._oLang = new dofus.Kernel(this);
      this._oMouseClicksMemorizer = dofus.sounds.AudioManager.getInstance();
      _global.SOMA = this._oMouseClicksMemorizer;
      this._oDatacenter = new dofus.datacenter.Datacenter(this);
      this._oUI = new dofus.aks.Aks(this);
      this._oGfx = _loc2_.BATTLEFIELD;
      if(this._oConfig.isStreaming && this._oConfig.streamingMethod == "explod")
      {
         this._oGfx.initialize(this._oDatacenter,dofus.Constants.OBJECTS_LIGHT_FILE,dofus.Constants.OBJECTS_LIGHT_FILE,dofus.Constants.ACCESSORIES_PATH,this);
      }
      else
      {
         this._oGfx.initialize(this._oDatacenter,dofus.Constants.GROUND_FILE,dofus.Constants.OBJECTS_FILE,dofus.Constants.ACCESSORIES_PATH,this);
      }
      this._oColors = _global.GAC;
      this._oConfig.languages = this._oKernel.getConfigText("LANGUAGES_LIST");
      this._oConfig.languagesFullName = this._oKernel.getConfigText("LANGUAGES_FULLNAME_LIST");
      this._oSounds = new ank.utils.MouseClicksMemorizer();
      _root.menu = new ank.gapi.controls.RightClickContextMenu(this);
      if(this.ui.getUIComponent("Zoom") == undefined)
      {
         this.ui.loadUIComponent("Zoom","Zoom");
      }
   }
   function checkFileSize(sFile, nCheckID)
   {
      var _loc2_ = sFile.split("*");
      sFile = _loc2_[0];
      var sCheckParams = "";
      if(_loc2_.length > 1)
      {
         sCheckParams = _loc2_[1];
      }
      var _loc3_ = !this.datacenter.Player.isAuthorized && (!this.datacenter.Player.isSkippingFightAnimations && (!this.datacenter.Player.isSkippingLootPanel && this.ui.getUIComponent("Debug") == undefined));
      var _loc4_;
      if(_loc3_)
      {
         _loc4_ = _global.CONFIG.connexionServer.ip;
         if(_loc4_ == undefined)
         {
            _loc4_ = this.datacenter.Basics.serverHost;
         }
         if(_loc4_ != undefined && (_loc4_.indexOf("127.0.0.1") == 0 || _loc4_.indexOf("192.168") == 0))
         {
            _loc3_ = !_loc3_;
         }
      }
      var nAddition = _loc3_ ? -10 : 0;
      var _loc5_ = {};
      var ref = this;
      _loc5_.onLoadInit = function(mc_, httpStatus)
      {
         var _loc4_ = mc_.getBytesTotal() + nAddition;
         var _loc5_ = "CHALLENGE";
         var _loc6_ = mc_[_loc5_];
         var _loc7_;
         var _loc8_;
         var _loc9_;
         if(_loc6_ != undefined)
         {
            _loc7_ = false;
            _loc8_ = 0;
            while(_loc8_ < ref.config.dataServers.length)
            {
               if(sFile.indexOf(ref.config.dataServers[_loc8_].url) == 0)
               {
                  _loc7_ = true;
               }
               _loc8_ = _loc8_ + 1;
            }
            if(_loc7_)
            {
               _loc9_ = Number(_loc6_.apply(ref,[_root,_global,sFile,nCheckID,sCheckParams]));
               if(_global.isNaN(_loc9_))
               {
                  mc_.removeMovieClip();
                  return undefined;
               }
               _loc4_ = _loc9_;
            }
         }
         ref.onFileCheckFinished(true,_loc4_,nCheckID);
         mc_.removeMovieClip();
      };
      _loc5_.onLoadError = function(mc_, errorCode, httpStatus)
      {
         var _loc5_ = mc_.getBytesTotal() + nAddition;
         ref.onFileCheckFinished(true,_loc5_,nCheckID);
         mc_.removeMovieClip();
      };
      var _loc6_ = dofus.DofusCore.getInstance().getTemporaryContainer();
      var _loc7_ = _loc6_.createEmptyMovieClip("FC" + nCheckID,_loc6_.getNextHighestDepth());
      var _loc8_ = new MovieClipLoader();
      _loc8_.addListener(_loc5_);
      _loc8_.loadClip(sFile,_loc7_);
   }
   function onFileCheckFinished(bSuccess, nFileSize, nCheckID)
   {
      this.network.Basics.fileCheckAnswer(nCheckID,!bSuccess ? -1 : nFileSize);
   }
}
