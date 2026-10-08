719174486 - 1;
class dofus.graphics.gapi.ui.FloatingTips extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _lblLearnMore;
   var _mcLearnMoreButton;
   var _nSnap;
   var _nTipID;
   var _oBounds;
   var _taTipsContent;
   var _winBackground;
   var _x;
   var _y;
   var addToQueue;
   var gapi;
   var getBounds;
   var unloadThis;
   static var CLASS_NAME = "FloatingTips";
   static var MINIMUM_ALPHA_VALUE = 40;
   var _bDraggin = false;
   var _nOffsetX = 0;
   var _nOffsetY = 0;
   function FloatingTips()
   {
      super();
   }
   function get bounds()
   {
      return this._oBounds;
   }
   function set bounds(oValue)
   {
      this._oBounds = oValue;
   }
   function get snap()
   {
      return this._nSnap;
   }
   function set snap(nValue)
   {
      this._nSnap = nValue;
   }
   function get tip()
   {
      return this._nTipID;
   }
   function set tip(nValue)
   {
      this._nTipID = nValue;
      this.refreshData();
   }
   function get position()
   {
      return new com.ankamagames.types.Point(this._x,this._y);
   }
   function set position(pValue)
   {
      this._x = pValue.x;
      this._y = pValue.y;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.FloatingTips.CLASS_NAME);
      this._oBounds = {left:0,top:0,right:this.gapi.screenWidth,bottom:this.gapi.screenHeight};
      this._nSnap = 20;
   }
   function destroy()
   {
      Mouse.removeListener(this);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.refreshData});
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._taTipsContent.addEventListener("href",this);
      ank.utils.MouseEvents.addListener(this);
      var myself = this;
      this._winBackground.onPress = function()
      {
         myself.drag();
      };
      this._winBackground.onRelease = this._winBackground.onReleaseOutside = function()
      {
         myself.drop();
      };
      this._mcLearnMoreButton.onRelease = function()
      {
         myself.click({target:myself._mcLearnMoreButton});
      };
   }
   function initTexts()
   {
      this._winBackground.title = this.api.lang.getText("TIPS_WORD");
      this._lblLearnMore.text = this.api.lang.getText("LEARN_MORE");
   }
   function refreshData()
   {
      if(this._taTipsContent.text == undefined)
      {
         return undefined;
      }
      this._taTipsContent.text = "<p class=\'body\'>" + this.api.lang.getKnownledgeBaseTip(this._nTipID).c + "</p>";
   }
   function move(nX, nY)
   {
      this._x = nX;
      this._y = nY;
      this.snapWindow();
      this.api.kernel.OptionsManager.setOption("FloatingTipsCoord",new com.ankamagames.types.Point(this._x,this._y));
   }
   function snapWindow()
   {
      var _loc2_ = this._x;
      var _loc3_ = this._y;
      var _loc4_ = this.getBounds();
      var _loc5_ = _loc3_ + _loc4_.yMin - this._oBounds.top;
      var _loc6_ = this._oBounds.bottom - _loc3_ - _loc4_.yMax;
      var _loc7_ = _loc2_ + _loc4_.xMin - this._oBounds.left;
      var _loc8_ = this._oBounds.right - _loc2_ - _loc4_.xMax;
      if(_loc5_ < this._nSnap)
      {
         _loc3_ = this._oBounds.top - _loc4_.yMin;
      }
      if(_loc6_ < this._nSnap)
      {
         _loc3_ = this._oBounds.bottom - _loc4_.yMax;
      }
      if(_loc7_ < this._nSnap)
      {
         _loc2_ = this._oBounds.left - _loc4_.xMin;
      }
      if(_loc8_ < this._nSnap)
      {
         _loc2_ = this._oBounds.right - _loc4_.xMax;
      }
      this._y = _loc3_;
      this._x = _loc2_;
   }
   function click(oEvent)
   {
      switch(oEvent.target._name)
      {
         case "_btnClose":
            this.unloadThis();
            break;
         case "_mcLearnMoreButton":
            this.api.ui.loadUIComponent("KnownledgeBase","KnownledgeBase",{article:this.api.lang.getKnownledgeBaseTip(this._nTipID).l});
         default:
            return;
      }
   }
   function drag()
   {
      this._nOffsetX = _root._xmouse - this._x;
      this._nOffsetY = _root._ymouse - this._y;
      this._bDraggin = true;
   }
   function drop()
   {
      this._bDraggin = false;
   }
   function onMouseMove()
   {
      if(this._bDraggin)
      {
         this.move(_root._xmouse - this._nOffsetX,_root._ymouse - this._nOffsetY);
      }
   }
   function href(oEvent)
   {
      this.api.kernel.TipsManager.onLink(oEvent);
   }
}
