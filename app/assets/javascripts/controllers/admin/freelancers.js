drivers_table = null;

document.addEventListener("turbolinks:load", function(){
    $('#search_filter_by_disabled').on('change', function(){
        console.log("A");
        $('.js--admin-search-form').submit();
    });

    $('#search_sort').on('change', function(){
        console.log("A");
        $('.js--admin-search-form').submit();
    });
});
