var readyState = function(callback)
{
    var body = document.body;
    
    if(body && body.readyState == 'loaded')
    {
        callback();
    }
    else
    {
        if (window.addEventListener)
        {
            window.addEventListener('load', callback, false);
        }
        else
        {
            window.attachEvent('onload', callback);
        }
    }   
}

readyState(function()
{
    /**
     * Scroll Page
     */
    function scrollPage(page)
    {
        $('#navigation a[data-nav="scroll"]').removeClass('active');

        $('#navigation a[href="#/' + page + '"]').addClass('active');

        scroll = false;

        $('html, body').animate({ scrollTop: $('#' + page).offset().top }, 800, function(){ scroll = true; });
    }

    /**
     * Hash helper
     */
    function parseHash(newHash, oldHash)
    {
        crossroads.parse(newHash);
    }

    /**
     * Position of the intro text
     */
    function introPos()
    {
        $('#intro').css({'margin-top':( ($('.box:first').height() /2) - $('#header').height() - ($('#intro').height() /2) )});
    }

    /**
     * Set Hash silently
     */
    function setHashSilently(hash){
        hasher.changed.active = false;
        hasher.setHash(hash);
        hasher.changed.active = true;
    }

    /**
     * Panel offset
     */
    $('.panel').css({'margin-top':$('#header').height()});

    /**
     * Crossroad
     */
    crossroads.addRoute('{page}', function(page)
    {
            scrollPage(page);
    });
    
    /**
     * Hasher
     */
    hasher.initialized.add(parseHash);
    hasher.changed.add(parseHash);
    hasher.init();
    
    introPos();

    $('#intro').fadeIn();

    /**
     * Window scroll
     */
    $(window).scroll(function()
    {
        var self = this;
        
        if(scroll)
        {
            $('.box').each(function()
            {
                    if(($(self).scrollTop() + $('#header').height()) >= $(this).position().top && ($(self).scrollTop() + $('#header').height()) < ($(this).position().top + $(this).height()))
                    {
                            $("#navigation a[href='#/"+$(this).attr('id') + "']").addClass('active');
                            setHashSilently($(this).attr('id'));
                    }
                    else
                    {
                            $("#navigation a[href='#/"+$(this).attr('id') + "']").removeClass('active');
                    }
            });
        }

        if ($(this).scrollTop() > 100)
        {
            $('#back-top').fadeIn();
        }
        else
        {
            $('#back-top').fadeOut();
        }
    });

    /**
     * Window resize
     */
    $(window).resize(function()
    {
        introPos();
    });

    /**
     * Scroll to top links
     */    
    $('#back-top').click(function(event)
    {
        $('#navigation a[data-nav="scroll"]').removeClass('active');

        var firstItem = $('#navigation a[data-nav="scroll"]:first');
        
        firstItem.addClass('active');

        hasher.setHash(firstItem.attr('href').replace('#/', ''));

        $('html, body').animate({ scrollTop: 0 }, 800);
        
        return false;
    });

    $('#logo').click(function(event)
    {
        $('#navigation a[data-nav="scroll"]').removeClass('active');

        var firstItem = $('#navigation a[data-nav="scroll"]:first');

        firstItem.addClass('active');

        hasher.setHash(firstItem.attr('href').replace('#/', ''));

        $('html, body').animate({ scrollTop: 0 }, 800);
        
        return false;
    });

    /**
     * Vegas background image slider
     */
    $.vegas('slideshow',
    {
        delay: 10000,
        backgrounds: [
            { src: 'http://res.cloudinary.com/espadaysantacruz/image/asset/v1397747834/4-790bde19111ee67334edb8e0e9d8171a.png', fade: 1000 },
            { src: 'http://res.cloudinary.com/espadaysantacruz/image/asset/v1397747830/3-cef97c2481c2d7e8a2ff681313e97522.png', fade: 1000 },
            { src: 'http://res.cloudinary.com/espadaysantacruz/image/asset/v1397747825/2-4bb6c076041e84d7a00a4762b4c89798.png', fade: 1000 },
            { src: 'http://res.cloudinary.com/espadaysantacruz/image/asset/v1397747821/1-332d8245e5269a80b613c4e31a0b86f5.png', fade: 1000 },
        ]
    })('overlay');

    /**
     * Lightbox
     */

    $('#lightbox').on('click', function(event)
    {
        $('#lightbox').hide();
    });

    $('.lightbox_trigger').click(function(event)
    {
        event.preventDefault();
        
        $('#bigimg').attr({'src':$(this).attr("href")});
        $('#lightbox').show();
    });

    /**
     * Flexslider
     */
    $('.flexslider').flexslider();

});