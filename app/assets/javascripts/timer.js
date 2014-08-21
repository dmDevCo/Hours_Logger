
	var start = 0;
	var total_seconds = 0;
	var seconds = 0;
	var intervalID=0;
	var x = 0;
	
$(document).ready(function(){
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
			hours = (hours<10 ? "0" : "")+ hours;
			seconds = seconds % 3600;
			
			
			var minutes = Math.floor(seconds / 60);
			minutes = (minutes<10 ? "0" : "")+ minutes;
			seconds = seconds % 60;
			
			var seconds = Math.floor(seconds);
			seconds = (seconds<10 ? "0" : "")+ seconds;
			
			var currentTimeString = hours + ":" + minutes + ":" + seconds;
			
			document.getElementById("current_time").innerHTML = currentTimeString;
			document.getElementById("current_time_2").innerHTML = currentTimeString;
		}