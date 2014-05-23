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