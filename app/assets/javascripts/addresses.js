$(document).on('turbolinks:load', function () {
    $('#address_is_job_address').on('change', function() {
        if ( this.checked )
        {
            $(".address_position").show();
        }
        else
        {
            $(".address_position").hide();
        }
    });

});
