document.addEventListener("turbolinks:load", function(){

    if ($(".js--notifications").length > 0) {
        if (!App.notifications) {
            App.notifications = App.cable.subscriptions.create(
                {
                    channel: "NotificationsChannel",
                    notifications_stream_id: $(".js--notifications").data("id")
                },
                {
                    connected: function() {
                        // Called when the subscription is ready for use on the server
                    },

                    disconnected: function() {
                        // Called when the subscription has been terminated by the server
                    },

                    received: function(data) {
                        // Called when there's incoming data on the websocket for this channel
                        if (data.count > 0) {
                            $(".js--notifications-count").show();
                            $(".js--notifications").html(data.count);
                        }
                    }
                });
            setInterval(function() { App.notifications.send({'id': $(".js--notifications").data("id")}); }, 10000);
        }
        if ($(".js--notifications-count").html() == 0) {
            $(".js--notifications-count").hide();
        }
    }
});
