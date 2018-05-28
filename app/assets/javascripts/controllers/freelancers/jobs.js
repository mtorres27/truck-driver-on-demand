$(document).on("turbolinks:load", function () {

    // Display options for country
    if ($("#search_country").val() == "us") {
        $(".search_ca_option").hide();
    }
    else if ($("#search_country").val() == "ca") {
        $(".search_us_option").hide();
    }
    else {
        $("#search_state_province").attr("disabled", true);
        $(".search_ca_option").hide();
        $(".search_us_option").hide();
    }

    $("#search_country").on("change", function() {
        if ($(this).val() == "us") {
            $("#search_state_province").val("");
            $("#search_state_province").removeAttr("disabled");
            $(".search_ca_option").hide();
            $(".search_us_option").show();
        }
        else if ($(this).val() == "ca") {
            $("#search_state_province").val("");
            $("#search_state_province").removeAttr("disabled");
            $(".search_us_option").hide();
            $(".search_ca_option").show();
        }
        else {
            $("#search_state_province").val("");
            $("#search_state_province").attr("disabled", true);
            $(".search_ca_option").hide();
            $(".search_us_option").hide();
        }
    });
});
