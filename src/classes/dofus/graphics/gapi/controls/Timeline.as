class dofus.graphics.gapi.controls.Timeline extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aTs;
   var _btnOpenClose;
   var _parent;
   var _vcChrono;
   var addToQueue;
   var createEmptyMovieClip;
   var gapi;
   var layout_mc;
   static var CLASS_NAME = "Timeline";
   static var ITEM_WIDTH = 34;
   static var ITEM_SUMMONED_HEIGHT_DELTA = 2;
   static var ITEM_SUMMONED_WIDTH = 28;
   static var HIDE_COLOR = 4473924;
   var _currentDisplayIndex = 0;
   var _itemsList = [];
   var _previousCharacList = [];
   var _depth = 0;
   var _bOpened = true;
   function Timeline()
   {
      super();
   }
   function set opened(bOpened)
   {
      this._bOpened = bOpened;
      this.layout_mc._visible = bOpened;
   }
   function get opened()
   {
      return this._bOpened;
   }
   function update()
   {
      this.generate();
   }
   function nextTurn(id, bWithoutTween)
   {
      if(bWithoutTween)
      {
         bWithoutTween = false;
      }
      var _loc4_ = this.layout_mc.items_mc["item" + id];
      if(_loc4_ == undefined)
      {
         return undefined;
      }
      this.layout_mc.pointer_mc._visible = true;
      this.stopChrono();
      this._vcChrono = _loc4_.chrono;
      if(bWithoutTween)
      {
         this.layout_mc.pointer_mc.move(_loc4_._x,0);
         this.layout_mc.pointer_mc._xscale = _loc4_._xscale;
         this.layout_mc.pointer_mc._yscale = _loc4_._yscale;
      }
      else
      {
         this.layout_mc.pointer_mc.moveTween(_loc4_._x,_loc4_._xscale);
      }
      this.layout_mc.pointer_mc._y = !_loc4_._oData.isSummoned ? 0 : dofus.graphics.gapi.controls.Timeline.ITEM_SUMMONED_HEIGHT_DELTA;
      this._currentDisplayIndex = id;
   }
   function hideItem(id)
   {
      var _loc3_ = this.layout_mc.items_mc["item" + id];
      _loc3_.isHidden = true;
      this.generate();
   }
   function showItem(id)
   {
      var _loc3_ = this.layout_mc.items_mc["item" + id];
      _loc3_.isHidden = false;
      this.generate();
   }
   function startChrono(nDuration)
   {
      this._vcChrono.startTimer(nDuration);
   }
   function stopChrono()
   {
      this._vcChrono.stopTimer();
   }
   function itemOver(nObjectID)
   {
      var _loc3_ = this.layout_mc.items_mc["item" + nObjectID];
      _loc3_.itemOver();
   }
   function itemOut(nObjectID)
   {
      var _loc3_ = this.layout_mc.items_mc["item" + nObjectID];
      _loc3_.itemOut();
   }
   function updateCharacters()
   {
      var _loc2_ = this.api.datacenter;
      var _loc3_ = [];
      var _loc4_ = 0;
      while(_loc4_ < this._aTs.length)
      {
         _loc3_.push(_loc2_.Sprites.getItemAt(this._aTs[_loc4_]));
         _loc4_ = _loc4_ + 1;
      }
      var _loc5_ = _loc3_.length;
      _loc4_ = 0;
      var _loc7_;
      var _loc6_;
      while(_loc4_ < _loc5_)
      {
         _loc7_ = _loc3_[_loc4_];
         _loc6_ = _loc7_.id;
         this.layout_mc.items_mc["item" + _loc6_].data = _loc7_;
         _loc4_ = _loc4_ + 1;
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.Timeline.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.createEmptyMovieClip("layout_mc",10);
      this.layout_mc.createEmptyMovieClip("SummonedLayout",9);
      var _loc2_ = this.layout_mc.attachMovie("TimelinePointer","pointer_mc",10);
      _loc2_._visible = false;
      this.generate();
   }
   function addListeners()
   {
      this._btnOpenClose.onRelease = function()
      {
         this._parent.opened = !this._parent.opened;
      };
   }
   function generate(cs)
   {
      var _loc3_ = this.api.datacenter;
      if(cs == undefined)
      {
         cs = _loc3_.Game.turnSequence;
      }
      this._aTs = cs;
      var _loc4_ = [];
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < cs.length)
      {
         _loc6_ = _loc3_.Sprites.getItemAt(cs[_loc5_]);
         if(_loc6_ != undefined)
         {
            _loc4_.push(_loc6_);
         }
         _loc5_ = _loc5_ + 1;
      }
      var _loc7_ = _loc4_.length;
      if(this.layout_mc.items_mc == undefined)
      {
         this.layout_mc.createEmptyMovieClip("items_mc",20);
      }
      var _loc8_ = 20;
      _loc5_ = 0;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      while(_loc5_ < _loc7_)
      {
         _loc9_ = _loc4_[_loc5_];
         _loc10_ = this.layout_mc.items_mc["item" + _loc9_.id];
         if(!(_loc10_ != undefined && _loc10_.isHidden))
         {
            _loc11_ = _loc4_[_loc5_];
            _loc8_ += !_loc11_.isSummoned ? dofus.graphics.gapi.controls.Timeline.ITEM_WIDTH : dofus.graphics.gapi.controls.Timeline.ITEM_SUMMONED_WIDTH;
         }
         _loc5_ = _loc5_ + 1;
      }
      var _loc12_;
      var _loc13_;
      var _loc14_;
      for(var k in this._previousCharacList)
      {
         _loc12_ = this._previousCharacList[k].id;
         _loc13_ = false;
         for(var kk in _loc4_)
         {
            _loc14_ = _loc4_[kk].id;
            if(_loc12_ == _loc14_)
            {
               _loc13_ = true;
               break;
            }
         }
         if(!_loc13_)
         {
            this.layout_mc.items_mc["item" + _loc12_].removeMovieClip();
         }
      }
      var _loc16_ = - _loc8_;
      _loc5_ = 0;
      var _loc19_;
      var _loc15_;
      var _loc20_;
      var _loc17_;
      var _loc21_;
      var _loc18_;
      for(; _loc5_ < _loc7_; _loc5_ = _loc5_ + 1)
      {
         _loc19_ = _loc4_[_loc5_];
         _loc15_ = _loc19_.id;
         _loc20_ = this.layout_mc.items_mc["item" + _loc15_];
         if(_loc20_ == undefined)
         {
            _loc20_ = this.layout_mc.items_mc.attachMovie("TimelineItem","item" + _loc15_,this._depth++,{index:_loc5_,data:_loc19_,api:this.api,gapi:this.gapi});
         }
         else
         {
            _loc20_._visible = !_loc20_.isHidden;
            if(_loc20_.isHidden)
            {
               if(!_loc19_.isSummoned)
               {
                  this.layout_mc.SummonedLayout["TISB" + _loc20_.index].removeMovieClip();
               }
               continue;
            }
         }
         if(_loc19_.isSummoned)
         {
            _loc20_._xscale = 80;
            _loc20_._yscale = 80;
         }
         _loc20_._x = _loc16_;
         _loc20_._y = !_loc19_.isSummoned ? 0 : dofus.graphics.gapi.controls.Timeline.ITEM_SUMMONED_HEIGHT_DELTA;
         if(!_loc19_.isSummoned)
         {
            _loc17_ = _loc20_;
            this.layout_mc.SummonedLayout["TISB" + _loc20_.index].removeMovieClip();
         }
         else
         {
            _loc21_ = this.layout_mc.SummonedLayout["TISB" + _loc17_.index];
            if(_loc21_ == undefined)
            {
               _loc21_ = this.layout_mc.SummonedLayout.attachMovie("TimelineItemSummonedBg","TISB" + _loc17_.index,_loc17_.index);
            }
            _loc21_._x = _loc17_._x;
            _loc21_._mcBody._width = _loc20_._x - _loc17_._x + _loc20_._width + 1;
            _loc21_._mcEnd._x = _loc21_._mcBody._width;
         }
         _loc16_ += !_loc19_.isSummoned ? dofus.graphics.gapi.controls.Timeline.ITEM_WIDTH : dofus.graphics.gapi.controls.Timeline.ITEM_SUMMONED_WIDTH;
         _loc18_ = _loc20_;
      }
      this.nextTurn(this._currentDisplayIndex,true);
      this._previousCharacList = _loc4_;
   }
}
