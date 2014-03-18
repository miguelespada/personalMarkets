//= require tagmanager.js
//= require jquery.ui.widget
//= require jquery.iframe-transport
//= require jquery.fileupload
//= require attachinary
//= require twitter/typeahead

var substringMatcher = function(strs) {
  return function findMatches(q, cb) {
    var matches, substringRegex;
    matches = [];
    substrRegex = new RegExp(q, 'i');
    $.each(strs, function(i, str) {
      if (substrRegex.test(str)) {
        matches.push({ value: str });
      }
    });
    cb(matches);
  };
};


$( document ).ready(function() {
   $('.attachinary-input').attachinary();

   var tagApi = $(".tm-input").tagsManager({
      prefilled: $( "form" ).data( "tags"),
      delimiters: [13, 44]
      });
  
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

