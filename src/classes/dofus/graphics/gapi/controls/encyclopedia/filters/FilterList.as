class dofus.graphics.gapi.controls.encyclopedia.filters.FilterList extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _eaFilters;
   var _eaFiltersMovieClip;
   var _mcFilters;
   var addToQueue;
   var createEmptyMovieClip;
   var dispatchEvent;
   var getNextHighestDepth;
   static var CLASS_NAME = "FilterList";
   static var REDUCE_MARGIN = 2;
   static var TOP_POSITION = -2;
   function FilterList()
   {
      super();
      mx.events.EventDispatcher.initialize(this);
   }
   function get length()
   {
      return this._eaFilters.length;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.encyclopedia.filters.FilterList.CLASS_NAME);
   }
   function createChildren()
   {
      this._eaFilters = new ank.utils.ExtendedArray();
   }
   function updateList()
   {
      this._mcFilters.removeMovieClip();
      this._mcFilters = this.createEmptyMovieClip("_mcFilters",this.getNextHighestDepth());
      this._eaFiltersMovieClip = new ank.utils.ExtendedArray();
      var _loc2_ = this._eaFilters.length;
      var _loc3_ = dofus.graphics.gapi.controls.encyclopedia.filters.FilterList.TOP_POSITION;
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      while(_loc4_ < _loc2_)
      {
         _loc5_ = this._eaFilters[_loc4_];
         _loc6_ = this._mcFilters.attachMovie(_loc5_.composantName,"Filter_" + _loc4_,_loc4_,{data:_loc5_});
         _loc6_._y = _loc3_;
         _loc3_ += _loc6_.height - dofus.graphics.gapi.controls.encyclopedia.filters.FilterList.REDUCE_MARGIN;
         _loc6_.addEventListener("filterChanged",this);
         _loc6_.addEventListener("filterClosed",this);
         this._eaFiltersMovieClip.push(_loc6_);
         _loc4_ = _loc4_ + 1;
      }
   }
   function selectValue(nFilterIndex, nValue_)
   {
      var _loc4_ = this._mcFilters["Filter_" + nFilterIndex];
      if(_loc4_ instanceof dofus.graphics.gapi.controls.encyclopedia.filters.FilterCategoryViewer)
      {
         this.addToQueue({object:_loc4_,method:_loc4_.select,params:[nValue_]});
      }
   }
   function removeAll()
   {
      this._eaFilters.removeAll();
      this.updateList();
   }
   function drawAll()
   {
      this.updateList();
   }
   function addFilter(composant)
   {
      this._eaFilters.push(composant);
   }
   function removeFilter(composant)
   {
      var _loc3_;
      for(var i in this._eaFiltersMovieClip)
      {
         _loc3_ = dofus.graphics.gapi.controls.encyclopedia.filters.UIBasicFilter(this._eaFiltersMovieClip[i]);
         if(_loc3_.data == composant)
         {
            this._eaFiltersMovieClip.remove(_loc3_);
            _loc3_.removeMovieClip();
         }
      }
      this._eaFilters.remove(composant);
   }
   function isObjectValid(object_)
   {
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < this._eaFilters.length)
      {
         _loc4_ = this._eaFilters[_loc3_];
         if(!_loc4_.isObjectValid(object_))
         {
            return false;
         }
         _loc3_ = _loc3_ + 1;
      }
      return true;
   }
   function resetFilters()
   {
      var _loc2_ = this._eaFilters.length;
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < _loc2_)
      {
         _loc4_ = dofus.graphics.gapi.controls.encyclopedia.filters.UIBasicFilter(this._mcFilters["Filter_" + _loc3_]);
         _loc4_.reset();
         _loc3_ = _loc3_ + 1;
      }
      this.dispatchEvent({type:"filterChanged"});
   }
   function closeAll()
   {
      var _loc2_ = this._eaFilters.length;
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < _loc2_)
      {
         _loc4_ = dofus.graphics.gapi.controls.encyclopedia.filters.UIBasicFilter(this._mcFilters["Filter_" + _loc3_]);
         _loc4_.close();
         _loc3_ = _loc3_ + 1;
      }
   }
   function filterChanged(oEvent_)
   {
      this.dispatchEvent(oEvent_);
   }
   function filterClosed(oEvent_)
   {
      this.dispatchEvent(oEvent_);
   }
}
