document.addEventListener("turbolinks:load", function(){
    $("#freelance_distance").on('change', function() {
        var val = this.value;
        $("#distance").val(val);
        $("#freelancer_search_form").submit();
    });

    $("#freelance_sort").on('change', function() {
        var val = this.value;
        $("#sort").val(val);
        $("#freelancer_search_form").submit();
    });

    $("#freelancer_hired_location").on('change', function() {
        window.location = "/company/freelancers/hired?location="+this.value;
    });

    $("#freelancer_favourites_location").on('change', function() {
        window.location = "/company/freelancers/favourites?location="+this.value;
    });

    $("#show_avatar_only").on('change', function(){
        updateFreelancers();
    });

    updateFreelancers();
});

function updateFreelancers() {
    if ($("#show_avatar_only").is(":checked")) {
        $(".freelancer_without_avatar").hide();
        $(".freelancer_with_avatar").show();
    }
    else {
        $(".freelancer_without_avatar").show();
        $(".freelancer_with_avatar").show();
    }
}
