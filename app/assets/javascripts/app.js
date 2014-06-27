$(function(){
  $("#prices-slider").slider( { 
    range: true,
    step: 10,
    max: 1000,
    min: 0,
    values: [0, 1000],
    slide: function(event, ui) {
      var prices = $('#prices-slider').slider('option', 'values');
      $('#market_min_price').val(prices[0]);
      $('#market_max_price').val(prices[1]);
    },
    create: function(event, ui) {
      var prices = $('#prices-slider').slider('option', 'values');
      $('#market_min_price').val(prices[0]);
      $('#market_max_price').val(prices[1]);
    }
  });
});

var PM = {};


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


$( document ).ready(function() {

    if (window.location.hash && window.location.hash == '#_=_') {
        if (window.history && history.pushState) {
            window.history.pushState("", document.title, window.location.pathname);
        } else {
            // Prevent scrolling by storing the page's current scroll offset
            var scroll = {
                top: document.body.scrollTop,
                left: document.body.scrollLeft
            };
            window.location.hash = '';
            // Restore the scroll offset, should be flicker free
            document.body.scrollTop = scroll.top;
            document.body.scrollLeft = scroll.left;
        }
    }
});



