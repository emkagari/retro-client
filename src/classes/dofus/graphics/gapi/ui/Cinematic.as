579107311 - 1;
class dofus.graphics.gapi.ui.Cinematic extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnCancel;
   var _lblWhite;
   var _ldrLoader;
   var _mcBackground;
   var _oSequencer;
   var _sFile;
   var _sOldQuality;
   var addToQueue;
   var api;
   var dispatchEvent;
   var gapi;
   var unloadThis;
   static var CLASS_NAME = "Cinematic";
   var _nFrameToStart = 2;
   var _bCanCancel = true;
   var _bDisplayNpc = true;
   var _bDisplayMonster = true;
   function Cinematic()
   {
      super();
   }
   function set file(sFile)
   {
      this._sFile = sFile;
   }
   function set sequencer(oSequencer)
   {
      this._oSequencer = oSequencer;
   }
   function set background(bVisible)
   {
      this._mcBackground._visible = bVisible;
   }
   function set banner(bVisible)
   {
      this.api.ui.getUIComponent("Banner")._visible = bVisible;
   }
   function set npc(bVisible)
   {
      this._bDisplayNpc = bVisible;
   }
   function set monster(bVisible)
   {
      this._bDisplayMonster = bVisible;
   }
   function set frameToStart(nFrameToStart)
   {
      this._nFrameToStart = nFrameToStart;
   }
   function set canCancel(bCanCancel)
   {
      this._bCanCancel = bCanCancel;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Cinematic.CLASS_NAME);
   }
   function destroy()
   {
      _root._quality = this._sOldQuality;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.loadFile});
   }
   function startCinematic(mcCinematic)
   {
      if(!this._mcBackground._visible)
      {
         this.api.ui.getUIComponent("NpcDialog")._visible = false;
         this.api.ui.getUIComponent("GameResult")._visible = false;
         this.api.ui.getUIComponent("GameResultLight")._visible = false;
      }
      if(!this._bDisplayNpc)
      {
         this.api.gfx.spriteHandler.hideSprites(true,2);
      }
      if(!this._bDisplayMonster)
      {
         this.api.gfx.spriteHandler.hideSprites(true,3);
      }
      mcCinematic.gotoAndPlay(this._nFrameToStart);
      this._btnCancel._visible = this._bCanCancel || this.api.datacenter.Player.isAuthorized;
   }
   function addListeners()
   {
      this._ldrLoader.addEventListener("initialization",this);
      this._ldrLoader.addEventListener("complete",this);
      this._btnCancel.addEventListener("click",this);
      this._btnCancel.addEventListener("over",this);
      this._btnCancel.addEventListener("out",this);
   }
   function loadFile()
   {
      this._ldrLoader.contentPath = this._sFile;
      if(_root._quality == "HIGH")
      {
         this._sOldQuality = _root._quality;
         _root._quality = "MEDIUM";
      }
      this._lblWhite.text = this.api.lang.getText("LOADING");
   }
   function initialization(oEvent)
   {
      this._lblWhite._visible = false;
      oEvent.target.content.cinematic = this;
      this.addToQueue({object:this,method:this.startCinematic,params:[oEvent.target.content]});
   }
   function complete(oEvent)
   {
      oEvent.target.stop();
      oEvent.target.content.stop();
      oEvent.target.content.cinematic.stop();
   }
   function click(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._btnCancel)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("LEAVE_CINEMATIC"),"CAUTION_YESNO",{name:"Cinematic",listener:this});
      }
   }
   function over(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._btnCancel)
      {
         this.gapi.showTooltip(this.api.lang.getText("CANCEL_CINEMATIC"));
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function onCinematicFinished()
   {
      this.dispatchEvent({type:"cinematicFinished"});
      this._oSequencer.onActionEnd();
      if(this._sOldQuality != undefined)
      {
         _root._quality = this._sOldQuality;
      }
      if(!this._bDisplayNpc)
      {
         this.api.gfx.spriteHandler.hideSprites(false,2);
      }
      if(!this._bDisplayMonster)
      {
         this.api.gfx.spriteHandler.hideSprites(false,3);
      }
      if(!this._mcBackground._visible)
      {
         this.api.ui.getUIComponent("NpcDialog")._visible = true;
         this.api.ui.getUIComponent("GameResult")._visible = true;
         this.api.ui.getUIComponent("GameResultLight")._visible = true;
      }
      if(!this.api.ui.getUIComponent("Banner")._visible)
      {
         this.api.ui.getUIComponent("Banner")._visible = true;
      }
      this.unloadThis();
   }
   function onSubtitle(tfSubtitle, nSubtitle)
   {
      org.flashdevelop.utils.FlashConnect.trace("Sub : " + tfSubtitle,"dofus.graphics.gapi.ui.Cinematic::onSubtitle","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/graphics/gapi/ui/Cinematic.as",249);
      var _loc4_ = this._sFile.substring(0,this._sFile.toLowerCase().indexOf(".swf"));
      while(_loc4_.indexOf("/") > -1)
      {
         _loc4_ = _loc4_.substr(_loc4_.indexOf("/") + 1);
      }
      var _loc5_ = Number(_loc4_);
      var _loc6_ = this.api.lang.getSubtitle(_loc5_,nSubtitle);
      if(_loc6_ != undefined)
      {
         tfSubtitle.text = _loc6_;
      }
   }
   function yes(oEvent)
   {
      this.onCinematicFinished();
   }
}
