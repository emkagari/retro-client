class dofus.utils.ApiElement extends Object
{
   var _oAPI;
   static var _aQueue = [];
   function ApiElement()
   {
      super();
   }
   function get api()
   {
      return _global.API;
   }
   function set api(oApi)
   {
      this._oAPI = oApi;
   }
   function initialize(oAPI)
   {
      this._oAPI = oAPI;
   }
   function addToQueue(oCall)
   {
      dofus.utils.ApiElement._aQueue.push(oCall);
      if(_root.onEnterFrame == undefined)
      {
         _root.onEnterFrame = this.runQueue;
      }
   }
   function runQueue()
   {
      var _loc2_ = dofus.utils.ApiElement._aQueue.shift();
      _loc2_.method.apply(_loc2_.object,_loc2_.params);
      if(dofus.utils.ApiElement._aQueue.length == 0)
      {
         delete _root.onEnterFrame;
      }
   }
}
