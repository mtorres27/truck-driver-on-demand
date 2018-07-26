$(document).on("turbolinks:load", function () {
    $("#js--time_unit_amount").on("change", function() {
        $(".js--payment_amount").val($(this).val() * $("#js--pay_rate").val());
    })
});
