class dofus.managers.ServerEvenementialManager extends Object
{
   var api;
   var sLastTab;
   function ServerEvenementialManager()
   {
      super();
      this.api = _global.API;
   }
   function get isActif()
   {
      return this.api.datacenter.Season.hasData && this.api.datacenter.Basics.aks_current_server.isSeasonal() || this.api.datacenter.Player.isAuthorized;
   }
   function get lastTab()
   {
      return this.sLastTab;
   }
   function set lastTab(currentTab)
   {
      this.sLastTab = currentTab;
   }
}
