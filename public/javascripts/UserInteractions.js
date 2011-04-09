setTimeout(hideflash,5000);
    function hideflash()
    {
      $('.Flash_or_Notice').fadeOut(1000);
    }
$(function() {

    // For Adding new link
    $('.tbladdlinkform .data-entry-form').hide();
    $('#lnkaddnewlink').click(function() {
       $('.tbladdlinkform .data-entry-form').slideDown(500);
       setTimeout(function() { $('.tbladdlinkform input[type="text"]').eq(0).focus(); $('#lnkaddnewlink').hide(50);},300);
    });
    $('#lnkcancel').click(function() {
        $('.tbladdlinkform .data-entry-form').slideUp(500);
        setTimeout(function() {$('#lnkaddnewlink').show(50);},200);
    });

    if($('#txtlink').size() > 0 && $('#txtlink')[0].value != "")
    {
        $('#lnkaddnewlink').trigger('click');
    }
    //For new tag select box
    /*$('.select-field').bind('change',function() {
        var selectedindex = $('.tbladdlinkform select :selected').val();
        if (selectedindex == 0)
        {
            $('.text-field-new-tag').attr('disabled',false);
            $('.text-field-new-tag').focus();
        }
        else
        {
            $('.text-field-new-tag').attr('disabled',true);
        }
    });

    $('.text-field-new-tag').attr('disabled',true);*/

   
    function showError(element,text)
    {
        element.html('').append(text).slideDown(500).delay(3000).slideUp(500);
    }

    // For form validation and Ajax requestings

    // for keeping Tag list into an array
    var tagArray = new Array();
    $('.select-field option').each(function() {
        tagArray.push($(this)[0].text.toLowerCase());
    });

    // for adding link
    $('.tbladdlinkform input[type="button"]').click(function() {
        var errorBox  = $('.tbladdlinkform .errorbox');
        var link = $('#txtlink')[0].value;
        link = $.trim(link);
        var description = $('#txtdescription')[0].value;
        var This = $(this);
        var tag = $('.tbladdlinkform select :selected').text();
        var tagvalue = $('.tbladdlinkform select :selected').val();
        var newtag = $(".text-field-new-tag")[0].value;
        newtag = $.trim(newtag);
        if(link!= "")
        {
                if (newtag != "")
                {
                    var arrayindex = $.inArray(newtag.toLowerCase(),tagArray);
                    if (arrayindex == -1)
                    {
                        tag = newtag;
                    }
                    else
                    {
                        showError(errorBox,"The tag already exists, try new one.");
                        return;
                    }
                }
            // Sending here
            $.ajax({
                url: "/links",
                timeout: 10000,
                //datatype: 'xml',
                cache: false,
                data: $('.tbladdlinkform form').serialize(),
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
                        var splitstrings = data.split('#');
                        showError(errorBox,"Link added successfully.");
                        //Adding new tag into array
                        if (newtag != '')
                        {
                            tagArray.push(newtag);
                            if (splitstrings.length > 0)
                            {
                                $('.tbladdlinkform select').append('<option value=' + splitstrings[1] + ">" + tag + "</option>");
                                $('.tbladdlinkform select option').each(function() {
                                    if ($(this).val() == splitstrings[1])
                                    {
                                        $(this)[0].selected = true;
                                    }
                                });
                                $(".text-field-new-tag").val('');
                                //$('.text-field-new-tag').attr('disabled',true);
                            }
                        }
                        //setTimeout(function() {$('#lnkcancel').trigger('click');},1000);
                        $('#txtlink')[0].value = '';
                        $('#txtdescription')[0].value = '';
                        errorBox.hide();
                        // Inserting a new row in table
                        var tablerows =$('.linkrow').eq(0);
                        tablerows.before('<tr class="linkrow"><td><a href="' + link + '" target="_blank">' + link + ' </a></td><td>' + description + '</td><td>' + tag + '</td></tr>');
                        tablerows = $('.linkrow').eq(0);
                        tablerows.css('background','#f9efaf');
                        setTimeout(function() {tablerows.css('background','#ffffff')}, 250);
                        setTimeout(function() {tablerows.css('background','#f9efaf')}, 500);
                        setTimeout(function() {tablerows.css('background','#ffffff')}, 750);
                        setTimeout(function() {tablerows.css('background','#f9efaf')}, 1000);
                        setTimeout(function() {tablerows.css('background','#ffffff')}, 1250);
                        tablerows.hover( function(){
                                $(this).css('background-color', '#fff9bb');
                            },
                            function(){
                                $(this).css('background-color', '#ffffff');
                        });
                        $('.emptyRow').remove();
                        setTimeout(function() {$('#txtlink').focus();},1300);
                        $.get('/sendnotification');
                        
                    }
                    else
                    {
                        showError(errorBox,data);                        
                    }
                    This.val("Add link");
                },
                error: function(request, error) {
                    showError(errorBox,"Unable to reach the server. Refresh the page to continue.");
                    This.val("Add link");
                }});
        }
        else
        {
            $('#txtlink').focus();
            showError(errorBox,"Please input link");
        }
    });

    // for Search operations
        $("#txtsearchcriteria").quicksearch(".linkrow", {
            noResults: '#noresultsrow',
            stripeRows: ['odd', 'even'],
            loader: 'span.loading',
            onBefore: function() {
                $('.linkrow').removeHighlight();
            },
            onAfter: function() {
                if ($('#txtsearchcriteria').val() != null && $('#txtsearchcriteria').val() != "")
                    $('.linkrow').highlight($('#txtsearchcriteria').val());
            }
        });

    // for logo click event
    $('.Logo img').click(function(){
        window.location = "http://interestinglinks.heroku.com";
    });

    $('#txtsearchcriteria').keypress(function(e)
    {
        if (e.which == 13)
            window.location = "/search/" + $(this)[0].value;
    });

    $('.searchbutton').click(function() {
        window.location = "/search/" + $('#txtsearchcriteria')[0].value;
    });
    
});