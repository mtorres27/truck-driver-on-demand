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
    $("#avj-collapse-btn").on("click", function (){
        if ($("#avj-collapse-div").hasClass("collapse")) {
            $("#avj-collapse-div").removeClass("collapse");
            $("#avj-collapse-div").addClass("collapsein");
        }
        else {
            $("#avj-collapse-div").addClass("collapse");
            $("#avj-collapse-div").removeClass("collapsein");
        }
    });
});
