class dofus.datacenter.ServerInformations extends Object
{
   var _bOnFocus;
   var _pProblems;
   var api;
   var dispatchEvent;
   function ServerInformations()
   {
      super();
      this.initialize();
   }
   function get problems()
   {
      return this._pProblems;
   }
   function get isOnFocus()
   {
      return this._bOnFocus;
   }
   function load()
   {
      this.dispatchEvent({type:"onLoadStarted"});
      this.dispatchEvent({type:"onLoadError"});
   }
   function initialize()
   {
      this.api = _global.API;
      mx.events.EventDispatcher.initialize(this);
   }
   function parseXml(xml)
   {
      this._pProblems = [];
      var _loc3_ = xml.firstChild;
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
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
      var _loc18_;
      var _loc19_;
      var _loc20_;
      var _loc21_;
      var _loc22_;
      var _loc23_;
      while(_loc4_ < _loc3_.childNodes.length)
      {
         _loc5_ = _loc3_.childNodes[_loc4_];
         _loc6_ = Number(_loc5_.attributes.id);
         _loc7_ = Number(_loc5_.attributes.date);
         _loc8_ = Number(_loc5_.attributes.type);
         _loc9_ = Number(_loc5_.attributes.state);
         _loc10_ = _loc5_.attributes.visible == "true";
         this._bOnFocus = this._bOnFocus || _loc10_;
         _loc11_ = _loc5_.childNodes[0];
         _loc12_ = [];
         if(_loc11_.attributes.cnx == "true")
         {
            _loc12_.push(this.api.lang.getText("CONNECTION_SERVER"));
         }
         if(_loc11_.attributes.all == "true")
         {
            _loc12_.push(this.api.lang.getText("EVERY_SERVERS"));
         }
         else
         {
            _loc13_ = 0;
            while(_loc13_ < _loc11_.childNodes.length)
            {
               _loc12_.push(_loc11_.childNodes[_loc13_].attributes.name);
               _loc13_ = _loc13_ + 1;
            }
         }
         _loc14_ = _loc5_.childNodes[1];
         _loc15_ = [];
         _loc16_ = 0;
         while(_loc16_ < _loc14_.childNodes.length)
         {
            _loc17_ = _loc14_.childNodes[_loc16_];
            _loc18_ = Number(_loc17_.attributes.timestamp);
            _loc19_ = Number(_loc17_.attributes.id);
            _loc20_ = _loc17_.attributes.translated == "true";
            _loc21_ = _loc17_.firstChild.nodeValue;
            _loc22_ = new dofus.datacenter.ServerProblemEvent(_loc18_,_loc19_,_loc20_,_loc21_);
            _loc15_.push(_loc22_);
            _loc16_ = _loc16_ + 1;
         }
         _loc23_ = new dofus.datacenter.ServerProblem(_loc6_,_loc7_,_loc8_,_loc9_,_loc12_,_loc15_);
         this._pProblems.push(_loc23_);
         _loc4_ = _loc4_ + 1;
      }
      this.dispatchEvent({type:"onData"});
   }
   function onXMLLoadComplete(oEvent)
   {
      var _loc3_ = oEvent.value;
      this.parseXml(_loc3_);
   }
   function onXMLLoadError()
   {
      this.dispatchEvent({type:"onLoadError"});
   }
}
