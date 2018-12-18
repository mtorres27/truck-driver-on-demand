document.addEventListener("turbolinks:load", function(){
    $('.subscribe').click(function(e){
        e.stopPropagation();
        e.preventDefault();
        if($(this).hasClass('free')){
            $(this).parent('form').submit()
        }
        else{
            $(this).parent().find('.stripe-button-el').trigger('click')
        }
    });

    $('.js--radio-monthly-subscriptions').click(function(){
        $('.js--radio-yearly-subscriptions').prop('checked', false);
        $('.js--plans-monthly-subscriptions').removeClass('hidden');
        $('.js--plans-yearly-subscriptions').addClass('hidden');
    });

    $('.js--radio-yearly-subscriptions').click(function(){
        $('.js--radio-monthly-subscriptions').prop('checked', false);
        $('.js--plans-monthly-subscriptions').addClass('hidden');
        $('.js--plans-yearly-subscriptions').removeClass('hidden');
    });
});
