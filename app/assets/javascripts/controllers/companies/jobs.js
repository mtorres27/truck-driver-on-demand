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
            $(".js--live_events_staging_and_rental_option").hide();
            $(".js--system_integration_option").show();
        }
        else if ($(this).val() == "live_events_staging_and_rental") {
            $(".js--job_type_dependent_select").val("");
            $(".js--live_events_staging_and_rental_option").show();
            $(".js--system_integration_option").hide();
        }
        else {
            $(".js--job_type_dependent_select").val("");
            $(".js--live_events_staging_and_rental_option").hide();
            $(".js--system_integration_option").hide();
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

function inviteToQuote(freelancer_id, job_id) {
    $.get("/company/freelancers/"+ freelancer_id + "/invite_to_quote", { job_to_invite: job_id})
        .done(function( data ) {
            if (data.success == 1) {
                $(".js--invite-to-quote-matches-btn-" + freelancer_id).html(data.message);
            } else {
                $(".js--invite-to-quote-matches-btn-" + freelancer_id).html(data.message);
            }
            $(".js--invite-to-quote-matches-btn-" + freelancer_id).attr("disabled", true)
        });
}
