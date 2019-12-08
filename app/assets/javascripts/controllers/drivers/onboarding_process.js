$(document).on("turbolinks:load", function () {
  if ($("#driver_driver_profile_attributes_driver_type_independent_contractor").is(":checked")){
    showIndependentContractorFields();
  }

  $("#driver_driver_profile_attributes_driver_type_employee").on("click", function(){
    hideIndependentContractorFields();
  });

  $("#driver_driver_profile_attributes_driver_type_independent_contractor").on("click", function(){
    showIndependentContractorFields();
  });
});

function showIndependentContractorFields() {
  $("#driver_driver_profile_attributes_business_name").removeClass('d-none');
  $(".driver_driver_profile_business_name").removeClass('d-none');
  $("#driver_driver_profile_attributes_hst_number").removeClass('d-none');
  $(".driver_driver_profile_hst_number").removeClass('d-none');
}

function hideIndependentContractorFields() {
  $("#driver_driver_profile_attributes_business_name").val("");
  $("#driver_driver_profile_attributes_business_name").addClass('d-none');
  $(".driver_driver_profile_business_name").addClass('d-none');
  $("#driver_driver_profile_attributes_hst_number").val("");
  $("#driver_driver_profile_attributes_hst_number").addClass('d-none');
  $(".driver_driver_profile_hst_number").addClass('d-none');
}
