class dofus.datacenter.ParkMount extends dofus.datacenter.PlayableCharacter
{
   var _lang;
   var initialize;
   var modelID;
   function ParkMount(sID, clipClass, sGfxFile, cellNum, dir, gfxID, nModelID)
   {
      super();
      this.initialize(sID,clipClass,sGfxFile,cellNum,dir,gfxID);
      this.modelID = nModelID;
      this._lang = _global.API.lang.getMountText(nModelID);
   }
   function get color1()
   {
      return this._lang.c1;
   }
   function get color2()
   {
      return this._lang.c2;
   }
   function get color3()
   {
      return this._lang.c3;
   }
   function get modelName()
   {
      return this._lang.n;
   }
}
