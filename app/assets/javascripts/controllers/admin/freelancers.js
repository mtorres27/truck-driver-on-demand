$(document).on("turbolinks:load", function(){
    $('#admin-freelancers-table').dataTable({
        searching: false,
        info: false,
        columnDefs: [ {
            targets: [5],
            orderable: false
        }
        ]
    });
});