$(document).on("turbolinks:load", function () {
  if ($("#driver_driver_profile_attributes_driver_type_independent_contractor").is(":checked")){
    $("#driver_driver_profile_attributes_business_name").removeAttr('disabled');
  }

  $("#driver_driver_profile_attributes_driver_type_employee").on("click", function(){
    $("#driver_driver_profile_attributes_business_name").val("");
    $("#driver_driver_profile_attributes_business_name").attr('disabled', true);
  });

  $("#driver_driver_profile_attributes_driver_type_independent_contractor").on("click", function(){
    $("#driver_driver_profile_attributes_business_name").removeAttr('disabled');
  });
});