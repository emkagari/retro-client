class dofus.graphics.gapi.ui.ServersManagerRetry extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _lblCounter;
   var _lblCounterShadow;
   var addToQueue;
   var initialized;
   static var CLASS_NAME = "ServersManagerRetry";
   var _nTimer = 0;
   function ServersManagerRetry()
   {
      super();
   }
   function set timer(nTimer)
   {
      this.addToQueue({object:this,method:function(n_)
      {
         this._nTimer = Number(n_);
         if(this.initialized)
         {
            this.updateLabel();
         }
      },params:[nTimer]});
   }
   function updateLabel()
   {
      var _loc2_ = this.api.lang.getText("SERVERS_MANAGER_RETRY",[this._nTimer]);
      this._lblCounterShadow.text = _loc2_;
      this._lblCounter.text = _loc2_;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.ServersManagerRetry.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.updateLabel});
   }
}
