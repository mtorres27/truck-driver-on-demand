$(document).on("turbolinks:load", function () {
  $(".js--password-field").addClass("d-none");
  $(".js--email-login-submit-button").addClass("d-none");
  $(".js--phone-login-submit-button").addClass("d-none");
  $(".js--login-code-field").addClass("d-none");
  $(".js--phone-field").addClass("d-none");
  $(".js--email-field").addClass("d-none");

  $("#js--login-check-email-or-phone").on("click", function(){
    if ($("#email_or_phone").val().includes("@")) {
      showEmailLogin();
      $("#user_email").val($("#email_or_phone").val());
      showPasswordInput();
    } else {
      sendConfirmationCode($("#email_or_phone").val());
      showPhoneLogin();
      $("#user_phone_number").val($("#email_or_phone").val());
      showConfirmationCodeInput();
    }
  })

  $("#js--resend-code").on("click", function() {
    sendConfirmationCode($("#user_phone_number").val());
    phone = $("#email_or_phone").val();
    $(".js--message").html("New confirmation code sent to " + phone.replace(phone.substring(0,7), "********") + ".");
  });
});

function showPasswordInput() {
  $(".js--password-field").removeClass("d-none");
  $(".js--email-login-submit-button").removeClass("d-none");
  $(".js--email-field").addClass("d-none");
  $(".js--enter-password-button").addClass("d-none");
}

function showConfirmationCodeInput() {
  $(".js--login-code-field").removeClass("d-none");
  $(".js--phone-login-submit-button").removeClass("d-none");
  $(".js--phone-field").addClass("d-none");
  $(".js--enter-login-code-button").addClass("d-none");
}

function showPhoneLogin() {
  phone = $("#email_or_phone").val()
  $(".js--message").html("Enter the code sent to " + phone.replace(phone.substring(0,7), "********") + ".");
  $(".js--phone-login").removeClass("d-none");
  $(".js--email-or-phone-fields").addClass("d-none");
}

function showEmailLogin() {
  $(".js--message").html("Enter your truckker password");
  $(".js--email-login").removeClass("d-none");
  $(".js--email-or-phone-fields").addClass("d-none");
}

function sendConfirmationCode(phoneNumber) {
  const post_url = "/send_login_code/" + phoneNumber;
  $.ajax({
    type: "POST",
    url: post_url,
    success: function() {
      showConfirmationCodeInput();
    },
    error: function() {
      $(".js--message").html("An unexpected error occurred.");
    }
  });
}
