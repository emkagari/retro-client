class ank.gapi.controls.ScrollBar extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var _mcHolder;
   var _nDragOffset;
   var _nMax;
   var _nMin;
   var _nPage;
   var _nPrevScrollPosition;
   var _nSize;
   var _oListener;
   var _parent;
   var _rotation;
   var _sSnapTo;
   var _tTarget;
   var _width;
   var _x;
   var _y;
   var _ymouse;
   var addEventListener;
   var addToQueue;
   var createEmptyMovieClip;
   var dispatchEvent;
   var dispatchInterval;
   var down_mc;
   var getStyle;
   var height;
   var interval;
   var onRelease;
   var onRollOut;
   var onRollOver;
   var over_mc;
   var parent;
   var parentNode_;
   var removeEventListener;
   var scrollInterval;
   var setMovieClipColor;
   var target;
   var up_mc;
   static var CLASS_NAME = "ScrollBar";
   static var SCROLL_INTERVAL = 40;
   function ScrollBar()
   {
      super();
   }
   function set min(nMin)
   {
      this._nMin = nMin;
   }
   function get min()
   {
      return this._nMin;
   }
   function set max(nMax)
   {
      this._nMax = nMax;
   }
   function get max()
   {
      return this._nMax;
   }
   function set page(nPage)
   {
      this._nPage = nPage;
   }
   function get page()
   {
      return this._nPage;
   }
   function set _bHorizontal(tTarget)
   {
      if(tTarget == undefined)
      {
         return;
      }
      this._tTarget = typeof tTarget != "string" ? tTarget : this._parent[tTarget];
      if(this.addEventListener != undefined)
      {
         this.addTargetListener();
      }
      this._tTarget.removeListener(this);
      this._tTarget.addListener(this);
      this.addToQueue({object:this,method:this.addTargetListener});
      if(this._sSnapTo != undefined && this._sSnapTo != "none")
      {
         this.addToQueue({object:this,method:this.snapToTextField});
      }
   }
   function get _bHorizontal()
   {
      return this._tTarget;
   }
   function set snapTo(sSnapTo)
   {
      if(sSnapTo == undefined)
      {
         return;
      }
      this._sSnapTo = sSnapTo;
      if(this._tTarget != undefined)
      {
         if(this.addEventListener != undefined)
         {
            this.snapToTextField();
         }
         else
         {
            this.addToQueue({object:this,method:this.snapToTextField});
         }
      }
   }
   function set scrollPosition(nScrollPosition)
   {
      if(nScrollPosition > this._nMax)
      {
         nScrollPosition = this._nMax;
      }
      if(nScrollPosition < this._nMin)
      {
         nScrollPosition = this._nMin;
      }
      var _loc3_ = nScrollPosition * (this._mcHolder.track_mc._height - this._mcHolder.thumb_mc._height) / (this._nMax - this._nMin) + this._mcHolder.track_mc._y;
      this.moveThumb(_loc3_);
   }
   function get scrollPosition()
   {
      return Math.round((this._mcHolder.thumb_mc._y - this._mcHolder.track_mc._y) / (this._mcHolder.track_mc._height - this._mcHolder.thumb_mc._height) * (this._nMax - this._nMin));
   }
   function set horizontal(bHorizontal)
   {
      this.parent = bHorizontal;
      this.arrange();
   }
   function setSize(nHeight)
   {
      super.setSize(null,nHeight);
   }
   function setScrollProperties(nPage, nMin, nMax)
   {
      this._nPage = nPage;
      this._nMin = Math.max(nMin,0);
      this._nMax = Math.max(nMax,0);
      this.resizeThumb();
   }
   function init()
   {
      super.init(false,ank.gapi.controls.ScrollBar.CLASS_NAME);
      if(this._nMin == undefined)
      {
         this._nMin = 0;
      }
      if(this._nMax == undefined)
      {
         this._nMax = 100;
      }
      if(this._nPage == undefined)
      {
         this._nPage = 10;
      }
   }
   function createChildren()
   {
      this.createEmptyMovieClip("_mcHolder",10);
      var _loc2_ = this._mcHolder.attachMovie("ScrollBarTrack","track_mc",10);
      var _loc3_ = this._mcHolder.attachMovie("ScrollBarUpArrow","upArrow_mc",20);
      var _loc4_ = this._mcHolder.attachMovie("ScrollBarDownArrow","downArrow_mc",30);
      var _loc5_ = this._mcHolder.attachMovie("ScrollBarThumb","thumb_mc",40);
      _loc3_.down_mc._visible = false;
      _loc4_.down_mc._visible = false;
      _loc3_.onRollOver = _loc4_.onRollOver = function()
      {
         this.up_mc._visible = false;
         this.over_mc._visible = true;
         this.down_mc._visible = false;
      };
      _loc3_.onRollOut = _loc4_.onRollOut = function()
      {
         this.up_mc._visible = true;
         this.over_mc._visible = false;
         this.down_mc._visible = false;
      };
      _loc3_.onPress = function()
      {
         this.up_mc._visible = false;
         this.over_mc._visible = false;
         this.down_mc._visible = true;
         this.interval = _global.setInterval(this._parent._parent,"addToScrollPosition",ank.gapi.controls.ScrollBar.SCROLL_INTERVAL,-1);
      };
      _loc4_.onPress = function()
      {
         this.up_mc._visible = false;
         this.over_mc._visible = false;
         this.down_mc._visible = true;
         this.interval = _global.setInterval(this._parent._parent,"addToScrollPosition",ank.gapi.controls.ScrollBar.SCROLL_INTERVAL,1);
      };
      _loc3_.onRelease = _loc4_.onRelease = function()
      {
         this.onRollOver();
         _global.clearInterval(this.interval);
      };
      _loc3_.onReleaseOutside = _loc4_.onReleaseOutside = function()
      {
         this.onRelease();
         this.onRollOut();
      };
      _loc5_.onRollOver = function()
      {
      };
      _loc5_.onRollOut = function()
      {
      };
      _loc5_.onPress = function()
      {
         this._parent._parent._nDragOffset = - this._ymouse;
         this.dispatchInterval = _global.setInterval(this._parent._parent,"dispatchScrollEvent",ank.gapi.controls.ScrollBar.SCROLL_INTERVAL);
         this.scrollInterval = _global.setInterval(this._parent._parent,"scrollThumb",ank.gapi.controls.ScrollBar.SCROLL_INTERVAL,null,true);
      };
      _loc5_.onRelease = function()
      {
         _global.clearInterval(this.scrollInterval);
         _global.clearInterval(this.dispatchInterval);
      };
      _loc5_.onReleaseOutside = function()
      {
         this.onRelease();
         this.onRollOut();
      };
      _loc2_.onPress = function()
      {
         var _loc2_ = this._parent._ymouse;
         var _loc3_ = this._parent._parent._nPage;
         if(_loc2_ < this._parent.thumb_mc._y)
         {
            _loc3_ = - _loc3_;
         }
         this._parent._parent.addToScrollPosition(_loc3_);
      };
   }
   function draw()
   {
      var _loc2_ = this.getStyle();
      var _loc3_ = this._mcHolder.downArrow_mc;
      this.setMovieClipColor(_loc3_.up_mc.bg_mc,_loc2_.sbarrowbgcolor);
      this.setMovieClipColor(_loc3_.up_mc.arrow_mc,_loc2_.sbarrowcolor);
      this.setMovieClipColor(_loc3_.down_mc.bg_mc,_loc2_.sbarrowbgcolor);
      this.setMovieClipColor(_loc3_.down_mc.arrow_mc,_loc2_.sbarrowcolor);
      this.setMovieClipColor(_loc3_.over_mc.bg_mc,_loc2_.sbarrowbgcolor);
      this.setMovieClipColor(_loc3_.over_mc.arrow_mc,_loc2_.sbarrowcolor);
      _loc3_ = this._mcHolder.upArrow_mc;
      this.setMovieClipColor(_loc3_.up_mc.bg_mc,_loc2_.sbarrowbgcolor);
      this.setMovieClipColor(_loc3_.up_mc.arrow_mc,_loc2_.sbarrowcolor);
      this.setMovieClipColor(_loc3_.down_mc.bg_mc,_loc2_.sbarrowbgcolor);
      this.setMovieClipColor(_loc3_.down_mc.arrow_mc,_loc2_.sbarrowcolor);
      this.setMovieClipColor(_loc3_.over_mc.bg_mc,_loc2_.sbarrowbgcolor);
      this.setMovieClipColor(_loc3_.over_mc.arrow_mc,_loc2_.sbarrowcolor);
      for(var k in this._mcHolder.thumb_mc)
      {
         this.setMovieClipColor(this._mcHolder.thumb_mc[k],_loc2_.sbthumbcolor);
      }
      this.setMovieClipColor(this._mcHolder.track_mc,_loc2_.sbtrackcolor);
   }
   function size()
   {
      super.size();
      this._nSize = this.__height;
      this.arrange();
      if(this._bHorizontal != undefined)
      {
         this.setScrollPropertiesToTarget();
      }
   }
   function arrange()
   {
      if(this._nSize == undefined)
      {
         return undefined;
      }
      if(this.parent)
      {
         this._rotation = -90;
      }
      this._mcHolder.track_mc._height = Math.max(this._nSize - this._mcHolder.upArrow_mc._height - this._mcHolder.downArrow_mc._height,0);
      this._mcHolder.track_mc._y = this._mcHolder.upArrow_mc._height;
      this._mcHolder.downArrow_mc._y = this._mcHolder.track_mc._y + this._mcHolder.track_mc._height;
      this._mcHolder.thumb_mc._y = this._mcHolder.track_mc._y;
      this.setScrollProperties(this._nPage,this._nMin,this._nMax);
   }
   function resizeThumb()
   {
      if(this._nMax != this._nMin && this._nPage != 0)
      {
         this._mcHolder.thumb_mc.height = Math.min(Math.abs(this._nPage / (this._nMax - this._nMin)),1) * this._mcHolder.track_mc._height;
         this._mcHolder.thumb_mc._y = this._mcHolder.upArrow_mc._height;
         if(this._mcHolder.thumb_mc._height > this._mcHolder.track_mc._height)
         {
            this._mcHolder.thumb_mc._visible = false;
         }
         else
         {
            this._mcHolder.thumb_mc._visible = true;
         }
      }
      else
      {
         this._mcHolder.thumb_mc._visible = false;
      }
   }
   function addToScrollPosition(nAmount)
   {
      this.scrollPosition += nAmount;
   }
   function scrollThumb(nAmount, bDrag)
   {
      if(bDrag)
      {
         this.moveThumb(this._mcHolder._ymouse + this._nDragOffset);
      }
      else
      {
         this.moveThumb(this._mcHolder.thumb_mc._y + nAmount);
      }
      _global.updateAfterEvent();
   }
   function moveThumb(nY)
   {
      this._mcHolder.thumb_mc._y = nY;
      if(this._mcHolder.thumb_mc._y < this._mcHolder.upArrow_mc._height)
      {
         this._mcHolder.thumb_mc._y = this._mcHolder.upArrow_mc._height;
      }
      else if(this._mcHolder.thumb_mc._y > this._mcHolder.downArrow_mc._y - this._mcHolder.thumb_mc._height)
      {
         this._mcHolder.thumb_mc._y = this._mcHolder.downArrow_mc._y - this._mcHolder.thumb_mc._height;
      }
      this.dispatchScrollEvent();
   }
   function dispatchScrollEvent()
   {
      if(this._mcHolder.thumb_mc._y != this._nPrevScrollPosition)
      {
         this._nPrevScrollPosition = Math.max(this._mcHolder.upArrow_mc._height,this._mcHolder.thumb_mc._y);
         this.dispatchEvent({type:"scroll",target:this});
      }
   }
   function snapToTextField()
   {
      if(this._sSnapTo == "right")
      {
         this._x = this._tTarget._x + this._tTarget._width - this._width;
         this._y = this._tTarget._y;
         this._tTarget._width -= this._width;
         this.height = this._tTarget._height;
         this.setScrollPropertiesToTarget();
      }
   }
   function addTargetListener()
   {
      this.removeEventListener("scroll",this._oListener);
      this._oListener = {};
      this._oListener.target = this._tTarget;
      this._oListener.parentNode_ = this;
      this._oListener.scroll = function(oEvent_)
      {
         this.target.scroll = this.target.maxscroll * (this.parentNode_.scrollPosition / Math.abs(this.parentNode_._nMax - this.parentNode_._nMin));
      };
      this.addEventListener("scroll",this._oListener);
      this.setScrollPropertiesToTarget();
   }
   function setScrollPropertiesToTarget()
   {
      var _loc2_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if(this._tTarget == undefined)
      {
         this.setScrollProperties(this._nPage,this._nMin,this._nMax);
      }
      else
      {
         _loc2_ = !_global.isNaN(Number(this._tTarget.maxscroll)) ? this._tTarget.maxscroll : 1;
         _loc3_ = !_global.isNaN(Number(this._tTarget._height)) ? this._tTarget._height : 0;
         _loc4_ = !_global.isNaN(Number(this._tTarget.textHeight)) ? this._tTarget.textHeight : 1;
         _loc5_ = 0.9 * _loc3_ / _loc4_ * _loc2_;
         this.setScrollProperties(_loc5_,0,_loc2_);
      }
   }
   function onChanged()
   {
      this.setScrollPropertiesToTarget();
      this.scrollPosition = this._tTarget.scroll;
   }
   function onScroller()
   {
      this.scrollPosition = this._tTarget.scroll;
   }
}
