class ank.battlefield.datacenter.Sprite extends Object
{
   var _aAccessories;
   var _bAllDirections;
   var _bClear;
   var _bInMove;
   var _bInSpellAnimation;
   var _bVisible;
   var _eoLinkedChilds;
   var _nCellNumValue;
   var _nColor1;
   var _nColor2;
   var _nColor3;
   var _nCreationInstant;
   var _nGlowFilter;
   var _nStartAnimationTimer;
   var _oCarriedChild;
   var _oCarriedParent;
   var _oLinkedParent;
   var _oMount;
   var _oSequencer;
   var _sBaseGfxFile;
   var _sBaseGfxFileName;
   var _sCreatureGfxFile;
   var _sCreatureGfxFileName;
   var _sGfxFile;
   var _sGfxFileName;
   var _sMoveAnimation;
   var _sMoveSpeedType;
   var _sTransformGfxFile;
   var _sTransformGfxFileName;
   var _states;
   var api;
   var clipClass;
   var dispatchEvent;
   var id;
   var mc;
   static var ANGELS_OF_THE_WORLD_SPRITE_ID = "999";
   static var ANGELS_OF_THE_WORLD_REPLACEMENT_SPRITE_ID = "8023";
   static var SPRITE_SEQUENCER_TIMEOUT = 1000;
   var allowGhostMode = true;
   var bAnimLoop = false;
   var _nChildIndex = -1;
   var _nFutureCellNum = -1;
   var _sDefaultAnimation = "static";
   var _sStartAnimation = "static";
   var _nSpeedModerator = 1;
   var _bHidden = false;
   var _bForceRun = true;
   var _bNoFlip = false;
   var _bIsPendingClearing = false;
   var _bUncarryingSprite = false;
   var bInCreaturesMode = false;
   var _bIsUncarrying = false;
   var creatureModeApplied = false;
   var _bIsInvisibleInFight = false;
   function Sprite(nID, fClipClass, sGfxFile, nCellNum, nDir)
   {
      super();
      this.initialize(nID,fClipClass,sGfxFile,nCellNum,nDir);
   }
   function initialize(sID, fClipClass, sGfxFile, nCellNum, nDir)
   {
      this.id = sID;
      this.clipClass = fClipClass;
      this._sGfxFile = sGfxFile;
      this._bInMove = this.refreshGfxFileName(sGfxFile);
      this._sBaseGfxFile = sGfxFile;
      this._sBaseGfxFileName = this._bInMove;
      this._oLinkedParent = Number(nCellNum);
      this._oCarriedChild = nDir != undefined ? Number(nDir) : 1;
      this._oSequencer = new ank.utils.Sequencer(ank.battlefield.datacenter.Sprite.SPRITE_SEQUENCER_TIMEOUT);
      this._bClear = false;
      this._sGfxFileName = true;
      this._bVisible = false;
      this._eoLinkedChilds = new ank.utils.ExtendedObject();
      mx.events.EventDispatcher.initialize(this);
      this._states = {};
      this._nCreationInstant = getTimer();
      this.api = _global.API;
      this.api.electron.addEventListener("onWindowFocusChanged",this);
   }
   function refreshGfxFileName(sID)
   {
      var _loc3_ = sID.split(".")[0].split("/");
      return _loc3_[_loc3_.length - 1];
   }
   function destroy()
   {
      this.api.electron.removeEventListener("onWindowFocusChanged",this);
   }
   function get isLocalPlayer()
   {
      return this.id == this.api.datacenter.Player.ID;
   }
   function set uncarryingSprite(bUncarrying)
   {
      this._bIsUncarrying = bUncarrying;
   }
   function get uncarryingSprite()
   {
      return this._bIsUncarrying;
   }
   function get hasChilds()
   {
      return this._eoLinkedChilds.getLength() != 0;
   }
   function get hasParent()
   {
      return this.linkedParent != undefined;
   }
   function get childIndex()
   {
      return this._nChildIndex;
   }
   function set childIndex(nChildIndex)
   {
      this._nChildIndex = nChildIndex;
   }
   function get linkedChilds()
   {
      return this._eoLinkedChilds;
   }
   function get linkedParent()
   {
      return this._sMoveAnimation;
   }
   function set linkedParent(sMoveAnimation)
   {
      this._sMoveAnimation = sMoveAnimation;
   }
   function hasCarriedChild()
   {
      return this._oCarriedParent != undefined;
   }
   function hasCarriedParent()
   {
      return this._sMoveSpeedType != undefined;
   }
   function get carriedChild()
   {
      return this._oCarriedParent;
   }
   function set carriedChild(o)
   {
      this._oCarriedParent = o;
   }
   function get carriedParent()
   {
      return this._sMoveSpeedType;
   }
   function set carriedParent(o)
   {
      this._sMoveSpeedType = o;
   }
   function get creationInstant()
   {
      return this._nCreationInstant;
   }
   function get gfxFile()
   {
      return this._sGfxFile;
   }
   function set gfxFile(sGfxFile)
   {
      this.dispatchEvent({type:"gfxFileChanged",value:sGfxFile});
      this._sGfxFile = sGfxFile;
      this._bInMove = this.refreshGfxFileName(sGfxFile);
   }
   function get baseGfxFile()
   {
      return this._sBaseGfxFile;
   }
   function get transformGfxFile()
   {
      return this._sTransformGfxFile;
   }
   function set transformGfxFile(sTransformGfxFile)
   {
      this._sTransformGfxFile = sTransformGfxFile;
      this._sTransformGfxFileName = this.refreshGfxFileName(sTransformGfxFile);
   }
   function get creatureGfxFile()
   {
      return this._sCreatureGfxFile;
   }
   function set creatureGfxFile(sCreatureGfxFile)
   {
      this._sCreatureGfxFile = sCreatureGfxFile;
      this._sCreatureGfxFileName = this.refreshGfxFileName(sCreatureGfxFile);
   }
   function get gfxFileName()
   {
      return this._bInMove;
   }
   function get baseGfxFileName()
   {
      return this._sBaseGfxFileName;
   }
   function get transformGfxFileName()
   {
      return this._sTransformGfxFileName;
   }
   function get creatureGfxFileName()
   {
      return this._sCreatureGfxFileName;
   }
   function get defaultAnimation()
   {
      return this._sDefaultAnimation;
   }
   function set defaultAnimation(value)
   {
      this._sDefaultAnimation = value;
   }
   function get startAnimation()
   {
      return this._sStartAnimation;
   }
   function set startAnimation(value)
   {
      this._sStartAnimation = value;
   }
   function get startAnimationTimer()
   {
      return this._nStartAnimationTimer;
   }
   function set startAnimationTimer(value)
   {
      this._nStartAnimationTimer = value;
   }
   function get speedModerator()
   {
      return this._nSpeedModerator;
   }
   function set speedModerator(value)
   {
      this._nSpeedModerator = Number(value);
   }
   function get isVisible()
   {
      return this._sGfxFileName;
   }
   function set isVisible(value)
   {
      this._sGfxFileName = value;
   }
   function get isInvisibleInFight()
   {
      return this._bIsInvisibleInFight;
   }
   function set isInvisibleInFight(bIsInvisibleInFight)
   {
      this._bIsInvisibleInFight = bIsInvisibleInFight;
   }
   function setInvisibleInFight(bIsInvisibleInFight)
   {
      this._bIsInvisibleInFight = bIsInvisibleInFight;
   }
   function get isHidden(Void)
   {
      return this._bHidden;
   }
   function set isHidden(value)
   {
      this.mc.isHidden = this._bHidden = value;
   }
   function get isInSpellAnimation()
   {
      return this._bInSpellAnimation;
   }
   function set isInSpellAnimation(value_)
   {
      this._bInSpellAnimation = value_;
   }
   function get isInMove()
   {
      return this._bClear;
   }
   function set isInMove(value)
   {
      if(!value)
      {
         this._nFutureCellNum = -1;
         this._nCellNumValue = undefined;
         this._bAllDirections = undefined;
      }
      this._bClear = value;
      if(this.hasCarriedChild())
      {
         this.carriedChild.isInMove = value;
      }
   }
   function get _nCellNum()
   {
      return this._nCellNumValue;
   }
   function set _nCellNum(bForceWalk)
   {
      this._nCellNumValue = bForceWalk;
   }
   function get _nDirection()
   {
      return this._bAllDirections;
   }
   function set _nDirection(bAllDirections)
   {
      this._bAllDirections = bAllDirections;
   }
   function get isClear()
   {
      return this._bVisible;
   }
   function set isClear(value)
   {
      this._bVisible = value;
   }
   function get cellNum()
   {
      return this._oLinkedParent;
   }
   function set cellNum(oLinkedParent)
   {
      this._oLinkedParent = Number(oLinkedParent);
   }
   function get futureCellNum()
   {
      return this._nFutureCellNum;
   }
   function set futureCellNum(nFutureCellNum)
   {
      this._nFutureCellNum = nFutureCellNum;
   }
   function get direction()
   {
      return this._oCarriedChild;
   }
   function set direction(value)
   {
      this._oCarriedChild = Number(value);
   }
   function get color1()
   {
      return this._nColor1;
   }
   function set color1(value)
   {
      this._nColor1 = Number(value);
   }
   function get color2()
   {
      return this._nColor2;
   }
   function set color2(value)
   {
      this._nColor2 = Number(value);
   }
   function get color3()
   {
      return this._nColor3;
   }
   function set color3(value)
   {
      this._nColor3 = Number(value);
   }
   function get accessories()
   {
      return this._aAccessories;
   }
   function set accessories(value)
   {
      this.dispatchEvent({type:"accessoriesChanged",value:value});
      this._aAccessories = value;
   }
   function get sequencer()
   {
      return this._oSequencer;
   }
   function set sequencer(value)
   {
      this._oSequencer = value;
   }
   function get allDirections()
   {
      return this._bForceRun;
   }
   function set allDirections(bForceRun)
   {
      this._bForceRun = bForceRun;
   }
   function get forceWalk()
   {
      return this._bNoFlip;
   }
   function set forceWalk(bNoFlip)
   {
      this._bNoFlip = bNoFlip;
   }
   function get forceRun()
   {
      return this._bIsPendingClearing;
   }
   function set forceRun(bIsPendingClearing)
   {
      this._bIsPendingClearing = bIsPendingClearing;
   }
   function get noFlip()
   {
      return this._bUncarryingSprite;
   }
   function set noFlip(bUncarryingSprite)
   {
      this._bUncarryingSprite = bUncarryingSprite;
   }
   function get mount()
   {
      return this._oMount;
   }
   function set mount(v)
   {
      this._oMount = v;
   }
   function get isMounting()
   {
      return this._oMount != undefined;
   }
   function get isPendingClearing()
   {
      return this.bInCreaturesMode;
   }
   function set isPendingClearing(bPending)
   {
      this.bInCreaturesMode = bPending;
   }
   function get states()
   {
      return this._states;
   }
   function isInState(stateID)
   {
      return this._states[stateID] == true;
   }
   function setState(api, stateID, bActivate)
   {
      this._states[stateID] = bActivate;
      if(bActivate)
      {
         dofus.datacenter.States.onStateAdded(api,this,stateID);
      }
      else
      {
         dofus.datacenter.States.onStateRemoved(api,this,stateID);
      }
      this.dispatchEvent({type:"statesChanged",value:this._states});
   }
   function get glowFilter()
   {
      return this._nGlowFilter;
   }
   function set glowFilter(nGlowFilter)
   {
      this._nGlowFilter = nGlowFilter;
   }
   function get circleFilePath()
   {
      return dofus.Constants.CIRCLE_FILE;
   }
   function onWindowFocusChanged(oEvent_)
   {
      var _loc3_;
      if(this.isInMove && this.api.kernel.OptionsManager.getOption("AntiLagOptimizeMovement"))
      {
         if(oEvent_.isFocused)
         {
            _loc3_ = this._nDirection == undefined ? this._nCellNum : this._nDirection;
            if(_loc3_ != undefined)
            {
               this.mc.setAnim(_loc3_);
            }
         }
         else
         {
            this.mc.setAnim("static");
         }
      }
   }
}
