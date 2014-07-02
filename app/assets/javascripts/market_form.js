
$( document ).ready(function() {
 
  // Disable add market button
  $(".add_market_button").addClass("btn-default").removeClass("btn-info").attr("disabled", true);

  // Jump to a section
  $('ul.nav a[href="' + window.location.hash + '"]').tab('show');

  // Prevent submission
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

  // Error is no name is provided
  $(".simple_form").submit(function(){
   if( $("#market_name").val().length == 0 ) {
        $("#error").removeClass("hidden");
        $("#error").html("Market name cannot be empty");
        return false;
    }
   else{
      $('#market_date').val(passedDates + collectNewDates());
      $('#market_schedule').val(passedSchedule + collectNewSchedules());
      $("#error").html("");

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
  
});

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
// ---- LOCATION ----

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
 $('#market_address').blur(function () {
    updateLocationData();
  });

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
      setLocation(results[0].geometry.location.k, results[0].geometry.location.A);
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
    language: locale,
    todayHighlight: true
  });

  $('.input-group.date').last().datepicker('setDates', new Date());
};

var addEditableDate = function(day, init, end){
  $('#date-schedule-table > tbody:last').append(form_date_template);
  initializeDatepicker();
  $('.input-group.date').last().datepicker('setDates', day);
  $('.schedule-start-input').last().val(init);
  $('.schedule-end-input').last().val(end);
}

$("#button-add-date").click(function(){
  $('#date-schedule-table > tbody:last').append(form_date_template);
  initializeDatepicker();
});

$( "table" ).on( "click", ".button-delete-line", function() {
  $(this).closest('tr').remove();
});

//----
var collectNewDates = function(){
  var dates = new Array();
  $('.input-group.date').each(function() {
    dates.push($(this).data().datepicker.viewDate);
  });
  dates.sort(function(a, b){return a-b}); 
  return formatDates(dates);
};

var formatDates = function(dates){
  var datesFormatted = new Array();
  $.each(dates, function(i, val){
    datesFormatted.push(moment(val).format("DD/MM/YYYY"));
  });
  datesFormatted = $.unique(datesFormatted);
  return datesFormatted.join(",");
};

var collectNewSchedules = function(){
  var scheduleArray = new Array();
  $('.schedule-line').each(function(){
    var schedule = new Array();
    schedule.push(moment($(this).find('.input-group.date').data().datepicker.viewDate).format("DD/MM/YYYY"));
    schedule.push($(this).find('.schedule-start-input').val());
    schedule.push($(this).find('.schedule-end-input').val());
    if(schedule[0] != "" && schedule[1] != "" && schedule[2] != "")
      scheduleArray.push(schedule.join(","));
  });
  return scheduleArray.join(";");
};