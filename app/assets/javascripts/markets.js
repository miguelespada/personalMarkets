//= require tagmanager.js

$( document ).ready(function() {
  $(".tm-input").tagsManager({prefilled: $( "form" ).data( "tags")});
});