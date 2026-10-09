class dofus.graphics.gapi.ui.EditPlayer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnCancel;
   var _btnClose;
   var _btnHideStuff;
   var _btnShowMount;
   var _btnValidate;
   var _csColors;
   var _itCharacterName;
   var _lblCharacterColors;
   var _lblCharacterName;
   var _lblClickToAnim;
   var _lblClickToAnimate;
   var _lblShowMount;
   var _lblTitle;
   var _mcItCharacterNameBg;
   var _mcRandomName;
   var _nSavedColor;
   var _oColors;
   var _svCharacter;
   var _winBg;
   var addToQueue;
   var gapi;
   var onEnterFrame;
   var unloadThis;
   static var CLASS_NAME = "EditPlayer";
   static var NAME_GENERATION_DELAY = 500;
   var _nLastRegenerateTimer = 0;
   var _bLoaded = false;
   var _bColorsEditable = false;
   var _bEditName = false;
   var _bForce = false;
   function EditPlayer()
   {
      super();
   }
   function set editColors(bColorsEditable)
   {
      this._bColorsEditable = bColorsEditable;
   }
   function set editName(bEditName)
   {
      this._bEditName = bEditName;
   }
   function set force(bForce)
   {
      this._bForce = bForce;
   }
   function set characterName(sNewName)
   {
      if(this._itCharacterName.text != undefined)
      {
         this._itCharacterName.text = sNewName;
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.EditPlayer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.setupRestriction});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.initComponent});
   }
   function addListeners()
   {
      var ref = this;
      this._mcRandomName.onPress = function()
      {
         ref.click({target:this});
      };
      this._mcRandomName.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._mcRandomName.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._btnCancel.addEventListener("click",this);
      this._btnValidate.addEventListener("click",this);
      this._btnHideStuff.addEventListener("click",this);
      if(this.api.datacenter.Player.mount != undefined)
      {
         this._btnShowMount.addEventListener("click",this);
      }
      else
      {
         this._btnShowMount._visible = false;
         this._lblShowMount._visible = false;
      }
      this._btnClose.addEventListener("click",this);
      this._itCharacterName.addEventListener("change",this);
      this._csColors.addEventListener("change",this);
      this._csColors.addEventListener("over",this);
      this._csColors.addEventListener("out",this);
   }
   function setupRestriction()
   {
      var _loc2_ = "";
      if(this.api.datacenter.Player.isAuthorized)
      {
         _loc2_ = "a-zA-Z\\-\\[\\]";
      }
      else
      {
         _loc2_ = "a-zA-Z\\-";
      }
      if(this.api.config.isStreaming)
      {
         _loc2_ += "0-9";
      }
      this._itCharacterName.restrict = _loc2_;
   }
   function initTexts()
   {
      this._winBg.title = this.api.lang.getText("CUSTOMIZE");
      this._lblTitle.text = this.api.lang.getText("CREATE_TITLE");
      this._lblClickToAnim.text = this.api.lang.getText("HIDE_STUFF");
      this._lblShowMount.text = this.api.lang.getText("SHOW_MOUNT");
      this._mcItCharacterNameBg.text = this.api.lang.getText("CLICK_TO_ANIMATE");
      this._lblCharacterColors.text = this.api.lang.getText("SPRITE_COLORS");
      this._lblCharacterName.text = this.api.lang.getText("CREATE_CHARACTER_NAME");
      this._btnCancel.label = this.api.lang.getText("BACK");
      this._btnValidate.label = this.api.lang.getText("VALIDATE");
   }
   function initComponent()
   {
      if(this._bForce)
      {
         this._btnClose._visible = false;
         this._btnCancel._visible = false;
      }
      if(!this._bEditName)
      {
         this._itCharacterName.enabled = false;
         this._mcRandomName._visible = false;
         this._lblClickToAnimate._visible = false;
      }
      if(!this._bColorsEditable)
      {
         this._lblCharacterColors._visible = false;
         this._csColors._visible = false;
      }
      this.characterName = this.api.datacenter.Player.Name;
      this.showMyself();
      this._btnValidate.label = this.api.lang.getText("VALIDATE");
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function showMyself()
   {
      var _loc2_ = this._btnHideStuff.selected;
      var _loc3_ = this._btnShowMount.selected;
      var _loc4_ = ank.battlefield.datacenter.Sprite(this.api.datacenter.Player.data);
      if(_loc4_ == undefined)
      {
         this._svCharacter._visible = false;
         this._csColors._visible = false;
         return undefined;
      }
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(this._svCharacter.spriteData == undefined)
      {
         _loc5_ = _loc4_.color1;
         _loc6_ = _loc4_.color2;
         _loc7_ = _loc4_.color3;
      }
      else
      {
         _loc5_ = this._svCharacter.getColor(1);
         _loc6_ = this._svCharacter.getColor(2);
         _loc7_ = this._svCharacter.getColor(3);
      }
      this._oColors = {color1:_loc5_,color2:_loc6_,color3:_loc7_};
      this._svCharacter.zoom = 200;
      this._svCharacter.spriteAnims = ["StaticF","StaticR","StaticL","WalkF","RunF","Anim2R","Anim2L"];
      this._svCharacter.refreshDelay = 50;
      this._svCharacter.useSingleLoader = true;
      var _loc8_ = this.api.datacenter.Player.Guild;
      var _loc9_ = this.api.datacenter.Player.Sex;
      this._csColors.breed = _loc8_;
      this._csColors.sex = _loc9_;
      this._csColors.colors = [_loc5_,_loc6_,_loc7_];
      var _loc10_ = _loc8_ + "" + _loc9_;
      var _loc11_ = new ank.battlefield.datacenter.Sprite("viewer",ank.battlefield.mc.Sprite,dofus.Constants.CLIPS_PERSOS_PATH + _loc10_ + ".swf",undefined,5);
      if(!_loc2_)
      {
         _loc11_.accessories = _loc4_.accessories;
      }
      var _loc12_;
      var _loc13_;
      if(_loc3_)
      {
         _loc12_ = this.api.datacenter.Player.mount;
         if(_loc12_ != undefined)
         {
            _loc13_ = new dofus.datacenter.Mount(_loc12_.modelID,Number(_loc10_));
            if(_loc12_.isChameleon)
            {
               _loc13_.capacities = _loc12_.capacities;
               _loc13_.customColor1 = _loc6_;
               _loc13_.customColor2 = _loc7_;
               _loc13_.customColor3 = _loc7_;
            }
            _loc11_.mount = _loc13_;
         }
      }
      this._svCharacter.enableBlur = true;
      this._svCharacter.refreshAccessories = !_loc2_;
      this._svCharacter.sourceSpriteData = _loc4_;
      this._svCharacter.spriteData = _loc11_;
      this._svCharacter.setColors(this._oColors);
   }
   function showColorPosition(nIndex)
   {
      var bWhite = true;
      this._nSavedColor = this._svCharacter.getColor(nIndex);
      var bTripleFramerate = dofus.Constants.TRIPLEFRAMERATE;
      var nFramesToIgnore = !bTripleFramerate ? 0 : 2;
      var nCurrentFrameState = 0;
      this.onEnterFrame = function()
      {
         if(!bTripleFramerate || nCurrentFrameState == 0)
         {
            nCurrentFrameState = nFramesToIgnore;
            this._svCharacter.setColor(nIndex,!(bWhite = !bWhite) ? 16746632 : 16733525);
         }
         else
         {
            nCurrentFrameState--;
         }
      };
   }
   function hideColorPosition(nIndex)
   {
      delete this.onEnterFrame;
      this._svCharacter.setColor(nIndex,this._nSavedColor);
   }
   function validateNameEdit()
   {
      var _loc2_ = this._itCharacterName.text;
      if(_loc2_.length == 0 || _loc2_ == undefined)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("NEED_CHARACTER_NAME"),"ERROR_BOX",{name:"CREATENONAME"});
         return undefined;
      }
      if(_loc2_.length > 20)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("LONG_CHARACTER_NAME",[_loc2_,20]),"ERROR_BOX");
         return undefined;
      }
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if(this.api.lang.getConfigText("CHAR_NAME_FILTER") && !this.api.datacenter.Player.isAuthorized)
      {
         _loc3_ = new dofus.utils.nameChecker.NameChecker(_loc2_);
         _loc4_ = new dofus.utils.nameChecker.rules.NameCheckerCharacterNameRules();
         _loc5_ = _loc3_.isValidAgainstWithDetails(_loc4_);
         if(!_loc5_.IS_SUCCESS)
         {
            this.api.kernel.showMessage(undefined,this.api.lang.getText("INVALID_CHARACTER_NAME") + "\r\n" + _loc5_.toString("\r\n"),"ERROR_BOX");
            return undefined;
         }
      }
      this.api.network.Account.editCharacterName(_loc2_);
   }
   function validateColorsEdit()
   {
      this.api.network.Account.editCharacterColors(this._oColors.color1,this._oColors.color2,this._oColors.color3);
   }
   function setColors(oColors)
   {
      this._oColors = oColors;
      this._svCharacter.setColors(this._oColors);
   }
   function hideGenerateRandomName()
   {
      this._mcRandomName._visible = false;
   }
   function click(oEvent)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent.target)
      {
         case this._btnValidate:
            if(!this._bEditName)
            {
               if(this._bColorsEditable)
               {
                  this.validateColorsEdit();
               }
               break;
            }
            _loc3_ = this._itCharacterName.text;
            if(this.api.datacenter.Player.Name == _loc3_)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CHARACTER_NAME_MUST_CHANGE"),"ERROR_BOX");
            }
            else
            {
               _loc4_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoEditName",{title:this.api.lang.getText("QUESTION"),text:this.api.lang.getText("CONFIRM_EDIT_NAME")});
               _loc4_.addEventListener("yes",this);
            }
         case this._btnCancel:
         case this._btnClose:
            break;
         case this._mcRandomName:
            if(this._nLastRegenerateTimer + dofus.graphics.gapi.ui.EditPlayer.NAME_GENERATION_DELAY < getTimer())
            {
               this.api.network.Account.getRandomCharacterName();
               this._nLastRegenerateTimer = getTimer();
            }
            break;
         case this._btnHideStuff:
         case this._btnShowMount:
            this.showMyself();
         default:
            return;
      }
      this.callClose();
   }
   function yes(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "AskYesNoEditName")
      {
         this.validateNameEdit();
         this.unloadThis();
      }
   }
   function over(oEvent)
   {
      switch(oEvent.target)
      {
         case this._csColors:
            this.showColorPosition(oEvent.index);
            break;
         case this._mcRandomName:
            this.gapi.showTooltip(this.api.lang.getText("RANDOM_NICKNAME"));
         default:
            return;
      }
   }
   function out(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) !== this._csColors)
      {
         this.gapi.hideTooltip();
      }
      else
      {
         this.hideColorPosition(oEvent.index);
      }
   }
   function change(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      switch(oEvent.target)
      {
         case this._csColors:
            this.setColors(oEvent.value);
            break;
         case this._itCharacterName:
            _loc3_ = this._itCharacterName.text;
            if(!this.api.datacenter.Player.isAuthorized)
            {
               _loc3_ = _loc3_.substr(0,1).toUpperCase() + _loc3_.substr(1);
               _loc4_ = _loc3_.substr(0,1);
               _loc5_ = 1;
               while(_loc5_ < _loc3_.length)
               {
                  if(_loc3_.substr(_loc5_ - 1,1) != "-")
                  {
                     _loc4_ += _loc3_.substr(_loc5_,1).toLowerCase();
                  }
                  else
                  {
                     _loc4_ += _loc3_.substr(_loc5_,1);
                  }
                  _loc5_ = _loc5_ + 1;
               }
               this._itCharacterName.removeEventListener("change",this);
               this._itCharacterName.text = _loc4_;
               this._itCharacterName.addEventListener("change",this);
            }
         default:
            return;
      }
   }
}
