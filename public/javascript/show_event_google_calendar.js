function loop_show_event_google_calendar()
{
    $("#event_google_calendar").text("Loading...");
    show_event();
    setInterval(function(){show_event()}, 60000);
}
function show_event()
{
    $.ajax({
	url:	  '/agenda',
	dataType: 'html',
	success: function(data){
	    $("#event_google_calendar").html(data);
	},
	error: function(){
	    $("#event_google_calendar").text("Erreur dans la récupération des tâches.");
	}
    });
}
