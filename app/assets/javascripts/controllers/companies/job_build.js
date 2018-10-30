document.addEventListener("turbolinks:load", function(){
    $(".js--job-required-field").on("change", function(){
        filled_count = 0
        $(".js--job-required-field").each(function() {
            if ($(this).val() != "") {
                filled_count += 1;
            }
        });
        if (filled_count == 5) {
            $(".js--job-publish-button").removeClass('disabled');
        } else {
            $(".js--job-publish-button").addClass('disabled');
        }
    })
});

function saveAsDraft() {
    $(".js--save_draft").val(true);
    $(".js--job_form").submit();
}
