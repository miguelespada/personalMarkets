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

PM.checkIfLocationSet = function(){
  var originLat = $("#market_latitude").val();
  var originLng = $("#market_longitude").val();

  if (PM._coordinatesSet(originLat, originLng)){
    PM.addMarker([parseFloat(originLat), parseFloat(originLng)], true);
    PM.map.setView([parseFloat(originLat), parseFloat(originLng)], 14);
  }
  else {
    PM.clickToUpdateMarker();
    PM.setViewWithUserLocation();
  }
};

PM.setMarker = function(){
  var marketLat = $(".market-latitude").html();
  var marketLng = $(".market-longitude").html();
  PM.addMarker([parseFloat(marketLat), parseFloat(marketLng)], false);
  PM.map.setView([parseFloat(marketLat), parseFloat(marketLng)], 14);
}

PM._coordinatesSet = function(latitude, longitude) {
  return latitude !== "" && longitude !== "";
};

PM.addMarker = function (latlng, canbechanged){
  PM.marker = L.marker(latlng,{
    icon: L.mapbox.marker.icon(
      {'marker-color': '#48a',
       'marker-symbol' : 'circle',
       'marker-size' : 'medium'}),
    draggable: canbechanged
  });

  PM.marker.addTo(PM.map);
  if (canbechanged){
    PM.updateLocation();
    PM.dragToUpdateMarker();
    PM.clickToUpdateMarker();
  }
};

PM.clickToUpdateMarker = function(){
  PM.map.on('click', function(event){
    if (PM.marker) {
      PM.map.removeLayer(PM.marker);
    }

    PM.addMarker(event.latlng, true);
  });
};

PM.dragToUpdateMarker = function() {
  PM.marker.on('dragend',function(){
    PM.updateLocation();
  });
};

PM.updateLocation = function(){
  $("#market_latitude").val(PM.marker.getLatLng().lat);
  $("#market_longitude").val(PM.marker.getLatLng().lng);
  PM.getAddress(PM.marker.getLatLng().lng, PM.marker.getLatLng().lat);
};

PM.getAddress = function(lng, lat){
  DOMAIN.getAddressJson(lng, lat, PM.updateAddress);
};

PM.updateAddress = function(data){
  PM.address = "Not Available";

  if (PM._validAddress(data)) {
    PM._setAddress(data);
  }

  $("#market_address").val(PM.address);
};

PM._setAddress = function(data) {
  var street = data.results[0][0].name;
  var city = data.results[0][1].name;
  var province = data.results[0][2].name;
  var country = data.results[0][3].name;
  PM.address = street + ", " + city + ", " + province + ", " + country;
};

PM._validAddress = function(data) {
  return data.results[0].length == 4;
};

$(document).ready(function(){
  if ($('#map-small').is(':visible'))
    PM.initializeSmallMap();
  if ($('#form-market-location').is(':visible'))
    PM.checkIfLocationSet();
  if ($('.market-location').is(':visible'))
    PM.setMarker();
});