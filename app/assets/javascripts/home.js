
var centerTitles = function(){
  $( "#slideshow_titles" ).position({
    my: "center center",
    at: "center center",
    of: "#slides"
  });
};

var generateTitles = function(){
   rand = Math.floor(Math.random() * titlesArray.length);
   $('#slideshow_titles').html("<p class='title'>" + titlesArray[rand] +  "</p>" + "<p class='subtitle'>" + subtitlesArray[rand] + "</p>");
   centerTitles();
}

var changeTitles= function(){
  setInterval(function(){
    generateTitles();
  }, 3000);
}

var setSlides = function(){

    $("#slides").slidesjs({
      width: 1000,
      height: 300,
      navigation: {
        active: false,
        effect: "fade"
      },
      play: {
        active: false,
        effect: "fade",
        interval: 4000,
        auto: true,
        swap: false,
        pauseOnHover: false,
        restartDelay: 1000
      },
      effect: {
        fade: {
          speed: 1000,
          crossfade: true
        }
      },
      pagination: {
        active: false
      }
    });
  };

$(document).ready(function(){
    setSlides();

    generateTitles();
    changeTitles();

    window.onresize = function(){
      centerTitles();
    };
});