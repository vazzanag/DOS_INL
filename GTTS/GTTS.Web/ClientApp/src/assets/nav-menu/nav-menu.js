function loadNavigationMenuCards() {
    // change icon when mouseover
    var target = $(".menu-wrapper-gtts");
    target.hover(
        function () {
            var span = $(this).find('span');
            var icon = $(this).find('i');
            span.text("");
            icon.addClass("fas fa-bars fa-2x");
            $(this).css('width', '100px');
            $(this).css('padding-left', '40px');
        }, function () {
            if (!($("#navMenuModal").data('bs.modal') || {}).isShown) {
                $(this).find('i').removeClass("fas fa-bars fa-2x");
                $(this).css('width', '90px');
                $(this).css('padding-left', '0px');
                $(this).find('span').html('<img src="/assets/images/cactus_0.png" height="16" width="16"/><span style="font-weight: bold">GTTS</span>');
            }
            else {
                $(this).css('width', '100px');
                $(this).css('padding-left', '40px');
            }
        }
    );
    // use animation
    $('.menu-wrapper-gtts').on('click', function (e) {
        e.preventDefault();
        $(".menu-wrapper-gtts").mouseover();
        animateNavigationMenuCardsCSS('.iconAnimate', 'rotateIn', function () {

        });
    });

    $('#navMenuModal').on('show.bs.modal', function () {
        $(".menu-wrapper-gtts").mouseover();
        $(this).find('.modal-content').css('background-color', 'transparent');
        $(this).find('.modal-content').css('box-shadow', 'none');
        $(this).find('.modal-body').find('.panel').css('border', 'none!important');
    });

    $('#navMenuModal').on('show.bs.modal', function () {
        // align modules        
        $('.animate-wrapper').show();
        animateNavigationMenuCardsCSS('.animate-wrapper', 'fadeInLeft', function () {
            $('.linkAnimation').on('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                var link = $(this);
                var module = link.attr('data-module');
                animateNavigationMenuCardsCSS('.animate-' + module, 'flipInY', function () {
                    //window.location.href = link.attr('data-target');
                    $('#NavigateTo').val(link.attr('data-target'));
                    $('#navMenuModal').modal('hide');
                });
            });
        });
    });


    $('#navMenuModal').on('hidden.bs.modal', function () {
        $(".menu-wrapper-gtts").mouseout();
        $(this).find('.modal-content').css('background-color', '#fff');
    });
}

// animated icon - documentation in: https://github.com/daneden/animate.css#slow-slower-fast-and-faster-class
function animateNavigationMenuCardsCSS(element, animationName, callback) {
    var node = document.querySelector(element);
    if (animationName === 'rotateIn')
        node.classList.add('animated', animationName, 'fast');
    else
        node.classList.add('animated', animationName);

    function handleAnimationEnd() {
        if (animationName === 'rotateIn')
            node.classList.remove('animated', animationName, 'fast');
        else
            node.classList.remove('animated', animationName);
        node.removeEventListener('animationend', handleAnimationEnd)

        if (typeof callback === 'function') callback()
    }

    node.addEventListener('animationend', handleAnimationEnd)
}
