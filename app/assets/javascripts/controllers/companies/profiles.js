$(document).on("turbolinks:load", function () {

    if ($("#company_job_types_live_events_staging_and_rental").is(":checked")) {
        $(".company_please_select_job_type_message").hide();
    }
    else {
        $(".company_live_events_staging_and_rental_checkboxes").hide();
    }

    if ($("#company_job_types_system_integration").is(":checked")) {
        $(".company_please_select_job_type_message").hide();
    }
    else {
        $(".company_system_integration_checkboxes").hide();
    }

    if (!$("#company_job_types_live_events_staging_and_rental").is(":checked") && !$("#company_job_types_system_integration").is(":checked")) {
        $(".company_system_integration_checkboxes").hide();
        $(".company_live_events_staging_and_rental_checkboxes").hide();
    }

    $("#company_job_types_live_events_staging_and_rental").on("change", function() {
        if ($(this).is(":checked")) {
            $(".company_please_select_job_type_message").hide();
            $(".company_live_events_staging_and_rental_checkboxes").show();
        }
        else {
            uncheck_all_checkboxes_with_class("company_live_events_staging_and_rental_check_box");
            $(".company_live_events_staging_and_rental_checkboxes").hide();
            if (!$("#company_job_types_system_integration").is(":checked")) {
                $(".company_please_select_job_type_message").show();
            }
        }
    });

    $("#company_job_types_system_integration").on("change", function() {
        if ($(this).is(":checked")) {
            $(".company_please_select_job_type_message").hide();
            $(".company_system_integration_checkboxes").show();
        }
        else {
            uncheck_all_checkboxes_with_class("company_system_integration_check_box");
            $(".company_system_integration_checkboxes").hide();
            if (!$("#company_job_types_live_events_staging_and_rental").is(":checked")) {
                $(".company_please_select_job_type_message").show();
            }
        }
    });
});

function uncheck_all_checkboxes_with_class(class_name) {
    $("." + class_name).each(function() {
        $(this).prop("checked", false)
    })
}
