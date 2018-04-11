document.addEventListener("turbolinks:load", function() {
    $("#message_checkin").on("change", function() {
        if ($(this).is(":checked")){
            $("#message-submit").attr("disabled", true);
            $("#new-message__loading-notice").html('Please wait while we retrieve your location.');
            getGeolocation()
        }
        else {
            $("#message_lat").val("");
            $("#message_lng").val("");
            $("#new-message__loading-notice").html("");
        }
    });
});

function success(position){
    $("#message_lat").val(position.coords.latitude);
    $("#message_lng").val(position.coords.longitude);
    $("#message-submit").removeAttr("disabled");
    $("#new-message__loading-notice").html("Your location has been successfully retrieved. Now you can send your message.");
}

function error(positionError) {
    $("#new-message__loading-notice").html("");
    $("#new-message__validation-errors").html('Error retrieving location: ' + positionError.message + '. Please try again');
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
}
