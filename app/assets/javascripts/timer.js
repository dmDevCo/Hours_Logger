
	var start = 0;
	var total_seconds = 0;
	var seconds = 0;
	
	$('#working').unbind().click(function() {
		start = new Date;
		window.setInterval("updateTime()", 1000);
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
		}