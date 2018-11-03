$(document).on('turbolinks:load', function () {
    $('#address_is_job_address').on('change', function() {
        if ( this.checked )
        {
            $(".job-order-container").show();
        }
        else
        {
            $(".job-order-container").hide();
        }
    });

});
