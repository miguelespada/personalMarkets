//= require mapbox

var PM = {};

var DOMAIN = {};

DOMAIN.getLocations = function(callback) {
  $.ajax({
    url: "/map.json",
    dataType: "json",
    success: callback
  });
};

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
    layer.bindPopup(popup,{ maxWidth: 200, minWidth: 200 });
};


PM.initializeMap = function() {
  var viewLat = 40.416775;
  var viewLng = -3.703790;
  PM.map = L.mapbox.map('map').setView([viewLat, viewLng], 14);

  PM.map.scrollWheelZoom.disable();
  PM.mapTiles = L.mapbox.tileLayer('jameshedaweng.hf5b366j');
  PM.map.addLayer(PM.mapTiles);
  PM.addMarkersToMap();
};



$(document).ready(function(){

// THis is for demo of calendar
  try{
    var timeline = new Timeline("timeline");
  }
  catch(err){}
//


  try{

    PM.initializeMap();

    $('#theme-default').on('click', function () {
      PM.changeTile('jameshedaweng.hf5b366j');
    });

    $('#theme-antique').on('click', function () {
      PM.changeTile('jameshedaweng.hig6oabo');
    });

    $('#theme-strawberry').on('click', function () {
      PM.changeTile('jameshedaweng.hig74k34');
    });

    $('#theme-night').on('click', function () {
      PM.changeTile('jameshedaweng.hig785hn');
    });

    $('#theme-sky').on('click', function () {
      PM.changeTile('jameshedaweng.hig7ak0h');
    });

    $('#theme-light').on('click', function () {
      PM.changeTile('jameshedaweng.hig7dplk');
    });

  }
  catch(err){}
//

});
