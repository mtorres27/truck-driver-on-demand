companies_table = null;

document.addEventListener("turbolinks:load", function(){

    $.fn.dataTable.moment('MMM D, Y');
    $.fn.dataTable.moment('MMM D, YYYY');

    if ($('#admin-companies-table_wrapper').length == 0) {
        companies_table = $('#admin-companies-table').dataTable({
            order: [],
            searching: true,
            info: false,
            columnDefs: [ {
                targets: [6],
                targets: [5, 6],
                orderable: false
            }
            ]
        });
        $('#admin-companies-table_filter').hide();
    }

    $('#filter-by-disabled-select').on('change', function(){
        if (this.value == 'all'){
            companies_table.fnFilter('', 5);
        }
        else if (this.value == 'enabled') {
            companies_table.fnFilter('false', 5);
        }
        else if (this.value == 'disabled') {
            companies_table.fnFilter('true', 5);
        }
    })
});
