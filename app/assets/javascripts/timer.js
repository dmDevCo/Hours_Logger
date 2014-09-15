
	var start = 0;
	var total_seconds = 0;
	var seconds = 0;
	var intervalID=0;
	var x = 0;
	var count = 0;
	var flag = 0;
	

	
$(document).ready(function(){
	


  $('.right_arrow').on({
    'mouseover' : function() {
      $(this).attr('src','/assets/orange-arrow-right_dark.png');
    },
    mouseout : function() {
  $(this).attr('src','/assets/orange-arrow-right.png');
    }
  });
  
   $('.left_arrow').on({
    'mouseover' : function() {
      $(this).attr('src','/assets/orange-arrow-left_dark.png');
    },
    mouseout : function() {
  $(this).attr('src','/assets/orange-arrow-left.png');
    }
  });
  
  
	$('#working').unbind().click(function() {
		start = new Date;
		x = window.setInterval(updateTime, 1000);
		$.cookie("start_time", start, { expires: 1 });
		intervalID = x;
		$('#working').hide();
		$('#not_working').show();
		$('#notice').hide();
	});	
	
	$('#not_working').unbind().click(function() {
		clearInterval(intervalID);
		var form = document.getElementById("myForm");
		form.elements['total_seconds'].value = total_seconds;
	});	
	
	
	$('#cancel').unbind().click(function() {
		x = window.setInterval(updateTime, 1000);
		intervalID = x;
	});	
	
	$('.close').unbind().click(function() {
		x = window.setInterval(updateTime, 1000);
		intervalID = x;
	});	
	
	if ((!$.cookie('start_time'))){
	$('#stats').unbind().click(function() {
	if(start != 0){
		$.cookie("start_time", start, { expires: 1 });
	}
	});	}
	
	$('#submit_1').unbind().click(function() {
		$.removeCookie('start_time');
	});	
	
	$('#signout').unbind().click(function() {
		$.removeCookie('start_time');
	});	
});
	
	



function updateTime(){
			
			total_seconds = Math.round(((new Date - start)/1000));
			seconds = total_seconds;
			
			var hours = Math.floor(total_seconds/3600);
			var hours_1 = hours;
			hours = (hours<10 ? "0" : "")+ hours;
			seconds = seconds % 3600;
			
			
			var minutes = Math.floor(seconds / 60);
			minutes = (minutes<10 ? "0" : "")+ minutes;
			seconds = seconds % 60;
			
			var seconds = Math.floor(seconds);
			seconds = (seconds<10 ? "0" : "")+ seconds;
			
			var currentTimeString = hours + ":" + minutes + ":" + seconds;
			
			document.getElementById("current_time").innerHTML = currentTimeString;
			document.getElementById("current_time_2").innerHTML = "Time: "+currentTimeString;
			
			if (hours_1 > 5){
				$('#edit_time').show();
				$('#current_time_3').hide();
				document.getElementById("current_time_4").innerHTML = currentTimeString;
				$('#for_hidden').html(" <input type='hidden' name='end_time' value='true'> ");
				$('#for_hidden_1').html(" <input type='hidden' name='start_time' value='"+$.cookie('start_time')+"'> ");
			

			
				if (flag==0){
				    $.ajax({type: "POST", 
					url:"time_cards/email",
					success:function(){
					$("#div1").html("Email sent");
					}});
					
					while (count<50){
					count = count + 1;
					}
					
					flag = 1;
				}
			}
		}