$(document).on('turbolinks:load', function () {
    initNavLinkListener();
    initAddressServiceListener();
    showActiveSection();
});

function initAddressServiceListener(){
    var $addServiceLink = $('.add-service-link');

    $('#address_service_select').on('change', function(){
        if(this.value !== ''){
            $addServiceLink.removeClass('hidden');
            $addServiceLink.attr('href', '/addresses/' + this.value + '/service_prices/new')
        } else {
            $addServiceLink.addClass('hidden');
        }
    })
}

function initNavLinkListener() {
    $('.js-client-details-link').on('click', function(){
        var sectionName = this.id;
        showSelectedSection(sectionName);
        updateNavLink(sectionName);
    })
}

function showSelectedSection(sectionName){
    var sectionSelector = '.client-detail-section.' + sectionName;
    $('.client-detail-section').addClass('hidden');
    $(sectionSelector).removeClass('hidden');
}

function updateNavLink(sectionName) {
    var linkSelector = '.vertical-nav-link.' + sectionName;
    $('.vertical-nav-link').removeClass('active');
    $(linkSelector).addClass('active');
}

function showActiveSection() {
    var activeSection = $('#active_section').val();
    showSelectedSection(activeSection);
    updateNavLink(activeSection);
}
