class ank.gapi.controls.list.DefaultCellRenderer extends ank.gapi.core.UIBasicComponent
{
   var __height;
   var __width;
   var _lblText;
   var _ldrIcon;
   var _nIconOffset;
   var attachMovie;
   var getStyle;
   function DefaultCellRenderer()
   {
      super();
   }
   function setState(sState)
   {
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      if(bUsed)
      {
         this._lblText.text = sSuggested;
         if(oItem.icon != undefined)
         {
            this._lblText._x = this._nIconOffset;
            this.attachMovie("GAPILoader","_ldrIcon",100,{_x:3.5,_y:this._lblText._y + 2.5,_height:15,_width:15,contentPath:oItem.icon,scaleContent:true});
         }
         else
         {
            this._ldrIcon.removeMovieClip();
            this._lblText._x = 0;
         }
      }
      else if(this._lblText.text != undefined)
      {
         this._lblText.text = "";
      }
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.attachMovie("Label","_lblText",10,{styleName:this.getStyle().defaultstyle});
      this._nIconOffset = this._lblText._x + 20;
   }
   function size()
   {
      super.size();
      this._lblText.setSize(this.__width,this.__height);
   }
   function draw()
   {
      var _loc2_ = this.getStyle();
      this._lblText.styleName = _loc2_.defaultstyle;
   }
}
