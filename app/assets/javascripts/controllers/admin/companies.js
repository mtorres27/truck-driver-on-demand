document.addEventListener("turbolinks:load", function(){
    if ($('#admin-companies-table_wrapper').length == 0) {
        $('#admin-companies-table').dataTable({
            searching: false,
            info: false,
            columnDefs: [ {
                targets: [5],
                orderable: false
            }
            ]
        });
    }
});
