$(window).scroll(function() {
  var scroll = $(window).scrollTop()

  if (scroll > 0) {
    $("#top-nav").addClass("navbar-floating")

  } else {
    $("#top-nav").removeClass("navbar-floating")
  }
});
