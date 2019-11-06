$(document).on("turbolinks:load", function () {

    if ($("#driver_driver_profile_attributes_job_types_live_events_staging_and_rental").is(":checked")) {
        $(".driver_please_select_job_type_message").hide();
        $(".driver_driver_profile_attributes_live_events_staging_and_rental_checkboxes").show();
    }
    else {
        $(".driver_driver_profile_attributes_live_events_staging_and_rental_checkboxes").hide();
    }

    if ($("#driver_driver_profile_attributes_job_types_system_integration").is(":checked")) {
        $(".driver_please_select_job_type_message").hide();
        $(".driver_system_integration_checkboxes").show();
    }
    else {
        $(".driver_system_integration_checkboxes").hide();
    }

    if ($("#driver_driver_profile_attributes_pay_unit_time_preference").val() == "fixed" || $("#driver_driver_profile_attributes_pay_unit_time_preference").val() == "") {
        $("#driver_driver_profile_attributes_pay_rate").val("");
        $(".js--pay-rate").hide();
    } else {
        $(".js--pay-rate").show();
    }

    $("#driver_driver_profile_attributes_job_types_live_events_staging_and_rental").on("change", function() {
        if ($(this).is(":checked")) {
            $(".driver_please_select_job_type_message").hide();
            $(".driver_live_events_staging_and_rental_checkboxes").show();
        }
        else {
            uncheck_all_checkboxes_with_class("driver_live_events_staging_and_rental_check_box");
            $(".driver_live_events_staging_and_rental_checkboxes").hide();
            if (!$("#driver_driver_profile_attributes_job_types_system_integration").is(":checked")) {
                $(".driver_please_select_job_type_message").show();
            }
        }
    });

    $("#driver_driver_profile_attributes_job_types_system_integration").on("change", function() {
        if ($(this).is(":checked")) {
            $(".driver_please_select_job_type_message").hide();
            $(".driver_system_integration_checkboxes").show();
        }
        else {
            uncheck_all_checkboxes_with_class("driver_system_integration_check_box");
            $(".driver_system_integration_checkboxes").hide();
            if (!$("#driver_driver_profile_attributes_job_types_live_events_staging_and_rental").is(":checked")) {
                $(".driver_please_select_job_type_message").show();
            }
        }
    });

    $("#driver_driver_profile_attributes_pay_unit_time_preference").on("change", function() {
        if ($(this).val() == "fixed" || $(this).val() == "") {
            $("#driver_driver_profile_attributes_pay_rate").val("");
            $(".js--pay-rate").hide();
        } else {
            $(".js--pay-rate").show();
        }
    });
});

function uncheck_all_checkboxes_with_class(class_name) {
    $("." + class_name).each(function() {
        $(this).prop("checked", false)
    })
}