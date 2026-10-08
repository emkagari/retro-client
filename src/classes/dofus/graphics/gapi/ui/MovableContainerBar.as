class dofus.graphics.gapi.ui.MovableContainerBar extends dofus.graphics.gapi.core.MovableComponent
{
   var _aContainers;
   var _bTimerEnable;
   var _bVertical;
   var _mcBackground;
   var _mcContainers;
   var _mcDragOne;
   var _mcDragTwo;
   var _nContainerNumber;
   var _nMaxContainer;
   var _parent;
   var _x;
   var _y;
   var api;
   var bounds;
   var createEmptyMovieClip;
   var dispatchEvent;
   var move;
   var snap;
   static var CLASS_NAME = "MovableContainerBar";
   static var FORCE_HORIZONTAL_BAR_CONTAINERS_COUNT = 15;
   function MovableContainerBar()
   {
      super();
   }
   function get containers()
   {
      return this._aContainers;
   }
   function get size()
   {
      return this._nContainerNumber;
   }
   function set size(n)
   {
      if(n < 0)
      {
         n = 0;
      }
      if(n > this._nMaxContainer)
      {
         n = this._nMaxContainer;
      }
      if(n != this._nContainerNumber)
      {
         this._nContainerNumber = n;
         this.autoDetectBarOrientation(this._x,this._y);
         this.move(this._x,this._y,true);
      }
   }
   function get maxContainer()
   {
      return this._nMaxContainer;
   }
   function set maxContainer(n)
   {
      this._nMaxContainer = n;
      if(this._nContainerNumber > n)
      {
         this.size = n;
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.MovableContainerBar.CLASS_NAME);
      this._nContainerNumber = 1;
      this._nMaxContainer = 5;
      this._bVertical = false;
   }
   function createChildren()
   {
      this._mcDragOne.onPress = this._mcDragTwo.onPress = function()
      {
         if(this._parent._bTimerEnable != true)
         {
            this._parent.startDragWithOffset();
         }
      };
      this._mcDragOne.onRelease = this._mcDragOne.onReleaseOutside = this._mcDragTwo.onRelease = this._mcDragTwo.onReleaseOutside = function()
      {
         if(this._parent._bTimerEnable != true)
         {
            this._parent.stopDragWithOffset();
            this._parent.dispatchEvent({type:"drop"});
            this._parent._bTimerEnable = true;
            ank.utils.Timer.setTimer(this._parent,"movablecontainerbar",this._parent,this._parent.onClickTimer,ank.gapi.Gapi.DBLCLICK_DELAY);
         }
         else
         {
            this._parent.onClickTimer();
            this._parent.dispatchEvent({type:"dblClick"});
         }
      };
      this._mcBackground.onRelease = function()
      {
      };
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
   }
   function onBeforeMove(x, y, bForceDraw)
   {
      if(bForceDraw || this.autoDetectBarOrientation(x,y))
      {
         this.drawBar();
      }
   }
   function drawBar()
   {
      this._aContainers = [];
      this._mcContainers = this.createEmptyMovieClip("_mcContainers",1);
      var _loc2_ = {};
      _loc2_.backgroundRenderer = "UI_BannerContainerBackground";
      _loc2_.borderRenderer = "UI_BannerContainerBorder";
      _loc2_.dragAndDrop = true;
      _loc2_.enabled = true;
      _loc2_.highlightFront = true;
      _loc2_.highlightRenderer = "UI_BannerContainerHighLight";
      _loc2_.margin = 1;
      _loc2_.showLabel = false;
      _loc2_.styleName = "InventoryGridContainer";
      var _loc0_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      switch(this._bVertical)
      {
         case true:
            this._mcDragOne._x = 3;
            this._mcDragOne._y = 3;
            this._mcDragTwo._x = 3;
            this._mcDragTwo._y = 18 + this._nContainerNumber * (25 + 3);
            var _temp_2 = this._mcDragOne;
            var _temp_1 = "_width";
            this._mcDragTwo._width = _loc0_ = 25;
            _temp_2[_temp_1] = _loc0_;
            var _temp_4 = this._mcDragOne;
            var _temp_3 = "_height";
            this._mcDragTwo._height = _loc0_ = 12;
            _temp_4[_temp_3] = _loc0_;
            this._mcDragOne.styleName = "VerticalDragOneMovableBarStylizedRectangle";
            this._mcDragTwo.styleName = "VerticalDragTwoMovableBarStylizedRectangle";
            this._mcContainers._x = 3;
            this._mcContainers._y = 18;
            _loc3_ = 0;
            while(_loc3_ < this._nContainerNumber)
            {
               _loc2_._y = (25 + 3) * _loc3_;
               _loc4_ = this._mcContainers.attachMovie("Container","_ctr" + _loc3_,_loc3_,_loc2_);
               _loc4_.setSize(25,25);
               this._aContainers.push(_loc4_);
               _loc3_ = _loc3_ + 1;
            }
            this._mcBackground.setSize(31,33 + this._nContainerNumber * (25 + 3));
            break;
         case false:
            this._mcDragOne._x = 3;
            this._mcDragOne._y = 3;
            this._mcDragTwo._x = 18 + this._nContainerNumber * (25 + 3);
            this._mcDragTwo._y = 3;
            var _temp_6 = this._mcDragOne;
            var _temp_5 = "_width";
            this._mcDragTwo._width = _loc0_ = 12;
            _temp_6[_temp_5] = _loc0_;
            var _temp_8 = this._mcDragOne;
            var _temp_7 = "_height";
            this._mcDragTwo._height = _loc0_ = 25;
            _temp_8[_temp_7] = _loc0_;
            this._mcDragOne.styleName = "HorizontalDragOneMovableBarStylizedRectangle";
            this._mcDragTwo.styleName = "HorizontalDragTwoMovableBarStylizedRectangle";
            this._mcContainers._x = 18;
            this._mcContainers._y = 3;
            _loc5_ = 0;
            while(_loc5_ < this._nContainerNumber)
            {
               _loc2_._x = (25 + 3) * _loc5_;
               _loc6_ = this._mcContainers.attachMovie("Container","_ctr" + _loc5_,_loc5_,_loc2_);
               _loc6_.setSize(25,25);
               this._aContainers.push(_loc6_);
               _loc5_ = _loc5_ + 1;
            }
            this._mcBackground.setSize(33 + this._nContainerNumber * (25 + 3),31);
      }
      this.dispatchEvent({type:"drawBar"});
   }
   function autoDetectBarOrientation(x, y)
   {
      var _loc4_ = y - this.bounds.top;
      var _loc5_ = this.bounds.bottom - y;
      var _loc6_ = x - this.bounds.left;
      var _loc7_ = this.bounds.right - x;
      var _loc8_ = this._bVertical;
      var _loc9_ = 1000000;
      if(_loc4_ < this.snap)
      {
         if(_loc4_ < _loc9_)
         {
            _loc9_ = _loc4_;
            _loc8_ = false;
         }
      }
      if(_loc5_ < this.snap)
      {
         if(_loc5_ < _loc9_)
         {
            _loc9_ = _loc5_;
            _loc8_ = false;
         }
      }
      if(_loc6_ < this.snap)
      {
         if(_loc6_ < _loc9_)
         {
            _loc9_ = _loc6_;
            _loc8_ = true;
         }
      }
      if(_loc7_ < this.snap)
      {
         if(_loc7_ < _loc9_)
         {
            _loc9_ = _loc7_;
            _loc8_ = true;
         }
      }
      if(this._nContainerNumber >= dofus.graphics.gapi.ui.MovableContainerBar.FORCE_HORIZONTAL_BAR_CONTAINERS_COUNT)
      {
         _loc8_ = false;
      }
      if(_loc8_ != undefined && this._bVertical != _loc8_)
      {
         this._bVertical = _loc8_;
         return true;
      }
      return false;
   }
   function setOptions(m, s, b, si, c)
   {
      this._nMaxContainer = m;
      this.snap = s;
      this.bounds = b;
      this._nContainerNumber = si;
      if(c.v != undefined)
      {
         this._bVertical = this._nContainerNumber < dofus.graphics.gapi.ui.MovableContainerBar.FORCE_HORIZONTAL_BAR_CONTAINERS_COUNT ? c.v : false;
      }
      this.move(c.x,c.y,true);
   }
   function onClickTimer()
   {
      ank.utils.Timer.removeTimer(this,"movablecontainerbar");
      this._bTimerEnable = false;
   }
   function onShortcut(shortcut)
   {
      var _loc3_ = 0;
      while(_loc3_ < this._nContainerNumber)
      {
         if(shortcut == "MOVABLEBAR_SH" + _loc3_)
         {
            this._aContainers[_loc3_].notInChat = true;
            this._aContainers[_loc3_].emulateClick();
            return false;
         }
         _loc3_ = _loc3_ + 1;
      }
      return true;
   }
}
