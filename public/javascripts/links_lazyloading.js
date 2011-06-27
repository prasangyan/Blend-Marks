$(function() {
    var pageIndex = 1;
    function LoadLinks() {
        $.ajax({
            url: "/links/index/" + pageIndex,
            async: true,
            cache: false,
            type: 'GET',
            data: {},
            beforeSend: function() {
            },
            success: function (data) {
                $('.link').append($(data).find('.link').html());
                pageIndex += 1;
                if($(data).find('.link li').size() > 0)
                    scrollLock = false;
            },
            error: function () {
                //setTimeout(LoadLinks(),10000);
            },
            xhrFields: {
                withCredentials: true
            }
        });
    }
    var scrollLock = false;
    $(window).scroll(function() {
        if(!scrollLock)
        {
            var scrollheight = $(window).height() + $(window).scrollTop();
            if( ($.getDocHeight() - scrollheight) < 10 )
            {
                scrollLock = true;
                LoadLinks();
            }
        }
    });
    $.getDocHeight = function(){     var D = document;     return Math.max(Math.max(D.body.scrollHeight,    D.documentElement.scrollHeight), Math.max(D.body.offsetHeight, D.documentElement.offsetHeight), Math.max(D.body.clientHeight, D.documentElement.clientHeight));};
});
