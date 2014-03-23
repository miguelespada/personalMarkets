//= require mapbox

$(document).ready(function(){

// THis is for demo of calendar
  try{
    var timeline = new Timeline("timeline");
  }
  catch(err){}
// 

  
  try{
    var viewLat = 40.416775;
    var viewLng = -3.703790;
    map = L.mapbox.map('map').setView([viewLat, viewLng], 14);

    map.scrollWheelZoom.disable();
    var mapTiles = L.mapbox.tileLayer('jameshedaweng.hf5b366j');
    map.addLayer(mapTiles);
    
    $.get( "/map.json", function( data ) {
      var markers = map.markerLayer.setGeoJSON(data);
      markers.eachLayer(function(layer) {
      var popup = '<div>' + layer.feature.properties.content +'<\/div>';
        layer.bindPopup(popup,{ maxWidth: 200, minWidth: 200 });
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

  }
  catch(err){}
// 

});