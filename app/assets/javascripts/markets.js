//= require tagmanager.js
//= require jquery.ui.widget
//= require jquery.iframe-transport
//= require jquery.fileupload
//= require attachinary

$( document ).ready(function() {
  $(".tm-input").tagsManager({prefilled: $( "form" ).data( "tags")});
  $('.attachinary-input').attachinary();
});