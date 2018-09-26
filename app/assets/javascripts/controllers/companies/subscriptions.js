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
});
