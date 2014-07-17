$(document).ready(function() {
    $(".replies-btn").click(function(){
    //get collapse content selector
    var collapse_content_selector = $(this).attr('href');         

    //make the collapse content to be shown or hide
    var toggle_switch = $(this);
    $(collapse_content_selector).toggle(function(){
      if($(this).css('display')=='none'){
                              //change the button label to be 'Show'
      toggle_switch.html('Show Replies');
      }else{
                              //change the button label to be 'Hide'
      toggle_switch.html('Hide Replies');
      }
    });
    });

  }); 