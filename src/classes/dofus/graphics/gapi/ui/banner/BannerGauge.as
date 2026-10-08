class dofus.graphics.gapi.ui.banner.BannerGauge
{
   function BannerGauge()
   {
   }
   static function showGaugeMode(mcBanner)
   {
      if(mcBanner.api.datacenter.Player.XP == undefined || mcBanner.api.datacenter.Game.isFight)
      {
         return undefined;
      }
      var _loc3_ = mcBanner.api.kernel.OptionsManager.getOption("BannerGaugeMode");
      if(mcBanner._mcCurrentXtraMask == mcBanner._mcCircleXtraMaskBig || _loc3_ == "none")
      {
         mcBanner.circleXtra.setXtraFightMask(false);
         return undefined;
      }
      mcBanner.circleXtra.setXtraFightMask(true);
      mcBanner.showOverweightPods(false);
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      switch(_loc3_)
      {
         case "xp":
            _loc4_ = mcBanner.api.datacenter.Player.currentXPPercent;
            _loc5_ = 8298148;
            break;
         case "xpmount":
            if(mcBanner.api.datacenter.Player.mount == undefined)
            {
               _loc4_ = 0;
            }
            else
            {
               _loc4_ = Math.floor((mcBanner.api.datacenter.Player.mount.xp - mcBanner.api.datacenter.Player.mount.xpMin) / (mcBanner.api.datacenter.Player.mount.xpMax - mcBanner.api.datacenter.Player.mount.xpMin) * 100);
            }
            _loc5_ = 8298148;
            break;
         case "pods":
            if(mcBanner.api.datacenter.Player.isOverWeight)
            {
               _loc4_ = Math.floor(mcBanner.api.datacenter.Player.currentOverWeight / mcBanner.api.datacenter.Player.maxOverWeight * 100);
               _loc5_ = 16756480;
               mcBanner.showOverweightPods(true);
            }
            else
            {
               _loc4_ = Math.floor(mcBanner.api.datacenter.Player.currentWeight / mcBanner.api.datacenter.Player.maxWeight * 100);
               _loc5_ = 16737792;
            }
            break;
         case "energy":
            if(mcBanner.api.datacenter.Player.EnergyMax == -1)
            {
               _loc4_ = 0;
            }
            else
            {
               _loc4_ = Math.floor(mcBanner.api.datacenter.Player.Energy / mcBanner.api.datacenter.Player.EnergyMax * 100);
            }
            _loc5_ = 10994717;
            break;
         case "xpcurrentjob":
            _loc6_ = mcBanner.api.datacenter.Player.currentJobID;
            if(_loc6_ != undefined)
            {
               _loc7_ = mcBanner.api.datacenter.Player.Jobs.findFirstItem("id",_loc6_).item;
               if(_loc7_.xpMax != -1)
               {
                  _loc4_ = Math.floor((_loc7_.xp - _loc7_.xpMin) / (_loc7_.xpMax - _loc7_.xpMin) * 100);
               }
               else
               {
                  _loc4_ = 0;
               }
            }
            else
            {
               _loc4_ = 0;
            }
            _loc5_ = 10441125;
            break;
         case "tempotons":
            _loc8_ = mcBanner.api.datacenter.Player.Inventory.findFirstItem("unicID",dofus.graphics.gapi.controls.temporis.TemporisGeneral.TEMPOTON_ID);
            _loc9_ = _loc8_.item;
            _loc4_ = _loc9_.Quantity / Number(mcBanner.api.lang.getConfigText("TEMPORIS_3_TEMPOTONS_MAX_COUNT")) * 100;
            _loc5_ = 16239703;
      }
      if(!_global.isNaN(_loc5_))
      {
         if(_global.isNaN(_loc4_))
         {
            _loc4_ = 0;
         }
         mcBanner._ccChrono._visible = true;
         mcBanner._ccChrono.setGaugeChrono(_loc4_,_loc5_);
      }
   }
   static function setGaugeMode(mcBanner, sGaugeMode)
   {
      mcBanner._mcCurrentXtraMask = sGaugeMode != "none" ? mcBanner._mcCircleXtraMask : mcBanner._mcCircleXtraMaskBig;
      var _loc4_ = mcBanner.api.kernel.OptionsManager.getOption("BannerGaugeMode");
      switch(_loc4_)
      {
         case "xp":
            mcBanner.api.datacenter.Player.removeEventListener("xpChanged",mcBanner);
            break;
         case "xpmount":
            mcBanner.api.datacenter.Player.removeEventListener("mountChanged",mcBanner);
            break;
         case "pods":
            mcBanner.api.datacenter.Player.removeEventListener("currentWeightChanged",mcBanner);
            break;
         case "energy":
            mcBanner.api.datacenter.Player.removeEventListener("energyChanged",mcBanner);
            break;
         case "xpcurrentjob":
            mcBanner.api.datacenter.Player.removeEventListener("currentJobChanged",mcBanner);
            break;
         case "tempotons":
            mcBanner.api.datacenter.Player.removeEventListener("tempotonsChanged",mcBanner);
      }
      mcBanner.api.kernel.OptionsManager.setOption("BannerGaugeMode",sGaugeMode);
      switch(sGaugeMode)
      {
         case "xp":
            mcBanner.api.datacenter.Player.addEventListener("xpChanged",mcBanner);
            break;
         case "xpmount":
            mcBanner.api.datacenter.Player.addEventListener("mountChanged",mcBanner);
            break;
         case "pods":
            mcBanner.api.datacenter.Player.addEventListener("currentWeightChanged",mcBanner);
            break;
         case "energy":
            mcBanner.api.datacenter.Player.addEventListener("energyChanged",mcBanner);
            break;
         case "xpcurrentjob":
            mcBanner.api.datacenter.Player.addEventListener("currentJobChanged",mcBanner);
            break;
         case "tempotons":
            mcBanner.api.datacenter.Player.addEventListener("tempotonsChanged",mcBanner);
      }
      dofus.graphics.gapi.ui.banner.BannerGauge.showGaugeMode(mcBanner);
   }
   static function showGaugeModeSelectMenu(mcBanner)
   {
      var _loc3_ = mcBanner.api.kernel.OptionsManager.getOption("BannerGaugeMode");
      var _loc4_ = mcBanner.api.ui.createPopupMenu();
      _loc4_.addItem(mcBanner.api.lang.getText("DISABLE"),dofus.graphics.gapi.ui.banner.BannerGauge,dofus.graphics.gapi.ui.banner.BannerGauge.setGaugeMode,[mcBanner,"none"],_loc3_ != "none");
      _loc4_.addItem(mcBanner.api.lang.getText("WORD_XP"),dofus.graphics.gapi.ui.banner.BannerGauge,dofus.graphics.gapi.ui.banner.BannerGauge.setGaugeMode,[mcBanner,"xp"],_loc3_ != "xp");
      _loc4_.addItem(mcBanner.api.lang.getText("WORD_XP") + " " + mcBanner.api.lang.getText("JOB"),dofus.graphics.gapi.ui.banner.BannerGauge,dofus.graphics.gapi.ui.banner.BannerGauge.setGaugeMode,[mcBanner,"xpcurrentjob"],_loc3_ != "xpcurrentjob");
      _loc4_.addItem(mcBanner.api.lang.getText("WORD_XP") + " " + mcBanner.api.lang.getText("MOUNT"),dofus.graphics.gapi.ui.banner.BannerGauge,dofus.graphics.gapi.ui.banner.BannerGauge.setGaugeMode,[mcBanner,"xpmount"],_loc3_ != "xpmount");
      _loc4_.addItem(mcBanner.api.lang.getText("WEIGHT"),dofus.graphics.gapi.ui.banner.BannerGauge,dofus.graphics.gapi.ui.banner.BannerGauge.setGaugeMode,[mcBanner,"pods"],_loc3_ != "pods");
      _loc4_.addItem(mcBanner.api.lang.getText("ENERGY"),dofus.graphics.gapi.ui.banner.BannerGauge,dofus.graphics.gapi.ui.banner.BannerGauge.setGaugeMode,[mcBanner,"energy"],_loc3_ != "energy");
      if(_global.API.datacenter.Basics.aks_current_server.isTemporis())
      {
         _loc4_.addItem(mcBanner.api.lang.getText("TEMPOTONS"),dofus.graphics.gapi.ui.banner.BannerGauge,dofus.graphics.gapi.ui.banner.BannerGauge.setGaugeMode,[mcBanner,"tempotons"],_loc3_ != "tempotons");
      }
      _loc4_.show(_root._xmouse,_root._ymouse,true);
   }
}
