$(window).scroll(function() {
  var scroll = $(window).scrollTop();

  if (scroll > 0) {
    $("#top-nav").addClass("navbar-floating");

  } else {
    $("#top-nav").removeClass("navbar-floating");
  }
});

var hide_remove_association = function (obj, hard) {
  $(obj).parent().parent().parent().parent().fadeOut();
  if (hard) $(obj).parent().parent().remove();
};

$(document).on("turbolinks:load", function () {
    $("#truckker-collapse-btn").on("click", function (){
        if ($("#truckker-collapse-div").hasClass("collapse")) {
            $("#truckker-collapse-div").removeClass("collapse");
            $("#truckker-collapse-div").addClass("collapsein");
        }
        else {
            $("#truckker-collapse-div").addClass("collapse");
            $("#truckker-collapse-div").removeClass("collapsein");
        }
    });
});
