(function($) {

$(document).ready(function() {
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
      }, 5000);
    });
  }, 750);

  $("#main-nav ul.pulldown").each(function() {
    $(this).closest("li").dropdown();
  });
});

})(jQuery);