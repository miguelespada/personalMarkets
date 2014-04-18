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
    var v = H.makeDateString($(this).val());
    $("#from").val(v.from);
    $("#to").val(v.to);
};

PM.searchCallBacks = function(){
    var ajaxSearch = function () {
    $.get(this.action, $(this).serialize(), function(data) {
        $( "#gallery-items" ).html( data );
    });
        return false;
    };

    $('#range').change(PM.setDataRange).change();
    $('#search_market').change(ajaxSearch);
}


$( document ).ready(function() {
    $('#edit_link').click(PM.editClick);
    PM.searchCallBacks();
});



