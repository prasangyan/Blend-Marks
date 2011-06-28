$(function() {
    var pageIndex = 1;
    function LoadLinks() {
        $.ajax({
            url: $.trim($('#pageReference').html()) + "/" + pageIndex, //"/links/index/" + pageIndex,
            async: true,
            cache: false,
            type: 'GET',
            data: {},
            contentType: 'text/html; charset=utf-8',
            dataType: 'text/html',
            beforeSend: function() {
                 $('.AjaxLoadingPanel').fadeIn(500);  
            },
            success: function (data) {
                $('#main').append($(data).html());
                pageIndex += 1;
                if($(data).find('.link li').size() > 0)
                {
                    scrollLock = false;
                }
                $('.AjaxLoadingPanel').fadeOut(500);
            },
            error: function (e) {
                //setTimeout(LoadLinks(),10000);
                $('.AjaxLoadingPanel').fadeOut(500);
            }
        });
    }
    var scrollLock = false;
    $(window).scroll(function() {
        if(!scrollLock)
        {
            var scrollheight = $(window).height() + $(window).scrollTop();
            var docHeight = $.getDocHeight() ;
            if( (docHeight - scrollheight) < 10 )
            {
                scrollLock = true;
                LoadLinks();
            }
        }
    });
    $.getDocHeight = function(){     var D = document;     return Math.max(Math.max(D.body.scrollHeight,    D.documentElement.scrollHeight), Math.max(D.body.offsetHeight, D.documentElement.offsetHeight), Math.max(D.body.clientHeight, D.documentElement.clientHeight));};
});
