//= require mapbox

$(document).ready(function(){
  map = L.mapbox.map('map-small').setView([40.416775, -3.703790], 14);
  var mapTiles = L.mapbox.tileLayer('jameshedaweng.hf5b366j');
  map.addLayer(mapTiles);
	
	var locationExist;
	var originLatS = $("#market_latitude").val();
	var originLngS = $("#market_longitude").val();
	var originLat = parseFloat($("#market_latitude").val());
	var originLng = parseFloat($("#market_longitude").val());
	
	if (originLatS != "" && originLatS != "") {
		locationExist = -1;
	}
	else {
		locationExist = 0;
	}

	if (locationExist == -1){
		marker = L.marker([originLat, originLng], 
			       {icon: L.mapbox.marker.icon(
			      	  {'marker-color': '#00607d',
			      	   'marker-symbol' : 'circle',
			      	   'marker-size' : 'medium'}),
             draggable: true
    });
    marker.addTo(map);
		locationExist = 1;
		marker.on('dragend',function(e){
			$("#market_latitude").val(marker.getLatLng().lat);
			$("#market_longitude").val(marker.getLatLng().lng);
		console.log(marker.getLatLng().lat, marker.getLatLng().lng);
    });
  }

  map.on('click', function(e){
  	
		if (locationExist == 0){
			marker = L.marker(e.latlng, 
			      {icon: L.mapbox.marker.icon(
			      	{'marker-color': '#00607d',
			      	 'marker-symbol' : 'circle',
			      	 'marker-size' : 'medium'}),
            draggable: true
      });
      marker.addTo(map);
      $("#market_latitude").val(marker.getLatLng().lat);
			$("#market_longitude").val(marker.getLatLng().lng);
			locationExist = 1;
			marker.on('dragend',function(e){
				$("#market_latitude").val(marker.getLatLng().lat);
				$("#market_longitude").val(marker.getLatLng().lng);
      });
  	}
  	else if (locationExist == 1){
  		map.removeLayer(marker);
  		marker = L.marker(e.latlng, 
			      {icon: L.mapbox.marker.icon(
			      	{'marker-color': '#00607d',
			      	 'marker-symbol' : 'circle',
			      	 'marker-size' : 'medium'}),
            draggable: true
      });
      marker.addTo(map);
      $("#market_latitude").val(marker.getLatLng().lat);
			$("#market_longitude").val(marker.getLatLng().lng);
  		marker.on('dragend',function(e){
				$("#market_latitude").val(marker.getLatLng().lat);
				$("#market_longitude").val(marker.getLatLng().lng);
      });
  	}
	});
});