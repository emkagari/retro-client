class ank.utils.ExtendedString extends String
{
   var _s;
   static var DEFAULT_SPACECHARS = " \n\r\t";
   function ExtendedString(o)
   {
      super();
      this._s = String(o);
   }
   function xmlUnescape()
   {
      return this.replace(["&lt;","&gt;","&quot;","&amp;","&apos;"],["<",">","\"","&","\'"]);
   }
   function externalInterfaceEscape()
   {
      return this.replace(["&amp;","&lt;","&gt;","","\\"],["&ASamp;","&ASlt;","&ASgt;","|","\\\\"]);
   }
   function replace(pFrom, pTo)
   {
      if(arguments.length == 0)
      {
         return this._s;
      }
      if(arguments.length == 1)
      {
         if(!(pFrom instanceof Array))
         {
            return this._s.split(pFrom).join("");
         }
         pTo = [pFrom.length];
      }
      if(!(pFrom instanceof Array))
      {
         return this._s.split(pFrom).join(pTo);
      }
      var _loc4_ = pFrom.length;
      var _loc5_ = this._s;
      var _loc6_;
      var _loc7_;
      if(pTo instanceof Array)
      {
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = _loc5_.split(pFrom[_loc6_]).join(pTo[_loc6_]);
            _loc6_ = _loc6_ + 1;
         }
      }
      else
      {
         _loc7_ = 0;
         while(_loc7_ < _loc4_)
         {
            _loc5_ = _loc5_.split(pFrom[_loc7_]).join(pTo);
            _loc7_ = _loc7_ + 1;
         }
      }
      return _loc5_;
   }
   function addLeftChar(sChar, nMaxSize)
   {
      var _loc4_ = nMaxSize - this._s.length;
      var _loc5_ = new String();
      var _loc6_ = 0;
      while(_loc6_ < _loc4_)
      {
         _loc5_ += sChar;
         _loc6_ = _loc6_ + 1;
      }
      _loc5_ += this._s;
      return _loc5_;
   }
   function addMiddleChar(nChar, nCount)
   {
      if(_global.isNaN(nCount))
      {
         nCount = Number(nCount);
      }
      nCount = Math.abs(nCount);
      var _loc5_ = [];
      var _loc4_ = this._s.length;
      while(_loc4_ > 0)
      {
         if(Math.max(0,_loc4_ - nCount) == 0)
         {
            _loc5_.push(this._s.substr(0,_loc4_));
         }
         else
         {
            _loc5_.push(this._s.substr(_loc4_ - nCount,nCount));
         }
         _loc4_ -= nCount;
      }
      _loc5_.reverse();
      return _loc5_.join(nChar);
   }
   function rTrim($space)
   {
      this._clearOutOfRange();
      this._rTrim(this.spaceStringToObject($space));
      return this;
   }
   function lTrim($space)
   {
      this._clearOutOfRange();
      this._lTrim(this.spaceStringToObject($space));
      return this;
   }
   function trim($space)
   {
      var _loc3_ = this.spaceStringToObject($space);
      this._clearOutOfRange();
      this._lTrim(_loc3_);
      this._rTrim(_loc3_);
      return this;
   }
   function toString()
   {
      return this._s;
   }
   function removeAccents()
   {
      var _loc2_ = "àáâãäÀÁÂÃÄèéêëËÉÊÈìíîïÌÍÎÏòóôõöÒÓÔÕÖùúûüÙÚÛÜýýÿÝÝŸçÇñÑ";
      var _loc3_ = "aaaaaAAAAAeeeeEEEEiiiiIIIIoooooOOOOOuuuuUUUUyyyYYYcCnN";
      var _loc4_ = "";
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      while(_loc5_ < this._s.length)
      {
         _loc6_ = this._s.charAt(_loc5_);
         _loc7_ = _loc2_.indexOf(_loc6_);
         _loc4_ += _loc7_ == -1 ? _loc6_ : _loc3_.charAt(_loc7_);
         _loc5_ = _loc5_ + 1;
      }
      return _loc4_;
   }
   static function compare(str1, str2)
   {
      if(str1.toLowerCase() < str2.toLowerCase())
      {
         return -1;
      }
      if(str1.toLowerCase() > str2.toLowerCase())
      {
         return 1;
      }
      return 0;
   }
   static function searchWordsInName(aWords, sName_)
   {
      var _loc4_ = aWords.length - 1;
      var _loc5_;
      var _loc6_;
      while(_loc4_ >= 0)
      {
         _loc5_ = aWords[_loc4_];
         _loc6_ = sName_.indexOf(_loc5_);
         if(_loc6_ == -1)
         {
            return false;
         }
         sName_ = sName_.substr(0,_loc6_) + sName_.substr(_loc6_ + _loc5_.length);
         _loc4_ -= 1;
      }
      return true;
   }
   function spaceStringToObject($space)
   {
      var _loc3_ = {};
      if($space == undefined)
      {
         $space = ank.utils.ExtendedString.DEFAULT_SPACECHARS;
      }
      var _loc4_;
      if(typeof $space == "string")
      {
         _loc4_ = $space.length;
         while((_loc4_ = _loc4_ - 1) >= 0)
         {
            _loc3_[$space.charAt(_loc4_)] = true;
         }
      }
      else
      {
         _loc3_ = $space;
      }
      return _loc3_;
   }
   function _rTrim($space)
   {
      var _loc3_ = this._s.length;
      var _loc4_ = 0;
      while(_loc3_ > 0)
      {
         if(!$space[this._s.charAt(_loc4_)])
         {
            break;
         }
         _loc4_ = _loc4_ + 1;
         _loc3_ = _loc3_ - 1;
      }
      this._s = this._s.slice(_loc4_);
   }
   function _lTrim($space)
   {
      var _loc3_ = this._s.length;
      var _loc4_ = _loc3_ - 1;
      while(_loc3_ > 0)
      {
         if(!$space[this._s.charAt(_loc4_)])
         {
            break;
         }
         _loc4_ = _loc4_ - 1;
         _loc3_ = _loc3_ - 1;
      }
      this._s = this._s.slice(0,_loc4_ + 1);
   }
   function _clearOutOfRange()
   {
      var _loc2_ = "";
      var _loc3_ = 0;
      while(_loc3_ < this._s.length)
      {
         if(this._s.charCodeAt(_loc3_) >= 32 && this._s.charCodeAt(_loc3_) <= 255)
         {
            _loc2_ += this._s.charAt(_loc3_);
         }
         _loc3_ = _loc3_ + 1;
      }
      this._s = _loc2_;
   }
}
