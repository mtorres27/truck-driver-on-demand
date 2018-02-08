document.addEventListener("turbolinks:load", function(){
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
