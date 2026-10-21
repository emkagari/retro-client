class dofus.managers.DebugManager extends dofus.utils.ApiElement
{
   var _bDebugEnabled;
   static var _sSelf = null;
   function DebugManager(oAPI)
   {
      super();
      dofus.managers.DebugManager._sSelf = this;
      this.initialize(oAPI);
   }
   static function getInstance()
   {
      return dofus.managers.DebugManager._sSelf;
   }
   function initialize(oAPI)
   {
      super.initialize(oAPI);
      this.setDebug(dofus.Constants.DEBUG == true);
   }
   function setDebug(bOnOff)
   {
      this._bDebugEnabled = bOnOff;
      this.print("Debug mode " + (!bOnOff ? "OFF" : "ON"),5,true);
   }
   function toggleDebug()
   {
      this.setDebug(!this._bDebugEnabled);
   }
   function print(sMsg, nLevel, bEvenIfOff)
   {
      if(!bEvenIfOff && !this._bDebugEnabled)
      {
         return undefined;
      }
      var _loc5_ = this.getTimestamp() + " ";
      _loc5_ += sMsg;
      var _loc6_ = "DEBUG_INFO";
      switch(nLevel)
      {
         case 5:
            _loc6_ = "ERROR_CHAT";
            break;
         case 4:
            _loc6_ = "MESSAGE_CHAT";
            break;
         case 3:
            _loc6_ = "DEBUG_ERROR";
            break;
         case 2:
            _loc6_ = "DEBUG_LOG";
            break;
         default:
            _loc6_ = "DEBUG_INFO";
      }
      this.api.kernel.showMessage(undefined,_loc5_,_loc6_);
   }
   function getFormattedMessage(sMsg, sCommandsDelimiter)
   {
      var _loc4_ = "";
      var _loc6_ = [];
      var _loc5_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      var _loc17_;
      do
      {
         _loc5_ = sMsg.indexOf("#");
         if(_loc5_ != -1)
         {
            _loc4_ += sMsg.substring(0,_loc5_);
            sMsg = sMsg.substring(_loc5_ + 1);
            _loc7_ = sMsg.split(sCommandsDelimiter);
            _loc7_.splice(2);
            _loc8_ = null;
            if(_loc7_ != undefined && _loc7_.length > 1)
            {
               switch(_loc7_[0])
               {
                  case "getioname":
                     _loc9_ = Number(_loc7_[1]);
                     if(_loc9_ != undefined && !_global.isNaN(_loc9_))
                     {
                        if(_loc6_[0] == undefined)
                        {
                           _loc6_[0] = this.api.lang.getInteractiveObjectDataTexts();
                        }
                        _loc8_ = _loc6_[0][_loc9_].n;
                        if(_loc8_ == undefined)
                        {
                           _loc8_ = "-";
                        }
                     }
                     break;
                  case "getitemname":
                     _loc10_ = Number(_loc7_[1]);
                     if(_loc10_ != undefined && !_global.isNaN(_loc10_))
                     {
                        if(_loc6_[1] == undefined)
                        {
                           _loc6_[1] = this.api.lang.getItemUnics();
                        }
                        _loc8_ = _loc6_[1][_loc10_].n;
                        if(_loc8_ == undefined)
                        {
                           _loc8_ = "-";
                        }
                     }
                     break;
                  case "getsubareaname":
                     _loc11_ = Number(_loc7_[1]);
                     if(_loc11_ != undefined && !_global.isNaN(_loc11_))
                     {
                        if(_loc6_[2] == undefined)
                        {
                           _loc6_[2] = this.api.lang.getMapSubAreas();
                        }
                        _loc8_ = _loc6_[2][_loc11_].n;
                        if(_loc8_ == undefined)
                        {
                           _loc8_ = "-";
                        }
                     }
                     break;
                  case "getiogfxname":
                     _loc12_ = Number(_loc7_[1]);
                     if(_loc12_ != undefined && !_global.isNaN(_loc12_))
                     {
                        _loc8_ = this.api.lang.getInteractiveObjectDataByGfxText(_loc12_).n;
                        if(_loc8_ == undefined)
                        {
                           _loc8_ = "-";
                        }
                     }
                     break;
                  case "getcelliogfxname":
                     _loc13_ = Number(_loc7_[1]);
                     if(_loc13_ != undefined && !_global.isNaN(_loc13_))
                     {
                        _loc14_ = this.api.gfx.mapHandler.getCellData(_loc13_).layerObject2Num;
                        if(!_global.isNaN(_loc14_))
                        {
                           _loc8_ = this.api.lang.getInteractiveObjectDataByGfxText(_loc14_).n;
                        }
                        if(_loc8_ == undefined)
                        {
                           _loc8_ = "-";
                        }
                     }
                     break;
                  case "getmonstername":
                     _loc15_ = Number(_loc7_[1]);
                     if(_loc15_ != undefined && !_global.isNaN(_loc15_))
                     {
                        if(_loc6_[3] == undefined)
                        {
                           _loc6_[3] = this.api.lang.getMonsters();
                        }
                        _loc8_ = _loc6_[3][_loc15_].n;
                        if(_loc8_ == undefined)
                        {
                           _loc8_ = "-";
                        }
                     }
                     break;
                  case "getalignmentid":
                     _loc16_ = Number(_loc7_[1]);
                     if(_loc16_ != undefined && !_global.isNaN(_loc16_))
                     {
                        if(_loc6_[4] == undefined)
                        {
                           _loc6_[4] = this.api.lang.getAlignments();
                        }
                        _loc8_ = _loc6_[4][_loc16_].n;
                        if(_loc8_ == undefined)
                        {
                           _loc8_ = "-";
                        }
                     }
                     break;
                  case "getbreedid":
                     _loc17_ = Number(_loc7_[1]);
                     if(_loc17_ != undefined && !_global.isNaN(_loc17_))
                     {
                        if(_loc6_[5] == undefined)
                        {
                           _loc6_[5] = this.api.lang.getAllClassText();
                        }
                        _loc8_ = _loc6_[5][_loc17_].sn;
                        if(_loc8_ == undefined)
                        {
                           _loc8_ = "-";
                        }
                     }
               }
            }
            if(_loc8_ != null && _loc8_.length > 0)
            {
               _loc4_ += _loc8_;
               sMsg = sMsg.substring(_loc7_.join("|").length + 1);
            }
            else
            {
               _loc4_ += "#";
            }
         }
      }
      while(_loc5_ == undefined || _loc5_ != -1);
      _loc4_ += sMsg;
      return _loc4_;
   }
   function getTimestamp()
   {
      var _loc2_ = new ank.utils.ExtendedDate();
      return "[" + _loc2_.getHoursPadded() + ":" + _loc2_.getMinutesPadded() + ":" + _loc2_.getSecondsPadded() + ":" + _loc2_.getMillisecondsPadded() + "]";
   }
   function getTimestampShort()
   {
      var _loc2_ = new ank.utils.ExtendedDate();
      return "[" + _loc2_.getHoursPadded() + ":" + _loc2_.getMinutesPadded() + "]";
   }
}
