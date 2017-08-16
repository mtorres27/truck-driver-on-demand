$(document).on("turbolinks:load", function () {
  if ($(".company-freelancers").length == 0) {
    return;
  }

  var freelancers = [];

  $(".company-freelancer__favourite-checkbox").on('click', function(event) {
    event.stopPropagation();
    updateFreelancerList();
  });

  function updateFreelancerList() {
    freelancers = [];
    $(".company-freelancer__favourite-checkbox").each(function(i, obj) {
      var c = $(this);
      if (c.is(':checked')) {
        freelancers.push(c.attr('freelancer-id'));
      }

    });

    if (freelancers.length == 0) {
      $(".company-freelancer__favourite-button").prop("disabled",true);
    } else {
      $(".company-freelancer__favourite-button").prop("disabled",false);
    }
  }

  $(".company-freelancer__favourite-button").on('click', function() {
    // submit favourites
    $.ajax({
      type: "POST",
      url: "/company/freelancers/add_favourites",
      data: { freelancers: freelancers },
      success: addFreelancerToFavouritesSuccess
    });
  });

  $("#freelance_distance").on('change', function() {
    var val = this.value;
    $("#distance").val(val);
    $("#freelancer_search_form").submit();
  });

  $("#freelance_sort").on('change', function() {
    var val = this.value;
    $("#sort").val(val);
    $("#freelancer_search_form").submit();
  });

  function addFreelancerToFavouritesSuccess (event) {
    window.location.reload();
  }
});