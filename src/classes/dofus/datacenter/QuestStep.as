class dofus.datacenter.QuestStep extends Object
{
   var _aDialogParams;
   var _aNextSteps;
   var _aPreviousSteps;
   var _bAccountQuest;
   var _bRepeatableQuest;
   var _eaObjectives;
   var _nDialogID;
   var _nID;
   var _nState;
   var api;
   function QuestStep(nID, nState, isAccountQuest, isRepeatableQuest, eaObjectives, aPreviousSteps, aNextSteps, nDialogID, aDialogParams)
   {
      super();
      this.initialize(nID,nState,isAccountQuest,isRepeatableQuest,eaObjectives,aPreviousSteps,aNextSteps,nDialogID,aDialogParams);
   }
   function get id()
   {
      return this._nID;
   }
   function get name()
   {
      var _loc2_ = this.api.lang.getQuestStepText(this._nID).n;
      if(_loc2_ != null && dofus.Constants.DEBUG)
      {
         _loc2_ = _loc2_ + " (" + this._nID + ")";
      }
      return _loc2_;
   }
   function get description()
   {
      return this.api.lang.getQuestStepText(this._nID).d;
   }
   function get objectives()
   {
      return this._eaObjectives;
   }
   function get allSteps()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = 0;
      while(_loc3_ < this._aPreviousSteps.length)
      {
         _loc2_.push(new dofus.datacenter.QuestStep(this._aPreviousSteps[_loc3_],2));
         _loc3_ = _loc3_ + 1;
      }
      _loc2_.push(this);
      var _loc4_ = 0;
      while(_loc4_ < this._aNextSteps.length)
      {
         _loc2_.push(new dofus.datacenter.QuestStep(this._aNextSteps[_loc4_],0));
         _loc4_ = _loc4_ + 1;
      }
      return _loc2_;
   }
   function get rewards()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = this.api.lang.getQuestStepText(this._nID);
      var _loc4_ = _loc3_.r;
      var _loc5_ = _loc3_.rbl;
      var _loc6_;
      var _loc7_;
      if(_loc5_ != undefined)
      {
         _loc7_ = 0;
         while(_loc7_ < _loc5_.length)
         {
            if(this.api.datacenter.Player.Level >= _loc5_[_loc7_].min && this.api.datacenter.Player.Level <= _loc5_[_loc7_].max)
            {
               _loc6_ = _loc5_[_loc7_];
            }
            _loc7_ = _loc7_ + 1;
         }
      }
      var _loc8_ = 0;
      if(_loc4_[0] != undefined)
      {
         _loc8_ += Number(_loc4_[0]);
      }
      if(_loc6_ != undefined)
      {
         _loc8_ += Number(_loc6_.xp);
      }
      if(_loc8_ > 0)
      {
         _loc2_.push({iconFile:"UI_QuestXP",label:new ank.utils.ExtendedString(_loc8_).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3)});
      }
      var _loc9_ = 0;
      if(_loc4_[1] != undefined)
      {
         _loc9_ += Number(_loc4_[1]);
      }
      if(_loc6_ != undefined)
      {
         _loc9_ += Number(_loc6_.k);
      }
      if(_loc9_ > 0)
      {
         _loc2_.push({iconFile:"UI_QuestKamaSymbol",label:new ank.utils.ExtendedString(_loc9_).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3)});
      }
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      if(_loc4_[2] != undefined)
      {
         _loc10_ = _loc4_[2];
         _loc11_ = 0;
         while(_loc11_ < _loc10_.length)
         {
            _loc12_ = Number(_loc10_[_loc11_][0]);
            _loc13_ = _loc10_[_loc11_][1];
            _loc14_ = new dofus.datacenter.Item(0,_loc12_,_loc13_);
            _loc2_.push({iconFile:_loc14_.iconFile,label:(_loc13_ == 0 ? "" : "x" + _loc13_ + " ") + _loc14_.name});
            _loc11_ = _loc11_ + 1;
         }
      }
      var _loc15_;
      var _loc16_;
      var _loc17_;
      if(_loc4_[3] != undefined)
      {
         _loc15_ = _loc4_[3];
         _loc16_ = 0;
         while(_loc16_ < _loc15_.length)
         {
            _loc17_ = Number(_loc15_[_loc16_]);
            _loc2_.push({iconFile:dofus.Constants.EMOTES_ICONS_PATH + _loc17_ + ".swf",label:this.api.lang.getEmoteText(_loc17_).n});
            _loc16_ = _loc16_ + 1;
         }
      }
      var _loc18_;
      var _loc19_;
      var _loc20_;
      var _loc21_;
      if(_loc4_[4] != undefined)
      {
         _loc18_ = _loc4_[4];
         _loc19_ = 0;
         while(_loc19_ < _loc18_.length)
         {
            _loc20_ = Number(_loc18_[_loc19_]);
            _loc21_ = new dofus.datacenter.Job(_loc20_);
            _loc2_.push({iconFile:_loc21_.iconFile,label:_loc21_.name});
            _loc19_ = _loc19_ + 1;
         }
      }
      var _loc22_;
      var _loc23_;
      var _loc24_;
      var _loc25_;
      if(_loc4_[5] != undefined)
      {
         _loc22_ = _loc4_[5];
         _loc23_ = 0;
         while(_loc23_ < _loc22_.length)
         {
            _loc24_ = Number(_loc22_[_loc23_]);
            _loc25_ = new dofus.datacenter.Spell(_loc24_,1);
            _loc2_.push({iconFile:_loc25_.iconFile,label:_loc25_.name,params:_loc25_.params});
            _loc23_ = _loc23_ + 1;
         }
      }
      return _loc2_;
   }
   function get dialogID()
   {
      return this._nDialogID;
   }
   function get dialogParams()
   {
      return this._aDialogParams;
   }
   function get isFinished()
   {
      return this._nState == 2;
   }
   function get isCurrent()
   {
      return this._nState == 1;
   }
   function get isNotDo()
   {
      return this._nState == 0;
   }
   function get hasNext()
   {
      return true;
   }
   function get hasPrevious()
   {
      return true;
   }
   function get isAccountQuest()
   {
      return this._bAccountQuest;
   }
   function get isRepeatableQuest()
   {
      return this._bRepeatableQuest;
   }
   function initialize(nID, nState, isAccountQuest, isRepeatableQuest, eaObjectives, aPreviousSteps, aNextSteps, nDialogID, aDialogParams)
   {
      this.api = _global.API;
      this._nID = nID;
      this._nState = nState;
      this._bAccountQuest = isAccountQuest;
      this._bRepeatableQuest = isRepeatableQuest;
      this._eaObjectives = eaObjectives;
      this._aPreviousSteps = aPreviousSteps;
      this._aNextSteps = aNextSteps;
      this._nDialogID = nDialogID;
      this._aDialogParams = aDialogParams;
   }
}
