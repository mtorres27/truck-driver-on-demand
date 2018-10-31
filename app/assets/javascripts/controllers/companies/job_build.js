document.addEventListener("turbolinks:load", function(){
    countFilledItems();

    $(".js--job-required-field").on("change", function(){
        countFilledItems();
    })
});

function saveAsDraft() {
    $(".js--save_draft").val(true);
    $(".js--job_form").submit();
}

function countFilledItems() {
    filled_count = 0
    $(".js--job-required-field").each(function() {
        if ($(this).val() != "") {
            filled_count += 1;
        }
    });
    if (filled_count == 5) {
        $(".js--job-publish-button").removeClass('disabled');
        $(".js--job-publish-button").removeAttr('disabled');
    } else {
        $(".js--job-publish-button").addClass('disabled');
        $(".js--job-publish-button").attr('disabled', true);
    }
}
