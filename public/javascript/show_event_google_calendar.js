function loop_show_event_google_calendar()
{
    show_event();
    setInterval(function(){show_event()}, 60000);
}
function show_event()
{
    $.ajax({
	url:	  '/agenda',
	dataType: 'json',
	success: function(data){
	    console.log(data);
	    var event_html;

	    var time;
	    $("#event_google_calendar").html("");
	    for each(var event in data)
	    {
		event_html = "<p>"
		event_html += "<h4>" + event["title"] + "</h4>"
		event_html += "Auteur : " + event["author_name"]
		event_html += "<br />Mail de l'auteur : " + event["author_email"]
		event_html += "<br/>Lieu: " + event["where"]
		time = new Date(event["start_time"]["^t"] * 1000)
		event_html += "<br/>Date de début: " + time.getHours() + "h" + time.getMinutes()
		time = new Date(event["end_time"]["^t"] * 1000)
		event_html += "<br/>Date de fin: " + + time.getHours() + "h" + time.getMinutes()
		event_html += "<br/><strong>Description: </strong><br/>" + event["content"]		
		event_html += "</p><br/>"
		$("#event_google_calendar").append(event_html);
	    }
	},
	error: function(){
	    $("#event_google_calendar").text("Erreur dans la récupération des tâches.");
	}
    });
}
