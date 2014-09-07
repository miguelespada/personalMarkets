
  var downcase_tags = function(){
    var tags = $('[name="hidden-market[tags]"]').attr("value").toLowerCase();
     $('[name="hidden-market[tags]"]').attr("value", tags);

  }
// ---- LOCATION ----

var initializeAutocomplete = function(input_id) {
  autocomplete = new google.maps.places.Autocomplete(
    (document.getElementById(input_id)),
    {
      types: ['(cities)']
    });
};
var updateLocationData = function(){
  if(addressAndCityAreFilled()) geocode();
};

var addressAndCityAreFilled = function(){
  return $('#market_address').val() && $('#market_city').val();
};

function geocode(){
 geocoder = new google.maps.Geocoder();
  var address =  $('#market_address').val() + ", " + $('#market_city').val()
  geocoder.geocode({ 'address': address}, 
    function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      setLocation(results[0].geometry.location.lat(), 
                  results[0].geometry.location.lng());
    }
    });
  };

function setLocation(lat, lon){
    $("#market_latitude").val(lat);
    $("#market_longitude").val(lon);

    if (PM.marker) {
      PM.map.removeLayer(PM.marker);
    }
    PM.addMarker([lat, lon], false);
    PM.map.setView([lat, lon], 16);

};

// ------------

var initializeDatepicker = function(){
  $('.input-group.date').datepicker({
    weekStart: 1,
    format: "dd/mm/yyyy",
    startDate: "today",
    endDate:"+1m",
    multidate:true,
    language: locale,
    todayHighlight: true
  });
};

var addEditableDate = function(day, init, end){
  $('#date-schedule-table > tbody:last').append(form_date_template);
  initializeDatepicker();
  $('.input-group.date').last().datepicker('setDates', day);
  $('.schedule-start-input').last().val(init);
  $('.schedule-end-input').last().val(end);
}

//----
var collectNewDates = function(){
  try{
    var dates = new Array();

    $('.schedule-line').each(function(){
      var initTime = $(this).find('.schedule-start-input').val();
      var endTime  = $(this).find('.schedule-end-input').val();
      $(this).find('.input-group.date').data().datepicker.getDates().forEach(function(date){
          var schedule = new Array();
          schedule.push(date);
          schedule.push(initTime);
          schedule.push(endTime);

          dates.push(schedule);
        });
    });
    dates.sort(function(a, b){return a[0]-b[0]}); 
  return dates;
  } catch(em){
    console.log(em);
  } ;
};

var serializeSchedules = function(dates){
  var scheduleArray = new Array();
  dates.forEach(function(val){
    var schedule = moment(val[0]).format("DD/MM/YYYY") + "," + val[1] + "," + val[2];
    scheduleArray.push(schedule);
  });
  return scheduleArray.join(";");
};


$( document ).ready(function() {
  $("#wizard").removeClass("hidden");
  $(".add_market_button").addClass("btn-default").removeClass("btn-info").attr("disabled", true);
  $(window).keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });

  // Enable and disbale map
  $('#wizard').bootstrapWizard({
    tabClass: 'nav nav-pills nav-stacked',
    onTabChange: function(){    
      if ($("#form-market-location").hasClass("active"))
        $("#small-map-container").show();
      else
        $("#small-map-container").hide();
    }
  });

  // TAGS 
 
  
  var tagApi = jQuery(".tm-input").tagsManager({
    prefilled: $("#market_tags").val(),
    delimiters: [9, 13, 44],
    tagClass: "tm-tag",
    tagsContainer: '#tags-container'
  });

  var tags = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: 3, 
    prefetch: {
      url: suggested_tags_path,
      filter: function(list) {  
        return $.map(list, function(tag) { return { name: tag }; });
      }
    }
  });

  tags.initialize();

  $('.tm-input').typeahead(null, {
    name: 'tags',
    displayKey: 'name',
    hint: true,
    highlight: true,
    minLength: 1,
    source: tags.ttAdapter()
  });

  initializeAutocomplete('market_city');
 
  $("#button-add-date").click(function(){
    $('#date-schedule-table > tbody:last').append(form_date_template);
    initializeDatepicker();
  });

  $( "table" ).on( "click", ".button-delete-line", function() {
    $(this).closest('tr').remove();
  });

// PRICE RANGE
  var pricesOriginal = [$('#market_min_price').val() || 0, 
                        $('#market_max_price').val() || 1000];

  $("#prices-slider").slider( { 
    range: true,
    step: 5,
    max: 1000,
    min: 0,
    values: pricesOriginal,
    slide: function(event, ui) {
      var prices = $('#prices-slider').slider('option', 'values');
      $('#market_min_price').val(prices[0]);
      $('#market_max_price').val(prices[1]);
      $('#min-price').text(prices[0]);
      $('#max-price').text(prices[1]);
    },
    create: function(event, ui) {
      $('#min-price').text(pricesOriginal[0]);
      $('#max-price').text(pricesOriginal[1]);
      var prices = $('#prices-slider').slider('option', 'values');
    }
  });
  $('ul.nav a[href="' + window.location.hash + '"]').tab('show');
});
