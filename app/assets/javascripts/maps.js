//= require mapbox

$(document).ready(function(){
	map = L.mapbox.map('map', 'jameshedaweng.hf5b366j').setView([40.416775, -3.703790], 14);
	
	$.get( "/maps.json", function( data ) {
    var markers = map.markerLayer.setGeoJSON(data);
    markers.eachLayer(function(layer) {
    var content = '<div>' + layer.feature.properties.name + '<br>' +layer.feature.properties.description +'<\/div>';
    	layer.bindPopup(content);
		});
 		map.addLayer(markers);	
  });
});