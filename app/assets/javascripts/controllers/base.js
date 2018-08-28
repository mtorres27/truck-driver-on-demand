$(window).scroll(function() {
  var scroll = $(window).scrollTop();

  if (scroll > 0) {
    $("#top-nav").addClass("navbar-floating");

  } else {
    $("#top-nav").removeClass("navbar-floating");
  }
});

var hide_remove_association = function (obj, hard) {
  $(obj).parent().parent().fadeOut();
  if (hard) $(obj).parent().parent().remove();
};
