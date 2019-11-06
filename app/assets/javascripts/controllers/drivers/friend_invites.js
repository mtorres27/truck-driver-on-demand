$(document).on("turbolinks:load", function () {
    $("#add_invite_button").on("click", function (){
        $("#friend-invites__submit").removeAttr('disabled')
    })
});