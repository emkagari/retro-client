class ank.utils.ExtendedArray extends Array
{
   var _bNoEventDispatchs;
   var _nNoEventPeriodTimeout;
   function ExtendedArray()
   {
      super();
      this.initialize();
   }
   function removeEventListener()
   {
   }
   function addEventListener()
   {
   }
   function dispatchEvent()
   {
   }
   function dispatchQueue()
   {
   }
   function initialize(Void)
   {
      mx.events.EventDispatcher.initialize(this);
   }
   function isInNoEventDispatchsPeriod()
   {
      return this._bNoEventDispatchs;
   }
   function startNoEventDispatchsPeriod(nDuration)
   {
      this._bNoEventDispatchs = true;
      if(this._nNoEventPeriodTimeout != undefined)
      {
         _global.clearTimeout(this._nNoEventPeriodTimeout);
      }
      var _loc3_ = _global.setTimeout(this,"endNoEventDispatchsPeriod",nDuration);
      this._nNoEventPeriodTimeout = _loc3_;
   }
   function endNoEventDispatchsPeriod()
   {
      this._bNoEventDispatchs = undefined;
      this._nNoEventPeriodTimeout = undefined;
      this.doDispatchEvent({type:"modelChanged",eventName:"updateAll"});
      var _loc2_ = _global.API;
      _loc2_.ui.getUIComponent("TaxCollectorStorage").refreshGetItemButton();
   }
   function pushAll(aValues)
   {
      var _loc4_ = 0;
      while(_loc4_ < aValues.length)
      {
         super.push(aValues[_loc4_]);
         _loc4_ = _loc4_ + 1;
      }
      this.doDispatchEvent({type:"modelChanged",eventName:"addItem"});
   }
   function removeAll(Void)
   {
      this.splice(0,this.length);
      this.doDispatchEvent({type:"modelChanged",eventName:"updateAll"});
   }
   function pushAt(value_, nInsertIndex)
   {
      var _loc6_ = value_;
      var _loc7_ = nInsertIndex;
      var _loc5_;
      while(_loc7_ < this.length)
      {
         _loc5_ = this[_loc7_];
         this[_loc7_] = _loc6_;
         _loc6_ = _loc5_;
         _loc7_ = _loc7_ + 1;
      }
      super.push(_loc6_);
      this.doDispatchEvent({type:"modelChanged",eventName:"addItem"});
   }
   function push(value)
   {
      var _loc4_ = super.push(value);
      this.doDispatchEvent({type:"modelChanged",eventName:"addItem"});
      return _loc4_;
   }
   function remove(value_)
   {
      var _loc3_ = this.indexOf(value_);
      if(_loc3_ == -1)
      {
         return undefined;
      }
      this.removeItems(_loc3_,1);
      return value_;
   }
   function pop()
   {
      var _loc3_ = super.pop();
      this.doDispatchEvent({type:"modelChanged",eventName:"updateAll"});
      return _loc3_;
   }
   function shift()
   {
      var _loc3_ = super.shift();
      this.doDispatchEvent({type:"modelChanged",eventName:"updateAll"});
      return _loc3_;
   }
   function unshift(value)
   {
      var _loc4_ = super.unshift(value);
      this.doDispatchEvent({type:"modelChanged",eventName:"updateAll"});
      return _loc4_;
   }
   function reverse()
   {
      super.reverse();
      this.doDispatchEvent({type:"modelChanged",eventName:"updateAll"});
   }
   function replaceAll(nStart, aNew)
   {
      var _loc4_ = [nStart,0];
      for(var k in aNew)
      {
         _loc4_.push(aNew[k]);
      }
      this.splice.apply(this,_loc4_);
      this.doDispatchEvent({type:"modelChanged",eventName:"updateAll"});
   }
   function removeItems(nIndex, deleteCount)
   {
      this.splice(nIndex,deleteCount);
      this.doDispatchEvent({type:"modelChanged",eventName:"updateAll"});
   }
   function updateItem(nIndex, newValue)
   {
      this.splice(nIndex,1,newValue);
      this.doDispatchEvent({type:"modelChanged",eventName:"updateOne",updateIndex:nIndex});
   }
   function indexOf(value_)
   {
      for(var idx in this)
      {
         if(this[idx] == value_)
         {
            return Number(idx);
         }
      }
      return -1;
   }
   function contains(value_)
   {
      return this.indexOf(value_) >= 0;
   }
   function findFirstItem(sPropName, propValue)
   {
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < this.length)
      {
         _loc5_ = this[_loc4_];
         if(_loc5_[sPropName] == propValue)
         {
            return {index:_loc4_,item:_loc5_};
         }
         _loc4_ = _loc4_ + 1;
      }
      return {index:-1};
   }
   function deepClone()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = 0;
      while(_loc3_ < this.length)
      {
         _loc2_.push(this[_loc3_].clone());
         _loc3_ = _loc3_ + 1;
      }
      return _loc2_;
   }
   function clone()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = 0;
      while(_loc3_ < this.length)
      {
         _loc2_.push(this[_loc3_]);
         _loc3_ = _loc3_ + 1;
      }
      return _loc2_;
   }
   function shuffle()
   {
      var _loc2_ = this.clone();
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      while(_loc3_ < _loc2_.length)
      {
         _loc4_ = _loc2_[_loc3_];
         _loc5_ = random(_loc2_.length);
         _loc2_[_loc3_] = _loc2_[_loc5_];
         _loc2_[_loc5_] = _loc4_;
         _loc3_ = _loc3_ + 1;
      }
      return _loc2_;
   }
   function doDispatchEvent(oEvent)
   {
      if(this.isInNoEventDispatchsPeriod())
      {
         return undefined;
      }
      this.dispatchEvent(oEvent);
   }
   function bubbleSortOn(prop, flags)
   {
      if((flags & Array.ASCENDING) == 0 && (flags & Array.DESCENDING) == 0)
      {
         flags |= Array.ASCENDING;
      }
      var _loc4_;
      var _loc5_;
      var _loc6_;
      do
      {
         _loc4_ = false;
         _loc5_ = 1;
         while(_loc5_ < this.length)
         {
            if((flags & Array.ASCENDING) > 0 && this[_loc5_ - 1][prop] > this[_loc5_][prop] || (flags & Array.DESCENDING) > 0 && this[_loc5_ - 1][prop] < this[_loc5_][prop])
            {
               _loc6_ = this[_loc5_ - 1];
               this[_loc5_ - 1] = this[_loc5_];
               this[_loc5_] = _loc6_;
               _loc4_ = true;
            }
            _loc5_ = _loc5_ + 1;
         }
      }
      while(_loc4_);
   }
   function concat(oArray)
   {
      var _loc4_ = super.concat(oArray);
      var _loc5_ = new ank.utils.ExtendedArray();
      _loc5_.pushAll(_loc4_);
      return _loc5_;
   }
   static function createFromArray(aArray)
   {
      var _loc3_ = new ank.utils.ExtendedArray();
      for(var idx in aArray)
      {
         _loc3_.push(aArray[idx]);
      }
      return _loc3_;
   }
   static function createWithoutDuplicatesFromArray(aArray)
   {
      var _loc3_ = new ank.utils.ExtendedArray();
      for(var idx in aArray)
      {
         if(!_loc3_.contains(aArray[idx]) && aArray[idx] != undefined)
         {
            _loc3_.push(aArray[idx]);
         }
      }
      return _loc3_;
   }
   static function equals(a_, b_)
   {
      if(a_.length != b_.length)
      {
         return false;
      }
      var _loc4_ = 0;
      while(_loc4_ < a_.length)
      {
         if(a_[_loc4_] != b_[_loc4_])
         {
            return false;
         }
         _loc4_ = _loc4_ + 1;
      }
      return true;
   }
}
