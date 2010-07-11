jQuery(function($){
  $("#main-nav .login").toggle(function(event) {
    event.preventDefault();
    var target = $(this).attr("target");
    $(target).slideDown();
  }, function(event) {
    event.preventDefault();
    var target = $(this).attr("target");
    $(target).slideUp();    
  });

  setTimeout(function() {
    $("#messages").slideDown(function() {
      setTimeout(function() {
        $("#messages").slideUp();
      }, 2000);
    });
  }, 750);

  $("#main-nav ul.pulldown").each(function() {
    $(this).closest("li").dropdown();
  });

  $(".flipflop").click(function(event) {
    var str = $(this).closest("form").serialize();
    jQuery.post($(this).closest("form").attr("action")+".js",
                str,
                function(data,status){ },
                "script");
    event.preventDefault();
  });     
  $(".ui-date").datepicker({
    changeMonth: true,
    changeYear: true,
    yearRange: '1900:' + ((new Date()).getYear() + 1900)
  });
  $('input.main-contact-select').change(function() {
    var selected = $(this);
    var other_selected = $('input.main-contact-select:checked').not(selected);
    if (selected.attr('checked')) {
      if (other_selected.length > 0) {
        other_selected.attr('checked', false);
      }
    } else {
      if (other_selected.length == 0) {
        $(this).attr('checked', true);
      }
    }
  });
});

function remove_fields(link) {  
    $(link).prev("input[type=hidden]").val("1");  
    $(link).closest(".fields").hide();  
}  
  
function add_fields(link, association, content) {  
    var new_id = new Date().getTime();  
    var regexp = new RegExp("new_" + association, "g");  
    $(link).before(content.replace(regexp, new_id));  
}
