327486143 - 1;
class dofus.datacenter.PrismSprite extends dofus.datacenter.PlayableCharacter
{
   var _aAlignment;
   var _nLinkedMonsterId;
   var _sCreatureGfxFile;
   var _sCreatureGfxFileName;
   var api;
   var refreshGfxFileName;
   function PrismSprite(sID, clipClass, sGfxFile, cellNum, dir, gfxID)
   {
      super();
      this.initialize(sID,clipClass,sGfxFile,cellNum,dir,gfxID);
   }
   function get name()
   {
      return this.api.lang.getMonstersText(this._nLinkedMonsterId).n;
   }
   function set linkedMonster(value)
   {
      this._nLinkedMonsterId = value;
   }
   function get linkedMonster()
   {
      return this._nLinkedMonsterId;
   }
   function set alignment(value)
   {
      this._aAlignment = value;
   }
   function get alignment()
   {
      return this._aAlignment;
   }
   function get circleFilePath()
   {
      return dofus.Constants.CIRCLE_BOSS_FILE;
   }
   function get canSwitchInCreaturesMode()
   {
      return this.api.datacenter.Game.isFight;
   }
   function get creatureGfxFile()
   {
      if(this._sCreatureGfxFile != undefined)
      {
         return this._sCreatureGfxFile;
      }
      var _loc2_ = dofus.Constants.CLIPS_PERSOS_PATH + "901.swf";
      this._sCreatureGfxFile = _loc2_;
      this._sCreatureGfxFileName = this.refreshGfxFileName(_loc2_);
      return _loc2_;
   }
}
