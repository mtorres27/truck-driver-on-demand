document.addEventListener("turbolinks:load", function(){

    $.fn.dataTable.moment('MMM D, Y');
    $.fn.dataTable.moment('MMM D, YYYY');

    if ($('#admin-freelancers-table_wrapper').length == 0) {
        $('#admin-freelancers-table').dataTable({
            order: [],
            searching: false,
            info: false,
            columnDefs: [ {
                targets: [6],
                orderable: false
            }
            ]
        });
    }
});
