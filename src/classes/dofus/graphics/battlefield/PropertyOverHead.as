class dofus.graphics.battlefield.PropertyOverHead extends dofus.graphics.battlefield.AbstractTextOverHead
{
   var _txtOwnerName;
   var _txtPropertyName;
   var attachMovie;
   var createEmptyMovieClip;
   var createTextField;
   var getNextHighestDepth;
   static var EMBLEM_SIZE = 11;
   function PropertyOverHead(eoProperties, sIconFile)
   {
      super();
      this.initialize();
      this.drawClip(eoProperties,sIconFile);
   }
   function initialize()
   {
      super.initialize();
      this.createTextField("_txtPropertyName",30,0,-2 + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER,0,0);
      this.createTextField("_txtOwnerName",40,0,13 + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER,0,0);
   }
   function drawClip(eoProperties, sIconFile)
   {
      var _loc4_ = false;
      var _loc5_ = eoProperties.getLength() == 1;
      var _loc6_ = eoProperties.getFirstItem().name;
      this._txtPropertyName.setNewTextFormat(dofus.graphics.battlefield.AbstractTextOverHead.TEXT_SMALL_FORMAT);
      this._txtPropertyName.setTextFormat();
      this._txtPropertyName.embedFonts = true;
      this._txtPropertyName.autoSize = "center";
      this._txtPropertyName.html = true;
      this._txtPropertyName.htmlText = "<b>" + _loc6_ + "</b>";
      this._txtPropertyName.selectable = false;
      this._txtOwnerName.setNewTextFormat(dofus.graphics.battlefield.AbstractTextOverHead.TEXT_SMALL_FORMAT);
      this._txtOwnerName.setTextFormat();
      this._txtOwnerName.embedFonts = true;
      this._txtOwnerName.autoSize = "center";
      this._txtOwnerName.html = true;
      this._txtOwnerName.selectable = false;
      var _loc7_ = this.createEmptyMovieClip("_mcIcon",this.getNextHighestDepth());
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      for(var i in eoProperties.getItems())
      {
         _loc8_ = eoProperties.getItemAt(i);
         _loc9_ = _loc8_.getOwnerAndGuild(true);
         this._txtOwnerName.text += _loc9_ + "\n";
         if(!_loc5_ && _loc8_.guildName != undefined)
         {
            _loc10_ = _root.createTextField("txtMeasurementTextField",_root.getNextHighestDepth(),0,0,0,0);
            _loc10_.setNewTextFormat(dofus.graphics.battlefield.AbstractTextOverHead.TEXT_SMALL_FORMAT);
            _loc10_.setTextFormat();
            _loc10_.embedFonts = true;
            _loc10_.html = true;
            _loc10_.htmlText = _loc9_;
            _loc11_ = _loc10_.textWidth + 30 + dofus.graphics.battlefield.PropertyOverHead.EMBLEM_SIZE;
            _loc4_ = true;
            _loc7_.attachMovie("Emblem","_eEmblem" + i,_loc7_.getNextHighestDepth(),{_x:_loc11_,_y:this._txtOwnerName._height + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER,_height:dofus.graphics.battlefield.PropertyOverHead.EMBLEM_SIZE,_width:dofus.graphics.battlefield.PropertyOverHead.EMBLEM_SIZE,data:_loc8_.guildEmblem,shadow:true});
            _loc10_.removeTextField();
         }
      }
      this._txtOwnerName.htmlText = this._txtOwnerName.text;
      var _loc14_ = 0;
      var _loc12_ = Math.ceil(18 + this._txtOwnerName.textHeight + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER * 2);
      var _loc13_ = Math.ceil(Math.max(this._txtPropertyName.textWidth,this._txtOwnerName.textWidth) + dofus.graphics.battlefield.AbstractTextOverHead.WIDTH_SPACER * 4) + 30;
      if(_loc4_)
      {
         _loc13_ += dofus.graphics.battlefield.PropertyOverHead.EMBLEM_SIZE + dofus.graphics.battlefield.AbstractTextOverHead.WIDTH_SPACER;
      }
      this._txtPropertyName._x = this._txtOwnerName._x = (- _loc13_) / 2 + 30 + dofus.graphics.battlefield.AbstractTextOverHead.WIDTH_SPACER * 2;
      var _loc15_;
      if(_loc5_ && eoProperties.getFirstItem().guildName != undefined)
      {
         _loc7_.attachMovie("Emblem","_eEmblem",100,{_y:dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER,_height:30,_width:30,data:eoProperties.getFirstItem().guildEmblem,shadow:true});
      }
      else
      {
         _loc15_ = ank.gapi.controls.Loader(this.attachMovie("GAPILoader","_ldrIcon",100,{contentPath:sIconFile,_height:30,_width:30,_x:Math.ceil((- _loc13_) / 2) + dofus.graphics.battlefield.AbstractTextOverHead.WIDTH_SPACER,_y:dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER,scaleContent:true}));
      }
      _loc7_._x = Math.ceil((- _loc13_) / 2) + dofus.graphics.battlefield.AbstractTextOverHead.WIDTH_SPACER;
      this.drawBackground(_loc13_,_loc12_,dofus.graphics.battlefield.AbstractTextOverHead.BACKGROUND_COLOR);
   }
}
