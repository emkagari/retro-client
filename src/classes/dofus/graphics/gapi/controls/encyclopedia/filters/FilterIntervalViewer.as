class dofus.graphics.gapi.controls.encyclopedia.filters.FilterIntervalViewer extends dofus.graphics.gapi.controls.encyclopedia.filters.UIBasicFilter
{
   var _lblInterval;
   var _lblName;
   var _oData;
   var _tiMax;
   var _tiMin;
   var addToQueue;
   var api;
   var dispatchEvent;
   function FilterIntervalViewer()
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
   function reset()
   {
      this._tiMax.text = "";
      this._tiMin.text = "";
      this._oData.max = this._oData.defaultMax;
      this._oData.min = this._oData.defaultMin;
      this._tiMax.placeholder = "" + this._oData.max;
      this._tiMin.placeholder = "" + this._oData.min;
      this._tiMax.updateFocus();
      this._tiMin.updateFocus();
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initText});
      this.addToQueue({object:this,method:this.addListeners});
   }
   function initText()
   {
      this._tiMax.placeholder = "" + this._oData.max;
      this._tiMin.placeholder = "" + this._oData.min;
      this._tiMax.text = "";
      this._tiMin.text = "";
      this._lblName.text = this.api.lang.getText(this._oData.label);
      this._lblInterval.text = this.api.lang.getText("TO_RANGE");
   }
   function addListeners()
   {
      this._tiMin.addEventListener("change",this);
      this._tiMax.addEventListener("change",this);
   }
   function change(oEvent_)
   {
      var _loc3_;
      switch(oEvent_.target)
      {
         case this._tiMax:
            _loc3_ = this._tiMax.text == "" ? this._oData.defaultMax : Number(this._tiMax.text);
            if(this._oData.max == _loc3_)
            {
               return undefined;
            }
            if(_loc3_ > this._oData.defaultMax)
            {
               _loc3_ = this._oData.defaultMax;
            }
            if(_loc3_ < this._oData.defaultMin)
            {
               _loc3_ = this._oData.defaultMin;
            }
            this._oData.max = _loc3_;
            break;
         case this._tiMin:
            _loc3_ = this._tiMin.text == "" ? this._oData.defaultMin : Number(this._tiMin.text);
            if(this._oData.min == _loc3_)
            {
               return undefined;
            }
            if(_loc3_ > this._oData.defaultMax)
            {
               _loc3_ = this._oData.defaultMax;
            }
            if(_loc3_ < this._oData.defaultMin)
            {
               _loc3_ = this._oData.defaultMin;
            }
            this._oData.min = _loc3_;
      }
      this.dispatchEvent({type:"filterChanged",value:oEvent_});
   }
}
