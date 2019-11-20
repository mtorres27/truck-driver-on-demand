$(document).on("turbolinks:load", function () {
  $(".js--password-field").addClass("d-none");
  $(".js--email-login-submit-button").addClass("d-none");
  $(".js--phone-login-submit-button").addClass("d-none");
  $(".js--login-code-field").addClass("d-none");
  $(".js--email-login").addClass("d-none");
  $("#js--enter-password-button").on('click', function() {
    showPasswordInput();
  });
  $("#js--enter-login-code-button").on('click', function() {
    sendConfirmationCode($("#user_phone_number").val());
  });
  $("#js--phone-login-nav").on('click', function() {
    showPhoneLogin();
  });
  $("#js--email-login-nav").on('click', function() {
    showEmailLogin();
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
  $(".js--phone-login").removeClass("d-none");
  $("#js--email-login-nav").removeClass("active");
  $(".js--email-login").addClass("d-none");
  $(".js--phone-login-nav").addClass("active");
}

function showEmailLogin() {
  $(".js--email-login").removeClass("d-none");
  $("#js--phone-login-nav").removeClass("active");
  $(".js--phone-login").addClass("d-none");
  $(".js--email-login-nav").addClass("active");
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
