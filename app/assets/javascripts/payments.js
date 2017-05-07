$(document).on('turbolinks:load', function () {
    initPaymentInvoiceAutocomplete();
    initPaymentClientAutocomplete();
});

function initPaymentInvoiceAutocomplete () {
    $('#payment_invoice').autocomplete({
        source: $('#payment_invoice').data('autocomplete-source'),
        select: function (event, ui) {
            $("#payment_invoice").val(ui.item.label);
            $("#payment_invoice_id").val(ui.item.id);
        }
    })
}

function initPaymentClientAutocomplete () {
    $('#payment_client').autocomplete({
        source: $('#payment_client').data('autocomplete-source'),
        select: function (event, ui) {
            $("#payment_client").val(ui.item.label);
            $("#payment_client_id").val(ui.item.id);
        }
    })
}
