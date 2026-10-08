class ank.gapi.controls.Compass extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _aCurrentCoords;
   var _aTargetCoords;
   var _ldrBack;
   var _mcArrow;
   var addToQueue;
   var attachMovie;
   var createEmptyMovieClip;
   var dispatchEvent;
   var initialized;
   static var CLASS_NAME = "Compass";
   var _bUpdateOnLoad = true;
   var _sBackground = "CompassNormalBackground";
   var _sArrow = "CompassNormalArrow";
   var _sNoArrow = "CompassNormalNoArrow";
   function Compass()
   {
      super();
   }
   function set updateOnLoad(bUpdateOnLoad)
   {
      this._bUpdateOnLoad = bUpdateOnLoad;
   }
   function get updateOnLoad()
   {
      return this._bUpdateOnLoad;
   }
   function set background(sBackground)
   {
      this._sBackground = sBackground;
   }
   function get background()
   {
      return this._sBackground;
   }
   function set arrow(sArrow)
   {
      this._sArrow = sArrow;
   }
   function get arrow()
   {
      return this._sArrow;
   }
   function set noArrow(sNoArrow)
   {
      this._sNoArrow = sNoArrow;
   }
   function get noArrow()
   {
      return this._sNoArrow;
   }
   function set currentCoords(aCurrentCoords)
   {
      this._aCurrentCoords = aCurrentCoords;
      if(this.initialized)
      {
         this.layoutContent();
      }
   }
   function set targetCoords(aTargetCoords)
   {
      this._aTargetCoords = aTargetCoords;
      if(this.initialized)
      {
         this.layoutContent();
      }
   }
   function get targetCoords()
   {
      return this._aTargetCoords;
   }
   function set allCoords(oAllCoords)
   {
      this._aTargetCoords = oAllCoords.targetCoords;
      this._aCurrentCoords = oAllCoords.currentCoords;
      if(this.initialized)
      {
         this.addToQueue({object:this,method:this.layoutContent});
      }
   }
   function init()
   {
      super.init(false,ank.gapi.controls.Compass.CLASS_NAME);
   }
   function createChildren()
   {
      this.attachMovie("GAPILoader","_ldrBack",10,{contentPath:this._sBackground,centerContent:false,scaleContent:true});
      this.createEmptyMovieClip("_mcArrow",20);
      this._mcArrow.attachMovie("GAPILoader","_ldrArrow",10,{contentPath:this._sNoArrow,centerContent:false,scaleContent:true});
      if(this._bUpdateOnLoad)
      {
         this.addToQueue({object:this,method:this.layoutContent});
      }
   }
   function size()
   {
      super.size();
      this.arrange();
   }
   function arrange()
   {
      this._ldrBack.setSize(this.__width,this.__height);
      this._mcArrow._x = this.__width / 2;
      this._mcArrow._y = this.__height / 2;
      this._mcArrow._ldrArrow.setSize(this.__width,this.__height);
      this._mcArrow._ldrArrow._x = (- this.__width) / 2;
      this._mcArrow._ldrArrow._y = (- this.__height) / 2;
   }
   function layoutContent()
   {
      if(this._aCurrentCoords == undefined)
      {
         return undefined;
      }
      if(this._aCurrentCoords.length == 0)
      {
         return undefined;
      }
      if(this._aTargetCoords == undefined)
      {
         return undefined;
      }
      if(this._aTargetCoords.length == 0)
      {
         return undefined;
      }
      ank.utils.Timer.removeTimer(this,"compass");
      var _loc2_ = this._aTargetCoords[0] - this._aCurrentCoords[0];
      var _loc3_ = this._aTargetCoords[1] - this._aCurrentCoords[1];
      var _loc4_;
      if(_loc2_ == 0 && _loc3_ == 0)
      {
         this._mcArrow._ldrArrow.contentPath = this._sNoArrow;
         this._mcArrow._ldrArrow.content._rotation = this._mcArrow._rotation;
         this._mcArrow._rotation = 0;
         this.smoothRotation(0,1);
      }
      else
      {
         _loc4_ = Math.atan2(_loc3_,_loc2_) * (180 / Math.PI);
         this._mcArrow._ldrArrow.contentPath = this._sArrow;
         this._mcArrow._ldrArrow.content._rotation = this._mcArrow._rotation - _loc4_;
         this._mcArrow._rotation = _loc4_;
         this.smoothRotation(_loc4_,1);
      }
   }
   function smoothRotation(nMaxAngle, nSpeed)
   {
      this._mcArrow._ldrArrow.content._rotation += nSpeed;
      nSpeed = (- this._mcArrow._ldrArrow.content._rotation) * 0.2 + nSpeed * 0.7;
      if(Math.abs(nSpeed) > 0.01)
      {
         ank.utils.Timer.setTimer(this,"compass",this,this.smoothRotation,50,[nMaxAngle,nSpeed]);
      }
      else
      {
         this._mcArrow._ldrArrow.content._rotation = 0;
      }
   }
   function onRelease()
   {
      this.dispatchEvent({type:"click"});
   }
   function onReleaseOutside()
   {
      this.onRollOut();
   }
   function onRollOver()
   {
      this.dispatchEvent({type:"over"});
   }
   function onRollOut()
   {
      this.dispatchEvent({type:"out"});
   }
}
