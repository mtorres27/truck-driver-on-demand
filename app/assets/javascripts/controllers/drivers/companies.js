$(document).on("turbolinks:load", function () {
  if ($(".cdriver-companies").length == 0) {
    return;
  }

  $("#job_distance").on('change', function() {
    var val = this.value;
    $("#distance").val(val);
    $("#company_search_form").submit();
  });

  $("#driver_sort").on('change', function() {
    var val = this.value;
    $("#sort").val(val);
    $("#driver_search_form").submit();
  });

  $("#driver_hired_location").on('change', function() {
    window.location = "/company/drivers/hired?location="+this.value;
  });

  $("#driver_favourites_location").on('change', function() {
    window.location = "/company/drivers/favourites?location="+this.value;
  });
});