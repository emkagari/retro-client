i = 0;
while(i < 100)
{
   this.attachMovie("dot","dot" + i,i);
   this["dot" + i]._x = 100 - i;
   i++;
}
this.attachMovie("avg","avg",i);
this.attachMovie("avg_50","avg50",i + 1);
this.avg50._x = 100;
stop();
