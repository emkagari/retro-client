class dofus.graphics.gapi.controls.StatsViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _dgStats;
   var _winBg;
   var addToQueue;
   static var CLASS_NAME = "StatsViewer";
   function StatsViewer()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.StatsViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function initTexts()
   {
      this._winBg.title = this.api.lang.getText("ADVANCED_STATS");
      this._dgStats.columnsNames = [this.api.lang.getText("STAT_WORD"),this.api.lang.getText("BASE_WORD"),this.api.lang.getText("ADDITIONNAL"),this.api.lang.getText("STUFF_WORD"),this.api.lang.getText("FEATS"),this.api.lang.getText("BOOST"),this.api.lang.getText("TOTAL_WORD")];
   }
   function addListeners()
   {
      this.api.datacenter.Player.addEventListener("fullStatsChanged",this);
   }
   function initData()
   {
      var _loc2_ = this.api.datacenter.Player.FullStats;
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_;
      var _loc5_;
      var _loc6_;
      for(var k in _loc2_)
      {
         _loc3_.push({isCat:true,name:this.api.lang.getText("FULL_STATS_CAT" + k)});
         _loc4_ = new ank.utils.ExtendedArray();
         _loc5_ = 0;
         while(_loc5_ < _loc2_[k].length)
         {
            _loc4_.push({name:this.api.lang.getText("FULL_STATS_ID" + _loc2_[k][_loc5_].id),s:_loc2_[k][_loc5_].s,i:_loc2_[k][_loc5_].i,d:_loc2_[k][_loc5_].d,b:_loc2_[k][_loc5_].b,o:Number(_loc2_[k][_loc5_].o),c:k,idx:_loc2_[k][_loc5_].id,p:_loc2_[k][_loc5_].p,a:_loc2_[k][_loc5_].a});
            _loc5_ = _loc5_ + 1;
         }
         _loc4_.sortOn("o",Array.NUMERIC);
         _loc6_ = _loc3_.concat(_loc4_);
         _loc3_ = new ank.utils.ExtendedArray();
         _loc3_.pushAll(_loc6_);
      }
      this._dgStats.dataProvider = _loc3_;
   }
   function fullStatsChanged(oEvent_)
   {
      this.initData();
   }
}
