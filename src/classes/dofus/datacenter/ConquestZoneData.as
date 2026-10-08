class dofus.datacenter.ConquestZoneData extends dofus.utils.ApiElement
{
   var _bAttackable;
   var _bFighting;
   var _nAlignment;
   var _nPrismMap;
   var _nSubAreaId;
   var areaName;
   function ConquestZoneData(id, alignment, fighting, prism, attackable)
   {
      super();
      this._nSubAreaId = id;
      this._nAlignment = alignment;
      this._bFighting = fighting;
      this._nPrismMap = prism;
      this._bAttackable = attackable;
      this.areaName = _global.API.lang.getMapAreaText(Number(_global.API.lang.getMapSubAreaText(this._nSubAreaId).a)).n;
   }
   function get id()
   {
      return this._nSubAreaId;
   }
   function get areaId()
   {
      return Number(_global.API.lang.getMapSubAreaText(this._nSubAreaId).a);
   }
   function get alignment()
   {
      return this._nAlignment;
   }
   function get fighting()
   {
      return this._bFighting;
   }
   function get subway()
   {
      return this._nPrismMap;
   }
   function get attackable()
   {
      return this._bAttackable;
   }
   function isCapturable()
   {
      if(!this._bAttackable)
      {
         return false;
      }
      if(this.alignment == this.api.datacenter.Player.alignment.index)
      {
         return false;
      }
      var _loc2_ = this.getNearZonesList();
      var _loc3_ = this.api.datacenter.Conquest.worldDatas;
      for(var s in _loc2_)
      {
         if(_loc3_.areas.findFirstItem("id",_loc2_[s]).item.alignment == this.api.datacenter.Player.alignment.index)
         {
            return true;
         }
      }
      return false;
   }
   function isVulnerable()
   {
      if(!this._bAttackable)
      {
         return false;
      }
      if(this.alignment != this.api.datacenter.Player.alignment.index)
      {
         return false;
      }
      var _loc2_ = this.getNearZonesList();
      var _loc3_ = this.api.datacenter.Conquest.worldDatas;
      var _loc4_;
      for(var s in _loc2_)
      {
         _loc4_ = _loc3_.areas.findFirstItem("id",_loc2_[s]).item.alignment;
         if(_loc4_ != this.api.datacenter.Player.alignment.index && _loc4_ > 0)
         {
            return true;
         }
      }
      return false;
   }
   function getNearZonesList()
   {
      return this.api.lang.getMapSubAreaText(this._nSubAreaId).v;
   }
   function toString()
   {
      return "N:" + this.areaName + "/A:" + this.areaId + "/S:" + this.id;
   }
}
