$(document).on("turbolinks:load", function () {

    if ($("#driver_profile_job_types_live_events_staging_and_rental").is(":checked")) {
        $(".driver_please_select_job_type_message").hide();
    }
    else {
        $(".driver_live_events_staging_and_rental_checkboxes").hide();
    }

    if ($("#driver_profile_job_types_system_integration").is(":checked")) {
        $(".driver_please_select_job_type_message").hide();
    }
    else {
        $(".driver_profile_system_integration_checkboxes").hide();
    }

    $("#driver_profile_job_types_live_events_staging_and_rental").on("change", function() {
        if ($(this).is(":checked")) {
            $(".driver_please_select_job_type_message").hide();
            $(".driver_live_events_staging_and_rental_checkboxes").show();
        }
        else {
            uncheck_all_checkboxes_with_class("driver_live_events_staging_and_rental_check_box");
            $(".driver_live_events_staging_and_rental_checkboxes").hide();
            if (!$("#driver_profile_job_types_system_integration").is(":checked")) {
                $(".driver_please_select_job_type_message").show();
            }
        }
    });

    $("#driver_profile_job_types_system_integration").on("change", function() {
        if ($(this).is(":checked")) {
            $(".driver_please_select_job_type_message").hide();
            $(".driver_system_integration_checkboxes").show();
        }
        else {
            uncheck_all_checkboxes_with_class("driver_system_integration_check_box");
            $(".driver_system_integration_checkboxes").hide();
            if (!$("#driver_profile_job_types_live_events_staging_and_rental").is(":checked")) {
                $(".driver_please_select_job_type_message").show();
            }
        }
    });

    // Display options for country
    if ($("#driver_profile_country").val() == "us") {
        $(".driver_ca_option").hide();
    }
    else if ($("#driver_profile_country").val() == "ca") {
        $(".driver_us_option").hide();
    }
    else {
        $("#driver_profile_state").attr("disabled", true);
        $(".driver_ca_option").hide();
        $(".driver_us_option").hide();
    }

    $("#driver_profile_country").on("change", function() {
        if ($(this).val() == "us") {
            $("#driver_profile_state").val("");
            $("#driver_profile_state").removeAttr("disabled");
            $(".driver_ca_option").hide();
            $(".driver_us_option").show();
        }
        else if ($(this).val() == "ca") {
            $("#driver_profile_state").val("");
            $("#driver_profile_state").removeAttr("disabled");
            $(".driver_us_option").hide();
            $(".driver_ca_option").show();
        }
        else {
            $("#driver_profile_state").val("");
            $("#driver_profile_state").attr("disabled", true);
            $(".driver_ca_option").hide();
            $(".driver_us_option").hide();
        }
    });
});

function uncheck_all_checkboxes_with_class(class_name) {
    $("." + class_name).each(function() {
        $(this).prop("checked", false)
    })
}
