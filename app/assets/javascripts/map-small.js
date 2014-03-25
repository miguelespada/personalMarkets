//= require mapbox

var PM = {};

var DOMAIN = {};

DOMAIN.getAddressJson = function(lng, lat, callback) {
  $.ajax({
    url: "http://api.tiles.mapbox.com/v3/jameshedaweng.hf5b366j/geocode/"+lng+","+lat+".json",
    dataType: "json",
    success: callback
  });
};

PM.initializeMap = function(){
  var viewLat = 40.416775;
  var viewLng = -3.703790;
  PM.map = L.mapbox.map('map-small').setView([viewLat, viewLng], 14);
    
  PM.map.scrollWheelZoom.disable();
  PM.mapTiles = L.mapbox.tileLayer('jameshedaweng.hf5b366j');
  PM.map.addLayer(PM.mapTiles);
  
  PM.checkIfLocationExist();
}

PM.checkIfLocationExist = function(){
  var originLat = $("#market_latitude").val();
  var originLng = $("#market_longitude").val();

  if (originLat != "" && originLat != "")
    PM.addMarker([parseFloat(originLat), parseFloat(originLng)]); 
  else
    PM.clickToUpdateMarker();
}

PM.addMarker = function (latlng){
  PM.marker = L.marker(latlng,{
    icon: L.mapbox.marker.icon(
      {'marker-color': '#48a',
       'marker-symbol' : 'circle',
       'marker-size' : 'medium'}),
    draggable: true
  });
  PM.marker.addTo(PM.map);
  PM.updateLocation();  
  PM.dragToUpdateMarker(); 
  PM.clickToUpdateMarker(); 
}

PM.clickToUpdateMarker = function(){
  PM.map.on('click', function(e){ 
    if (PM.marker != null)
      PM.map.removeLayer(PM.marker);
    PM.addMarker(e.latlng);
  });
}

PM.dragToUpdateMarker = function() {
  PM.marker.on('dragend',function(){
    PM.updateLocation();
  });
}

PM.updateLocation = function(){
  $("#market_latitude").val(PM.marker.getLatLng().lat);
  $("#market_longitude").val(PM.marker.getLatLng().lng);
  PM.getAddress(PM.marker.getLatLng().lng, PM.marker.getLatLng().lat);
}

PM.getAddress = function(lng, lat){
  DOMAIN.getAddressJson(lng, lat, PM.updateAddress);
}

PM.updateAddress = function(data){
  if (data.results[0].length == 4)
    PM.address = data.results[0][0].name + ", " + 
                 data.results[0][1].name + ", " + 
                 data.results[0][2].name + ", " + 
                 data.results[0][3].name;
  else
    PM.address = "Not Available";
  $("#market_address").val(PM.address);
}

$(document).ready(function(){

  try{

    PM.initializeMap();      

  }

  catch(err){}
  
});

