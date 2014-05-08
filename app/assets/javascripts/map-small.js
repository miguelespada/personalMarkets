//= require mapbox
//= require app
//= require domain
//= require data

PM.initializeSmallMap = function() {
  var viewLat = DATA.maps.defaultLatitude;
  var viewLng = DATA.maps.defaultLongitude;
  PM.map = L.mapbox.map('map-small').setView([viewLat, viewLng], 14);

  PM.map.scrollWheelZoom.disable();
  PM.mapTiles = L.mapbox.tileLayer('jameshedaweng.hf5b366j');
  PM.map.addLayer(PM.mapTiles);
};

PM.setMarker = function(lat, lng){
  var marketLat = lat;
  var marketLng = lng;
  PM.addMarker([parseFloat(marketLat), parseFloat(marketLng)]);
  PM.map.setView([parseFloat(marketLat), parseFloat(marketLng)], 14);
};

PM._coordinatesSet = function(latitude, longitude) {
  return latitude !== "" && longitude !== "";
};

PM.addMarker = function (latlng){
  PM.marker = L.marker(latlng,{
    icon: L.mapbox.marker.icon(
      {'marker-color': '#48a',
       'marker-symbol' : 'circle',
       'marker-size' : 'medium'}),
    draggable: false
  });
  PM.marker.addTo(PM.map);
};

PM.checkAndSetMarker = function(lat, lng){
  if (PM._coordinatesSet(lat, lng)){
    PM.setMarker(lat, lng);
  }
  else{
    PM.setViewWithUserLocation();
  }
};

$(document).ready(function(){
  if ($('#map-small').is(':visible'))
    PM.initializeSmallMap();
  if ($('.edit_market').is(':visible'))
    PM.checkAndSetMarker($(".market_latitude > .controls > input").val(), 
                         $(".market_longitude > .controls > input").val());
  if ($('.new_market').is(':visible'))
    PM.setViewWithUserLocation();
  if ($('.market-location').is(':visible'))
    PM.setMarker($(".market-latitude").html(), $(".market-longitude").html());
  if ($('.edit_special_location').is(':visible'))
    PM.checkAndSetMarker($(".special_location_latitude > .controls > input").val(), 
                         $(".special_location_longitude > .controls > input").val());
  if ($('.new_special_location').is(':visible'))
    PM.setViewWithUserLocation();
});