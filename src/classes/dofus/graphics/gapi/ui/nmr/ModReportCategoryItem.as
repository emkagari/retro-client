class dofus.graphics.gapi.ui.nmr.ModReportCategoryItem extends ank.gapi.core.UIBasicComponent
{
   var _lblName;
   var _lblTotalReportsCount;
   var _lblTotalScore;
   var _mcList;
   var _oItem;
   function ModReportCategoryItem()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      if(bUsed)
      {
         this._oItem = oItem;
         this._lblName.text = oItem.categoryName;
         this._lblTotalReportsCount.text = String(oItem.totalReportsCount);
         this._lblTotalScore.text = String(oItem.totalScore);
      }
      else if(this._lblName.text != undefined)
      {
         this._lblName.text = "";
         this._lblTotalReportsCount.text = "";
         this._lblTotalScore.text = "";
      }
   }
   function init()
   {
      super.init(false);
   }
}
