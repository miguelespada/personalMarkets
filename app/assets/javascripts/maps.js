//= require mapbox
//= require app
//= require domain
//= require data

PM.changeTile = function(mapID) {
  PM.map.removeLayer(PM.mapTiles);
  PM.mapTiles = L.mapbox.tileLayer(mapID);
  PM.map.addLayer(PM.mapTiles);
};

PM.addMarkersToMap = function() {
  DOMAIN.getLocations(PM.fillMapView);
};

PM.fillMapView = function(data) {
  var markers = PM.map.markerLayer.setGeoJSON(data);
  markers.eachLayer(PM.addTooltipToMarker);
  PM.map.addLayer(markers);
};

PM.addTooltipToMarker = function(layer) {
  var popup = '<div>' + layer.feature.properties.content +'<\/div>';
    layer.bindPopup(popup,{ closeButton: false, maxWidth: 400, minWidth: 120 });
    layer.on('mouseover', function() {
      layer.openPopup();
      console.log(layer);
    });
    layer.on('mouseout', function() {
      layer.closePopup();
    });
    layer.on('click', function() {
      layer.closePopup();
    });
};

PM.initializeMap = function() {
  var viewLat = DATA.maps.defaultLatitude;
  var viewLng = DATA.maps.defaultLongitude;
  PM.map = L.mapbox.map('map').setView([viewLat, viewLng], 14);

  PM.map.scrollWheelZoom.disable();
  PM.mapTiles = L.mapbox.tileLayer('jameshedaweng.hf5b366j');
  PM.map.addLayer(PM.mapTiles);
  PM.addMarkersToMap();
};
