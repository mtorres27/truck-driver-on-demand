$(document).on("turbolinks:load", function(){
    $('#admin-companies-table').dataTable({
        searching: false,
        paging: false,
        info: false,
        columnDefs: [ {
            targets: [5],
            orderable: false
        }
        ]
    });
});
