document.addEventListener("turbolinks:load", function() {
    $("#message_checkin").on("change", function() {
        if ($(this).is(":checked")){
            $("#message-submit").attr("disabled", true);
            $("#new-message__loading-notice").html("Please wait while we retrieve your location.");
            getGeolocation()
        }
        else {
            $("#message_lat").val("");
            $("#message_lng").val("");
            $("#new-message__loading-notice").html("");
        }
    });

    $("#new-message__validation-errors").hide();


    $("#message_attachment").change(function() {
        $(".new-message__attachment-button").addClass("new-message__attachment-button--active");
    });

    $("#message_attachment").change(function() {
        $("#attachment-indicator").addClass("new-message__checkin--active");
    });

    $(".js--message-form").submit(function(e) {
        var params = {};

        params["job_id"] = $(".js--message-form").data("id");
        params["authorable_type"] = $(".js--message-form").data("type");
        params["message"] = {};
        params["message"]["body"] = $(".js--message-input").val();
        if ($(".js--message-checkin").is(":checked")) {
            params["message"]["checkin"] = true;
            params["message"]["lat"] = $(".js--message-lat").val();
            params["message"]["lng"] = $(".js--message-lng").val();
        }
        if ($(".js--message-attachment").get(0).files.length > 0) {
            var reader = new FileReader();
            reader.addEventListener("loadend", function() {
                params['message']['attachment_data_uri'] = reader.result;
                App.messages.send(params);
                $("#new-message__loading-notice").html("");
            });
            reader.addEventListener("progress", function() {
                $("#new-message__loading-notice").html("Please wait while your message is uploaded.");
            });
            reader.addEventListener("error", function() {
                $("#new-message__loading-notice").html("There was an error uploading your file. Please try again.");
            });
            reader.readAsDataURL($(".js--message-attachment").get(0).files[0]);
        }
        else {
            App.messages.send(params);
        }
        e.preventDefault();
        return false;
    })
});

function success(position){
    $("#message_lat").val(position.coords.latitude);
    $("#message_lng").val(position.coords.longitude);
    $("#message-submit").removeAttr("disabled");
    $("#new-message__loading-notice").html("Your location has been successfully retrieved. Now you can send your message.");
}

function error(positionError) {
    $("#new-message__loading-notice").html("");
    $("#new-message__validation-errors").html("Error retrieving location: " + positionError.message + ". Please try again");
    $("#message_checkin").prop("checked", false);
    $("#message-submit").removeAttr("disabled");
}

var positionOptions = {
    enableHighAccuracy: true,
    timeout: 10 * 1000, // 10 seconds
    maximumAge: 30 * 1000 // 30 seconds
};

function getGeolocation() {
    var geolocation = null;

    if (window.navigator && window.navigator.geolocation) {
        geolocation = window.navigator.geolocation;
    }

    if (geolocation) {
        geolocation.getCurrentPosition(success, error, positionOptions);
    }
};

var validateMessage = function() {
    $("#new-message__validation-errors").html("");
    $("#new-message__validation-errors").hide();
    var safe = true;

    if ($(".js--message-input").val() == "") {
        safe = false;
    }

    if (!safe) {
        $("#new-message__validation-errors").html("A message is required.");
        $("#new-message__validation-errors").show();
    }

    if (safe) {
        if ($(".js--message-form").length > 0) {
            $(".js--message-form").submit();
            $(".js--message-form")[0].reset();
        }
        else if ($(".js--applicant-message-form").length > 0) {
            $(".js--applicant-message-form").submit();
        }
    }
};


var triggerFileUpload = function () {
    $("#message_attachment").click();
};

var triggerCheckin = function() {
    if ($(".new-message__checkin").hasClass("new-message__checkin--active")) {
        $(".new-message__checkin").removeClass("new-message__checkin--active");
        $("#message_checkin").val("false");
    } else {
        $(".new-message__checkin").addClass("new-message__checkin--active");
        $("#message_checkin").val("true");
    }
};
