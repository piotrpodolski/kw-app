(function ($) {
    "use strict";
    $('#example').dataTable({
        "order": [
            [3, "desc"]
        ]
    });
})(jQuery);
(function ($) {
    "use strict";
    $('#footable-res2').footable().bind('footable_filtering', function (e) {
        var selected = $('.filter-status').find(':selected').text();
        if (selected && selected.length > 0) {
            e.filter += (e.filter && e.filter.length > 0) ? ' ' + selected : selected;
            e.clear = !e.filter;
        }
    });
    $('.clear-filter').click(function (e) {
        e.preventDefault();
        $('.filter-status').val('');
        $('table.demo').trigger('footable_clear_filter');
    });
    $('.filter-status').change(function (e) {
        e.preventDefault();
        $('table.demo').trigger('footable_filter', {
            filter: $('#filter').val()
        });
    });
    $('.filter-api').click(function (e) {
        e.preventDefault();
        //get the footable filter object
        var footableFilter = $('table').data('footable-filter');
        alert('about to filter table by "tech"');
        //filter by 'tech'
        footableFilter.filter('tech');
        //clear the filter
        if (confirm('clear filter now?')) {
            footableFilter.clearFilter();
        }
    });
})(jQuery);