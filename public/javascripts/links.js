$(function() {
    /*$('.submit-link').click(function() {
        $('.add-link-form').css({
            "position": "absolute",
            "top": $('.submit-link').position().top + $('.submit-link').height() + 10,
            "left": $('.submit-link').position().left + ($('.submit-link').width() /2)  - ($('.add-link-form').outerWidth() / 2)
        }).fadeIn(300).show();
        return false;
    });
    $('#lnkcancel').click(function() {
        $('.add-link-form').fadeOut(300);
        return false;
    }); */
    $('.submit-link').fancybox({
        'transitionIn'	: 'elastic',
		'transitionOut'	: 'elastic',
        'type'			: 'ajax',
        'autoDimensions': 'true',
        'onComplete'    : function() {
            $('#addlink').click(function() {
                try
                {
                    This = $('#addlink');
                    errorBox = $('.add-link-form .errorbox');
                    $.ajax({
                        url: "/addlink",
                        timeout: 10000,
                        //datatype: 'xml',
                        cache: false,
                        data: $('form').serialize(),
                        type: "POST",
                        //contentType: "application/xml; charset=utf-8",
                        beforeSend: function() {
                            This.val("Adding......")
                        },
                        success: function(data) {
                            if (typeof (data) == typeof (int)) {
                                showError(errorBox,"Unable to reach the server. Check your internet connection. Refresh the page to continue.");
                            }
                            else if(data.indexOf("success") > -1) {
                                window.location = "/";
                            }
                            else
                            {
                               showError(errorBox,data);
                            }
                        },
                        error: function(request, error) {
                            showError(errorBox,"Unable to reach the server. Refresh the page to continue.");
                            This.val("Add link");
                        }});
                }catch(e){alert(e);}
            });
        }
    });
    function showError(obj,data)
     {
        obj.html(data);
        obj.slideDown(500);
        obj.delay(3000).slideUp(500);
     }
});