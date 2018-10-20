//initialization function
function initialize() {
    var mapOptions = {
         zoom:      8,
         center:    new google.maps.LatLng(-34.397, 150.644),
         mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
}
//global variables
var zipCodesToLookup = new Array('05001', '10002', '10457');
var output           = '<tr><th scope="col">From</th><th scope="col">To</th><th scope="col">Miles</th></tr>';

//Distance matrix query
var service = new google.maps.DistanceMatrixService();
service.getDistanceMatrix({
     origins:      zipCodesToLookup,
     destinations: zipCodesToLookup,
     travelMode:   google.maps.TravelMode.DRIVING,
     unitSystem:   google.maps.UnitSystem.IMPERIAL
}
function(response, status){
if(status== google.maps.DistanceMatrixStatus.OK){
    var origins= response.originAddresses;
    var destinations= response.destinationAddresses;

    for(var i=0; i< origins.length; i++){
        var results= response.rows[i].elements;
        for(var j=0; j< results.length; j++){
            output += '<tr><td>' + origins[i] + '</td><td>' +
            destinations[j] + '</td><td>' + results[j].distance.text +
            '</td><tr>';
        }
    }
}
});


//our function to load the google maps API 
function loadScript() {
    var script  = document.createElement("script");
    script.type = "text/javascript";
    script.src  = "http://maps.googleapis.com/maps/api/js?key=AIzaSyBDn-wgNNdi73rDfZPFA7FgEyCZRwuQCPI&sensor=false&callback=initialize";
    document.body.appendChild(script);
}
window.onload = loadScript;