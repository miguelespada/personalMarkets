//= require mapbox


var PM = {};

PM.initializeSmallMap = function() {
  var viewLat = DEFAULT_LOCATION.defaultLatitude;
  var viewLng = DEFAULT_LOCATION.defaultLongitude;

  PM.map = L.mapbox.map('map-small').setView([viewLat, viewLng], 14);

  PM.map.scrollWheelZoom.disable();
  PM.mapTiles = L.mapbox.tileLayer(MAPBOX_DEFAULT_STYLE);
  PM.map.addLayer(PM.mapTiles);
};

PM.setMarker = function(lat, lng){
  try{
    var coords = [parseFloat(lat), parseFloat(lng)];
    PM.addMarker(coords);
    PM.map.setView(coords);
  }
  catch (err){
    console.log(err.message);
  };
};

PM._coordinatesSet = function(latitude, longitude) {
  return latitude !== "" && longitude !== "";
};

PM.addMarker = function (latlng){
  PM.marker = L.marker(latlng,{
    icon: L.mapbox.marker.icon(
      {'marker-color': '#aaa',
       'marker-symbol' : 'shop',
       'marker-size' : 'medium'}),
    draggable: false
  }).addTo(PM.map);
};

PM.checkAndSetMarker = function(lat, lng){
  if (PM._coordinatesSet(lat, lng)){
    PM.setMarker(lat, lng);
  }
  else{
    PM.map.setView([DEFAULT_LOCATION.defaultLatitude, DEFAULT_LOCATION.defaultLongitude], 14);
  }
};

$(document).ready(function(){
  if ($('#map-small').is(':visible'))
    PM.initializeSmallMap();
  if ($('.edit_market').is(':visible'))
    PM.checkAndSetMarker($(".market_latitude > .controls > input").val(), 
                         $(".market_longitude > .controls > input").val());
  if ($('.new_market').is(':visible'))
    PM.map.setView([DEFAULT_LOCATION.defaultLatitude, DEFAULT_LOCATION.defaultLongitude], 14);
  if ($('.market-location').is(':visible'))
    PM.setMarker($(".market-latitude").html(), $(".market-longitude").html());
  if ($('.edit_special_location').is(':visible'))
    PM.checkAndSetMarker($(".special_location_latitude > .controls > input").val(), 
                         $(".special_location_longitude > .controls > input").val());
  if ($('.new_special_location').is(':visible'))
    PM.map.setView([DEFAULT_LOCATION.defaultLatitude, DEFAULT_LOCATION.defaultLongitude], 14);
});