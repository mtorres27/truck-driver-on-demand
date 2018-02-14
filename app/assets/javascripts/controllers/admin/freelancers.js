freelancers_table = null;

document.addEventListener("turbolinks:load", function(){

    $.fn.dataTable.moment('MMM D, Y');
    $.fn.dataTable.moment('MMM D, YYYY');

    if ($('#admin-freelancers-table_wrapper').length == 0) {
        freelancers_table = $('#admin-freelancers-table').dataTable({
            order: [],
            searching: true,
            info: false,
            columnDefs: [ {
                targets: [6, 7],
                orderable: false
            }
            ]
        });
        $('#admin-freelancers-table_filter').hide();
    }

    $('#filter-by-disabled-select').on('change', function(){
        if (this.value == 'all'){
            freelancers_table.fnFilter('', 6);
        }
        else if (this.value == 'enabled') {
            freelancers_table.fnFilter('false', 6);
        }
        else if (this.value == 'disabled') {
            freelancers_table.fnFilter('true', 6);
        }
    })
});
