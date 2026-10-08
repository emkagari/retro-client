class dofus.aks.Spells extends dofus.aks.Handler
{
   var aks;
   var api;
   function Spells(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function moveToUsed(nID, nPosition)
   {
      this.aks.send("SM" + nID + "|" + nPosition,false);
   }
   function boost(nID)
   {
      this.aks.send("SB" + nID);
   }
   function spellForget(nID)
   {
      this.aks.send("SF" + nID);
   }
   function spellRemove(nPosition)
   {
      this.aks.send("SR" + nPosition);
   }
   function onUpgradeSpell(bSuccess, sExtraData)
   {
      var _loc4_;
      if(bSuccess)
      {
         _loc4_ = this.api.kernel.CharactersManager.getSpellObjectFromData(sExtraData);
         this.api.datacenter.Player.updateSpell(_loc4_);
      }
      else
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_BOOST_SPELL"),"ERROR_BOX");
      }
   }
   function onList(sExtraData)
   {
      var _loc3_ = this.api.datacenter.Player;
      _loc3_.Spells.removeItems(1,_loc3_.Spells.length);
      var _loc4_ = sExtraData.split("|");
      var _loc5_ = [];
      var _loc6_ = 0;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      while(_loc6_ < _loc4_.length)
      {
         _loc7_ = _loc4_[_loc6_].split(";");
         _loc8_ = 0;
         while(_loc8_ < _loc7_.length)
         {
            _loc9_ = _loc7_[_loc8_];
            if(_loc9_.length != 0)
            {
               _loc10_ = this.api.kernel.CharactersManager.getSpellObjectFromData(_loc9_);
               if(_loc10_ != undefined)
               {
                  _loc5_.push(_loc10_);
               }
            }
            _loc8_ = _loc8_ + 1;
         }
         _loc6_ = _loc6_ + 1;
      }
      _loc3_.Spells.replaceAll(1,_loc5_);
   }
   function onChangeOption(sExtraData)
   {
      this.api.datacenter.Basics.canUseSeeAllSpell = sExtraData.charAt(0) == "+";
   }
   function onSpellBoost(sExtraData)
   {
      var _loc3_ = sExtraData.split(";");
      var _loc4_ = _loc3_[1].toLowerCase();
      var _loc5_ = _loc4_.split(",");
      var _loc6_ = Number(_loc3_[0]);
      var _loc7_ = Number(_loc3_[2]);
      var _loc8_ = 0;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      while(_loc8_ < _loc5_.length)
      {
         _loc9_ = Number(_loc5_[_loc8_]);
         _loc10_ = [];
         if(_loc9_ == -1)
         {
            _loc11_ = this.api.datacenter.Player.Spells;
            _loc12_ = 0;
            while(_loc12_ < _loc11_.length)
            {
               _loc13_ = _loc11_[_loc12_];
               if(_loc13_.ID != undefined && _loc13_.ID > 0)
               {
                  _loc10_.push(_loc13_.ID);
               }
               _loc12_ = _loc12_ + 1;
            }
         }
         else
         {
            _loc10_.push(_loc9_);
         }
         _loc14_ = 0;
         while(_loc14_ < _loc10_.length)
         {
            _loc15_ = _loc10_[_loc14_];
            this.api.kernel.SpellsBoostsManager.setSpellModificator(_loc6_,_loc15_,_loc7_);
            _loc14_ = _loc14_ + 1;
         }
         _loc8_ = _loc8_ + 1;
      }
   }
   function onSpellForget(sExtraData)
   {
      if(sExtraData == "+")
      {
         this.api.ui.loadUIComponent("SpellForget","SpellForget",undefined,{bStayIfPresent:true});
      }
      else if(sExtraData == "-")
      {
         this.api.ui.unloadUIComponent("SpellForget");
      }
   }
   function onSpellMove(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      this.api.ui.getUIComponent("Banner").shortcuts.spellMove(_loc4_,_loc5_);
      this.api.ui.getUIComponent("SpellsCollection").spellMove(_loc4_,_loc5_);
   }
   function onSpellRemove(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      this.api.ui.getUIComponent("Banner").shortcuts.spellRemove(_loc3_);
      this.api.ui.getUIComponent("SpellsCollection").spellRemove(_loc3_);
   }
   function onSpellCooldown(sExtraData)
   {
      var _loc3_ = sExtraData.split(";");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      var _loc6_ = this.api.datacenter.Player.Spells.findFirstItem("ID",_loc4_).item;
      var _loc7_;
      var _loc8_;
      if(_loc6_ != undefined)
      {
         _loc7_ = this.api.datacenter.Player.SpellsManager;
         if(_loc7_.hasSpellLaunched(_loc4_))
         {
            _loc8_ = _loc7_.getSpellLaunched(_loc4_);
         }
         else
         {
            _loc8_ = new dofus.datacenter.LaunchedSpell(_loc4_,undefined);
            _loc7_.addLaunchedSpell(_loc8_);
         }
         _loc8_.remainingTurn = _loc5_;
         _loc7_.dispatchEvent({type:"nextTurn"});
      }
   }
}
