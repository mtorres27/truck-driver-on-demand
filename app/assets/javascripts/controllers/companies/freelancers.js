document.addEventListener("turbolinks:load", function(){
    $("#driver_sort").on('change', function() {
        var val = this.value;
        $("#sort").val(val);
        $("#driver_search_form").submit();
    });

    $("#driver_hired_location").on('change', function() {
        window.location = "/company/drivers/hired?location="+this.value;
    });

    $("#driver_favourites_location").on('change', function() {
        window.location = "/company/drivers/favourites?location="+this.value;
    });
});

function toggleSearch() {
    $("#search-form").removeClass("truckker-hidden-important");
    $("#search-subheader").addClass("truckker-hidden-important");
    $("#search-results").addClass("truckker-hidden-important");
}
