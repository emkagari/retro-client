class ank.battlefield.datacenter.Mount extends Object
{
   var _nColor1;
   var _nColor2;
   var _nColor3;
   var chevauchorGfxFile;
   var gfxFile;
   function Mount(sGfxFile, sChevauchorGfxFile)
   {
      super();
      this.gfxFile = sGfxFile;
      this.chevauchorGfxFile = sChevauchorGfxFile;
   }
   function get color1()
   {
      return this._nColor1;
   }
   function set color1(v)
   {
      this._nColor1 = v;
   }
   function get color2()
   {
      return this._nColor2;
   }
   function set color2(v)
   {
      this._nColor2 = v;
   }
   function get color3()
   {
      return this._nColor3;
   }
   function set color3(v)
   {
      this._nColor3 = v;
   }
}
