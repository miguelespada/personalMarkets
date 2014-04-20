//= require date
//= require jquery.dp_calendar

$( document ).ready(function() {
  var events_array = []; 
  var eventDate, eventDay, eventMonth, eventYear;   

	$.getJSON( "markets.json").done(function(data){
    for (i=0; i<data.length; i++){
      try{
        eventDate = data[i].date.split("/");
        eventDay = parseInt(eventDate[0]);
        eventMonth = parseInt(eventDate[1]) - 1;
        eventYear = parseInt(eventDate[2]);
  
        var market_event = {};
        market_event.title = data[i].name;
        market_event.description = data[i].description;
        market_event.startDate = new Date(eventYear, eventMonth, eventDay, 17, 00);
        market_event.endDate = new Date(eventYear, eventMonth, eventDay, 18, 30);
  
        events_array.push(market_event);
      }
      catch(err){}
    }
    $("#calendar").dp_calendar({
      events_array: events_array
    });
  });
});