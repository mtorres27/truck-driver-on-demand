$(document).on("turbolinks:load", function () {
    $(".js--time_unit_amount").on("change", function() {
        calculateTotalAmount();
    });

    $(".js--overtime_hours_amount").on("change", function() {
        calculateTotalAmount();
    });
});

function calculateTotalAmount() {
    total = 0;

    if ($(".js--overtime_hours_amount").val() != "") {
        total += $(".js--overtime_hours_amount").val() * $("#js--overtime_pay_rate").val();
    }
    if ($(".js--time_unit_amount").val() != "") {
        total += $(".js--time_unit_amount").val() * $("#js--pay_rate").val();
    }

    $(".js--payment_amount").val(total);
}
