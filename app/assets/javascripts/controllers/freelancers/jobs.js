$(document).on("turbolinks:load", function () {

    // Display options for country
    if ($(".js--country-select").val() == "us") {
        $(".js--ca_option").hide();
    }
    else if ($(".js--country-select").val() == "ca") {
        $(".js--us_option").hide();
    }
    else {
        $(".js--state-province-select").attr("disabled", true);
        $(".js--ca_option").hide();
        $(".js--us_option").hide();
    }

    $(".js--country-select").on("change", function() {
        if ($(this).val() == "us") {
            $(".js--state-province-select").val("");
            $(".js--state-province-select").removeAttr("disabled");
            $(".js--ca_option").hide();
            $(".js--us_option").show();
        }
        else if ($(this).val() == "ca") {
            $(".js--state-province-select").val("");
            $(".js--state-province-select").removeAttr("disabled");
            $(".js--us_option").hide();
            $(".js--ca_option").show();
        }
        else {
            $(".js--state-province-select").val("");
            $(".js--state-province-select").attr("disabled", true);
            $(".js--ca_option").hide();
            $(".js--us_option").hide();
        }
    });

    // Submit search on distance change
    $(".freelancer-job-matches__distance").on("change", function() {
        $("#freelancer-job-matches__form").submit()
    })
});
