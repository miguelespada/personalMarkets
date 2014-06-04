var DOMAIN = {};

DOMAIN.getAddressJson = function(lng, lat, callback) {
  $.ajax({
    url: "http://api.tiles.mapbox.com/v3/jameshedaweng.hf5b366j/geocode/" + lng + "," + lat + ".json",
    dataType: "json",
    success: callback
  });
};
