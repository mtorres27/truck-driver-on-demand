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
        e.preventDefault();
        if ($(".js--message-input").val() != ""){
            var params = {};
            params["chat_room_id"] = $(".js--message-form").data("id");
            params["company_id"] = $(".js--message-form").data("company");
            params["driver_id"] = $(".js--message-form").data("driver");
            params["authorable_type"] = $(".js--message-form").data("type");
            params["message"] = {};
            params["message"]["body"] = $(".js--message-input").val();
            if ($("#message_job_id").length) {
                params["message"]["job_id"] = $("#message_job_id").val();
            }
            if ($(".js--message-attachment").get(0).files.length > 0) {
                var reader = new FileReader();
                reader.addEventListener("loadend", function() {
                    params['message']['attachment_data_uri'] = reader.result;
                    App.messages.send(params);
                    $("#new-message__loading-notice").html("File uploaded successfully.");
                    $(".js--message-attachment").val("");
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
        }
        return false;
    });
});

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
            $(".js--message-input").val("");
        }
    }
};


var triggerFileUpload = function () {
    $("#message_attachment").click();
};
