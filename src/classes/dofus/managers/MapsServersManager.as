class dofus.managers.MapsServersManager extends dofus.managers.ServersManager
{
   var addToQueue;
   var api;
   var loadData;
   static var _sSelf = null;
   var _lastLoadedMap = undefined;
   var _aKeys = [];
   var _bBuildingMap = false;
   var _bCustomFileCall = false;
   var _bPreloadCall = false;
   function MapsServersManager()
   {
      super();
      dofus.managers.MapsServersManager._sSelf = this;
   }
   function get isBuilding()
   {
      return this._bBuildingMap;
   }
   function set isBuilding(bBuilding)
   {
      this._bBuildingMap = bBuilding;
   }
   static function getInstance()
   {
      return dofus.managers.MapsServersManager._sSelf;
   }
   function initialize(oAPI)
   {
      super.initialize(oAPI,"maps","maps/");
   }
   function loadMap(sID, sDate, sKey)
   {
      this._lastLoadedMap = undefined;
      if(!_global.isNaN(Number(sID)))
      {
         if(sKey != undefined && sKey.length > 0)
         {
            this._aKeys[Number(sID)] = dofus.aks.Aks.prepareKey(sKey);
         }
         else
         {
            delete this._aKeys[Number(sID)];
         }
      }
      this.loadData(sID + "_" + sDate + (this._aKeys[Number(sID)] == undefined ? "" : "X") + ".swf");
   }
   function getMapName(nMapID)
   {
      var _loc3_ = this.api.lang.getMapText(nMapID);
      var _loc4_ = this.api.lang.getMapAreaInfos(_loc3_.sa);
      var _loc5_ = this.api.lang.getMapAreaText(_loc4_.areaID).n;
      var _loc6_ = this.api.lang.getMapSubAreaName(_loc3_.sa);
      var _loc7_ = _loc5_ + (!dofus.Constants.DEBUG ? "" : " (" + nMapID + ")");
      if(_loc5_ != _loc6_)
      {
         _loc7_ += " (" + _loc6_ + ")";
      }
      return _loc7_;
   }
   function parseMap(oData)
   {
      if(this.api.network.Game.isBusy)
      {
         this.addToQueue({object:this,method:this.parseMap,params:[oData]});
         return undefined;
      }
      var _loc3_ = Number(oData.id);
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      if(this.api.config.isStreaming && this.api.config.streamingMethod == "compact")
      {
         _loc4_ = this.api.lang.getConfigText("INCARNAM_CLASS_MAP");
         _loc5_ = false;
         _loc6_ = 0;
         while(_loc6_ < _loc4_.length && !_loc5_)
         {
            if(_loc4_[_loc6_] == _loc3_)
            {
               _loc5_ = true;
            }
            _loc6_ = _loc6_ + 1;
         }
         if(_loc5_)
         {
            _loc7_ = [dofus.Constants.GFX_ROOT_PATH + "g" + this.api.datacenter.Player.Guild + ".swf",dofus.Constants.GFX_ROOT_PATH + "o" + this.api.datacenter.Player.Guild + ".swf"];
         }
         else
         {
            _loc7_ = [dofus.Constants.GFX_ROOT_PATH + "g0.swf",dofus.Constants.GFX_ROOT_PATH + "o0.swf"];
         }
         if(!this.api.gfx.loadManager.areRegister(_loc7_))
         {
            this.api.gfx.loadManager.loadFiles(_loc7_);
            this.api.gfx.bCustomFileLoaded = false;
         }
         if(this.api.gfx.loadManager.areLoaded(_loc7_))
         {
            this.api.gfx.setCustomGfxFile(_loc7_[0],_loc7_[1]);
         }
         if(!this.api.gfx.bCustomFileLoaded || !this.api.gfx.loadManager.areLoaded(_loc7_))
         {
            _loc8_ = this.api.ui.getUIComponent("CenterTextMap");
            if(!_loc8_)
            {
               _loc8_ = this.api.ui.loadUIComponent("CenterText","CenterTextMap",{text:this.api.lang.getText("LOADING_MAP"),timer:40000},{bForceLoad:true});
            }
            this.api.ui.getUIComponent("CenterTextMap").updateProgressBar("Downloading",this.api.gfx.loadManager.getProgressions(_loc7_),100);
            this.addToQueue({object:this,method:this.parseMap,params:[oData]});
            return undefined;
         }
         if(_loc5_ && !this._bPreloadCall)
         {
            this._bPreloadCall = true;
            org.flashdevelop.utils.FlashConnect.trace("preload","dofus.managers.MapsServersManager::parseMap","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/managers/MapsServersManager.as",146);
            this.api.gfx.loadManager.loadFiles([dofus.Constants.CLIPS_PERSOS_PATH + (this.api.datacenter.Player.Guild * 10 + this.api.datacenter.Player.Sex) + ".swf",dofus.Constants.CLIPS_PERSOS_PATH + "9059.swf",dofus.Constants.CLIPS_PERSOS_PATH + "9091.swf",dofus.Constants.CLIPS_PERSOS_PATH + "1219.swf",dofus.Constants.CLIPS_PERSOS_PATH + "101.swf",dofus.Constants.GFX_ROOT_PATH + "g0.swf",dofus.Constants.GFX_ROOT_PATH + "o0.swf"]);
         }
      }
      org.flashdevelop.utils.FlashConnect.trace("===== Build Map =====","dofus.managers.MapsServersManager::parseMap","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/managers/MapsServersManager.as",157);
      this._bCustomFileCall = false;
      if(this.api.network.Game.nLastMapIdReceived != _loc3_ && (this.api.network.Game.nLastMapIdReceived != -1 && this.api.lang.getConfigText("CHECK_MAP_FILE_ID")))
      {
         org.flashdevelop.utils.FlashConnect.trace("Donnée de map ne correspondant pas à la carte courante","dofus.managers.MapsServersManager::parseMap","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/managers/MapsServersManager.as",164);
         this.api.gfx.onMapLoaded();
         return undefined;
      }
      this._bBuildingMap = true;
      this._lastLoadedMap = oData;
      var _loc9_ = this.getMapName(_loc3_);
      var _loc10_ = Number(oData.width);
      var _loc11_ = Number(oData.height);
      var _loc12_ = Number(oData.backgroundNum);
      var _loc13_ = this._aKeys[_loc3_] == undefined ? oData.mapData : dofus.aks.Aks.decypherData(oData.mapData,this._aKeys[_loc3_],_global.parseInt(dofus.aks.Aks.checksum(this._aKeys[_loc3_]),16) * 2);
      var _loc14_ = oData.ambianceId;
      var _loc15_ = oData.musicId;
      var _loc16_ = oData.bOutdoor != 1 ? false : true;
      var _loc17_ = (oData.capabilities & 1) == 0;
      var _loc18_ = (oData.capabilities >> 1 & 1) == 0;
      var _loc19_ = (oData.capabilities >> 2 & 1) == 0;
      var _loc20_ = (oData.capabilities >> 3 & 1) == 0;
      var _loc21_ = oData.canAggro != 1 ? false : true;
      var _loc22_ = oData.canUseObject != 1 ? false : true;
      var _loc23_ = oData.canUseInventory != 1 ? false : true;
      var _loc24_ = oData.canChangeCharac != 1 ? false : true;
      org.flashdevelop.utils.FlashConnect.trace("[MapServiceManager] (parseMap) Map " + _loc3_ + " : " + _loc18_,"dofus.managers.MapsServersManager::parseMap","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/managers/MapsServersManager.as",193);
      this.api.datacenter.Basics.aks_current_map_id = _loc3_;
      this.api.kernel.TipsManager.onNewMap(_loc3_);
      this.api.kernel.StreamingDisplayManager.onNewMap(_loc3_);
      var _loc25_ = new dofus.datacenter.DofusMap(_loc3_);
      _loc25_.bCanChallenge = _loc17_;
      _loc25_.bCanAttack = _loc18_;
      _loc25_.bSaveTeleport = _loc19_;
      _loc25_.bUseTeleport = _loc20_;
      _loc25_.bOutdoor = _loc16_;
      _loc25_.bCanAttackHunt = _loc21_;
      _loc25_.bCanUseItem = _loc22_;
      _loc25_.bCanEquipItem = _loc23_;
      _loc25_.bCanBoostStats = _loc24_;
      _loc25_.ambianceID = _loc14_;
      _loc25_.musicID = _loc15_;
      this.api.gfx.buildMap(_loc3_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc25_);
      if(this.api.network.Basics.lastReceivedReferenceTime != undefined)
      {
         this.api.kernel.NightManager.setReferenceTime(this.api.network.Basics.lastReceivedReferenceTime,this.api.kernel.OptionsManager.getOption("NightMode"),_loc25_);
      }
      this._bBuildingMap = false;
      org.flashdevelop.utils.FlashConnect.trace("===== Map Built =====","dofus.managers.MapsServersManager::parseMap","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/managers/MapsServersManager.as",229);
   }
   function onComplete(mc)
   {
      var _loc3_ = mc;
      this.parseMap(_loc3_);
   }
   function onFailed()
   {
      this.api.kernel.showMessage(undefined,this.api.lang.getText("NO_MAPDATA_FILE"),"ERROR_BOX",{name:"NoMapData"});
   }
}
