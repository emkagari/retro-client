class dofus.datacenter.Title extends Object
{
   var _nColor;
   var _nID;
   var _nType;
   var _sText;
   var api;
   function Title(nID, sParam, nType, nSex)
   {
      super();
      this.api = _global.API;
      this._nID = nID;
      this._nType = nType;
      var _loc7_ = this.api.lang.getTitle(nID);
      var _loc8_ = nSex == undefined ? this.api.datacenter.Player.Sex : nSex;
      var _loc9_ = _loc8_ != 0 ? _loc7_.tf : _loc7_.t;
      var _loc0_;
      var _loc10_;
      if((_loc0_ = _loc7_.pt) !== 1)
      {
         _loc9_ = _loc9_.split("%1").join(sParam);
      }
      else
      {
         _loc10_ = this.api.lang.getMonsters()[Number(sParam)].n;
         _loc9_ = _loc9_.split("%1").join(_loc10_);
      }
      this._sText = "« " + _loc9_ + " »";
      this._nColor = _loc7_.c;
   }
   function get color()
   {
      return this._nColor;
   }
   function get text()
   {
      var _loc2_ = this._sText;
      var _loc3_;
      if(dofus.Constants.DEBUG)
      {
         _loc3_ = " (" + this._nID + ")";
         _loc2_ += _loc3_;
      }
      return _loc2_;
   }
   function get id()
   {
      return this._nID;
   }
   function get type()
   {
      return this._nType;
   }
   function get iconFile()
   {
      return dofus.Constants.TITLES_PATH + this._nType + ".swf";
   }
   function toString()
   {
      if(this._nType == undefined)
      {
         return undefined;
      }
      var _loc2_ = "<b>" + this.api.lang.getText("TITLE") + " : " + this._sText + "</b>\n\n";
      _loc2_ += this.api.lang.getText("TITLE_ABOUT_TYPE_" + this._nType);
      return _loc2_;
   }
}
