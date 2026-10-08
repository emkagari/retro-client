class ank.battlefield.datacenter.Cell extends Object
{
   var allSpritesOn;
   var nPermanentLevel;
   var num;
   var y;
   var active = true;
   var lineOfSight = true;
   var layerGroundRot = 0;
   var groundLevel = 7;
   var movement = 4;
   var layerGroundNum = 0;
   var groundSlope = 1;
   var layerGroundFlip = false;
   var layerObject1Num = 0;
   var layerObject1Rot = 0;
   var layerObject1Flip = false;
   var layerObject2Flip = false;
   var layerObject2Interactive = false;
   var layerObject2Num = 0;
   function Cell()
   {
      super();
   }
   function get rootY()
   {
      return this.y - (7 - this.groundLevel) * ank.battlefield.Constants.LEVEL_HEIGHT;
   }
   function get isTrigger()
   {
      var _loc2_ = false;
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < dofus.Constants.MAP_TRIGGER_LAYEROBJECTS.length)
      {
         _loc4_ = dofus.Constants.MAP_TRIGGER_LAYEROBJECTS[_loc3_];
         if(this.layerObject1Num == _loc4_ || this.layerObject2Num == _loc4_)
         {
            _loc2_ = true;
            break;
         }
         _loc3_ = _loc3_ + 1;
      }
      return _loc2_;
   }
   function get isUnwalkableLayerObject()
   {
      var _loc2_ = false;
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < dofus.Constants.MAP_UNWALKABLE_LAYEROBJECTS.length)
      {
         _loc4_ = dofus.Constants.MAP_UNWALKABLE_LAYEROBJECTS[_loc3_];
         if(this.layerObject1Num == _loc4_ || this.layerObject2Num == _loc4_)
         {
            _loc2_ = true;
            break;
         }
         _loc3_ = _loc3_ + 1;
      }
      return _loc2_;
   }
   function get isTargetable()
   {
      return this.movement != 0 && (this.movement != 1 && this.active);
   }
   function addSpriteOnID(sID)
   {
      if(this.allSpritesOn == undefined)
      {
         this.allSpritesOn = {};
      }
      if(sID == undefined)
      {
         return undefined;
      }
      if(this.allSpritesOn[sID])
      {
         return undefined;
      }
      this.allSpritesOn[sID] = true;
      var _loc3_ = _global.API;
      var _loc4_ = _loc3_.datacenter.Basics.interactionsManager_path;
      var _loc5_;
      if(_loc4_ != undefined)
      {
         _loc5_ = _loc3_.gfx.mapHandler.getCellData(_loc4_[_loc4_.length - 1].num);
         if(_loc5_ != undefined && _loc5_.mc.onRollOver)
         {
            _loc5_.mc.onRollOver();
         }
      }
   }
   function removeSpriteOnID(sID)
   {
      this.allSpritesOn[sID] = undefined;
      delete this.allSpritesOn[sID];
   }
   function removeAllSpritesOnID()
   {
      for(var k in this.allSpritesOn)
      {
         this.allSpritesOn[k] = undefined;
         delete this.allSpritesOn[k];
      }
      delete this.allSpritesOn;
   }
   function get spriteOnCount()
   {
      var _loc2_ = 0;
      for(var k in this.allSpritesOn)
      {
         _loc2_ = _loc2_ + 1;
      }
      return _loc2_;
   }
   function get spriteOnID()
   {
      if(this.allSpritesOn == undefined)
      {
         return undefined;
      }
      for(var k in this.allSpritesOn)
      {
         if(this.allSpritesOn[k])
         {
            return String(k);
         }
      }
      return undefined;
   }
   function get carriedSpriteOnId()
   {
      if(this.allSpritesOn == undefined)
      {
         return false;
      }
      for(var k in this.allSpritesOn)
      {
         if(this.allSpritesOn[k].hasCarriedChild())
         {
            return true;
         }
      }
      return false;
   }
   function turnTactic(mapHandler, map)
   {
      var _loc4_ = _global.API;
      var _loc5_ = this.isTrigger;
      if(this.nPermanentLevel == 0)
      {
         this.nPermanentLevel = 1;
      }
      this.layerGroundNum = 0;
      this.layerObject1Rot = 0;
      this.layerObject1Flip = false;
      this.layerObject2Flip = false;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      if(!this.lineOfSight)
      {
         this.layerObject1Num = 100012;
      }
      else if(this.movement == 0 || this.movement == 1)
      {
         this.layerObject1Num = 0;
      }
      else
      {
         _loc6_ = ank.battlefield.utils.Pathfinding.getCaseCoordonnee(mapHandler,this.num);
         _loc7_ = Math.abs(_loc6_.x) % 2 == Math.abs(_loc6_.y) % 2;
         _loc8_ = this.groundSlope <= 9 ? "0" + this.groundSlope : this.groundSlope;
         this.layerObject1Num = !_loc7_ ? Number("100" + _loc8_ + "3") : Number("100" + _loc8_ + "1");
      }
      if(this.layerObject2Num != 25)
      {
         if(!this.lineOfSight)
         {
            this.layerObject2Num = 100010;
         }
         else if(_loc5_)
         {
            this.layerObject2Num = 1030;
         }
         else
         {
            this.layerObject2Num = 0;
         }
      }
   }
}
