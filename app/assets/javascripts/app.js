var PM = {};

PM.editClick = function(ev){
    var market_id = $(this).attr('data_market_id');
    var comment_id = $(this).attr('data_comment_id');

    var li = $(this).parent();
    var deleteLink = li.find('.delete-comment-link');
    var editLink = li.find('.edit-comment-link');

    var textarea = H.createTextarea(li.find('span').html());

    var callback = function(data){
        li.html("")
        var span = $('<span>');
        span.html(data.body);
        li.append(span);
        $(editLink).click(PM.editClick);
        li.append(deleteLink);
        li.append(editLink);
    };


    var save = $('<button>');
    save.html("Save");
    save.click(function(){
        DOMAIN.updateComment(market_id, comment_id, textarea.val(), callback);
    });
    li.html("");
    li.append(textarea).append(save);
    ev.stopPropagation();
    return false;
};


PM.setViewWithUserLocation = function(){
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(PM.getCurrentPosition);
  }
};

PM.getCurrentPosition = function(position){
  PM.newLatitude = parseFloat(position.coords.latitude);
  PM.newLongitude = parseFloat(position.coords.longitude);
  PM.map.setView([PM.newLatitude, PM.newLongitude], 14);
};

PM.setDataRange =  function() {
    var v = H.makeDateString($('#range').val());
    $("#from").val(v.from);
    $("#to").val(v.to);
};


var ajaxSearch = function () {
    PM.setDataRange();
    $.get("live_search" , $(this).serialize(), function(data) {
        $( "#gallery-items" ).html( data );
    });
    return false;
};

var jsonSearch = function () {
    PM.setDataRange();
    $.get("markets/live_search.json" , $(this).serialize(), function(data) {
        $( "#gallery-items" ).html( data );
    });
    return false;
};


$( document ).ready(function() {

    $('#edit_link').click(PM.editClick);

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



