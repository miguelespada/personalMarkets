//= require moment

var MAPBOX_DEFAULT_STYLE = "dowemarket.indhgaee";

var DEFAULT_LOCATION = {
  defaultLatitude: 40.416775,
  defaultLongitude: -3.703790
};

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


function reverseGeocode(lat, lon){
  geocoder = new google.maps.Geocoder();
  var latlng = new google.maps.LatLng(lat, lon);
  geocoder.geocode({'latLng': latlng}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      $("#user-city-text").html("<i class='fa fa-crosshairs'></i>&nbsp;&nbsp;" + results[1].formatted_address);
    } 
  });
}

var ajaxSearch = function () {
    $("#spinner-item").removeClass("hidden");
    $.get("live_search", $("#search_market").serialize(), function(data) {
        $("#spinner-item").addClass("hidden");
        $( "#gallery-items" ).html( data );
    });
    return false;
};

var jsonSearch = function () {
    $("#spinner-item").removeClass("hidden");
    $.get("markets/live_search.json", $("#search_market").serialize(), function(data) {
       $("#spinner-item").addClass("hidden");
       PM.fillMapView(data);
    });
    return false;
};



