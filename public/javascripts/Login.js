$(function() {
    $('#BtnFormSubmit').click(function() {
        $('input[type="password"]')[0].value = $.trim($('input[type="password"]')[0].value);
        $('form').submit();
    });
    $('#user_session_password,#user_password_confirmation').keypress(function(e)
    {
        if (e.which == 13)
            $('form').submit();
    });
});

setTimeout(hideflash,5000);
    function hideflash()
    {
      $('.Flash_or_Notice').fadeOut(1000);
    }