this.onPress = function()
{
   _parent.startDrag();
};
this.onRelease = function()
{
   _parent.stopDrag();
};
this.onReleaseOutside = this.onRelease;
