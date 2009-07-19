(function($) {

$(document).ready(function() {
  $("#navigation .login").toggle(function(event) {
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
      }, 5000);
    });
  }, 750);

});

})(jQuery);