class dofus.graphics.battlefield.MountParkOverHead extends dofus.graphics.battlefield.AbstractTextOverHead
{
   var _txtInfo;
   var _txtName;
   var _txtOwnerName;
   var attachMovie;
   var createEmptyMovieClip;
   var createTextField;
   var getNextHighestDepth;
   static var api;
   static var EMBLEM_SIZE = 11;
   function MountParkOverHead(eaMountParks, sIconFile)
   {
      super();
      this.initialize();
      this.drawClip(eaMountParks,sIconFile);
   }
   function initialize()
   {
      super.initialize();
      this.createTextField("_txtName",30,0,-2 + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER,0,0);
      this.createTextField("_txtInfo",40,0,9 + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER,0,0);
      this.createTextField("_txtOwnerName",50,0,25 + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER,0,0);
      dofus.graphics.battlefield.MountParkOverHead.api = _global.API;
   }
   function drawClip(eaMountParks, sIconFile)
   {
      var _loc4_ = false;
      var _loc5_ = eaMountParks.length == 1;
      var _loc6_ = dofus.datacenter.MountPark(eaMountParks[0]);
      var _loc7_ = _loc6_.name;
      this._txtName.setNewTextFormat(dofus.graphics.battlefield.AbstractTextOverHead.TEXT_SMALL_FORMAT);
      this._txtName.setTextFormat();
      this._txtName.embedFonts = true;
      this._txtName.autoSize = "center";
      this._txtName.html = true;
      this._txtName.htmlText = "<b>" + _loc7_ + "</b>";
      this._txtName.selectable = false;
      this._txtInfo.setNewTextFormat(dofus.graphics.battlefield.AbstractTextOverHead.TEXT_SMALL_FORMAT);
      this._txtInfo.setTextFormat();
      this._txtInfo.embedFonts = true;
      this._txtInfo.autoSize = "center";
      this._txtInfo.html = true;
      this._txtInfo.htmlText = !_loc6_.isPublic ? dofus.graphics.battlefield.MountParkOverHead.api.lang.getText("MOUNTPARK_INFOS",[_loc6_.size,_loc6_.maxItems]) : "5 " + dofus.graphics.battlefield.MountParkOverHead.api.lang.getText("MOUNTS");
      this._txtInfo.selectable = false;
      this._txtOwnerName.setNewTextFormat(dofus.graphics.battlefield.AbstractTextOverHead.TEXT_SMALL_FORMAT);
      this._txtOwnerName.setTextFormat();
      this._txtOwnerName.embedFonts = true;
      this._txtOwnerName.autoSize = "center";
      this._txtOwnerName.html = true;
      this._txtOwnerName.selectable = false;
      var _loc8_ = this.createEmptyMovieClip("_mcIcon",this.getNextHighestDepth());
      var _loc9_ = 0;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      while(_loc9_ < eaMountParks.length)
      {
         _loc10_ = eaMountParks[_loc9_];
         if(!_loc10_.isPublic)
         {
            _loc11_ = _loc10_.getPrintFormat();
            this._txtOwnerName.text += _loc11_ + "\n";
            if(!_loc5_ && (_loc10_.guildName != undefined && _loc10_.guildName.length != 0))
            {
               _loc12_ = _root.createTextField("txtMeasurementTextField",_root.getNextHighestDepth(),0,0,0,0);
               _loc12_.setNewTextFormat(dofus.graphics.battlefield.AbstractTextOverHead.TEXT_SMALL_FORMAT);
               _loc12_.setTextFormat();
               _loc12_.embedFonts = true;
               _loc12_.html = true;
               _loc12_.htmlText = _loc11_;
               _loc13_ = _loc12_.textWidth + 30 + dofus.graphics.battlefield.MountParkOverHead.EMBLEM_SIZE;
               _loc4_ = true;
               _loc8_.attachMovie("Emblem","_eEmblem" + _loc9_,_loc8_.getNextHighestDepth(),{_x:_loc13_,_y:this._txtOwnerName._height + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER + 12,_height:dofus.graphics.battlefield.MountParkOverHead.EMBLEM_SIZE,_width:dofus.graphics.battlefield.MountParkOverHead.EMBLEM_SIZE,data:_loc10_.guildEmblem,shadow:true});
               _loc12_.removeTextField();
            }
         }
         _loc9_ = _loc9_ + 1;
      }
      this._txtOwnerName.htmlText = this._txtOwnerName.text;
      var _loc16_ = 0;
      var _loc14_ = Math.ceil(30 + this._txtOwnerName.textHeight + dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER * 2);
      var _loc15_ = Math.ceil(Math.max(Math.max(this._txtName.textWidth,this._txtOwnerName.textWidth),this._txtInfo.textWidth) + dofus.graphics.battlefield.AbstractTextOverHead.WIDTH_SPACER * 4) + 30;
      if(_loc4_)
      {
         _loc15_ += dofus.graphics.battlefield.MountParkOverHead.EMBLEM_SIZE + dofus.graphics.battlefield.AbstractTextOverHead.WIDTH_SPACER;
      }
      this._txtInfo._x = this._txtName._x = this._txtOwnerName._x = (- _loc15_) / 2 + 30 + dofus.graphics.battlefield.AbstractTextOverHead.WIDTH_SPACER * 2;
      var _loc17_;
      if(_loc5_ && (_loc6_.guildName != undefined && (_loc6_.guildName != "" && !_loc6_.isPublic)))
      {
         _loc8_.attachMovie("Emblem","_eEmblem",100,{_y:dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER,_height:30,_width:30,data:_loc6_.guildEmblem,shadow:true});
      }
      else
      {
         _loc17_ = ank.gapi.controls.Loader(this.attachMovie("GAPILoader","_ldrIcon",100,{contentPath:sIconFile,_height:30,_width:30,_x:Math.ceil((- _loc15_) / 2) + dofus.graphics.battlefield.AbstractTextOverHead.WIDTH_SPACER,_y:dofus.graphics.battlefield.AbstractTextOverHead.HEIGHT_SPACER,scaleContent:true}));
      }
      _loc8_._x = Math.ceil((- _loc15_) / 2) + dofus.graphics.battlefield.AbstractTextOverHead.WIDTH_SPACER;
      this.drawBackground(_loc15_,_loc14_,dofus.graphics.battlefield.AbstractTextOverHead.BACKGROUND_COLOR);
   }
}
