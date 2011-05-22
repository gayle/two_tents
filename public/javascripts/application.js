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
  // $(".ui-date").datepicker({
  //   changeMonth: true,
  //   changeYear: true,
  //   yearRange: '1900:' + ((new Date()).getYear() + 1900)
  // });
  $('.ui-date').live('click', function() {
    $(this).datepicker({
      showOn:'focus',
      changeMonth: true,
      changeYear: true,
      yearRange: '1900:' + ((new Date()).getYear() + 1900)
    }).focus();
  });
  
  $('input.main-contact-select').live('change', function() {
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

  $("input.button, a.button").button();
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

function setup_age_groups_page() {
  $("#AddNewGroupLink").click(function(){
    var age_group = $("#age_group_template").clone()
    $(age_group).removeAttr("id");
    var id = parseInt($("#num_age_groups").val());
    age_group.children("input, select").each(function(i, element){
      // Replace the name attribute with something unique
      var cur_name = $(element).attr("name");
      $(element).attr("name", cur_name.replace("X", id));
      // Make the min select 1 higher than the previous age group's max
      var last_max = parseInt($("#age_groups .age_group:last .max_input").val());
      if (last_max > 94) { last_max = 94; }
      $(age_group).children(".min_input").val(last_max + 1);
      // Make the max select 6 higher than the previous age group's max
      $(age_group).children(".max_input").val(last_max + 5);
      // Make the text set to '#{min} to #{max} year old's"
      $(age_group).children(".text_input").val("Age " + (last_max + 1) + " to " + (last_max+5));
    });
    $("#num_age_groups").val(id + 1);
    age_group.appendTo("#age_groups").show();
  });

  $(".delete_age_group_link").live("click", function(){
    $(this).parent().remove();
  });
}
