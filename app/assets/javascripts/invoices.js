$(document).on('turbolinks:load', function () {
    initInvoiceAddressAutocomplete();
    hideOtherServiceTextBoxes();
    toggleOtherServiceTextBoxes();
});

function initInvoiceAddressAutocomplete () {
    $('#invoice_job_address').autocomplete({
        source: $('#invoice_job_address').data('autocomplete-source'),
        select: function(event, ui) {
            $( "#invoice_job_address" ).val( ui.item.label );
            $( "#invoice_job_address_id" ).val( ui.item.id );
        }
    });
}

function hideOtherServiceTextBoxes () {
    $("#other_text_box").hide();
    $("#other_price_box").hide();
}

function toggleOtherServiceTextBoxes() {
    $('#invoice_item_name').on('change', function(ev) {
        var selected_item = $(ev.currentTarget).val();
        console.log("Your select value is " + selected_item);
        if ( selected_item === 'Other' )
        {
            $("#other_text_box").show();
            $("#other_price_box").show();
            $('.invoice_item_price').hide();
        }
        else
        {
            $("#other_text_box").hide();
            $("#other_price_box").hide();
            $('.invoice_item_price').show();
        }
    }).trigger('change');
}
