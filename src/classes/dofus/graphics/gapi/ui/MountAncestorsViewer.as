class dofus.graphics.gapi.ui.MountAncestorsViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _lblMountName;
   var _oMount;
   var _parent;
   var addToQueue;
   var attachMovie;
   var gapi;
   var initialized;
   var unloadThis;
   static var CLASS_NAME = "MountAncestorsViewer";
   function MountAncestorsViewer()
   {
      super();
   }
   function set mount(oMount)
   {
      this._oMount = oMount;
      if(this.initialized)
      {
         this.updateData();
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.MountAncestorsViewer.CLASS_NAME);
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.updateData});
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      var _loc2_ = 0;
      while(_loc2_ < 15)
      {
         this["_ldr" + _loc2_].addEventListener("initialization",this);
         _loc2_ = _loc2_ + 1;
      }
   }
   function initTexts()
   {
   }
   function updateData()
   {
      var _loc2_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      if(this._oMount != undefined)
      {
         this._lblMountName.text = this._oMount.name;
         _loc2_ = new ank.utils.ExtendedArray();
         for(var a in this._oMount.ancestors)
         {
            _loc2_[a] = this._oMount.ancestors[a];
         }
         _loc2_.push(this._oMount.modelID);
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = Number(_loc2_[_loc3_]);
            if(_loc4_ != 0)
            {
               _loc5_ = new dofus.datacenter.Mount(_loc4_);
               _loc6_ = ank.gapi.controls.Loader(this["_ldr" + _loc3_]);
               _loc6_.forceNextLoad();
               _loc6_.contentPath = _loc5_.gfxFile;
               _loc7_ = new ank.battlefield.datacenter.Sprite("-1",undefined,"",0,0);
               _loc7_.mount = _loc5_;
               this.api.colors.addSprite(_loc6_,_loc7_);
               _loc8_ = this.attachMovie("Rectangle","mcButton" + _loc3_,_loc3_);
               _loc8_._width = 75;
               _loc8_._height = 75;
               _loc8_._alpha = 0;
               _loc8_._x = _loc6_._x - 35;
               _loc8_._y = _loc6_._y - 60;
               _loc8_.mount = _loc5_;
               _loc8_.onRollOver = function()
               {
                  this._parent.gapi.showTooltip(this.mount.modelName);
               };
               _loc8_.onRollOut = function()
               {
                  this._parent.out();
               };
            }
            this["_mcUnknown" + _loc3_]._visible = _loc4_ == 0;
            _loc3_ = _loc3_ + 1;
         }
      }
   }
   function initialization(oEvent)
   {
      var _loc3_ = oEvent.target.content;
      _loc3_.attachMovie("staticR_front","anim_front",11);
      _loc3_.attachMovie("staticR_back","anim_back",10);
   }
   function click(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._btnClose)
      {
         this.callClose();
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
