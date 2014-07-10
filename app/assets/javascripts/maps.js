//= require mapbox

var PM = {};
PM.changeTile = function(mapID) {
  PM.map.removeLayer(PM.mapTiles);
  PM.mapTiles = L.mapbox.tileLayer(mapID);
  PM.map.addLayer(PM.mapTiles);
};


PM.fillMapView = function(data) {
  var markers = PM.map.markerLayer.setGeoJSON(data);
  markers.eachLayer(PM.addTooltipToMarker);
  PM.map.addLayer(markers);
};

PM.setViewWithUserLocation = function(latitude, longitude, dist){
  PM.newLatitude = parseFloat(latitude);
  PM.newLongitude = parseFloat(longitude);
  PM.map.setView([PM.newLatitude, PM.newLongitude], dist);
};

PM.addTooltipToMarker = function(layer) {
  var popup = '<div>' + layer.feature.properties.content +'<\/div>';
    layer.bindPopup(popup,{ closeButton: false, maxWidth: 400, minWidth: 120 });
    layer.on('mouseover', function() {
      layer.openPopup();
    });
    layer.on('mouseout', function() {
      layer.closePopup();
    });
    layer.on('click', function() {
      window.open(layer.feature.properties.url,"_self");
    });
};

PM.initializeMap = function(tile, viewLat, viewLng, dist) {
  PM.map = L.mapbox.map('map').setView([viewLat, viewLng], dist);

  // PM.map.scrollWheelZoom.disable();
  PM.mapTiles = L.mapbox.tileLayer(tile);
  PM.map.addLayer(PM.mapTiles);
  PM.map.on('dragend', function(){
     $("#lat").val(PM.map.getCenter().lat);
     $("#lon").val(PM.map.getCenter().lng);
     $("#location_location_id option[value='My location']").remove();
     $("#location_location_id option[value='Custom location']").remove();
     $('#location_location_id').append("<option value='Custom location'>Custom location</option>").val('Custom location');
     $("#search_market").change();
  });
};
