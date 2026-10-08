class dofus.graphics.gapi.ui.PopupQuantityWithDescription extends dofus.graphics.gapi.ui.PopupQuantity
{
   var _aDescriptionLangKeyParams;
   var _sDescriptionLangKey;
   var _winBackground;
   var api;
   static var CLASS_NAME = "PopupQuantityWithDescription";
   function PopupQuantityWithDescription()
   {
      super();
   }
   function get descriptionLangKey()
   {
      return this._sDescriptionLangKey;
   }
   function set descriptionLangKey(sDescriptionLangKey)
   {
      this._sDescriptionLangKey = sDescriptionLangKey;
   }
   function get descriptionLangKeyParams()
   {
      return this._aDescriptionLangKeyParams;
   }
   function set descriptionLangKeyParams(aDescriptionLangKeyParams)
   {
      this._aDescriptionLangKeyParams = aDescriptionLangKeyParams;
   }
   function refreshDescription()
   {
      if(this._sDescriptionLangKey == undefined)
      {
         return undefined;
      }
      var _loc2_ = this._winBackground.content;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if(this._aDescriptionLangKeyParams != undefined)
      {
         _loc3_ = [];
         _loc4_ = 0;
         while(_loc4_ < this._aDescriptionLangKeyParams.length)
         {
            _loc5_ = this._aDescriptionLangKeyParams[_loc4_];
            if(_loc5_ instanceof Function)
            {
               _loc6_ = _loc5_;
               _loc3_.push(_loc6_.apply(this,[this._nMin,this._nMax,this._nValue]));
            }
            else
            {
               switch(_loc5_)
               {
                  case "value":
                     _loc3_.push(this._nValue);
                     break;
                  case "min":
                     _loc3_.push(this._nMin);
                     break;
                  case "max":
                     _loc3_.push(this._nMax);
                     break;
                  default:
                     _loc3_.push(_loc5_);
               }
            }
            _loc4_ = _loc4_ + 1;
         }
      }
      _loc2_._txtDescription.text = this.api.lang.getText(this._sDescriptionLangKey,_loc3_);
   }
   function initWindowContent()
   {
      super.initWindowContent();
      this.refreshDescription();
   }
   function change(oEvent)
   {
      super.change(oEvent);
      this.refreshDescription();
   }
}
