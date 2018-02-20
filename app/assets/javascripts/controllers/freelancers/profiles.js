$(document).on("turbolinks:load", function () {

    if ($("#freelancer_job_type").val() == "live_events_staging_and_rental") {
        $(".freelancer_system_integration_checkboxes").hide();
        $(".freelancer_please_select_job_type_message").hide();
    }
    else if ($("#freelancer_job_type").val() == "system_integration") {
        $(".freelancer_live_events_staging_and_rental_checkboxes").hide();
        $(".freelancer_please_select_job_type_message").hide();
    }
    else if ($("#freelancer_job_type").val() == "") {
        $(".freelancer_system_integration_checkboxes").hide();
        $(".freelancer_live_events_staging_and_rental_checkboxes").hide();
    }

    $("#freelancer_job_type").on("change", function(){
        if (this.value == "live_events_staging_and_rental") {
            uncheck_all_checkboxes_with_class("freelancer_system_integration_check_box");
            $(".freelancer_system_integration_checkboxes").hide();
            $(".freelancer_please_select_job_type_message").hide();
            $(".freelancer_live_events_staging_and_rental_checkboxes").show();
        }
        else if (this.value == "system_integration") {
            uncheck_all_checkboxes_with_class("freelancer_live_events_staging_and_rental_check_box");
            $(".freelancer_live_events_staging_and_rental_checkboxes").hide();
            $(".freelancer_please_select_job_type_message").hide();
            $(".freelancer_system_integration_checkboxes").show();
        }
        else if (this.value == "") {
            uncheck_all_checkboxes_with_class("freelancer_system_integration_check_box");
            uncheck_all_checkboxes_with_class("freelancer_live_events_staging_and_rental_check_box");
            $(".freelancer_system_integration_checkboxes").hide();
            $(".freelancer_live_events_staging_and_rental_checkboxes").hide();
            $(".freelancer_please_select_job_type_message").show();
        }
    })
});

function uncheck_all_checkboxes_with_class(class_name) {
    $("." + class_name).each(function() {
        $(this).prop("checked", false)
    })
}