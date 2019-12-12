$(document).on("turbolinks:load", function () {
  if ($(".js--accept-terms-checkbox").is(":checked")){
    enableSubmitButton();
  } else{
    disableSubmitButton();
  }

  $(".js--accept-terms-checkbox").on("click", function(){
    if ($(this).is(":checked")){
      enableSubmitButton();
    } else {
      disableSubmitButton();
    }
  });
});

function enableSubmitButton() {
  $(".js--accept-terms-submit-button").removeAttr('disabled');
}

function disableSubmitButton() {
  $(".js--accept-terms-submit-button").attr('disabled', true);
}
