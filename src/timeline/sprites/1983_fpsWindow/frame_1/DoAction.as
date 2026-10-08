function turnOn()
{
   this.state = !this.state;
   check_on._visible = true;
   check_off._visible = false;
}
function turnOff()
{
   this.state = !this.state;
   check_off._visible = true;
   check_on._visible = false;
}
this.state = true;
this.ar_fps = new Array();
this.lasttime = 0;
this.avg = 0;
this.avg50 = 0;
this.refreshtime = 0;
this.delayrefresh = 10;
this.check_off._visible = false;
this.run = 0;
this.set_fps = function(l_text)
{
   this.ar_fps.unshift(l_text);
   if(this.ar_fps.length > 100)
   {
      this.ar_fps.pop();
   }
};
this.onEnterFrame = function()
{
   this.refreshtime = this.refreshtime + 1;
   tmp = getTimer();
   var _loc2_ = 1000 / (tmp - this.lasttime) | cfps;
   if(_loc2_ > txt_max)
   {
      txt_max = int(_loc2_);
   }
   if(this.refreshtime > this.delayrefresh)
   {
      this.txt_fps.text = _loc2_;
      this.refreshtime = 0;
   }
   this.set_fps(_loc2_);
   this.lasttime = tmp;
   this.avg = (this.avg * this.run + _loc2_) / (this.run + 1);
   if(this.run > 50)
   {
      this.avg50 = (this.avg50 * 50 + _loc2_ - this.ar_fps[49]) / 50;
   }
   else
   {
      this.avg50 = this.avg;
   }
   if(this.state == true)
   {
      i = 0;
      while(i < 100)
      {
         this.wnd_his["dot" + i]._y = (- this.ar_fps[i]) * (75 / txt_max);
         i++;
      }
      this.wnd_his.avg._y = (- this.avg) * (75 / txt_max);
      this.wnd_his.avg.txt = this.avg;
      this.wnd_his.avg50._y = (- this.avg50) * (75 / txt_max);
      this.wnd_his.avg50.txt = this.avg50;
   }
   this.run = this.run + 1;
};
stop();
