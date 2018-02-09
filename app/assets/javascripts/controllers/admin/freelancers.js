document.addEventListener("turbolinks:load", function(){
    if ($('#admin-freelancers-table_wrapper').length == 0) {
        $('#admin-freelancers-table').dataTable({
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
