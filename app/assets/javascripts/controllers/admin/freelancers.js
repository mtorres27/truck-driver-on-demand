$(document).ready(function(){
    $('#admin-freelancers-table').dataTable({
        columnDefs: [ {
            targets: [5],
            orderable: false
        }
        ]
    });
});