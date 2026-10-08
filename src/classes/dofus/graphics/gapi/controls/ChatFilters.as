class dofus.graphics.gapi.controls.ChatFilters extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnFilter0;
   var _btnFilter1;
   var _btnFilter2;
   var _btnFilter3;
   var _btnFilter4;
   var _btnFilter5;
   var _btnFilter6;
   var _btnFilter7;
   var _btnFilter8;
   var _btnFilter9;
   var _btnFilter10;
   var addToQueue;
   var dispatchEvent;
   var gapi;
   static var CLASS_NAME = "ChatFilters";
   function ChatFilters()
   {
      super();
   }
   function get filters()
   {
      return [this._btnFilter0.selected,this._btnFilter1.selected,this._btnFilter2.selected,this._btnFilter3.selected,this._btnFilter4.selected,this._btnFilter5.selected,this._btnFilter6.selected,this._btnFilter7.selected,this._btnFilter8.selected,this._btnFilter9.selected,this._btnFilter10.selected];
   }
   function selectFilter(nFilter, bSelect)
   {
      var _loc4_ = this["_btnFilter" + nFilter];
      if(_loc4_ == undefined)
      {
         return undefined;
      }
      _loc4_.selected = bSelect;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.ChatFilters.CLASS_NAME);
   }
   function createChildren()
   {
      var _loc2_ = this.api.lang.getConfigText("CHAT_FILTERS");
      var _loc3_ = 0;
      var _loc4_;
      for(; _loc3_ < _loc2_.length; _loc3_ = _loc3_ + 1)
      {
         if(_loc2_[_loc3_] != 1)
         {
            _loc4_ = this["_btnFilter" + (_loc3_ + 1)];
            if(_loc4_ == undefined)
            {
               continue;
            }
            _loc4_._visible = false;
         }
      }
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._btnFilter0.addEventListener("click",this);
      this._btnFilter1.addEventListener("click",this);
      this._btnFilter2.addEventListener("click",this);
      this._btnFilter3.addEventListener("click",this);
      this._btnFilter4.addEventListener("click",this);
      this._btnFilter5.addEventListener("click",this);
      this._btnFilter6.addEventListener("click",this);
      this._btnFilter7.addEventListener("click",this);
      this._btnFilter8.addEventListener("click",this);
      this._btnFilter10.addEventListener("click",this);
      this._btnFilter0.addEventListener("over",this);
      this._btnFilter1.addEventListener("over",this);
      this._btnFilter2.addEventListener("over",this);
      this._btnFilter3.addEventListener("over",this);
      this._btnFilter4.addEventListener("over",this);
      this._btnFilter5.addEventListener("over",this);
      this._btnFilter6.addEventListener("over",this);
      this._btnFilter7.addEventListener("over",this);
      this._btnFilter8.addEventListener("over",this);
      this._btnFilter10.addEventListener("over",this);
      this._btnFilter0.addEventListener("out",this);
      this._btnFilter1.addEventListener("out",this);
      this._btnFilter2.addEventListener("out",this);
      this._btnFilter3.addEventListener("out",this);
      this._btnFilter4.addEventListener("out",this);
      this._btnFilter5.addEventListener("out",this);
      this._btnFilter6.addEventListener("out",this);
      this._btnFilter7.addEventListener("out",this);
      this._btnFilter8.addEventListener("out",this);
      this._btnFilter10.addEventListener("out",this);
      var _loc2_ = this.api.kernel.ChatManager.visibleTypes;
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < _loc2_.length)
      {
         _loc4_ = this["_btnFilter" + _loc3_];
         if(_loc4_ != undefined)
         {
            _loc4_.selected = this.api.datacenter.Basics.chat_type_visible[_loc3_] == true;
            this.api.kernel.ChatManager.setTypeVisible(_loc3_,_loc4_.selected);
         }
         _loc3_ = _loc3_ + 1;
      }
      this.api.kernel.ChatManager.setTypeVisible(1,true);
      this.api.kernel.ChatManager.setTypeVisible(9,true);
   }
   function click(oEvent)
   {
      var _loc0_;
      var _temp_1 = _loc0_ = oEvent.target._name;
      this.dispatchEvent({type:"filterChanged",filter:Number(oEvent.target._name.substr(10)),selected:oEvent.target.selected});
      _temp_1;
   }
   function over(oEvent)
   {
      var _loc0_;
      var _temp_1 = _loc0_ = oEvent.target._name;
      var _loc3_ = Number(oEvent.target._name.substr(10));
      this.gapi.showTooltip(this.api.lang.getText("CHAT_TYPE" + _loc3_));
      _temp_1;
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
