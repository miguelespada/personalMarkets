//= require mapbox

$(document).ready(function(){
  map = L.mapbox.map('map-small').setView([40.416775, -3.703790], 14);
  var mapTiles = L.mapbox.tileLayer('jameshedaweng.hf5b366j');
  map.addLayer(mapTiles);
});