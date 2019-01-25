$(document).on("turbolinks:load", function () {
    
    if ($(".js--contract-payment-type").val() == "fixed") {
        $(".js--contract-variable-payment-type-div").hide();
        $(".js--contract-overtime-rate-div").hide();
        $(".js--contract-price-label").html("<abbr title='required'>*</abbr>Contract price");
        $(".js--payment-add-button").click();
        $("#payments").show();
    }
    else if ($(".js--contract-payment-type").val() == "variable") {
        $(".js--contract-variable-payment-type-div").show();
        $(".js--contract-overtime-rate-div").show();
        $("#payments").hide();
    }
    
    if ($(".js--contract-variable-payment-type").val() == "daily") {
        $(".js--contract-price-label").html("<abbr title='required'>*</abbr>Daily rate");
        $("#payments").hide();
    }
    else if ($(".js--contract-variable-payment-type-div").val() == "hourly") {
        $(".js--contract-price-label").html("<abbr title='required'>*</abbr>Hourly rate");
        $("#payments").hide();
    }

    $(".js--contract-payment-type").on("change", function() {
        if ($(this).val() == "fixed") {
            $(".js--contract-variable-payment-type").val("");
            $(".js--contract-variable-payment-type-div").hide();
            $(".js--contract-overtime-rate").val("");
            $(".js--contract-overtime-rate-div").hide();
            $(".js--contract-price-label").html("<abbr title='required'>*</abbr>Contract price");
            $(".js--payment-add-button").click();
            $("#payments").show();
        }
        else if ($(this).val() == "variable") {
            $(".js--contract-variable-payment-type-div").show();
            $(".js--contract-overtime-rate-div").show();
            $(".js--payment-destroy-button").click();
            $("#payments").hide();
        }
    });

    $(".js--contract-variable-payment-type").on("change", function() {
        if ($(this).val() == "hourly") {
            $(".js--contract-price-label").html("<abbr title='required'>*</abbr>Hourly rate");
        }
        else if ($(this).val() == "daily") {
            $(".js--contract-price-label").html("<abbr title='required'>*</abbr>Daily rate");
        }
    });

    if ($(".js--disable-overtime-rate-checkbox").is(":checked")) {
        $(".js--contract-overtime-rate").val("");
        $(".js--contract-overtime-rate").attr("disabled", true);
    }

    $(".js--disable-overtime-rate-checkbox").on("change", function() {
        if ($(this).is(":checked")) {
            $(".js--contract-overtime-rate").val("");
            $(".js--contract-overtime-rate").attr("disabled", true);
        }
        else {
            $(".js--contract-overtime-rate").removeAttr("disabled");
        }
    })
});

var toggleExpandedJobDetails = function() {
    var collapsed = "job-details--collapsed";
    if ($("#contract-extra-data").hasClass(collapsed)) {
        $("#contract-extra-data").removeClass(collapsed);
        $(".result-content__expand-btn").html("collapse job details");
    } else {
        $("#contract-extra-data").addClass(collapsed);
        $(".result-content__expand-btn").html("expand job details");
    }
};

function uploadAddendum (index) {
    if (index != undefined) {
        var id = "#job_attachments_attributes_"+index+"_file";
        var ref = $(id);
    } else {
        var ref = $(".add-new-addendum").prev('div').find(".nested_fields").find(".file-input--hidden");

    }

    ref.on('change', function() {
        var imgPath = $(this)[0].value;
        var extn = imgPath.substring(imgPath.lastIndexOf('.') + 1).toLowerCase();
        var image_holder = $(this).parent().parent().find(".freelancer-profile__image").find(".authorable_attachment--full").find("img");
        if (extn == "gif" || extn == "png" || extn == "jpg" || extn == "jpeg") {
            if (typeof (FileReader) != "undefined") {
                var reader = new FileReader();
                reader.onload = function (e) {
                    image_holder.attr('src', e.target.result)
                };

                reader.readAsDataURL($(this)[0].files[0]);
            }
        } else if (extn == "pdf") {
            image_holder.attr('src', "/assets/adendum/placeholder.png")
        } else {
            alert("Only images can be selected.");
        }
    });

    ref.click();
}
