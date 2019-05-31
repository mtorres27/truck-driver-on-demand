document.addEventListener("turbolinks:load", function(){

    if ($(".js--message-form").length > 0) {
        if (window.matchMedia("(max-width: 768px)").matches) {
            window.scrollTo(0,document.body.scrollHeight);
        }
        if (!App.messages) {
            App.messages = App.cable.subscriptions.create(
                {
                    channel: "MessagesChannel",
                    chat_room_id: $(".js--message-form").data("id")
                },
                {
                    connected: function() {
                        console.log("connected to messages_channel");
                        // Called when the subscription is ready for use on the server
                    },

                    disconnected: function() {
                        console.log("disconnected");
                        // Called when the subscription has been terminated by the server
                    },

                    received: function(data) {
                        console.log("received");
                        // Called when there's incoming data on the websocket for this channel
                        $(".js--messages-beginning").hide();
                        $(".js--freelancer-job__message-history").append(data.message);
                        if (window.matchMedia("(max-width: 768px)").matches) {
                            window.scrollTo(0,document.body.scrollHeight);
                        }
                    }
                });
        }
    }
    else {
        window.scrollTo(0,0);
    }
});
