//FUNCTION TO INITIALIZE THE GOOGLE MAP
function initialize() {
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
                //var origins = response.originAddresses;
                //var destinations = response.destinationAddresses;

                var results = response.rows[0].elements;
                //console.log(results);
                $("#results").append("<tr><td>"+ results[1].distance.text + "</td></tr>");
                    
            }// end status if

        });// end getDistanceMatrix

    });// end submit onclick
}