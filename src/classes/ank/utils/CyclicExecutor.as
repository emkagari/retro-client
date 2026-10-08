class ank.utils.CyclicExecutor extends Object
{
   var _mcCyclicGameLoop;
   static var _instance = new ank.utils.CyclicExecutor();
   var _aFunctions = [];
   var _bPlaying = false;
   function CyclicExecutor()
   {
      super();
   }
   static function getInstance()
   {
      return ank.utils.CyclicExecutor._instance;
   }
   function addFunction(oRef, oObjFn, fFunction, aParams, oObjFnEnd, fFunctionEnd, aParamsEnd)
   {
      var _loc9_ = {};
      _loc9_.objRef = oRef;
      _loc9_.objFn = oObjFn;
      _loc9_.fn = fFunction;
      _loc9_.params = aParams;
      _loc9_.objFnEnd = oObjFnEnd;
      _loc9_.fnEnd = fFunctionEnd;
      _loc9_.paramsEnd = aParamsEnd;
      this._aFunctions.push(_loc9_);
      this.play();
   }
   function removeFunction(oRef)
   {
      var _loc3_ = this._aFunctions.length - 1;
      var _loc4_;
      while(_loc3_ >= 0)
      {
         _loc4_ = this._aFunctions[_loc3_];
         if(oRef == _loc4_.objRef)
         {
            this._aFunctions.splice(_loc3_,1);
         }
         _loc3_ = _loc3_ - 1;
      }
   }
   function clear()
   {
      this.stop();
      this._aFunctions = [];
   }
   function play()
   {
      if(this._bPlaying)
      {
         return undefined;
      }
      this._bPlaying = true;
      if(this._mcCyclicGameLoop == undefined)
      {
         this._mcCyclicGameLoop = _root.createEmptyMovieClip("_mcCyclicGameLoop",_root.getNextHighestDepth());
      }
      if(this._mcCyclicGameLoop.onEnterFrame == undefined)
      {
         var thisObject = this;
         var api = _global.API;
         var FRAMES_TO_SKIP = !dofus.Constants.TRIPLEFRAMERATE ? 1 : 5;
         var nCurrentFrameSkipState = 0;
         this._mcCyclicGameLoop.onEnterFrame = function()
         {
            if(!api.electron.isWindowFocused && api.kernel.OptionsManager.getOption("AntiLagOptimizeMovement"))
            {
               if(nCurrentFrameSkipState > 0)
               {
                  nCurrentFrameSkipState--;
                  return undefined;
               }
               nCurrentFrameSkipState = FRAMES_TO_SKIP;
            }
            thisObject.doCycle();
         };
      }
   }
   function stop()
   {
      delete this._mcCyclicGameLoop.onEnterFrame;
      this._bPlaying = false;
   }
   function doCycle()
   {
      var _loc2_ = this._aFunctions.length - 1;
      var _loc3_;
      while(_loc2_ >= 0)
      {
         _loc3_ = this._aFunctions[_loc2_];
         if(!_loc3_.fn.apply(_loc3_.objFn,_loc3_.params))
         {
            this.onFunctionEnd(_loc2_,_loc3_);
         }
         _loc2_ = _loc2_ - 1;
      }
      if(this._aFunctions.length == 0)
      {
         this.stop();
      }
   }
   function onFunctionEnd(nIndex, oFunction)
   {
      oFunction.fnEnd.apply(oFunction.objFnEnd,oFunction.paramsEnd);
      this._aFunctions.splice(nIndex,1);
   }
}
