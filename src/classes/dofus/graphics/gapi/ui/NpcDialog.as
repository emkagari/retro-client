class dofus.graphics.gapi.ui.NpcDialog extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aColors;
   var _ldrArtwork;
   var _mcPic;
   var _mcQuestionViewer;
   var _nCustomArtwork;
   var _nNpcID;
   var _oQuestion;
   var _qvQuestionViewer;
   var _sGfx;
   var _sName;
   var _winBackground;
   var _winBackgroundUp;
   var addToQueue;
   var api;
   var attachMovie;
   var gapi;
   var getStyle;
   static var CLASS_NAME = "NpcDialog";
   var _bFirstQuestion = true;
   function NpcDialog()
   {
      super();
   }
   function set id(nNpcID)
   {
      this._nNpcID = nNpcID;
   }
   function set name(sName)
   {
      this._sName = sName;
   }
   function set gfx(sGfx)
   {
      this._sGfx = sGfx;
   }
   function set customArtwork(nGfx)
   {
      this._nCustomArtwork = nGfx;
   }
   function set colors(aColors)
   {
      this._aColors = aColors;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.NpcDialog.CLASS_NAME);
   }
   function callClose()
   {
      this.api.network.Dialog.leave();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.setNpcCharacteristics});
      this.gapi.unloadLastUIAutoHideComponent();
   }
   function draw()
   {
      var _loc2_ = this.getStyle();
   }
   function setNpcCharacteristics()
   {
      this._mcPic._visible = false;
      this._ldrArtwork.addEventListener("initialization",this);
      this._ldrArtwork.addEventListener("complete",this);
      if(this._nCustomArtwork != undefined && (!_global.isNaN(this._nCustomArtwork) && this._nCustomArtwork > 0))
      {
         this._ldrArtwork.contentPath = dofus.Constants.ARTWORKS_BIG_PATH + this._nCustomArtwork + ".swf";
      }
      else
      {
         this._ldrArtwork.contentPath = dofus.Constants.ARTWORKS_BIG_PATH + this._sGfx + ".swf";
      }
      this._winBackgroundUp.title = this._sName;
   }
   function setPause()
   {
      this.showElements(false);
   }
   function showElements(bShow)
   {
      this._ldrArtwork._visible = bShow;
      this._mcPic._visible = bShow;
      this._winBackground._visible = bShow;
      this._winBackgroundUp._visible = bShow;
      this._qvQuestionViewer._visible = bShow;
   }
   function setQuestion(oQuestion)
   {
      this._oQuestion = oQuestion;
      if(this._qvQuestionViewer == undefined)
      {
         this.attachMovie("QuestionViewer","_qvQuestionViewer",10,{_x:this._mcQuestionViewer._x,_y:this._mcQuestionViewer._y,question:oQuestion,isFirstQuestion:this._bFirstQuestion});
         this._qvQuestionViewer.addEventListener("response",this);
         this._qvQuestionViewer.addEventListener("resize",this);
      }
      else
      {
         this._qvQuestionViewer.isFirstQuestion = this._bFirstQuestion;
         this._qvQuestionViewer.question = oQuestion;
      }
      this.showElements(true);
   }
   function applyColor(mc, zone)
   {
      var _loc4_ = this._aColors[zone];
      if(_loc4_ == -1 || _loc4_ == undefined)
      {
         return undefined;
      }
      var _loc5_ = (_loc4_ & 0xFF0000) >> 16;
      var _loc6_ = (_loc4_ & 0xFF00) >> 8;
      var _loc7_ = _loc4_ & 0xFF;
      var _loc8_ = new Color(mc);
      var _loc9_ = {};
      _loc9_ = {ra:0,ga:0,ba:0,rb:_loc5_,gb:_loc6_,bb:_loc7_};
      _loc8_.setTransform(_loc9_);
   }
   function closeDialog()
   {
      this.callClose();
   }
   function response(oEvent)
   {
      if(oEvent.response.id == -1)
      {
         this.api.network.Dialog.leave();
      }
      else
      {
         this.api.network.Dialog.response(this._oQuestion.id,oEvent.response.id);
         this._bFirstQuestion = false;
      }
   }
   function complete(oEvent)
   {
      var ref = this;
      this._ldrArtwork.content.stringCourseColor = function(mc_, nColorIndex)
      {
         ref.applyColor(mc_,nColorIndex);
      };
   }
   function resize(oEvent)
   {
      this._winBackground.setSize(undefined,oEvent.target.height + (oEvent.target._y - this._winBackground._y) + 12);
      this._winBackgroundUp.setSize(undefined,oEvent.target.height + (oEvent.target._y - this._winBackground._y) + 10);
   }
   function initialization(oEvent)
   {
      this._mcPic._visible = true;
   }
}
