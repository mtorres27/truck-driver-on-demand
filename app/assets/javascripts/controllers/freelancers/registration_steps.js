$(document).on("turbolinks:load", function () {

    if ($("#freelancer_profile_job_types_live_events_staging_and_rental").is(":checked")) {
        console.log(1);
        $(".freelancer_please_select_job_type_message").hide();
    }
    else {
        console.log(2);
        $(".freelancer_live_events_staging_and_rental_checkboxes").hide();
    }

    if ($("#freelancer_profile_job_types_system_integration").is(":checked")) {
        console.log(3);
        $(".freelancer_please_select_job_type_message").hide();
    }
    else {
        console.log(4);
        $(".freelancer_profile_system_integration_checkboxes").hide();
    }

    $("#freelancer_profile_job_types_live_events_staging_and_rental").on("change", function() {
        if ($(this).is(":checked")) {
            $(".freelancer_please_select_job_type_message").hide();
            $(".freelancer_live_events_staging_and_rental_checkboxes").show();
        }
        else {
            uncheck_all_checkboxes_with_class("freelancer_live_events_staging_and_rental_check_box");
            $(".freelancer_live_events_staging_and_rental_checkboxes").hide();
            if (!$("#freelancer_profile_job_types_system_integration").is(":checked")) {
                $(".freelancer_please_select_job_type_message").show();
            }
        }
    });

    $("#freelancer_profile_job_types_system_integration").on("change", function() {
        if ($(this).is(":checked")) {
            $(".freelancer_please_select_job_type_message").hide();
            $(".freelancer_system_integration_checkboxes").show();
        }
        else {
            uncheck_all_checkboxes_with_class("freelancer_system_integration_check_box");
            $(".freelancer_system_integration_checkboxes").hide();
            if (!$("#freelancer_profile_job_types_live_events_staging_and_rental").is(":checked")) {
                $(".freelancer_please_select_job_type_message").show();
            }
        }
    });

    // Display options for country
    if ($("#freelancer_profile_country").val() == "us") {
        $(".freelancer_ca_option").hide();
    }
    else if ($("#freelancer_profile_country").val() == "ca") {
        $(".freelancer_us_option").hide();
    }
    else {
        $("#freelancer_profile_state").attr("disabled", true);
        $(".freelancer_ca_option").hide();
        $(".freelancer_us_option").hide();
    }

    $("#freelancer_profile_country").on("change", function() {
        if ($(this).val() == "us") {
            $("#freelancer_profile_state").val("");
            $("#freelancer_profile_state").removeAttr("disabled");
            $(".freelancer_ca_option").hide();
            $(".freelancer_us_option").show();
        }
        else if ($(this).val() == "ca") {
            $("#freelancer_profile_state").val("");
            $("#freelancer_profile_state").removeAttr("disabled");
            $(".freelancer_us_option").hide();
            $(".freelancer_ca_option").show();
        }
        else {
            $("#freelancer_profile_state").val("");
            $("#freelancer_profile_state").attr("disabled", true);
            $(".freelancer_ca_option").hide();
            $(".freelancer_us_option").hide();
        }
    });
});

function uncheck_all_checkboxes_with_class(class_name) {
    $("." + class_name).each(function() {
        $(this).prop("checked", false)
    })
}
