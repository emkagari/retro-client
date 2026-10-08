class dofus.graphics.gapi.controls.StarsDisplayer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aStarsColor;
   var _mcMask;
   var _nValue;
   var addToQueue;
   var getStyle;
   var initialized;
   static var CLASS_NAME = "StarsDisplayer";
   static var STARS_COUNT = 5;
   function StarsDisplayer()
   {
      super();
   }
   function get value()
   {
      return this._nValue;
   }
   function set value(value)
   {
      this._nValue = value;
      if(this.initialized)
      {
         this.updateData();
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.StarsDisplayer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.addListeners});
   }
   function draw()
   {
      var _loc2_ = this.getStyle();
      this._aStarsColor = _loc2_.starcolors;
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      while(_loc3_ < dofus.graphics.gapi.controls.StarsDisplayer.STARS_COUNT)
      {
         _loc4_ = this["_mcStar" + _loc3_].border;
         _loc5_ = new Color(_loc4_);
         _loc5_.setRGB(_loc2_.starborder);
         _loc3_ = _loc3_ + 1;
      }
   }
   function initData()
   {
      this.updateData();
   }
   function addListeners()
   {
      var ref = this;
      this._mcMask.onRollOut = function()
      {
         ref.dispatchEvent({type:"out"});
      };
      this._mcMask.onRollOver = function()
      {
         ref.dispatchEvent({type:"over"});
      };
      this._mcMask.onRelease = function()
      {
         ref.dispatchEvent({type:"click"});
      };
   }
   function updateData()
   {
      var _loc2_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if(this._nValue != undefined && (this._nValue > 0 && !_global.isNaN(this._nValue)))
      {
         _loc2_ = this.getStarsColor();
         _loc3_ = 0;
         while(_loc3_ < dofus.graphics.gapi.controls.StarsDisplayer.STARS_COUNT)
         {
            _loc4_ = this["_mcStar" + _loc3_].fill;
            if(_loc2_[_loc3_] > -1)
            {
               _loc5_ = new Color(_loc4_);
               _loc5_.setRGB(_loc2_[_loc3_]);
            }
            else
            {
               _loc4_._alpha = 0;
            }
            _loc3_ = _loc3_ + 1;
         }
      }
      else
      {
         _loc6_ = 0;
         while(_loc6_ < dofus.graphics.gapi.controls.StarsDisplayer.STARS_COUNT)
         {
            this["_mcStar" + _loc6_].fill._alpha = 0;
            _loc6_ = _loc6_ + 1;
         }
      }
   }
   function getStarsColor()
   {
      var _loc2_ = [];
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < dofus.graphics.gapi.controls.StarsDisplayer.STARS_COUNT)
      {
         _loc4_ = Math.floor(this._nValue / 100) + (this._nValue - Math.floor(this._nValue / 100) * 100 <= _loc3_ * (100 / dofus.graphics.gapi.controls.StarsDisplayer.STARS_COUNT) ? 0 : 1);
         _loc2_[_loc3_] = this._aStarsColor[Math.min(_loc4_,this._aStarsColor.length - 1)];
         _loc3_ = _loc3_ + 1;
      }
      return _loc2_;
   }
}
