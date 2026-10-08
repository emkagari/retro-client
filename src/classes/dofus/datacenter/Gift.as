class dofus.datacenter.Gift extends Object
{
   var _bForbidPlayerChoice;
   var _bPlayerWantsAttribution;
   var _eaItems;
   var _nID;
   var _nIndexOnGiftsStack;
   var _nType;
   var _sDate;
   var _sDescription;
   var _sGfxURL;
   var _sTitle;
   var api;
   var dispatchEvent;
   function Gift()
   {
      super();
      this.api = _global.API;
      this._bPlayerWantsAttribution = false;
      mx.events.EventDispatcher.initialize(this);
   }
   function get id()
   {
      return this._nID;
   }
   function set id(nID)
   {
      this._nID = nID;
   }
   function get title()
   {
      return this._sTitle;
   }
   function set title(sTitle)
   {
      this._sTitle = sTitle;
   }
   function get items()
   {
      return this._eaItems;
   }
   function set items(eaItems)
   {
      this._eaItems = eaItems;
   }
   function get type()
   {
      return this._nType;
   }
   function set type(nType)
   {
      this._nType = nType;
   }
   function get gfxUrl()
   {
      return this._sGfxURL;
   }
   function set gfxUrl(sGfxURL)
   {
      this._sGfxURL = sGfxURL;
   }
   function get desc()
   {
      return this._sDescription;
   }
   function set desc(sDescription_)
   {
      this._sDescription = sDescription_;
   }
   function get playerWantsAttribution()
   {
      return this._bPlayerWantsAttribution;
   }
   function set playerWantsAttribution(bPlayerWantsAttribution)
   {
      this._bPlayerWantsAttribution = bPlayerWantsAttribution;
   }
   function get forbidPlayerChoice()
   {
      return this._bForbidPlayerChoice;
   }
   function set forbidPlayerChoice(bForbidPlayerChoice)
   {
      this._bForbidPlayerChoice = bForbidPlayerChoice;
   }
   function get indexOnGiftsStack()
   {
      return this._nIndexOnGiftsStack;
   }
   function set indexOnGiftsStack(nIndexOnGiftsStack)
   {
      this._nIndexOnGiftsStack = nIndexOnGiftsStack;
   }
   function get date()
   {
      return this._sDate;
   }
   function set date(sDate)
   {
      this._sDate = sDate;
   }
   function onAttributionStateChanged()
   {
      this.dispatchEvent({type:"giftAttributionStateChanged",currentValue:this._bPlayerWantsAttribution});
   }
}
