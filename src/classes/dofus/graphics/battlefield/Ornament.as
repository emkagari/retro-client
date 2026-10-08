/**
 * A Dofus 2-style nameplate frame (clips/ornaments/<id>.swf) drawn around a
 * plate: the overheads' name plate, the titles window's preview.
 *
 * An ornament SWF holds a 160x40 frame, "bg", and parts ("top", "bottom",
 * "left", "right", "omega_bottom", "picto"...) hanging on its edges or middle.
 * The frame is stretched to the plate (its corners kept whole), the parts
 * follow their edge, and the dark plate is redrawn to fill the frame.
 */
class dofus.graphics.battlefield.Ornament
{
   static var PLATE_WIDTH = 160;
   static var PLATE_HEIGHT = 40;
   static var SCALE = 0.5;
   // Narrowest stretched plate: the frame's corners stay whole.
   static var MIN_WIDTH = 100;
   // bg's stretchable middle, in the plate's coordinates.
   static var GRID = new flash.geom.Rectangle(40,12,80,16);
   var _mcOrnament;
   var _mcBackground;
   var _oPainter;
   var _nColor;
   var _nAlpha;
   var _nWidth;
   var _nHeight;
   var _oFrame;
   /**
    * mcParent: where the ornament goes, at nDepth (between the plate and its text);
    * the plate is drawn in mcBackground (from y = 0, centred on x = 0) with
    * oPainter.drawRoundRect, in nColor / nAlpha.
    */
   function Ornament(mcParent, nDepth, nId, mcBackground, oPainter, nColor, nAlpha)
   {
      this._mcBackground = mcBackground;
      this._oPainter = oPainter;
      this._nColor = nColor;
      this._nAlpha = nAlpha;
      this._mcOrnament = mcParent.createEmptyMovieClip("_mcOrnament",nDepth);
      var owner = this;
      var listener = new Object();
      listener.onLoadInit = function(mc)
      {
         owner.loaded(mc);
      };
      var loader = new MovieClipLoader();
      loader.addListener(listener);
      loader.loadClip(dofus.Constants.CLIPS_PATH + "ornaments/" + nId + ".swf",this._mcOrnament);
   }
   function setPlate(nWidth, nHeight)
   {
      this._nWidth = nWidth;
      this._nHeight = nHeight;
      if(this._oFrame != undefined)
      {
         this.layout();
      }
   }
   function remove()
   {
      this._oFrame = undefined;
      this._mcOrnament.removeMovieClip();
   }
   function loaded(mc)
   {
      var frame = this.findFrame(mc,0);
      if(frame == undefined || this._mcOrnament._parent == undefined)
      {
         return undefined;
      }
      // The original layout, which every relayout starts from.
      var parts = new Array();
      for(var name in frame)
      {
         var part = frame[name];
         if(typeof part == "movieclip" && part._parent == frame && part != frame.bg)
         {
            parts.push({mc:part,x:part._x,y:part._y});
         }
      }
      // A part that starts empty grows in: the ornament is an intro, played once.
      var intro = false;
      var j = 0;
      while(j < parts.length)
      {
         if(parts[j].mc._totalframes > 1 && parts[j].mc._width == 0)
         {
            intro = true;
         }
         j++;
      }
      j = 0;
      while(intro && j < parts.length)
      {
         this.playOnce(parts[j].mc);
         j++;
      }
      var bg = frame.bg;
      this._oFrame = {mc:frame,parts:parts,x:bg._x,y:bg._y,bounds:bg.getBounds(frame),width:bg._width,height:bg._height};
      bg.scale9Grid = dofus.graphics.battlefield.Ornament.GRID;
      if(this._nWidth != undefined)
      {
         this.layout();
      }
   }
   function playOnce(mc)
   {
      if(mc._totalframes < 2)
      {
         return undefined;
      }
      mc.onEnterFrame = function()
      {
         if(this._currentframe >= this._totalframes)
         {
            this.stop();
            delete this.onEnterFrame;
            dofus.graphics.battlefield.Ornament.stopAll(this);
         }
      };
   }
   static function stopAll(mc)
   {
      // The animations nested in a finished part end too, on their last frame.
      for(var name in mc)
      {
         if(typeof mc[name] == "movieclip" && mc[name]._parent == mc)
         {
            mc[name].gotoAndStop(mc[name]._totalframes);
            dofus.graphics.battlefield.Ornament.stopAll(mc[name]);
         }
      }
   }
   function findFrame(mc, nDepth)
   {
      if(mc.bg != undefined)
      {
         return mc;
      }
      if(nDepth > 2)
      {
         return undefined;
      }
      var found;
      for(var name in mc)
      {
         if(typeof mc[name] == "movieclip" && mc[name]._parent == mc)
         {
            found = this.findFrame(mc[name],nDepth + 1);
            if(found != undefined)
            {
               return found;
            }
         }
      }
      return undefined;
   }
   function layout()
   {
      var o = this._oFrame;
      var c = dofus.graphics.battlefield.Ornament;
      var scale = c.SCALE;
      var plateWidth = Math.max(this._nWidth / scale,c.MIN_WIDTH);
      var plateHeight = Math.max(this._nHeight / scale,c.PLATE_HEIGHT);
      var dw = plateWidth - c.PLATE_WIDTH;
      var dh = plateHeight - c.PLATE_HEIGHT;
      // The plate grows from its centre: the edges move by half the growth.
      var bg = o.mc.bg;
      bg._width = o.width + dw;
      bg._height = o.height + dh;
      var b = bg.getBounds(o.mc);
      bg._x += o.bounds.xMin - dw / 2 - b.xMin;
      bg._y += o.bounds.yMin - dh / 2 - b.yMin;
      var i = 0;
      var p;
      while(i < o.parts.length)
      {
         p = o.parts[i];
         p.mc._x = p.x + dw * (this.anchor(p.x - o.x,c.PLATE_WIDTH) - 0.5);
         p.mc._y = p.y + dh * (this.anchor(p.y - o.y,c.PLATE_HEIGHT) - 0.5);
         i++;
      }
      // The dark plate fills the frame, which can be wider than the text.
      var w = plateWidth * scale;
      var h = plateHeight * scale;
      this._mcBackground.clear();
      this._oPainter.drawRoundRect(this._mcBackground,(- w) / 2,(this._nHeight - h) / 2,w,h,3,this._nColor,this._nAlpha);
      // The plate's centre goes onto the text's.
      o.mc._xscale = o.mc._yscale = scale * 100;
      var centre = {x:o.x + c.PLATE_WIDTH / 2,y:o.y + c.PLATE_HEIGHT / 2};
      o.mc.localToGlobal(centre);
      this._mcOrnament._parent.globalToLocal(centre);
      o.mc._x += - centre.x;
      o.mc._y += this._nHeight / 2 - centre.y;
   }
   function anchor(nOffset, nSize)
   {
      // 0, 0.5 or 1: the plate edge or middle the part hangs on.
      return Math.min(1,Math.max(0,Math.round(nOffset / nSize * 2) / 2));
   }
}
