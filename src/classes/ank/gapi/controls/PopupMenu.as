class ank.gapi.controls.PopupMenu extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _aColumnsMaxSize;
   var _aItems;
   var _bAdminPopupMenu;
   var _bInitialized;
   var _mcBackground;
   var _mcBorder;
   var _mcForeground;
   var _mcItems;
   var _nX;
   var _nY;
   var _name;
   var _parent;
   var _x;
   var _y;
   var addToQueue;
   var createEmptyMovieClip;
   var drawRoundRect;
   var gapi;
   var getStyle;
   var removeMovieClip;
   var setSize;
   static var currentPopupMenu;
   static var CLASS_NAME = "PopupMenu";
   static var MAX_ITEM_WIDTH = 150;
   static var ITEM_HEIGHT = 18;
   var _bOver = false;
   var _bCloseOnMouseUp = false;
   var _bRemoved = true;
   var _bGatherPopupMenu = false;
   var _nGatherCellNum = -1;
   function PopupMenu()
   {
      super();
   }
   function get isGatherPopupMenu()
   {
      return this._bGatherPopupMenu;
   }
   function set isGatherPopupMenu(bGatherPopupMenu)
   {
      this._bGatherPopupMenu = bGatherPopupMenu;
   }
   function get gatherCellNum()
   {
      return this._nGatherCellNum;
   }
   function set gatherCellNum(nGatherCellNum)
   {
      this._nGatherCellNum = nGatherCellNum;
   }
   function get x()
   {
      return this._nX;
   }
   function get y()
   {
      return this._nY;
   }
   function get removed()
   {
      return this._bCloseOnMouseUp;
   }
   function get adminPopupMenu()
   {
      return this._bAdminPopupMenu;
   }
   function set adminPopupMenu(bAdminPopupMenu)
   {
      this._bAdminPopupMenu = bAdminPopupMenu;
   }
   function addNewColumn()
   {
      var _loc2_ = {};
      _loc2_.addNewColumn = true;
      this._aItems.push(_loc2_);
   }
   function addStaticItem(text)
   {
      var _loc3_ = {};
      _loc3_.text = text;
      _loc3_.bStatic = true;
      _loc3_.bEnabled = false;
      this._aItems.push(_loc3_);
   }
   function addItem(text, obj, fn, args, bEnabled)
   {
      if(bEnabled == undefined)
      {
         bEnabled = true;
      }
      var _loc7_ = {};
      _loc7_.text = text;
      _loc7_.bStatic = false;
      _loc7_.bEnabled = bEnabled;
      _loc7_.obj = obj;
      _loc7_.fn = fn;
      _loc7_.args = args;
      this._aItems.push(_loc7_);
   }
   function get items()
   {
      return this._aItems;
   }
   function show(nX, nY, bMaximize, bUseRightCorner, nTimer)
   {
      ank.utils.Timer.removeTimer(this._name);
      if(nX == undefined)
      {
         nX = _root._xmouse;
      }
      if(nY == undefined)
      {
         nY = _root._ymouse;
      }
      this._nX = nX;
      this._nY = nY;
      this.layoutContent(nX,nY,bMaximize,bUseRightCorner);
      if(!_global.isNaN(Number(nTimer)))
      {
         ank.utils.Timer.setTimer(this,this._name,this,this.remove,nTimer);
         this._bRemoved = false;
      }
      ank.gapi.controls.PopupMenu.currentPopupMenu = this;
      this.addToQueue({object:Mouse,method:Mouse.addListener,params:[this]});
   }
   function init()
   {
      super.init(false,ank.gapi.controls.PopupMenu.CLASS_NAME);
      this._aItems = [];
      this._aColumnsMaxSize = [];
   }
   function createChildren()
   {
      this.createEmptyMovieClip("_mcBorder",10);
      this.createEmptyMovieClip("_mcBackground",20);
      this.createEmptyMovieClip("_mcForeground",30);
      this.createEmptyMovieClip("_mcItems",40);
   }
   function size()
   {
      this.arrange();
   }
   function arrange()
   {
      var _loc2_;
      if(this._bInitialized && (this.__width != undefined && this.__height != undefined))
      {
         this._mcItems._x = this._mcItems._y = 2;
         this._mcBorder._width = this.__width;
         this._mcBorder._height = this.__height;
         this._mcBackground._x = this._mcBackground._y = 1;
         this._mcBackground._width = this.__width - 2;
         this._mcBackground._height = this.__height - 2;
         this._mcForeground._x = this._mcForeground._y = 2;
         this._mcForeground._width = this.__width - 4;
         this._mcForeground._height = this.__height - 4;
         _loc2_ = this._aItems.length;
         while(_loc2_-- > 0)
         {
            this.arrangeItem(_loc2_,this.__width - 4);
         }
      }
   }
   function draw()
   {
      var _loc2_ = this.getStyle();
      this._mcBorder.clear();
      this._mcBackground.clear();
      this._mcForeground.clear();
      this.drawRoundRect(this._mcBorder,0,0,1,1,0,_loc2_.bordercolor);
      this.drawRoundRect(this._mcBackground,0,0,1,1,0,_loc2_.backgroundcolor);
      this.drawRoundRect(this._mcForeground,0,0,1,1,0,_loc2_.foregroundcolor);
   }
   function drawItem(i, index, nY, nXStart)
   {
      var _loc5_ = this._mcItems.createEmptyMovieClip("item" + index,index);
      var _loc6_ = ank.gapi.controls.Label(_loc5_.attachMovie("Label","_lbl",20,{_width:ank.gapi.controls.PopupMenu.MAX_ITEM_WIDTH,styleName:this.getStyle().labelenabledstyle,wordWrap:true,text:i.text}));
      _loc6_.setPreferedSize("left");
      var _loc7_ = Math.max(ank.gapi.controls.PopupMenu.ITEM_HEIGHT,_loc6_.textHeight + 6);
      if(i.bStatic)
      {
         _loc6_.styleName = this.getStyle().labelstaticstyle;
      }
      else if(!i.bEnabled)
      {
         _loc6_.styleName = this.getStyle().labeldisabledstyle;
      }
      _loc5_.createEmptyMovieClip("bg",10);
      this.drawRoundRect(_loc5_.bg,0,0,1,_loc7_,0,this.getStyle().itembgcolor);
      _loc5_.bg.over = false;
      _loc5_._y = nY;
      _loc5_._x = nXStart;
      var _loc8_;
      if(i.bEnabled)
      {
         _loc5_.bg.onRelease = function()
         {
            i.fn.apply(i.obj,i.args);
            this._parent._parent._parent.remove();
         };
         _loc5_.bg.onRollOver = function()
         {
            this._parent._parent._parent.onItemOver(this,true);
         };
         _loc5_.bg.onRollOut = _loc5_.bg.onReleaseOutside = function()
         {
            this._parent._parent._parent.onItemOut(this,true);
         };
      }
      else
      {
         _loc5_.bg.onPress = function()
         {
         };
         _loc5_.bg.useHandCursor = false;
         _loc8_ = new Color(_loc5_.bg);
         if(i.bStatic)
         {
            _loc8_.setRGB(this.getStyle().itemstaticbgcolor);
         }
         else
         {
            _loc8_.setRGB(this.getStyle().itembgcolor);
         }
      }
      return {w:_loc6_.textWidth,h:_loc7_};
   }
   function arrangeItem(nIndex, nWidth)
   {
      var _loc4_ = this._mcItems["item" + nIndex];
      var _loc5_ = this._aItems[nIndex];
      var _loc6_;
      var _loc7_;
      if(_loc5_.column == this._aColumnsMaxSize.length - 1)
      {
         _loc6_ = nWidth;
         _loc7_ = 0;
         while(_loc7_ < this._aColumnsMaxSize.length - 1)
         {
            _loc6_ = _loc6_ - this._aColumnsMaxSize[_loc7_] - 16;
            _loc7_ = _loc7_ + 1;
         }
      }
      else
      {
         _loc6_ = this._aColumnsMaxSize[_loc5_.column];
      }
      _loc4_._lbl.setSize(_loc6_,ank.gapi.controls.PopupMenu.ITEM_HEIGHT);
      _loc4_.bg._width = _loc6_;
   }
   function layoutContent(x, y, bMaximize, bUseRightCorner)
   {
      var _loc6_ = this._aItems.length;
      var _loc7_ = 0;
      var _loc8_ = 0;
      var _loc9_ = 0;
      var _loc10_ = 0;
      var _loc11_ = 0;
      var _loc12_ = 0;
      var _loc13_;
      var _loc14_;
      while(_loc12_ < this._aItems.length)
      {
         _loc13_ = this._aItems[_loc12_];
         _loc13_.column = _loc11_;
         if(_loc13_.addNewColumn)
         {
            if(_loc12_ + 1 < this._aItems.length)
            {
               if(_loc7_ > _loc10_)
               {
                  _loc10_ = _loc7_;
               }
               _loc8_ += 16;
               _loc9_ += _loc8_ + 16;
               this._aColumnsMaxSize[_loc11_] = _loc8_;
               _loc7_ = 0;
               _loc8_ = 0;
               _loc11_ = _loc11_ + 1;
            }
         }
         else
         {
            _loc14_ = this.drawItem(_loc13_,_loc12_,_loc7_,_loc9_);
            _loc7_ += _loc14_.h;
            _loc8_ = Math.max(_loc8_,_loc14_.w);
         }
         _loc12_ = _loc12_ + 1;
      }
      _loc8_ += 16;
      this._aColumnsMaxSize[_loc11_] = _loc8_;
      if(_loc7_ > _loc10_)
      {
         _loc10_ = _loc7_;
      }
      _loc9_ += _loc8_;
      this.setSize(_loc9_,_loc10_ + 4);
      var _loc15_ = !bMaximize ? this.gapi.screenWidth : Stage.width;
      var _loc16_ = !bMaximize ? this.gapi.screenHeight : Stage.height;
      if(bUseRightCorner == true)
      {
         x -= this.__width;
      }
      if(x > _loc15_ - this.__width)
      {
         this._x = _loc15_ - this.__width;
      }
      else if(x < 0)
      {
         this._x = 0;
      }
      else
      {
         this._x = x;
      }
      if(y > _loc16_ - this.__height)
      {
         this._y = _loc16_ - this.__height;
      }
      else if(y < 0)
      {
         this._y = 0;
      }
      else
      {
         this._y = y;
      }
   }
   function removePopupMenu()
   {
      this.remove();
   }
   function remove()
   {
      var _loc2_;
      if(this._bGatherPopupMenu)
      {
         _loc2_ = _global.API;
         this.addToQueue({object:_loc2_.mouseClicksMemorizer,method:_loc2_.mouseClicksMemorizer.resetForGather});
      }
      ank.gapi.controls.PopupMenu.currentPopupMenu = undefined;
      this._bCloseOnMouseUp = true;
      Mouse.removeListener(this);
      this.removeMovieClip();
   }
   function getEnabledItems()
   {
      var _loc2_ = [];
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < this._aItems.length)
      {
         _loc4_ = this._aItems[_loc3_];
         if(_loc4_.bStatic || !_loc4_.bEnabled)
         {
            _loc2_.push(undefined);
         }
         else
         {
            _loc2_.push(_loc4_);
         }
         _loc3_ = _loc3_ + 1;
      }
      return _loc2_;
   }
   function selectFirstEnabled(aEnabledItems)
   {
      if(aEnabledItems == undefined)
      {
         aEnabledItems = this.getEnabledItems();
      }
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      while(_loc3_ < aEnabledItems.length)
      {
         _loc4_ = aEnabledItems[_loc3_];
         if(_loc4_ != undefined)
         {
            _loc5_ = this._mcItems["item" + _loc3_];
            this.onItemOver(_loc5_.bg);
            break;
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function selectLastEnabled(aEnabledItems)
   {
      if(aEnabledItems == undefined)
      {
         aEnabledItems = this.getEnabledItems();
      }
      var _loc3_ = aEnabledItems.length - 1;
      var _loc4_;
      var _loc5_;
      while(_loc3_ >= 0)
      {
         _loc4_ = aEnabledItems[_loc3_];
         if(_loc4_ != undefined)
         {
            _loc5_ = this._mcItems["item" + _loc3_];
            this.onItemOver(_loc5_.bg);
            break;
         }
         _loc3_ = _loc3_ - 1;
      }
   }
   function unselectAll()
   {
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < this._aItems.length)
      {
         _loc3_ = this._mcItems["item" + _loc2_];
         this.onItemOut(_loc3_.bg);
         _loc2_ = _loc2_ + 1;
      }
   }
   function executeSelectedItem()
   {
      var _loc2_ = 0;
      var _loc3_;
      var _loc4_;
      while(_loc2_ < this._aItems.length)
      {
         _loc3_ = this._aItems[_loc2_];
         _loc4_ = this._mcItems["item" + _loc2_];
         if(_loc4_.bg.over)
         {
            _loc3_.fn.apply(_loc3_.obj,_loc3_.args);
            this.remove();
            return true;
         }
         _loc2_ = _loc2_ + 1;
      }
      return false;
   }
   function selectNextItem()
   {
      var _loc2_ = this.getEnabledItems();
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      while(_loc3_ < _loc2_.length)
      {
         _loc4_ = _loc2_[_loc3_];
         if(_loc4_ != undefined)
         {
            _loc5_ = this._mcItems["item" + _loc3_];
            if(_loc5_.bg.over)
            {
               _loc6_ = _loc3_ + 1;
               while(_loc6_ < _loc2_.length)
               {
                  _loc7_ = _loc2_[_loc6_];
                  if(_loc7_ != undefined)
                  {
                     _loc8_ = this._mcItems["item" + _loc6_];
                     this.onItemOver(_loc8_.bg);
                     return undefined;
                  }
                  _loc6_ = _loc6_ + 1;
               }
               break;
            }
         }
         _loc3_ = _loc3_ + 1;
      }
      this.selectFirstEnabled(_loc2_);
   }
   function selectPreviousItem()
   {
      var _loc2_ = this.getEnabledItems();
      var _loc3_ = _loc2_.length - 1;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      while(_loc3_ >= 0)
      {
         _loc4_ = _loc2_[_loc3_];
         if(_loc4_ != undefined)
         {
            _loc5_ = this._mcItems["item" + _loc3_];
            if(_loc5_.bg.over)
            {
               _loc6_ = _loc3_ - 1;
               while(_loc6_ >= 0)
               {
                  _loc7_ = _loc2_[_loc6_];
                  if(_loc7_ != undefined)
                  {
                     _loc8_ = this._mcItems["item" + _loc6_];
                     this.onItemOver(_loc8_.bg);
                     return undefined;
                  }
                  _loc6_ = _loc6_ - 1;
               }
               break;
            }
         }
         _loc3_ = _loc3_ - 1;
      }
      this.selectLastEnabled(_loc2_);
   }
   function onItemOver(mcBg, bReal)
   {
      if(bReal)
      {
         this._bOver = true;
      }
      if(mcBg.over)
      {
         return undefined;
      }
      this.unselectAll();
      mcBg.over = true;
      var _loc4_ = new Color(mcBg);
      _loc4_.setRGB(this.getStyle().itemovercolor);
   }
   function onItemOut(mcBg, bReal)
   {
      if(bReal)
      {
         this._bOver = false;
      }
      if(!mcBg.over)
      {
         return undefined;
      }
      mcBg.over = false;
      var _loc4_ = new Color(mcBg);
      _loc4_.setRGB(this.getStyle().itembgcolor);
   }
   function onMouseUp()
   {
      if(!this._bOver && this._bRemoved)
      {
         this.remove();
      }
   }
}
