class ank.battlefield.InteractionHandler
{
   var _bIs8;
   var _extraProto;
   var _mcContainer;
   var _oDatacenter;
   function InteractionHandler(c, d)
   {
      this.initialize(c,d);
   }
   function initialize(c, d)
   {
      this._mcContainer = c;
      this._oDatacenter = d;
      this._extraProto = {};
      this.setEnabled(ank.battlefield.Constants.INTERACTION_NONE);
      this._bIs8 = Number(System.capabilities.version.substr(0,1)) >= 8;
   }
   function setEnabled(nState)
   {
      switch(nState)
      {
         case ank.battlefield.Constants.INTERACTION_NONE:
            this.setEnabledOffAllExtraProto();
            this.setEnabledProtoAll(ank.battlefield.mc.Cell.prototype,false);
            this.setEnabledProtoAll(ank.battlefield.mc.InteractiveObject.prototype,false);
            this.setEnabledProtoAll(ank.battlefield.mc.Sprite.prototype,false);
            break;
         case ank.battlefield.Constants.INTERACTION_CELL_NONE:
            this.setEnabledOffAllExtraProto();
            this.setEnabledProtoAll(ank.battlefield.mc.Cell.prototype,false);
            break;
         case ank.battlefield.Constants.INTERACTION_CELL_RELEASE:
            this.setEnabledProtoRelease(ank.battlefield.mc.Cell.prototype,true);
            this.setEnabledProtoOutOver(ank.battlefield.mc.Cell.prototype,false);
            break;
         case ank.battlefield.Constants.INTERACTION_CELL_OVER_OUT:
            this.setEnabledProtoRelease(ank.battlefield.mc.Cell.prototype,false);
            this.setEnabledProtoOutOver(ank.battlefield.mc.Cell.prototype,true);
            break;
         case ank.battlefield.Constants.INTERACTION_CELL_RELEASE_OVER_OUT:
            this.setEnabledProtoAll(ank.battlefield.mc.Cell.prototype,true);
            break;
         case ank.battlefield.Constants.INTERACTION_OBJECT_NONE:
            this.setEnabledProtoRelease(ank.battlefield.mc.InteractiveObject.prototype,false);
            this.setEnabledProtoOutOver(ank.battlefield.mc.InteractiveObject.prototype,false);
            if(this._bIs8)
            {
               this.setEnabledObject2Release(false);
               this.setEnabledObject2OutOver(false);
            }
            break;
         case ank.battlefield.Constants.INTERACTION_OBJECT_RELEASE:
            this.setEnabledProtoRelease(ank.battlefield.mc.InteractiveObject.prototype,true);
            this.setEnabledProtoOutOver(ank.battlefield.mc.InteractiveObject.prototype,false);
            if(this._bIs8)
            {
               this.setEnabledObject2Release(true);
               this.setEnabledObject2OutOver(false);
            }
            break;
         case ank.battlefield.Constants.INTERACTION_OBJECT_OVER_OUT:
            this.setEnabledProtoRelease(ank.battlefield.mc.InteractiveObject.prototype,false);
            this.setEnabledProtoOutOver(ank.battlefield.mc.InteractiveObject.prototype,true);
            if(this._bIs8)
            {
               this.setEnabledObject2Release(false);
               this.setEnabledObject2OutOver(true);
            }
            break;
         case ank.battlefield.Constants.INTERACTION_OBJECT_RELEASE_OVER_OUT:
            this.setEnabledProtoAll(ank.battlefield.mc.InteractiveObject.prototype,true);
            if(this._bIs8)
            {
               this.setEnabledObject2All(true);
            }
            break;
         case ank.battlefield.Constants.INTERACTION_SPRITE_NONE:
            this.setEnabledProtoRelease(ank.battlefield.mc.Sprite.prototype,false);
            this.setEnabledProtoOutOver(ank.battlefield.mc.Sprite.prototype,false);
            break;
         case ank.battlefield.Constants.INTERACTION_SPRITE_RELEASE:
            this.setEnabledProtoRelease(ank.battlefield.mc.Sprite.prototype,true);
            this.setEnabledProtoOutOver(ank.battlefield.mc.Sprite.prototype,false);
            break;
         case ank.battlefield.Constants.INTERACTION_SPRITE_OVER_OUT:
            this.setEnabledProtoRelease(ank.battlefield.mc.Sprite.prototype,false);
            this.setEnabledProtoOutOver(ank.battlefield.mc.Sprite.prototype,true);
            break;
         case ank.battlefield.Constants.INTERACTION_SPRITE_RELEASE_OVER_OUT:
            this.setEnabledProtoAll(ank.battlefield.mc.Sprite.prototype,true);
         default:
            return;
      }
   }
   function setEnabledCell(nCellNum, nState)
   {
      var _loc4_ = this._mcContainer["cell" + nCellNum];
      if(_loc4_ == undefined)
      {
         ank.utils.Logger.err("[setEnabledCell] Cell inexistante");
         return undefined;
      }
      this._extraProto[_loc4_._name] = _loc4_;
      switch(nState)
      {
         case ank.battlefield.Constants.INTERACTION_NONE:
            this.setEnabledProtoAll(_loc4_,false);
            break;
         case ank.battlefield.Constants.INTERACTION_CELL_RELEASE:
            this.setEnabledProtoRelease(_loc4_,true);
            this.setEnabledProtoOutOver(_loc4_,false);
            break;
         case ank.battlefield.Constants.INTERACTION_CELL_OVER_OUT:
            this.setEnabledProtoRelease(_loc4_,false);
            this.setEnabledProtoOutOver(_loc4_,true);
            break;
         case ank.battlefield.Constants.INTERACTION_CELL_RELEASE_OVER_OUT:
            this.setEnabledProtoAll(_loc4_,true);
         default:
            return;
      }
   }
   function setEnabledOffAllExtraProto(Void)
   {
      var _loc3_;
      for(var p in this._extraProto)
      {
         _loc3_ = this._extraProto[p];
         this.setEnabledProtoAll(_loc3_,false);
      }
      this._extraProto = [];
   }
   function setEnabledProtoAll(proto, bool)
   {
      if(bool)
      {
         proto.onRelease = proto._release;
      }
      else
      {
         delete proto.onRelease;
      }
      this.setEnabledProtoOutOver(proto,bool);
   }
   function setEnabledProtoRelease(proto, bool)
   {
      if(bool)
      {
         proto.onRelease = proto._release;
      }
      else
      {
         delete proto.onRelease;
      }
   }
   function setEnabledProtoOutOver(proto, bool)
   {
      var _loc4_;
      if(bool)
      {
         proto.onRollOver = proto._rollOver;
         proto.onRollOut = proto._rollOut;
         proto.onRollOut = proto.onReleaseOutside = proto._rollOut;
      }
      else
      {
         delete proto.onRollOver;
         delete proto.onRollOut;
         delete proto.onReleaseOutside;
         _loc4_ = _global.API;
         if(_loc4_.gfx.rollOverMcObject == proto || _loc4_.gfx.rollOverMcSprite == proto)
         {
            proto._rollOut();
         }
      }
   }
   function setEnabledObject2All(bool)
   {
      var _loc3_ = this._oDatacenter.Map.data;
      var _loc4_;
      for(var k in _loc3_)
      {
         _loc4_ = _loc3_[k].mcObject2;
         if(_loc3_[k].layerObject2Interactive)
         {
            if(_loc4_ != undefined)
            {
               if(bool)
               {
                  _loc4_.onRelease = _loc4_._release;
               }
               else
               {
                  delete _loc4_.onRelease;
               }
               this.setEnabledProtoOutOver(_loc4_,bool);
            }
         }
      }
   }
   function setEnabledObject2Release(bool)
   {
      var _loc3_ = this._oDatacenter.Map.data;
      var _loc4_;
      for(var k in _loc3_)
      {
         _loc4_ = _loc3_[k].mcObject2;
         if(_loc3_[k].layerObject2Interactive)
         {
            if(_loc4_ != undefined)
            {
               if(bool)
               {
                  _loc4_.onRelease = _loc4_._release;
               }
               else
               {
                  delete _loc4_.onRelease;
               }
            }
         }
      }
   }
   function setEnabledObject2OutOver(bool)
   {
      var _loc3_ = this._oDatacenter.Map.data;
      var _loc4_;
      for(var k in _loc3_)
      {
         _loc4_ = _loc3_[k].mcObject2;
         if(_loc3_[k].layerObject2Interactive)
         {
            if(_loc4_ != undefined)
            {
               this.setEnabledProtoOutOver(_loc4_,bool);
            }
         }
      }
   }
}
