class dofus.graphics.gapi.controls.RightClickContextItemViewer
{
   var api;
   function RightClickContextItemViewer(api_)
   {
      this.api = api_;
   }
   function createActionPopupMenu(oItem_)
   {
      var _loc3_ = this.api.ui.createPopupMenu();
      _loc3_.addStaticItem(oItem_.name);
      _loc3_.addItem(this.api.lang.getText("CLICK_TO_INSERT"),this.api.kernel.GameManager,this.api.kernel.GameManager.insertItemInChat,[oItem_]);
      _loc3_.addItem(this.api.lang.getText("ASSOCIATE_RECEIPTS"),this,this.showAssociateReceipts,[oItem_]);
      if(oItem_.isSearchableInEncyclopedia)
      {
         _loc3_.addItem(this.api.lang.getText("VIEW_IN_ENCYCLOPEDIA"),dofus.graphics.gapi.ui.Encyclopedia,dofus.graphics.gapi.ui.Encyclopedia.openEncyclopediaForItem,[oItem_]);
      }
      if(oItem_.isDroppable)
      {
         _loc3_.addItem(this.api.lang.getText("DISPLAY_MONSTERS_WHO_DROP_ITEM"),this,this.displayMonsterWhoDrops,[oItem_]);
      }
      if(this.api.datacenter.Player.isAuthorized && dofus.Constants.DEBUG)
      {
         _loc3_.addItem("[Debug] Give item",this.api.network.Basics,this.api.network.Basics.autorisedCommand,["item * " + oItem_.unicID + " 1"]);
      }
      _loc3_.show(_root._xmouse,_root._ymouse);
   }
   function showAssociateReceipts(oItem_)
   {
      if(this.api.ui.getUIComponent("ItemUtility") != undefined)
      {
         this.api.ui.unloadUIComponent("ItemUtility");
      }
      this.api.ui.loadUIComponent("ItemUtility","ItemUtility",{item:oItem_},{bAlwaysOnTop:true});
   }
   function displayMonsterWhoDrops(oItem_)
   {
      var _loc3_ = this.api.ui.getUIComponent("Encyclopedia");
      var _loc4_ = dofus.datacenter.Item.droppedFromMonstersWithEnabledCriterions(oItem_.unicID);
      if(_loc3_ != undefined)
      {
         _loc3_.setCurrentTab("Bestiary",_loc4_);
      }
      else
      {
         this.api.ui.loadUIAutoHideComponent("Encyclopedia","Encyclopedia",{_sCurrentTab:"Bestiary",_aSearchedIDs:_loc4_},{bStayIfPresent:true});
      }
   }
}
