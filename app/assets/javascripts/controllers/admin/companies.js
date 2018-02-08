document.addEventListener("turbolinks:load", function(){
    if ($('#admin-companies-table_wrapper').length == 0) {
        $('#admin-companies-table').dataTable({
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
