
var setDataRange =  function() {
    var v = makeDateString($('#range').val());
    $("#from").val(v.from);
    $("#to").val(v.to);
};

var makeDateString = function(range){
  fromDate = moment();

  if (range == 'Today') toDate = moment();
  if (range == 'This week') toDate = moment().weekday(7);
  if (range == 'This month') toDate = moment().add('weeks', 4);
  if (range == 'Next week'){
    fromDate = moment().day(7).weekday(1);
    toDate = moment().day(7).weekday(8);
  }
  if (range == 'All') {
    fromDate = moment();
    toDate = moment().add('weeks', 50);
  }

  var from = moment(fromDate).format("DD/MM/YYYY");
  var to = moment(toDate).format("DD/MM/YYYY");
  
  return {from: from, to: to};
};


var ajaxSearch = function () {
    $.get("live_search", $("#search_market").serialize(), function(data) {
        $( "#gallery-items" ).html( data );
    });
    return false;
};

var jsonSearch = function () {
    $.get("markets/live_search.json", $("#search_market").serialize(), function(data) {
       PM.fillMapView(data);
    });
    return false;
};

function reverseGeocode(lat, lon){

  geocoder = new google.maps.Geocoder();
  var latlng = new google.maps.LatLng(lat, lon);
  geocoder.geocode({'latLng': latlng}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      $("#user-city-text").html("<i class='fa fa-crosshairs'></i>&nbsp;&nbsp;" + results[1].formatted_address);
    } 
  });
}

function pos_success(pos){
  var crd = pos.coords;
  reverseGeocode(crd.latitude, crd.longitude)
  $("#user_lat").val(crd.latitude);
  $("#user_lon").val(crd.longitude);
  $('#location_location_id').append("<option value='My location'><%= t :My_location %></option>");
};

function pos_error(){
  $("#user-city-text").html("<i class='fa fa-exclamation-triangle'></i> <%= t :enable_browser %>");
};

function getCityName(url){
  $.getJSON(url, function(data){
    city = data.results[0].address_components[2].long_name;
  });
};


function user_localization(){
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(pos_success, pos_error);
  }
  else{
    pos_error();
  }
}
