class dofus.datacenter.Craft extends Object
{
   var _aItems;
   var _nDifficulty;
   var _oSkill;
   var api;
   var name;
   function Craft(nID, oSkill)
   {
      super();
      this.initialize(nID,oSkill);
   }
   function get skill()
   {
      return this._nDifficulty;
   }
   function get craftItem()
   {
      return this._oSkill;
   }
   function get items()
   {
      return this._aItems;
   }
   function get itemsCount()
   {
      return this._aItems.length;
   }
   function get craftLevel()
   {
      return this.craftItem.level;
   }
   function get difficultyValue()
   {
      var _loc2_ = this.api.datacenter.Player.getJobInfo(this._nDifficulty.job).level;
      org.flashdevelop.utils.FlashConnect.trace(this._nDifficulty.job + " " + this.api.datacenter.Player.getJobInfo(this._nDifficulty.job) + " " + _loc2_,"dofus.datacenter.Craft::difficulty","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/datacenter/Craft.as",67);
      if(this._aItems.length < Number(this._nDifficulty.param1) - 4)
      {
         return 1;
      }
      if(this._aItems.length < Number(this._nDifficulty.param1) - 2 || _loc2_ == 100)
      {
         return 2;
      }
      return 3;
   }
   function initialize(nID, oSkill)
   {
      this.api = _global.API;
      this._nDifficulty = oSkill;
      this._oSkill = new dofus.datacenter.Item(0,nID,1);
      this.name = this._oSkill.name;
      var _loc4_ = this.api.lang.getCraftText(nID);
      this._aItems = [];
      var _loc5_;
      var _loc6_;
      if(!_global.isNaN(_loc4_.length))
      {
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = new dofus.datacenter.Item(0,_loc4_[_loc5_][0],_loc4_[_loc5_][1]);
            this._aItems.push(_loc6_);
            _loc5_ = _loc5_ + 1;
         }
      }
   }
}
