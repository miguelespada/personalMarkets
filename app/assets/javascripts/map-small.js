//= require mapbox

$(document).ready(function(){
  if ($("#map-small").length > 0){
    map = L.mapbox.map('map-small').setView([40.416775, -3.703790], 14);
    var mapTiles = L.mapbox.tileLayer('jameshedaweng.hf5b366j');
    map.addLayer(mapTiles);
    
    var locationExist, address;
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
      updateLocation([originLat, originLng]);
      locationExist = 1;  
    }
  
    map.on('click', function(e){    
      if (locationExist == 0){
        updateLocation(e.latlng);
        locationExist = 1;
      }
      else if (locationExist == 1){
        map.removeLayer(marker);
        updateLocation(e.latlng);
      }
    });
  }
});

function getAddress(lng, lat){
  var locationJson = 'http://api.tiles.mapbox.com/v3/jameshedaweng.hf5b366j/geocode/'+lng+','+lat+'.json'
  $.get(locationJson, function( data ) {
    if (data.results[0].length == 4) {
      street = data.results[0][0];
      city = data.results[0][1];
      province = data.results[0][2];
      country = data.results[0][3];
      address = street.name + ", " + city.name + ", " + province.name + ", " + country.name;
      $("#market_address").val(address);
    }
    else {
      $("#market_address").val("Not available");
    }
  });
}

function updateLocation (latlng){
  marker = L.marker(latlng, 
           {icon: L.mapbox.marker.icon(
              {'marker-color': '#48a',
               'marker-symbol' : 'circle',
               'marker-size' : 'medium'}),
           draggable: true
  });
  marker.addTo(map);
  $("#market_latitude").val(marker.getLatLng().lat);
  $("#market_longitude").val(marker.getLatLng().lng);
  getAddress(marker.getLatLng().lng, marker.getLatLng().lat);
  marker.on('dragend',function(e){
    $("#market_latitude").val(marker.getLatLng().lat);
    $("#market_longitude").val(marker.getLatLng().lng);
    getAddress(marker.getLatLng().lng, marker.getLatLng().lat);
  });
}
