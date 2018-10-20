//FUNCTION TO INITIALIZE THE GOOGLE MAP
function initialize() {
    //zip codes: '22033', '22101', '20124', '20151'
    //var zipCodesToLookup = new Array('20120', '20122');

    $("#submit").on('click', function () {

        //create new array
        var zipCodesToLookup = new Array();

        //get values from input box
        zipCodesToLookup.push($("#to").val());
        zipCodesToLookup.push($("#from").val());
    
        //EXECUTE THE DISTANCE MATRIX QUERY
        var service = new google.maps.DistanceMatrixService();
        service.getDistanceMatrix({
            origins:      zipCodesToLookup,
            destinations: zipCodesToLookup,
            travelMode:   google.maps.TravelMode.DRIVING,
            unitSystem:   google.maps.UnitSystem.IMPERIAL
        }, function(response, status) {
            //...response processed here...//
            if(status == google.maps.DistanceMatrixStatus.OK) {
                var origins = response.originAddresses;
                var destinations = response.destinationAddresses;

                for(var i=0; i <origins.length; i++) {
                    var results = response.rows[i].elements;
                    for(var j=0; j < results.length; j++) {
                        //do not add row for same zip codes. ex: reston to reston (useless information)
                        if(origins[i] != destinations[j]){
                            $("#results").append("<tr><td>"+ results[j].distance.text + "</td></tr>");
                            console.log(results[j].distance.text);
                        } // end if
    
                    } //end inner for loop
                } //end outer for loop
            }//end status if
        });

    });

   
}