$(document).on("turbolinks:load", function () {

    // Display options for job_type
    if ($(".js--job_type").val() == "system_integration") {
        $(".js--live_events_staging_and_rental_option").hide();
    }
    else if ($(".js--job_type").val() == "live_events_staging_and_rental") {
        $(".js--system_integration_option").hide();
    }
    else {
        $(".js--live_events_staging_and_rental_option").hide();
        $(".js--system_integration_option").hide();
    }

    $(".js--job_type").on("change", function() {
        if ($(this).val() == "system_integration") {
            $(".js--job_type_dependent_select").val("");
            $(".js--job_type_dependent_select_placeholder").html("Select");
            $(".js--live_events_staging_and_rental_option").hide();
            $(".js--system_integration_option").show();
        }
        else if ($(this).val() == "live_events_staging_and_rental") {
            $(".js--job_type_dependent_select").val("");
            $(".js--job_type_dependent_select_placeholder").html("Select");
            $(".js--live_events_staging_and_rental_option").show();
            $(".js--system_integration_option").hide();
        }
        else {
            $(".js--job_type_dependent_select").val("");
            $(".js--job_type_dependent_select_placeholder").html("Select job type to unlock options");
            $(".js--live_events_staging_and_rental_option").hide();
            $(".js--system_integration_option").hide();
        }
    });

    $('#replies-tab').on('click', function() {
        $(this).addClass('active');
        $('#matches-tab').removeClass('active');
    });
    $('#matches-tab').on('click', function() {
        $(this).addClass('active');
        $('#replies-tab').removeClass('active');
    });
});
