var PM = {};

PM.setViewWithUserLocation = function(){
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(PM.getCurrentPosition);
  }
};

PM.getCurrentPosition = function(position){
  PM.newLatitude = parseFloat(position.coords.latitude);
  PM.newLongitude = parseFloat(position.coords.longitude);
  PM.map.setView([PM.newLatitude, PM.newLongitude], 14);
};