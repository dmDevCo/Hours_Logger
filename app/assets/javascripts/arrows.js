$(document).ready(function(){
	var select = 1;
	
	$('.right_arrow').unbind().click(function() {
			select = select+1;
			
			if (select < 1){
			select = 3;
			}
			
			if (select > 3){
			select = 1;
			}
			
			current_select = ".select_"+select;
			
			$('.select_1').hide();
			$('.select_2').hide();
			$('.select_3').hide();
			$(current_select).show();
	});
	
	
	$('.left_arrow').unbind().click(function() {
			select = select-1;
			
			if (select < 1){
			select = 3;
			}
			
			if (select > 3){
			select = 1;
			}
			
			current_select = ".select_"+select;
			
			$('.select_1').hide();
			$('.select_2').hide();
			$('.select_3').hide();
			$(current_select).show();
	});

});