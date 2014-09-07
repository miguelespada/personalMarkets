var initializeAutocomplete = function(input_id) {
  autocomplete = new google.maps.places.Autocomplete(
    (document.getElementById(input_id)),
    {
      types: ['(cities)']
    });
   google.maps.event.addListener(autocomplete, 'place_changed', function() {
    updateLocationData();
  });
};

var updateLocationData = function(){
  if(addressAndCityAreFilled()) geocode();
};

var addressAndCityAreFilled = function(){
  return $('#special_location_address').val() && $('#special_location_city').val();
};


function geocode(){
  geocoder = new google.maps.Geocoder();
  var address =  $('#special_location_address').val() + ", " + $('#special_location_city').val();
  geocoder.geocode({ 'address': address}, 
    function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      setLocation(results[0].geometry.location.lat(), 
                  results[0].geometry.location.lng());
    }
    else{
        $("#special_location_latitude").val("error");
        $("#special_location_longitude").val("error");
      }
    });
};

function setLocation(lat, lng){
  $("#special_location_latitude").val(lat);
  $("#special_location_longitude").val(lng);
  if (PM.marker)  PM.map.removeLayer(PM.marker);
  PM.addMarker([lat, lng], false);
  PM.map.setView([lat, lng], 16);
};
