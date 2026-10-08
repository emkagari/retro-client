class dofus.graphics.gapi.ui.achievements.AchievementItem extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bIsToggled;
   var _btnToggle;
   var _lblDescription;
   var _lblFinishedDate;
   var _lblName;
   var _lblScore;
   var _ldrIcon;
   var _mcUI;
   var _oData;
   var addToQueue;
   var gotoAndStop;
   function AchievementItem()
   {
      super();
   }
   function get data()
   {
      return this._oData;
   }
   function set data(oData)
   {
      this._oData = oData;
   }
   function get isToggled()
   {
      return this._bIsToggled;
   }
   function set isToggled(bIsToggled)
   {
      this._bIsToggled = bIsToggled;
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function addListeners()
   {
      this._btnToggle.addEventListener("click",this);
      this._btnToggle.addEventListener("over",this);
      this._btnToggle.addEventListener("out",this);
      this._oData.addEventListener("updateFinishedState",this);
      this._oData.addEventListener("updateRewardsClaimed",this);
   }
   function initTexts()
   {
      this._lblName.text = this._oData.name;
      this._lblDescription.text = this._oData.description;
      this._lblScore.text = String(this._oData.score);
      this._lblFinishedDate.text = this._oData.finishedFormattedTime;
      if(this._lblDescription.textHeight > 20)
      {
         this._lblDescription._y -= 8;
         this._lblDescription.setPreferedSize("left");
      }
   }
   function initData()
   {
      this._mcUI = dofus.graphics.gapi.ui.Achievements(this.api.ui.getUIComponent("Achievements"));
      this._ldrIcon.contentPath = this._oData.iconFile;
      this.refreshFinishedState(this._oData.getFinishedState());
   }
   function refreshFinishedState(sState)
   {
      this.gotoAndStop(sState);
   }
   function updateFinishedState(oEvent_)
   {
      this._lblFinishedDate.text = oEvent_.value;
      this.refreshFinishedState(oEvent_.state);
   }
   function updateRewardsClaimed(oEvent_)
   {
      this.refreshFinishedState(oEvent_.state);
   }
   function over(oEvent_)
   {
      this._mcUI.currentOverItem = this._oData;
   }
   function out(oEvent_)
   {
      this._mcUI.currentOverItem = undefined;
   }
   function click(oEvent_)
   {
      if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY))
      {
         this.api.kernel.GameManager.insertAchievementInChat(this._oData);
         return undefined;
      }
      this._mcUI.toggleAchievementDetails(this._oData.ID);
   }
}
