//= require mapbox

$(document).ready(function(){
	map = L.mapbox.map('map', 'jameshedaweng.hf5b366j').setView([40.416775, -3.703790], 14);
	
	$.get( "/maps.json", function( data ) {
    var markers = map.markerLayer.setGeoJSON(data);
 		map.addLayer(markers);
  });
});