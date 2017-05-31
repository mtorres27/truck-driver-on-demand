document.addEventListener("turbolinks:load", function() {

  $(document).on("mouseover", ".applicant", function( event ) {
    $(this).find(".btn-group").show()
  })

  $(document).on("mouseout", ".applicant", function( event ) {
    $(this).find(".btn-group").hide()
  })
})
