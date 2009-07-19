(function($) {
  $.fn.dropdown = function() {    
    $(this).hover(function() {
      $(this).addClass("hover");
    },
    function() {
      $(this).removeClass("hover");
    });
  };
})(jQuery);