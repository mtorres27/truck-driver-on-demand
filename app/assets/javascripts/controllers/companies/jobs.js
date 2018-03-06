$(document).on("turbolinks:load", function () {

    if ($("#job_job_type").val() == "system_integration") {
        $(".job_live_events_staging_and_rental_option").hide();
    }
    else if ($("#job_job_type").val() == "live_events_staging_and_rental") {
        $(".job_system_integration_option").hide();
    }
    else {
        $(".job_live_events_staging_and_rental_option").hide();
        $(".job_system_integration_option").hide();
    }


    $("#job_job_type").on("change", function() {
        if ($(this).val() == "system_integration") {
            $(".job_live_events_staging_and_rental_option").hide();
            $(".job_system_integration_option").show();
        }
        else if ($(this).val() == "live_events_staging_and_rental") {
            $(".job_live_events_staging_and_rental_option").show();
            $(".job_system_integration_option").hide();
        }
        else {
            $(".job_live_events_staging_and_rental_option").hide();
            $(".job_system_integration_option").hide();
        }
    });
});
