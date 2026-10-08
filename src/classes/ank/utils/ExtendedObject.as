class ank.utils.ExtendedObject extends Object
{
   var _count;
   var _items;
   var dispatchEvent;
   function ExtendedObject()
   {
      super();
      this.initialize();
   }
   function initialize(Void)
   {
      this.clear();
      mx.events.EventDispatcher.initialize(this);
   }
   function clear(Void)
   {
      this._items = {};
      this._count = 0;
      this.dispatchEvent({type:"modelChanged"});
   }
   function addItemAt(key, item)
   {
      if(this._items[key] == undefined)
      {
         this._count = this._count + 1;
      }
      this._items[key] = item;
      this.dispatchEvent({type:"modelChanged"});
   }
   function removeItemAt(key)
   {
      var _loc3_ = this._items[key];
      delete this._items[key];
      this._count = this._count - 1;
      this.dispatchEvent({type:"modelChanged"});
      return _loc3_;
   }
   function removeAll(Void)
   {
      this.clear();
   }
   function removeFromKeys(aKeys)
   {
      var _loc3_;
      var _loc4_;
      for(var k in this._items)
      {
         _loc3_ = false;
         _loc4_ = 0;
         while(_loc4_ < aKeys.length)
         {
            if(aKeys[_loc4_] == k)
            {
               _loc3_ = true;
               break;
            }
            _loc4_ = _loc4_ + 1;
         }
         if(_loc3_)
         {
            delete this._items[k];
            this._count = this._count - 1;
         }
      }
      this.dispatchEvent({type:"modelChanged"});
   }
   function removeFromEOKeys(eo)
   {
      var _loc3_;
      for(var k in this._items)
      {
         _loc3_ = false;
         for(var kk in eo.getItems())
         {
            if(k == kk)
            {
               _loc3_ = true;
               break;
            }
         }
         if(_loc3_)
         {
            delete this._items[k];
            this._count = this._count - 1;
         }
      }
      this.dispatchEvent({type:"modelChanged"});
   }
   function removeAllExcept(key)
   {
      for(var k in this._items)
      {
         if(k != key)
         {
            delete this._items[k];
         }
      }
      this._count = 1;
      this.dispatchEvent({type:"modelChanged"});
   }
   function replaceItemAt(key, item)
   {
      if(this._items[key] == undefined)
      {
         return undefined;
      }
      this._items[key] = item;
      this.dispatchEvent({type:"modelChanged"});
   }
   function getLength(Void)
   {
      return this._count;
   }
   function getItemAt(key)
   {
      return this._items[key];
   }
   function getFirstItem()
   {
      for(var k in this._items)
      {
         return this._items[k];
         break;
      }
   }
   function getItems(Void)
   {
      return this._items;
   }
   function getKeys()
   {
      var _loc2_ = [];
      for(var k in this._items)
      {
         _loc2_.push(k);
      }
      return _loc2_;
   }
   function getPropertyValues(sProperty)
   {
      var _loc3_ = [];
      for(var k in this._items)
      {
         _loc3_.push(this._items[k][sProperty]);
      }
      return _loc3_;
   }
   function doesAnotherEOContainsAllMyKeys(eo)
   {
      var _loc3_ = true;
      var _loc4_;
      for(var i in this._items)
      {
         _loc4_ = false;
         for(var j in eo.getItems())
         {
            if(i == j)
            {
               _loc4_ = true;
               break;
            }
         }
         if(!_loc4_)
         {
            _loc3_ = false;
            break;
         }
      }
      return _loc3_;
   }
}
