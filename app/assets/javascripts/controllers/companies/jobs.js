$(document).on("turbolinks:load", function () {

    // Display options for job_type
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

    // Display options for country
    if ($("#job_country").val() == "us") {
        $(".job_ca_option").hide();
    }
    else if ($("#job_country").val() == "ca") {
        $(".job_us_option").hide();
    }
    else {
        $("#job_state_province").attr("disabled", true);
        $(".job_ca_option").hide();
        $(".job_us_option").hide();
    }

    $("#job_country").on("change", function() {
        if ($(this).val() == "us") {
            $("#job_state_province").val("");
            $("#job_state_province").removeAttr("disabled");
            $(".job_ca_option").hide();
            $(".job_us_option").show();
        }
        else if ($(this).val() == "ca") {
            $("#job_state_province").val("");
            $("#job_state_province").removeAttr("disabled");
            $(".job_us_option").hide();
            $(".job_ca_option").show();
        }
        else {
            $("#job_state_province").val("");
            $("#job_state_province").attr("disabled", true);
            $(".job_ca_option").hide();
            $(".job_us_option").hide();
        }
    });

    // Submit search on distance change
    $(".company-freelancer-matches__distance").on("change", function() {
        $("#company-freelancer-matches__form").submit()
    })

    if ($('.js--country-select').val() != "" && $('.js--country-select').val() != undefined ) {
        get_currencies($('.js--country-select').val())
    }
    $('.js--country-select').on('change', function () {
        get_currencies($(this).val())
    });
});

function get_currencies(country) {
    $.get("/job_country_currency", {country: country})
        .done(function (data) {
            var select = $('#job_currency');
            select.empty().append(data);
        });
}
