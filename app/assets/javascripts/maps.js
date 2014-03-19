//= require mapbox

$(document).ready(function(){
  map = L.mapbox.map('map').setView([40.416775, -3.703790], 14);
  var mapTiles = L.mapbox.tileLayer('jameshedaweng.hf5b366j');
  map.addLayer(mapTiles);
  
  $.get( "/maps.json", function( data ) {
    var markers = map.markerLayer.setGeoJSON(data);
    markers.eachLayer(function(layer) {
    var popup = '<div>' + layer.feature.properties.content +'<\/div>';
      layer.bindPopup(popup);
    });
    map.addLayer(markers);
  });

  $('#theme-default').on('click', function () {
    map.removeLayer(mapTiles);
    mapTiles = L.mapbox.tileLayer('jameshedaweng.hf5b366j');
    map.addLayer(mapTiles);
  });
  $('#theme-antique').on('click', function () {
    map.removeLayer(mapTiles);
    mapTiles = L.mapbox.tileLayer('jameshedaweng.hig6oabo');
    map.addLayer(mapTiles);
  });
  $('#theme-strawberry').on('click', function () {
    map.removeLayer(mapTiles);
    mapTiles = L.mapbox.tileLayer('jameshedaweng.hig74k34');
    map.addLayer(mapTiles);
  });
  $('#theme-night').on('click', function () {
    map.removeLayer(mapTiles);
    mapTiles = L.mapbox.tileLayer('jameshedaweng.hig785hn');
    map.addLayer(mapTiles);
  });
  $('#theme-sky').on('click', function () {
    map.removeLayer(mapTiles);
    mapTiles = L.mapbox.tileLayer('jameshedaweng.hig7ak0h');
    map.addLayer(mapTiles);
  });
  $('#theme-light').on('click', function () {
    map.removeLayer(mapTiles);
    mapTiles = L.mapbox.tileLayer('jameshedaweng.hig7dplk');
    map.addLayer(mapTiles);
  });

});