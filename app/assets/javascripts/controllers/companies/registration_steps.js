$(document).on("turbolinks:load", function () {

    // Display options for country
    if ($("#company_company_data_attributes_country").val() == "us") {
        $(".company_ca_option").hide();
    }
    else if ($("#company_company_data_attributes_country").val() == "ca") {
        $(".company_us_option").hide();
    }
    else {
        $("#company_company_data_attributes_state").attr("disabled", true);
        $(".company_ca_option").hide();
        $(".company_us_option").hide();
    }

    $("#company_company_data_attributes_country").on("change", function() {
        if ($(this).val() == "us") {
            $("#company_company_data_attributes_state").val("");
            $("#company_company_data_attributes_state").removeAttr("disabled");
            $(".company_ca_option").hide();
            $(".company_us_option").show();
        }
        else if ($(this).val() == "ca") {
            $("#company_company_data_attributes_state").val("");
            $("#company_company_data_attributes_state").removeAttr("disabled");
            $(".company_us_option").hide();
            $(".company_ca_option").show();
        }
        else {
            $("#company_company_data_attributes_state").val("");
            $("#company_company_data_attributes_state").attr("disabled", true);
            $(".company_ca_option").hide();
            $(".company_us_option").hide();
        }
    });
});
