496232205 - 1;
class dofus.graphics.gapi.ui.quests.DailyQuestsViewItem extends ank.gapi.core.UIBasicComponent
{
   var _btnLocate;
   var _lblKama;
   var _lblNpcName;
   var _lblQuestName;
   var _lblState;
   var _lblWinXP;
   var _mcChecked;
   var _mcInProgress;
   var _mcList;
   var _mcReward;
   var _mcXp;
   var _oItem;
   var _svCharacterViewer;
   static var CTR_INDEX = 5;
   function DailyQuestsViewItem()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function get api()
   {
      return this._mcList._parent.gapi.api;
   }
   function setValue(bUsed, sSuggested, oItem_)
   {
      this._oItem = oItem_;
      this._lblQuestName._visible = bUsed;
      this._lblNpcName._visible = bUsed;
      this._btnLocate._visible = bUsed;
      this._svCharacterViewer._visible = bUsed;
      this._lblState._visible = bUsed;
      this._lblKama._visible = bUsed;
      this._lblWinXP._visible = bUsed;
      this._mcXp._visible = bUsed;
      this._mcReward._visible = bUsed;
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < dofus.graphics.gapi.ui.quests.DailyQuestsViewItem.CTR_INDEX)
      {
         _loc6_ = this["_ctr" + _loc5_];
         _loc6_._visible = false;
         _loc5_ = _loc5_ + 1;
      }
      this._mcChecked._visible = false;
      this._mcInProgress._visible = false;
      if(bUsed)
      {
         this.setQuest(oItem_);
         this.setNpc(oItem_);
         if(this.api.datacenter.DailyQuests.hasFinishedQuest(oItem_.i))
         {
            this._mcChecked._visible = true;
            this._btnLocate._visible = false;
         }
         else if(this.api.datacenter.DailyQuests.hasStartedQuest(oItem_.i))
         {
            this._mcInProgress._visible = true;
            this._btnLocate._visible = false;
         }
         else
         {
            this.setMap();
         }
      }
   }
   function init()
   {
      super.init(false);
   }
   function setNpc(oData)
   {
      var _loc3_ = oData.n;
      var _loc4_ = this.api.lang.getNonPlayableCharactersText(_loc3_.i).n;
      this._lblNpcName.text = _loc4_;
      var _loc5_ = new ank.battlefield.datacenter.Sprite("viewer",ank.battlefield.mc.Sprite,dofus.Constants.CLIPS_PERSOS_PATH + _loc3_.g + ".swf",undefined,5);
      _loc5_.color1 = _loc3_.c1;
      _loc5_.color2 = _loc3_.c2;
      _loc5_.color3 = _loc3_.c3;
      this.api.kernel.CharactersManager.setSpriteAccessories(_loc5_,_loc3_.a);
      this._svCharacterViewer.spriteData = _loc5_;
      this._svCharacterViewer.useSingleLoader = true;
      this._svCharacterViewer.spriteAnims = ["staticR"];
      this._svCharacterViewer.noDelay = true;
   }
   function setQuest(oData)
   {
      var _loc3_ = this.api.lang.getQuestText(oData.q);
      this._lblQuestName.text = _loc3_;
      var _loc4_ = 0;
      var _loc5_ = 0;
      var _loc6_ = [];
      var _loc7_ = this.api.lang.getQuest(oData.q).s;
      var _loc8_ = 0;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      while(_loc8_ < _loc7_.length)
      {
         _loc9_ = _loc7_[_loc8_];
         _loc10_ = this.api.lang.getQuestStepText(_loc9_).r;
         if(_loc10_[0] != undefined)
         {
            _loc4_ += Number(_loc10_[0]);
         }
         if(_loc10_[1] != undefined)
         {
            _loc5_ += Number(_loc10_[1]);
         }
         if(_loc10_[2] != undefined)
         {
            _loc11_ = _loc10_[2];
            _loc12_ = 0;
            while(_loc12_ < _loc11_.length)
            {
               _loc13_ = Number(_loc11_[_loc12_][0]);
               _loc14_ = _loc11_[_loc12_][1];
               _loc15_ = new dofus.datacenter.Item(0,_loc13_,_loc14_);
               _loc6_.push(_loc15_);
               _loc12_ = _loc12_ + 1;
            }
         }
         _loc8_ = _loc8_ + 1;
      }
      this._lblKama.text = new ank.utils.ExtendedString(_loc5_).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
      this._lblWinXP.text = new ank.utils.ExtendedString(_loc4_).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
      var _loc16_ = 0;
      var _loc17_;
      while(_loc16_ < dofus.graphics.gapi.ui.quests.DailyQuestsViewItem.CTR_INDEX)
      {
         if(_loc6_[_loc16_] == undefined)
         {
            break;
         }
         _loc17_ = this["_ctr" + _loc16_];
         _loc17_.contentData = _loc6_[_loc16_];
         _loc17_.addEventListener("onContentLoaded",this);
         _loc17_.addEventListener("over",this);
         _loc17_.addEventListener("out",this);
         _loc17_.enabled = true;
         _loc17_._visible = true;
         _loc16_ = _loc16_ + 1;
      }
   }
   function setMap()
   {
      this._btnLocate.addEventListener("click",this);
      this._btnLocate.addEventListener("over",this);
      this._btnLocate.addEventListener("out",this);
   }
   function click(oEvent_)
   {
      this.api.ui.loadUIComponent("MapExplorer","MapExplorer",{mapID:this._oItem.m});
   }
   function over(oEvent_)
   {
      var _loc0_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc3_;
      if((_loc0_ = oEvent_.target) !== this._btnLocate)
      {
         _loc4_ = ank.gapi.controls.Container(oEvent_.target);
         if(_loc4_.contentData != undefined)
         {
            _loc5_ = dofus.datacenter.Item(_loc4_.contentData);
            _loc6_ = _loc5_.style + "ToolTip";
            this.api.ui.showTooltip(_loc5_.Quantity + " x " + _loc5_.name,_loc6_);
         }
      }
      else
      {
         _loc3_ = this.api.lang.getMapText(this._oItem.m);
         this.api.ui.showTooltip(this.api.lang.getText("LOCATE") + " " + "[" + _loc3_.x + ", " + _loc3_.y + "]");
      }
   }
   function out(oEvent_)
   {
      this.api.ui.hideTooltip();
   }
}
