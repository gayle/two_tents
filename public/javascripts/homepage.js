jQuery(function($) {
  $("#sticky_header").css("position", "fixed");
  
  $("#navigation").localScroll({offset: {top: -164}, duration: 2000, queue: false});
  
  $(":input:visible:first").focus();
  
  if($.browser.ie) {
    $("ol[start]").each(function() {
      var item_count = parseInt($(this).attr("start")) - 1, 
          el = "<li style='position:absolute; left:-9999px'></li>",
          els = "";
      for(var i = 0; i < item_count; i++) {
        els += el;
      }
      $(this).prepend(els).removeAttr("start");
    });    
  }
});