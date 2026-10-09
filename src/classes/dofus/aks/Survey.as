class dofus.aks.Survey extends dofus.aks.Handler
{
   var aks;
   var api;
   function Survey(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function getSurvey()
   {
      this.aks.send("zi");
   }
   function saveSurvey(sData)
   {
      this.aks.send("zs" + sData);
   }
   function onSurveyInfo(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = _loc3_.shift().split(";");
      var _loc5_ = Number(_loc4_[0]);
      var _loc6_ = _loc4_[1];
      var _loc7_ = _loc4_[2];
      var _loc8_ = [(Number(_loc4_[3]) < 10 ? "0" : "") + _loc4_[3],(Number(_loc4_[4]) < 10 ? "0" : "") + _loc4_[4],_loc4_[5],(Number(_loc4_[6]) < 10 ? "0" : "") + _loc4_[6],(Number(_loc4_[7]) < 10 ? "0" : "") + _loc4_[7]];
      var _loc9_ = this.api.lang.getText("DATE_SURVEY",_loc8_);
      var _loc10_ = new ank.utils.ExtendedArray();
      var _loc11_ = 0;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      while(_loc11_ < _loc3_.length)
      {
         _loc12_ = _loc3_[_loc11_].split(";");
         _loc13_ = {};
         _loc13_.id = Number(_loc12_[0]);
         _loc13_.type = Number(_loc12_[1]);
         _loc13_.text = _loc12_[2];
         _loc14_ = [];
         _loc14_.push(this.api.lang.getText("CHOOSE_ANSWER"));
         _loc13_.answers = _loc14_.concat(_loc12_[3].split(","));
         _loc13_.answerSelected = Number(_loc12_[4]);
         _loc10_.push(_loc13_);
         _loc11_ = _loc11_ + 1;
      }
      var _loc15_ = this.api.datacenter.Survey;
      _loc15_.id = _loc5_;
      _loc15_.title = _loc6_;
      _loc15_.desc = _loc7_;
      _loc15_.date = _loc9_;
      _loc15_.questions = _loc10_;
      this.api.ui.loadUIComponent("Survey","Survey",undefined,{bAlwaysOnTop:true});
   }
   function onSurveyNotify(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      if(_loc3_ == 1)
      {
         this.api.ui.loadUIComponent("SurveyNotification","SurveyNotification",undefined,{bAlwaysOnTop:false});
      }
      else
      {
         this.api.ui.unloadUIComponent("SurveyNotification");
      }
   }
}
