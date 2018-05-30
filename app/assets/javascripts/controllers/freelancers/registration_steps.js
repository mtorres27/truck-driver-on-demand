$(document).on("turbolinks:load", function () {

    // Display options for country
    if ($("#freelancer_country").val() == "us") {
        $(".freelancer_ca_option").hide();
    }
    else if ($("#freelancer_country").val() == "ca") {
        $(".freelancer_us_option").hide();
    }
    else {
        $("#freelancer_state").attr("disabled", true);
        $(".freelancer_ca_option").hide();
        $(".freelancer_us_option").hide();
    }

    $("#freelancer_country").on("change", function() {
        if ($(this).val() == "us") {
            $("#freelancer_state").val("");
            $("#freelancer_state").removeAttr("disabled");
            $(".freelancer_ca_option").hide();
            $(".freelancer_us_option").show();
        }
        else if ($(this).val() == "ca") {
            $("#freelancer_state").val("");
            $("#freelancer_state").removeAttr("disabled");
            $(".freelancer_us_option").hide();
            $(".freelancer_ca_option").show();
        }
        else {
            $("#freelancer_state").val("");
            $("#freelancer_state").attr("disabled", true);
            $(".freelancer_ca_option").hide();
            $(".freelancer_us_option").hide();
        }
    });
});
