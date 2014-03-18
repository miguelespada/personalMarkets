//= require tagmanager.js
//= require jquery.ui.widget
//= require jquery.iframe-transport
//= require jquery.fileupload
//= require attachinary
//= require twitter/typeahead

var substringMatcher = function(strs) {
  return function findMatches(q, cb) {
    var matches, substringRegex;
 
    // an array that will be populated with substring matches
    matches = [];
 
    // regex used to determine if a string contains the substring `q`
    substrRegex = new RegExp(q, 'i');
 
    // iterate through the pool of strings and for any string that
    // contains the substring `q`, add it to the `matches` array
    $.each(strs, function(i, str) {
      if (substrRegex.test(str)) {
        // the typeahead jQuery plugin expects suggestions to a
        // JavaScript object, refer to typeahead docs for more info
        matches.push({ value: str });
      }
    });
 
    cb(matches);
  };
};


$( document ).ready(function() {
   $('.attachinary-input').attachinary();

   var tagApi = $(".tm-input").tagsManager({prefilled: $( "form" ).data( "tags")});
  
  $.get( "/tags/index.json", function( data ) {
      $('.typeahead').typeahead({
        hint: true,
        highlight: true,
        minLength: 1
      },
      {
        name: 'tags',
        displayKey: 'value',
        source: substringMatcher(data)
      });
  });

});

