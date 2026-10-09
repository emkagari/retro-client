class dofus.graphics.gapi.controls.GuildHousesViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnTeleport;
   var _hSelectedHouse;
   var _lblCoordsTitle;
   var _lblDescription;
   var _lblHouse;
   var _lblHouseCoords;
   var _lblHouseName;
   var _lblHouseOwner;
   var _lblOwner;
   var _lblOwnerTitle;
   var _lblRightsTitle;
   var _lblSelectHouse;
   var _lblSkillsTitle;
   var _lstHouses;
   var _lstRights;
   var _lstSkills;
   var _mcHouseIcon;
   var _mcMask;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "GuildHousesViewer";
   function GuildHousesViewer()
   {
      super();
   }
   function set houses(eaHouses)
   {
      this.updateData(eaHouses);
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.GuildHousesViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
   }
   function initTexts()
   {
      this._lblDescription.text = this.api.lang.getText("GUILD_HOUSES_LIST");
      this._lblHouseCoords.text = this.api.lang.getText("HOUSE_WORD");
      this._lblOwner.text = this.api.lang.getText("OWNER_WORD");
      this._lblCoordsTitle.text = this.api.lang.getText("COORDINATES");
      this._lblRightsTitle.text = this.api.lang.getText("OWNER_WORD");
      this._lstHouses.text = this.api.lang.getText("SKILLS");
      this._lblSelectHouse.text = this.api.lang.getText("RIGHTS");
      this._lblHouse.text = this.api.lang.getText("SELECT_A_HOUSE");
      this._btnTeleport.label = this.api.lang.getText("JOIN_SMALL");
   }
   function addListeners()
   {
      this._lblSkillsTitle.addEventListener("itemSelected",this);
      this._btnTeleport.addEventListener("click",this);
   }
   function updateData(eaHouses)
   {
      this._lblSkillsTitle.dataProvider = eaHouses;
   }
   function itemSelected(oEvent)
   {
      this._hSelectedHouse = dofus.datacenter.House(oEvent.row.item);
      this._lblHouseOwner.text = this._hSelectedHouse.name;
      this._lblHouseName.text = this._hSelectedHouse.coords.x + ";" + this._hSelectedHouse.coords.y;
      this._lblOwnerTitle.text = this._hSelectedHouse.ownerName;
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < this._hSelectedHouse.skills.length)
      {
         _loc5_ = new dofus.datacenter.Skill(this._hSelectedHouse.skills[_loc4_]);
         if(!_global.isNaN(_loc5_.id))
         {
            _loc3_.push({id:_loc5_.id,label:_loc5_.description});
         }
         _loc4_ = _loc4_ + 1;
      }
      this._lstSkills.dataProvider = _loc3_;
      this._lstRights.dataProvider = this._hSelectedHouse.getHumanReadableRightsList();
      this._btnTeleport._visible = this._hSelectedHouse.hasRight(dofus.datacenter.House.GUILDSHARE_TELEPORT);
      if(!this._btnTeleport._visible)
      {
         if(!this._mcHouseIcon.moved)
         {
            this._mcHouseIcon.moved = true;
            this._mcHouseIcon._y += this._btnTeleport._height / 2;
         }
      }
      this._mcMask._visible = false;
      this._lblHouse._visible = false;
   }
   function click(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._btnTeleport)
      {
         if(this._hSelectedHouse == null)
         {
            return undefined;
         }
         if(!this._hSelectedHouse.hasRight(dofus.datacenter.House.GUILDSHARE_TELEPORT))
         {
            return undefined;
         }
         this.api.network.Guild.teleportToGuildHouse(this._hSelectedHouse.id,this._hSelectedHouse.instanceID);
      }
   }
   function over(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._btnTeleport)
      {
         this.gapi.showTooltip(this.api.lang.getText("GUILD_HOUSE_TELEPORT_TOOLTIP"));
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
