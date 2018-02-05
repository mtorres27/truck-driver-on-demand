$(document).ready(function(){
    $('#admin-companies-table').dataTable({
        columnDefs: [ {
            targets: [5],
            orderable: false
        }
        ]
    });
});
