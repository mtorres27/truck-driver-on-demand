document.addEventListener("turbolinks:load", function(){
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

    $("#job_to_invite").change(function() {
        var val = $("#job_to_invite").val();

        if (val == "") {
          $("#job_invite_button").addClass("btn--primary--disabled")
        } else {
          $("#job_invite_button").removeClass("btn--primary--disabled");
          $("#job_invite_button").removeAttr("disabled");
          $("#job_invite_button").html("Invite");
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
          if (data.success == 1) {
              $("#job_invite_button").html(data.message);
          } else {
              $("#job_invite_button").html(data.message);
          }
          $("#job_invite_button").attr("disabled", true);
          var select = $('#job_currency');
          select.empty().append(data);
    });
};