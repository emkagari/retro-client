class dofus.graphics.battlefield.SmileyOverHead extends MovieClip
{
   function SmileyOverHead(nSmileyID)
   {
      super();
      this.drawClip(nSmileyID);
   }
   function get height()
   {
      return 20;
   }
   function get width()
   {
      return 20;
   }
   function drawClip(nSmileyID)
   {
      this.attachMovie("GAPILoader","_ldrSmiley",10,{_x:-10,_width:20,_height:20,scaleContent:true,contentPath:dofus.Constants.SMILEYS_ICONS_PATH + nSmileyID + ".swf"});
   }
}
