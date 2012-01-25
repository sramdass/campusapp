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

$(function() {	
//for the sparklines in the marks pages.
$(".sparklines").peity("bar", {height:12, width:8});

$(".ajaxified a").live("click", function() {
  $.getScript(this.href);
  return false;
});

$( ".datepicker" ).datepicker({
		dateFormat: 'd MM, yy',
		changeMonth: true,
		changeYear: true,
		showOtherMonths: true			
	});

//Roles.
//hide the textbox with through which the permission values are sent.
$('input.total_permission').hide();

$("input:checkbox").click(function() {
    var amount = 0;
    var existing_value = $(this).parent().find('.total_permission').val();
    if (existing_value.length > 0 ){
      amount = parseInt(existing_value);
    }
    if ($(this).is(":checked")) {
        amount += parseInt($(this).attr('value'));
    } else {
        amount -= parseInt($(this).attr('value'));
    }
    //$(this).closest('input:text').val(amount);
    //$(this).parent("div").find("input[type=text]").val(amount);
    $(this).parent().find('.total_permission').val(amount);
});
	
});