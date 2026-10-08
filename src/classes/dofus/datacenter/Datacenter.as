class dofus.datacenter.Datacenter extends Object
{
   var Basics;
   var Challenges;
   var Conquest;
   var DailyQuests;
   var Exchange;
   var Game;
   var GameServer;
   var Gladiatrool;
   var Houses;
   var Map;
   var NameCustomization;
   var Player;
   var Season;
   var ServerEvenemential;
   var Spell;
   var Sprites;
   var Storages;
   var Subareas;
   var Survey;
   var Temporary;
   var Temporis;
   var _oAPI;
   function Datacenter(oAPI)
   {
      super();
      this.initialize(oAPI);
   }
   function initialize(oAPI)
   {
      this._oAPI = oAPI;
      this.Player = new dofus.datacenter.LocalPlayer(oAPI);
      this.Basics = new dofus.datacenter.Basics();
      this.Challenges = new ank.utils.ExtendedObject();
      this.Sprites = new ank.utils.ExtendedObject();
      this.Houses = new ank.utils.ExtendedObject();
      this.Storages = new ank.utils.ExtendedObject();
      this.Game = new dofus.datacenter.Game();
      this.Conquest = new dofus.datacenter.Conquest();
      this.Subareas = new ank.utils.ExtendedObject();
      this.Map = new dofus.datacenter.DofusMap();
      this.Temporary = {};
      this.Survey = new dofus.datacenter.SurveyManager();
      this.Temporis = new dofus.datacenter.evenemential.TemporisData();
      this.Gladiatrool = new dofus.datacenter.GladiatroolManager();
      this.Spell = new dofus.managers.SpellDatas();
      this.DailyQuests = new dofus.managers.DailyQuestsManager();
      this.NameCustomization = new dofus.managers.NameCustomizationManager();
      this.Season = new dofus.managers.SeasonManager();
      this.GameServer = new dofus.datacenter.GameServerManager();
      this.ServerEvenemential = new dofus.managers.ServerEvenementialManager();
   }
   function clear()
   {
      this.Player = new dofus.datacenter.LocalPlayer(this._oAPI);
      this.Basics.initialize();
      this.Challenges = new ank.utils.ExtendedObject();
      this.Sprites = new ank.utils.ExtendedObject();
      this.Houses = new ank.utils.ExtendedObject();
      this.Storages = new ank.utils.ExtendedObject();
      this.Game = new dofus.datacenter.Game();
      this.Conquest = new dofus.datacenter.Conquest();
      this.Subareas = new ank.utils.ExtendedObject();
      this.Map = new dofus.datacenter.DofusMap();
      this.Temporary = {};
      this.Survey = new dofus.datacenter.SurveyManager();
      this.Temporis = new dofus.datacenter.evenemential.TemporisData();
      this.Gladiatrool = new dofus.datacenter.GladiatroolManager();
      this.Spell = new dofus.managers.SpellDatas();
      this.DailyQuests = new dofus.managers.DailyQuestsManager();
      this.NameCustomization = new dofus.managers.NameCustomizationManager();
      this.Season = new dofus.managers.SeasonManager();
      this.GameServer = new dofus.datacenter.GameServerManager();
      this.ServerEvenemential = new dofus.managers.ServerEvenementialManager();
      delete this.Exchange;
   }
   function clearGame()
   {
      this.Game = new dofus.datacenter.Game();
   }
}
