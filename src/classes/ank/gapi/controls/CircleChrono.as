class ank.gapi.controls.CircleChrono extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _mcLeft;
   var _mcRight;
   var _nIntervalID;
   var _nMaxTime;
   var _nTimerValue;
   var addToQueue;
   var attachMovie;
   var dispatchEvent;
   var getStyle;
   var setMovieClipColor;
   static var CLASS_NAME = "CircleChrono";
   var _sBackgroundLink = "CircleChronoHalfDefault";
   var _nFinalCountDownTrigger = 5;
   var _nBackgroundColor = -1;
   function CircleChrono()
   {
      super();
   }
   function set background(sBackground)
   {
      this._sBackgroundLink = sBackground;
   }
   function set finalCountDownTrigger(nFinalCountDownTrigger)
   {
      nFinalCountDownTrigger = Number(nFinalCountDownTrigger);
      if(_global.isNaN(nFinalCountDownTrigger))
      {
         return;
      }
      if(nFinalCountDownTrigger < 0)
      {
         return;
      }
      this._nFinalCountDownTrigger = nFinalCountDownTrigger;
   }
   function setGaugeChrono(nPercent, nCustomBgColor)
   {
      _global.clearInterval(this._nIntervalID);
      this.dispatchEvent({type:"finish"});
      if(nPercent > 100)
      {
         nPercent = 100;
      }
      else if(nPercent < 0)
      {
         nPercent = 0;
      }
      this._nMaxTime = 100;
      this._nTimerValue = 100 - nPercent;
      this.draw(nCustomBgColor);
      this.chronoUpdate();
   }
   function startTimer(nDuration)
   {
      _global.clearInterval(this._nIntervalID);
      nDuration = Number(nDuration);
      if(_global.isNaN(nDuration))
      {
         return undefined;
      }
      if(nDuration < 0)
      {
         return undefined;
      }
      this._nMaxTime = nDuration;
      this._nTimerValue = nDuration;
      this.updateTimer();
      this._nIntervalID = _global.setInterval(this,"updateTimer",1000);
   }
   function stopTimer()
   {
      _global.clearInterval(this._nIntervalID);
      this.dispatchEvent({type:"finish"});
      this.addToQueue({object:this,method:this.initialize});
   }
   function redraw()
   {
      this.draw();
   }
   function init()
   {
      super.init(false,ank.gapi.controls.CircleChrono.CLASS_NAME);
   }
   function createChildren()
   {
      this.attachMovie(this._sBackgroundLink,"_mcLeft",10);
      this.attachMovie(this._sBackgroundLink,"_mcRight",20);
   }
   function arrange()
   {
      this._mcLeft._width = this._mcRight._width = this.__width;
      this._mcLeft._height = this._mcRight._height = this.__height;
      this._mcLeft._xscale *= -1;
      this._mcLeft._yscale *= -1;
      this._mcLeft._x = this._mcRight._x = this.__width / 2;
      this._mcLeft._y = this._mcRight._y = this.__height / 2;
   }
   function draw(nCustomBgColor)
   {
      var _loc3_ = nCustomBgColor == undefined ? this.getStyle().bgcolor : nCustomBgColor;
      if(_loc3_ != undefined && this._nBackgroundColor != nCustomBgColor)
      {
         this._nBackgroundColor = _loc3_;
         this.setMovieClipColor(this._mcLeft.bg_mc,_loc3_);
         this.setMovieClipColor(this._mcRight.bg_mc,_loc3_);
      }
   }
   function chronoUpdate()
   {
      var _loc2_ = this._nTimerValue / this._nMaxTime;
      var _loc3_ = 360 * (1 - this._nTimerValue / this._nMaxTime);
      if(_loc3_ < 180)
      {
         this.setRtation(this._mcRight,_loc3_);
         this.setRtation(this._mcLeft,0);
      }
      else
      {
         this.setRtation(this._mcRight,180);
         this.setRtation(this._mcLeft,_loc3_ - 180);
      }
   }
   function updateTimer()
   {
      this.dispatchEvent({type:"tictac"});
      this.chronoUpdate();
      if(this._nTimerValue - 5 <= this._nFinalCountDownTrigger)
      {
         this.dispatchEvent({type:"beforeFinalCountDown",value:Math.ceil(this._nTimerValue)});
      }
      if(this._nTimerValue <= this._nFinalCountDownTrigger)
      {
         this.dispatchEvent({type:"finalCountDown",value:Math.ceil(this._nTimerValue)});
      }
      this._nTimerValue = this._nTimerValue - 1;
      if(this._nTimerValue < 0)
      {
         this.stopTimer();
      }
   }
   function initialize()
   {
      this.setRtation(this._mcLeft,0);
      this.setRtation(this._mcRight,0);
   }
   function setRtation(mc, nAngle)
   {
      mc._mcMask._rotation = nAngle;
   }
}
