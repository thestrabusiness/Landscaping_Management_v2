$(document).on('turbolinks:load', function () {
    initPaymentEstimateAutocomplete();
});

function initPaymentEstimateAutocomplete () {
    $('#estimate_address').autocomplete({
        source: $('#estimate_address').data('autocomplete-source'),
        select: function (event, ui) {
            $("#estimate_address").val(ui.item.label);
            $("#estimate_address_id").val(ui.item.id);
        }
    })
}
