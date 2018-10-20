//FUNCTION TO INITIALIZE THE GOOGLE MAP
function initialize() {
    var zipCodesToLookup = new Array('20120', '20122', '22033', '22101', '20124', '20151');
    var output = '<tr><th scope="col">From</th><th scope="col">To</th><th scope="col">Miles</th></tr>';

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

            for(var i=0; i < origins.length; i++) {
                var results = response.rows[i].elements;
                for(var j=0; j < results.length; j++) {
                output += '<tr><td>' + origins[i] + '</td><td>' + destinations[j] + '</td><td>' + results[j].distance.text + '</td></tr>'; }}
            document.getElementById('zip_code_output').innerHTML = '<table cellpadding="5">' + output + '</table>';

        }
    });
}