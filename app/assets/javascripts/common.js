$(".ajaxified a").live("click", function() {
  $.getScript(this.href);
  return false;
});

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".tfields").hide();
  	update_row_count();  
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  /*$(link).parent().parent().before(content.replace(regexp, new_id));*/
  $(".input_form_table").append(content.replace(regexp, new_id));
}
