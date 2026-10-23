class dofus.aks.Job extends dofus.aks.Handler
{
   var api;
   function Job(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function changeJobStats(nJobID, params, minSlots)
   {
      this.aks.send("JO" + nJobID + "|" + params + "|" + minSlots);
   }
   function sendActivityResult(sContent)
   {
      this.aks.send("JR" + sContent);
   }
   function sendActivityAction()
   {
      this.aks.send("JA");
   }
   function onSkills(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = this.api.datacenter.Player.Jobs;
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      while(_loc5_ < _loc3_.length)
      {
         _loc6_ = _loc3_[_loc5_].split(";");
         _loc7_ = Number(_loc6_[0]);
         _loc8_ = new ank.utils.ExtendedArray();
         _loc9_ = _loc6_[1].split(",");
         _loc10_ = _loc9_.length;
         while(_loc10_-- > 0)
         {
            _loc11_ = _loc9_[_loc10_].split("~");
            _loc8_.push(new dofus.datacenter.Skill(_loc11_[0],_loc11_[1],_loc11_[2],_loc11_[3],_loc11_[4]));
         }
         _loc12_ = new dofus.datacenter.Job(_loc7_,_loc8_);
         _loc13_ = _loc4_.findFirstItem("id",_loc7_);
         if(_loc13_.index != -1)
         {
            _loc4_.updateItem(_loc13_.index,_loc12_);
         }
         else
         {
            _loc4_.push(_loc12_);
         }
         _loc5_ = _loc5_ + 1;
      }
   }
   function onXP(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = this.api.datacenter.Player.Jobs;
      var _loc5_ = _loc3_.length;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      while(_loc5_-- > 0)
      {
         _loc6_ = _loc3_[_loc5_].split(";");
         _loc7_ = Number(_loc6_[0]);
         _loc8_ = Number(_loc6_[1]);
         _loc9_ = Number(_loc6_[2]);
         _loc10_ = Number(_loc6_[3]);
         _loc11_ = Number(_loc6_[4]);
         _loc12_ = Number(_loc6_[5]);
         _loc13_ = _loc4_.findFirstItem("id",_loc7_);
         if(_loc13_.index != -1)
         {
            _loc14_ = _loc13_.item;
            _loc14_.level = _loc8_;
            _loc14_.xpMin = _loc9_;
            _loc14_.xpMax = _loc11_;
            _loc14_.xpTotal = _loc12_;
            _loc14_.xp = _loc10_;
            _loc4_.updateItem(_loc13_.index,_loc14_);
         }
      }
   }
   function onLevel(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("NEW_JOB_LEVEL",[this.api.lang.getJobText(_loc4_).n,_loc5_]),"ERROR_BOX",{name:"NewJobLevel"});
   }
   function onRemove(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      var _loc4_ = this.api.datacenter.Player.Jobs;
      var _loc5_ = _loc4_.findFirstItem("id",_loc3_);
      if(_loc5_.index != -1)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("REMOVE_JOB",[_loc5_.item.name]),"INFO_CHAT");
         _loc4_.removeItems(_loc5_.index,1);
      }
   }
   function onOptions(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      var _loc6_ = Number(_loc3_[2]);
      this.api.datacenter.Player.getJobInfo(_loc4_).options = new dofus.datacenter.JobOptions(_loc5_,_loc6_);
   }
   function onActivityStart(sExtraData)
   {
      var _loc3_ = this.api.electron.parseActivityRequest(sExtraData);
      var _loc4_ = _loc3_.split("|");
      var _loc5_ = Number(_loc4_.shift());
      var _loc6_ = dofus.managers.JobsManager.getInstance().getUIActivity(_loc5_);
      if(_loc6_ == undefined)
      {
         return undefined;
      }
      this.api.ui.loadUIComponent(_loc6_,_loc6_,{data:_loc4_},{bAlwaysOnTop:true,bForceLoad:true});
   }
   function onAnim(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = _loc3_[1];
      if(_loc5_ == this.api.datacenter.Player.ID)
      {
         return undefined;
      }
      var _loc6_;
      var _loc7_;
      var _loc8_;
      switch(_loc4_)
      {
         case -1:
            this.api.gfx.getSprite(_loc5_).mc.setAnim("static");
            break;
         case 0:
            _loc6_ = Number(_loc3_[2]);
            _loc7_ = this.api.datacenter.Sprites.getItemAt(_loc5_);
            _loc8_ = _loc7_.ToolAnimation;
            this.api.gfx.autoCalculateSpriteDirection(_loc5_,_loc6_);
            this.api.gfx.getSprite(_loc5_).mc.setAnim(_loc8_);
            break;
         case 1:
            org.flashdevelop.utils.FlashConnect.trace("dead ? " + this.api.gfx.getSprite(_loc5_).mc.currentJobAnim,"dofus.aks.Job::onAnim","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/aks/Job.as",226);
            this.api.gfx.getSprite(_loc5_).mc.currentJobAnim.gotoAndPlay(2);
         default:
            return;
      }
   }
}
