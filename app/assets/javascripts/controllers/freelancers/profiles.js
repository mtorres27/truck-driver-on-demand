$(document).on("turbolinks:load", function () {

    if ($("#freelancer_freelancer_profile_attributes_job_types_live_events_staging_and_rental").is(":checked")) {
        $(".freelancer_please_select_job_type_message").hide();
        $(".freelancer_freelancer_profile_attributes_live_events_staging_and_rental_checkboxes").show();
    }
    else {
        $(".freelancer_freelancer_profile_attributes_live_events_staging_and_rental_checkboxes").hide();
    }

    if ($("#freelancer_freelancer_profile_attributes_job_types_system_integration").is(":checked")) {
        $(".freelancer_please_select_job_type_message").hide();
        $(".freelancer_system_integration_checkboxes").show();
    }
    else {
        $(".freelancer_system_integration_checkboxes").hide();
    }

    if ($("#freelancer_freelancer_profile_attributes_pay_unit_time_preference").val() == "fixed" || $("#freelancer_freelancer_profile_attributes_pay_unit_time_preference").val() == "") {
        $("#freelancer_freelancer_profile_attributes_pay_rate").val("");
        $(".js--pay-rate").hide();
    } else {
        $(".js--pay-rate").show();
    }

    $("#freelancer_freelancer_profile_attributes_job_types_live_events_staging_and_rental").on("change", function() {
        if ($(this).is(":checked")) {
            $(".freelancer_please_select_job_type_message").hide();
            $(".freelancer_live_events_staging_and_rental_checkboxes").show();
        }
        else {
            uncheck_all_checkboxes_with_class("freelancer_live_events_staging_and_rental_check_box");
            $(".freelancer_live_events_staging_and_rental_checkboxes").hide();
            if (!$("#freelancer_freelancer_profile_attributes_job_types_system_integration").is(":checked")) {
                $(".freelancer_please_select_job_type_message").show();
            }
        }
    });

    $("#freelancer_freelancer_profile_attributes_job_types_system_integration").on("change", function() {
        if ($(this).is(":checked")) {
            $(".freelancer_please_select_job_type_message").hide();
            $(".freelancer_system_integration_checkboxes").show();
        }
        else {
            uncheck_all_checkboxes_with_class("freelancer_system_integration_check_box");
            $(".freelancer_system_integration_checkboxes").hide();
            if (!$("#freelancer_freelancer_profile_attributes_job_types_live_events_staging_and_rental").is(":checked")) {
                $(".freelancer_please_select_job_type_message").show();
            }
        }
    });

    $("#freelancer_freelancer_profile_attributes_pay_unit_time_preference").on("change", function() {
        if ($(this).val() == "fixed" || $(this).val() == "") {
            $("#freelancer_freelancer_profile_attributes_pay_rate").val("");
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