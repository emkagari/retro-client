class dofus.graphics.gapi.ui.MapInfos extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _lblArea;
   var _lblAreaShadow;
   var _lblCoordinates;
   var _lblCoordinatesShadow;
   var _visible;
   var addToQueue;
   static var CLASS_NAME = "MapInfos";
   function MapInfos()
   {
      super();
   }
   function update()
   {
      this.initText();
      this._visible = true;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.MapInfos.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initText});
   }
   function initText()
   {
      var _loc2_ = this.api.datacenter.Map;
      var _loc3_;
      var _loc4_;
      if(_loc2_.name == undefined)
      {
         this._lblArea.text = "";
         this._lblCoordinates.text = "";
         this._lblAreaShadow.text = "";
         this._lblCoordinatesShadow.text = "";
      }
      else
      {
         _loc3_ = dofus.datacenter.Subarea(this.api.datacenter.Subareas.getItemAt(_loc2_.subarea));
         _loc4_ = _loc2_.name + (_loc3_ != undefined ? (_loc3_.alignment.name != undefined ? " - " + _loc3_.alignment.name : "") : "");
         this._lblArea.text = _loc4_;
         this._lblCoordinates.text = _loc2_.coordinates;
         this._lblAreaShadow.text = _loc4_;
         this._lblCoordinatesShadow.text = _loc2_.coordinates;
      }
   }
}
