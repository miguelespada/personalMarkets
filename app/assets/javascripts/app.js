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



