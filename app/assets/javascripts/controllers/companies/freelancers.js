document.addEventListener("turbolinks:load", function(){
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
});

function toggleSearch() {
    $("#search-form").removeClass("truckker-hidden-important");
    $("#search-subheader").addClass("truckker-hidden-important");
    $("#search-results").addClass("truckker-hidden-important");
}
