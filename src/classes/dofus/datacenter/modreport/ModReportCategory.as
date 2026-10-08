class dofus.datacenter.modreport.ModReportCategory extends Object
{
   var bAllowIncludeChatConversation;
   var bAllowIncludeCustomText;
   var bForceIncludeChatConversation;
   var bIsFakeCategory;
   var bRequiresOfflineCharacter;
   var bRequiresOnlineCharacter;
   var nCategoryID;
   var sDescription;
   var sFakeCategoryRedirectionText;
   var sName;
   static var NOT_A_CATEGORY_ID = -1;
   function ModReportCategory(nCategoryID, sName, sDescription, bRequiresOnlineCharacter, bRequiresOfflineCharacter, bAllowIncludeChatConversation, bForceIncludeChatConversation, bAllowIncludeCustomText, bIsFakeCategory, sFakeCategoryRedirectionText)
   {
      super();
      this.nCategoryID = nCategoryID;
      this.sName = sName;
      this.sDescription = sDescription;
      this.bRequiresOnlineCharacter = bRequiresOnlineCharacter;
      this.bRequiresOfflineCharacter = bRequiresOfflineCharacter;
      this.bAllowIncludeChatConversation = bAllowIncludeChatConversation;
      this.bForceIncludeChatConversation = bForceIncludeChatConversation;
      this.bAllowIncludeCustomText = bAllowIncludeCustomText;
      this.bIsFakeCategory = bIsFakeCategory;
      this.sFakeCategoryRedirectionText = sFakeCategoryRedirectionText;
   }
   function get categoryID()
   {
      return this.nCategoryID;
   }
   function get name()
   {
      return this.sName;
   }
   function get label()
   {
      return this.sName;
   }
   function get description()
   {
      return this.sDescription;
   }
   function get isRequiringOnlineCharacter()
   {
      return this.bRequiresOnlineCharacter;
   }
   function get isRequiringOfflineCharacter()
   {
      return this.bRequiresOfflineCharacter;
   }
   function get isAllowIncludeChatConversation()
   {
      return this.bAllowIncludeChatConversation;
   }
   function get isForceIncludeChatConversation()
   {
      return this.bForceIncludeChatConversation;
   }
   function get isAllowIncludeCustomText()
   {
      return this.bAllowIncludeCustomText;
   }
   function get isFakeCategory()
   {
      return this.bIsFakeCategory;
   }
   function get fakeCategoryRedirectionText()
   {
      return this.sFakeCategoryRedirectionText;
   }
}
