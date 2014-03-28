var DOMAIN = {};

DOMAIN.getLocations = function(callback) {
  $.ajax({
    url: "/map.json",
    dataType: "json",
    success: callback
  });
};

DOMAIN.getAddressJson = function(lng, lat, callback) {
  $.ajax({
    url: "http://api.tiles.mapbox.com/v3/jameshedaweng.hf5b366j/geocode/" + lng + "," + lat + ".json",
    dataType: "json",
    success: callback
  });
};

DOMAIN.updateComment = function(market_id, comment_id, body, callback){
  $.ajax({
    url: "/markets/" + market_id + "/comments/" + comment_id,
    method: "PUT",
    dataType: "json",
    data: {body: body},
    success: callback,
    error: function(){
      alert("error");
    }
  });
};