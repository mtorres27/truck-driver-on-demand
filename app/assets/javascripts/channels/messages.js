document.addEventListener("turbolinks:load", function(){

    if ($(".js--message-form").length > 0) {
        if (!App.messages) {
            App.messages = App.cable.subscriptions.create(
                {
                    channel: "MessagesChannel",
                    chat_room_id: $(".js--message-form").data("id")
                },
                {
                    connected: function() {
                        console.log("connected");
                        // Called when the subscription is ready for use on the server
                    },

                    disconnected: function() {
                        console.log("disconnected");
                        // Called when the subscription has been terminated by the server
                    },

                    received: function(data) {
                        console.log("received");
                        // Called when there's incoming data on the websocket for this channel
                        $(".js--freelancer-job__message-history").append(data.message);
                    }
                });
        }
    }
});
