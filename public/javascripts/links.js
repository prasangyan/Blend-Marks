$(function() {
    $('.submit-link').click(function() {
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
    });
});