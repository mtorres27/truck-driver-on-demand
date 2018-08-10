document.addEventListener("turbolinks:load", function(){
    $("#freelance_distance").on('change', function() {
        var val = this.value;
        $(".js--distance").val(val);
        $(".js--freelancer-search-form").submit();
    });

    $("#freelance_sort").on('change', function() {
        var val = this.value;
        $("#sort").val(val);
        $("#freelancer_search_form").submit();
    });

    $("#freelancer_hired_location").on('change', function() {
        window.location = "/company/freelancers/hired?location="+this.value;
    });

    $("#freelancer_favourites_location").on('change', function() {
        window.location = "/company/freelancers/favourites?location="+this.value;
    });

    $(".js--show-avatar-only-checkbox").on('change', function(){
        if ($(this).is(":checked")) {
            $(".js--show-avatar-only-form-field").val(true);
        } else {
            $(".js--show-avatar-only-form-field").val(false);
        }
        $(".js--freelancer-search-form").submit();
    });

    $("#job_to_invite").change(function() {
        var val = $("#job_to_invite").val();

        if (val == "") {
          $("#job_invite_button").addClass("btn--primary--disabled")
        } else {
          $("#job_invite_button").removeClass("btn--primary--disabled");
        }
    });
});

var togglePopOver = function() {
  if ($(".popover").hasClass("popover--visible")) {
    $(".popover").removeClass("popover--visible");
    $(".popover--blanket").removeClass("popover--visible");
  } else {
    $(".popover").addClass("popover--visible");
    $(".popover--blanket").addClass("popover--visible");
  }
};

var hidePopOver = function() {
  if ($(".popover").hasClass("popover--visible")) {
    $(".popover").removeClass("popover--visible");
    $(".popover--blanket").removeClass("popover--visible");
  }
};

var submitInvitation = function(freelancer_id) {
  if ($("#job_invite_button").hasClass("btn btn--primary btn--primary--disabled")) {
    return;
  }

  $.get("/company/freelancers/"+ freelancer_id + "/invite_to_quote", { job_to_invite: $("#job_to_invite").val()})
    .done(function( data ) {
      $(".popover-response--error").html("");
      $(".popover-response--success").html("");
      if (data.success == 1) {
        $(".popover-response--success").html(data.message);
      } else {
        $(".popover-response--error").html(data.message);
      }

      var select = $('#job_currency');
      select.empty().append(data);
    });
}