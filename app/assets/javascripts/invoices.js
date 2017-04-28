$(document).on('turbolinks:load', function () {
    $('#invoice_job_address').autocomplete({
        source: $('#invoice_job_address').data('autocomplete-source'),
        select: function(event, ui) {
            $( "#invoice_job_address" ).val( ui.item.label );
            $( "#invoice_job_address_id" ).val( ui.item.id );
        }
    })
});
