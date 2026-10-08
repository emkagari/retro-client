class dofus.graphics.gapi.controls.Card extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bIsCardFoil;
   var _bIsCardUnlocked;
   var _lblCardID;
   var _lblCardName;
   var _lblCardNameNotUnlocked;
   var _ldrCardIcon;
   var _ldrFamilyIcon;
   var _mcCardIDBackground;
   var _mcCardLabelBackground;
   var _mcFamilyCardBackground;
   var _mcFamilyCardForeground;
   var _mcFoilMask;
   var _mcInventory;
   var _nCardID;
   var _nCardRarity;
   var _nFamilyID;
   var _sCardGfx;
   var _sCardName;
   var addToQueue;
   static var CLASS_NAME = "Card";
   static var CARD_CLIP_FOLDER = 118;
   function Card()
   {
      super();
      this.initialize();
   }
   function get ID()
   {
      return this._nCardID;
   }
   function set ID(nCardID)
   {
      this._nCardID = nCardID;
   }
   function get familyID()
   {
      return this._nFamilyID;
   }
   function set familyID(nFamilyID)
   {
      this._nFamilyID = nFamilyID;
   }
   function get name()
   {
      return this._sCardName;
   }
   function set name(sCardName)
   {
      this._sCardName = sCardName;
   }
   function get rarity()
   {
      return this._nCardRarity;
   }
   function set rarity(nCardRarity)
   {
      this._nCardRarity = nCardRarity;
   }
   function get gfx()
   {
      return this._sCardGfx;
   }
   function set gfx(sCardGfx)
   {
      this._sCardGfx = sCardGfx;
   }
   function get iconCardFile()
   {
      return dofus.Constants.ITEMS_PATH + (this.rarity + dofus.graphics.gapi.controls.Card.CARD_CLIP_FOLDER) + this.ID + ".swf";
   }
   function get iconFamilyFile()
   {
      return dofus.Constants.FAMILY_CLIP_FOLDER + this.familyID + ".swf";
   }
   function get isUnlocked()
   {
      return this._bIsCardUnlocked;
   }
   function set isUnlocked(bIsCardUnlocked)
   {
      this._bIsCardUnlocked = bIsCardUnlocked;
   }
   function get isFoil()
   {
      return this._bIsCardFoil;
   }
   function set isFoil(bFoil)
   {
      this._bIsCardFoil = bFoil;
   }
   function initialize(nCardID, nFamilyID, sCardName, nCardRarity, sCardGfx, bIsCardUnlocked, bIsCardFoil)
   {
      this.api = _global.API;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.Card.CLASS_NAME);
      this._mcCardLabelBackground._visible = false;
      this._mcFamilyCardBackground._visible = false;
      this._mcFamilyCardForeground._visible = false;
      this._lblCardName._visible = false;
      this._mcCardIDBackground._visible = false;
      this._lblCardID._visible = false;
      this._mcFoilMask._visible = false;
      this._mcInventory._visible = false;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
   }
   function initData()
   {
      var _loc2_;
      var _loc3_;
      if(this._bIsCardUnlocked)
      {
         this._lblCardName.text = this.name;
         if(this._lblCardName.textWidth > 46)
         {
            this._mcCardLabelBackground._height = 10;
            this._mcCardLabelBackground._y -= 4;
            this._lblCardName.setSize(47,15);
            this._lblCardName._x += 1;
            this._lblCardName._y -= 1.68;
            this._lblCardName.multiline = true;
            this._lblCardName.wordWrap = true;
            this._lblCardName.styleName = "BrownCenterExtraSmallBoldCard";
         }
         this._ldrCardIcon._rotation = 30;
         this._ldrCardIcon.contentPath = dofus.Constants.ITEMS_PATH + this.getItemCategoryIDByRarity() + "/" + this.ID + ".swf";
         this._ldrFamilyIcon.contentPath = dofus.Constants.FAMILY_CLIP_FOLDER + this.familyID + ".swf";
         this._lblCardID.text = "#" + this.ID;
         this._mcCardLabelBackground._visible = true;
         this._mcFamilyCardBackground._visible = true;
         this._mcFamilyCardForeground._visible = true;
         this._lblCardName._visible = true;
         this._mcCardIDBackground._visible = true;
         this._lblCardID._visible = true;
         this._mcFoilMask._visible = this._bIsCardFoil;
      }
      else
      {
         this._lblCardNameNotUnlocked.text = "#" + this.ID + " " + this.name + "\n\n" + this.api.lang.getText("RARITY") + " : " + this.rarity;
         this._lblCardNameNotUnlocked.styleName = "BrownCenterMediumBoldCardLabel";
         _loc2_ = new dofus.datacenter.ttg.TtgCard(this.ID,false);
         _loc3_ = dofus.datacenter.Item(this.api.datacenter.Player.Inventory.findFirstItem("unicID",_loc2_.correspondingItemID).item);
         if(_loc3_ != undefined)
         {
            this._mcInventory._visible = true;
         }
      }
   }
   function initTexts()
   {
   }
   function getItemCategoryIDByRarity()
   {
      switch(this.rarity)
      {
         case dofus.datacenter.ttg.TtgCard.CARD_RARITY_COMMON:
            return 119;
         case dofus.datacenter.ttg.TtgCard.CARD_RARITY_RARE:
            return 120;
         case dofus.datacenter.ttg.TtgCard.CARD_RARITY_EPIC:
            return 121;
         case dofus.datacenter.ttg.TtgCard.CARD_RARITY_UNIC:
            return 122;
         default:
            return;
      }
   }
}
