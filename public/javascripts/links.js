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
    $('#Invitepeople').fancybox({
        'transitionIn'	: 'elastic',
		'transitionOut'	: 'elastic',
        'type'			: 'ajax',
        'autoDimensions': 'true',
        'onComplete'    : function() {
            $('form').submit(function() {
                $('.btnsendinvitation').trigger('click');
                return false;
            });
            function submitinvitationform(LnkButton)
            {
                try
                {
                    var errorBox = $('.add-link-form .errorbox');
                    $.ajax({
                        url: "/confirminvitation",
                        timeout: 20000,
                        //datatype: 'xml',
                        cache: false,
                        data: $('form').serialize(),
                        type: "POST",
                        //contentType: "application/xml; charset=utf-8",
                        beforeSend: function() {
                            LnkButton.unbind('click');
                            LnkButton.html('please wait ....')
                        },
                        success: function(data) {
                            if (typeof (data) == typeof (int)) {
                                showError(errorBox,"Unable to reach the server. Check your internet connection. Refresh the page to continue.");
                            }
                            else if(data.indexOf("success") > -1) {
                                showError(errorBox,"Sent invitation mail successfully.");
                            }
                            else
                            {
                               showError(errorBox,data);
                            }
                            LnkButton.html('Send invitation');
                            LnkButton.click(function() {
                                submitinvitationform($(this));
                                return false;
                            });
                        },
                        error: function(request, error) {
                            showError(errorBox,"Unable to reach the server. Refresh the page to continue.");
                            LnkButton.html('Send invitation');
                            LnkButton.click(function() {
                                submitinvitationform($(this));
                                return false;
                            });
                        }});
                }catch(e){alert(e);}
            };
            $('.btnsendinvitation').click(function() {
                submitinvitationform($(this));
                return false;
            });
        }
    });
    $('.submit-link').fancybox({
        'transitionIn'	: 'elastic',
		'transitionOut'	: 'elastic',
        'type'			: 'ajax',
        'autoDimensions': 'true',
        'onComplete'    : function() {
            $('form').submit(function() {
                $('#addlink').trigger('click');
                return false;
            });
            function addLink(LnkButton) {
                try
                {
                    var errorBox = $('.add-link-form .errorbox');
                    $.ajax({
                        url: "/addlink",
                        timeout: 20000,
                        //datatype: 'xml',
                        cache: false,
                        data: $('form').serialize(),
                        type: "POST",
                        //contentType: "application/xml; charset=utf-8",
                        beforeSend: function() {
                            LnkButton.unbind('click');
                            LnkButton.html("please wait ....")
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
                            LnkButton.html('Save Link');
                            LnkButton.click(function() {
                                addLink($(this));
                                return false;
                            });
                        },
                        error: function(request, error) {
                            showError(errorBox,"Unable to reach the server. Refresh the page to continue.");
                            LnkButton.html('Save Link');
                            LnkButton.click(function() {
                                addLink($(this));
                                return false;
                            });
                        }});
                }catch(e){alert(e);}
            };
            $('#addlink').click(function() {
                addLink($(this));
                return false;
            });
        }
    });
    function showError(obj,data)
     {
        obj.html(data);
        obj.slideDown(500);
        obj.delay(3000).slideUp(500);
     }
    $('#searchcriteria').keypress(function(e)
    {
        if (e.which == 13)
        {
            if($.trim($(this)[0].value) != "")
                window.location = "/search/" + $(this)[0].value;
        }
    });
    $('#SearchButton').click(function() {
        if($.trim($('#searchcriteria')[0].value) != "")
            window.location = "/search/" + $('#searchcriteria')[0].value;
    });
});