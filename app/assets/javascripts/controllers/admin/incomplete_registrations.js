document.addEventListener("turbolinks:load", function(){

    $.fn.dataTable.moment('MMM D, Y');
    $.fn.dataTable.moment('MMM D, YYYY');

    if ($('#admin-incomplete-registrations-table_wrapper').length == 0) {
        freelancers_table = $('#admin-incomplete-registrations-table').dataTable({
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
