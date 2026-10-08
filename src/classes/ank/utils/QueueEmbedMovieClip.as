211978016 - 1;
class ank.utils.QueueEmbedMovieClip extends MovieClip
{
   static var _aQueue = [];
   static var _mcEnterFrame = _root.createEmptyMovieClip("queueEnterFrame_mc",_root.getNextHighestDepth());
   function QueueEmbedMovieClip()
   {
      super();
   }
   function addToQueue(oCall)
   {
      ank.utils.QueueEmbedMovieClip._aQueue.push(oCall);
      if(ank.utils.QueueEmbedMovieClip._mcEnterFrame.onEnterFrame == undefined)
      {
         ank.utils.QueueEmbedMovieClip._mcEnterFrame.onEnterFrame = this.runQueue;
      }
   }
   function runQueue()
   {
      var _loc2_;
      for(var k in ank.utils.QueueEmbedMovieClip._aQueue)
      {
         _loc2_ = ank.utils.QueueEmbedMovieClip._aQueue.shift();
         _loc2_.method.apply(_loc2_.object,_loc2_.params);
         if(ank.utils.QueueEmbedMovieClip._aQueue.length == 0)
         {
            delete ank.utils.QueueEmbedMovieClip._mcEnterFrame.onEnterFrame;
         }
      }
   }
}
