$( document ).ready(function() {
    console.log( "ready!" );
    $.get( "http://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&sensor=false"
    , function( data ) {
 	 console.log(data)});

});
