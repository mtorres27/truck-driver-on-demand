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
                        $(".js--notifications").html(data.message);
                        if (data.count > 0) {
                            $(".js--notifications-icon").addClass("zmdi-notifications-active");
                            $(".js--notifications-icon").removeClass("zmdi-notifications-none");
                            $(".js--notifications-count").html(data.count)
                            $(".js--notifications-count").show();
                        } else {
                            $(".js--notifications-icon").removeClass("zmdi-notifications-active");
                            $(".js--notifications-icon").addClass("zmdi-notifications-none");
                            $(".js--notifications-count").hide();
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
