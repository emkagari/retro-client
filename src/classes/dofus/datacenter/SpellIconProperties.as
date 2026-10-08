class dofus.datacenter.SpellIconProperties extends Object
{
   var _aBackgroundColors;
   var _aFrameColors;
   var _aPrintColors;
   var _nBackgroundFileID;
   var _nUpFileID;
   function SpellIconProperties(nUpFileID, nBackgroundFileID, aPrintColors, aBackgroundColors, aFrameColors)
   {
      super();
      this._nUpFileID = nUpFileID;
      this._nBackgroundFileID = nBackgroundFileID;
      this._aPrintColors = aPrintColors;
      this._aBackgroundColors = aBackgroundColors;
      this._aFrameColors = aFrameColors;
   }
   function get upFileID()
   {
      return this._nUpFileID;
   }
   function get backgroundFileID()
   {
      return this._nBackgroundFileID;
   }
   function get printColors()
   {
      return this._aPrintColors;
   }
   function get backgroundColors()
   {
      return this._aBackgroundColors;
   }
   function get frameColors()
   {
      return this._aFrameColors;
   }
   static function buildFromSpellText(oSpellText)
   {
      var _loc3_ = oSpellText.i;
      return new dofus.datacenter.SpellIconProperties(_loc3_.up,_loc3_.b,_loc3_.pc,_loc3_.bc,_loc3_.fc);
   }
}
