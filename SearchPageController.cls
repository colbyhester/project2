public class SearchPageController {
    
    //user input variables with getter and setter methods:
    //These are used to transfer data between VF and Apex
    
    public String mile{get;set;}
    
    public String spec = 'All';
    
    public String lang = 'All';
    
    public String plan = 'Both';
    
    public String aNP = 'Both';
    
    public void setANP(String s){
        aNP=s;
    }
    public String getANP(){
        return aNP;
    }
    
    public void setPlan(String s){
        plan=s;
    }
    public String getPlan(){
        return plan;
    }
    
    public void setSpec(String s){
        spec=s;
    }
    public String getSpec(){
        return spec;
    }
    
    public void setLang(String s){
        lang=s;
    }
    public String getLang(){
        return lang;
    }
    
    public String zip {get;set;}
    
    public Integer z;
    
    public Decimal lat{get;set;}   
    public Decimal lon{get;set;}   
    
    public String distanceFilter{get;set;}
    
    //method that queries the database according to search filters:
    
    public List<Doctor__c> getDoctors(){
        //base query
        String query = 'SELECT Name, Accepting_New_Patients__c,Plan_Network__c ,Languages__c ,Specialty__c, Office_Address__c, City__c, Zip_Code__c FROM Doctor__c';
        
        //hasWhere tells us whether or not the query already has a WHERE clause or not
        Boolean hasWhere = false;
        
        //Edit query with specialty filter
        if(spec!='All'){
            if(!hasWhere){
                query+=' WHERE Specialty__c=:spec';
                hasWhere=true;
            }else{
                query+=' AND Specialty__c=:spec';
            }
            
        }
        
        
        //Edit query with language filter
        if(lang!='All'){
            
            if(!hasWhere){
                query+=' WHERE Languages__c INCLUDES(:lang)';
                hasWhere=true;
            }else{
                query+=' AND Languages__c INCLUDES(:lang)';
            }
            
        }
        
        //Edit query with plan filter
        if(plan!='Both'){
            
            if(!hasWhere){
                query+=' WHERE Plan_Network__c INCLUDES(:plan)';
                hasWhere=true;
            }else{
                query+=' AND Plan_Network__c INCLUDES(:plan)';
            }
            
        }
        
        
        //Edit query with accepting new patients filter
        if(aNP!='Both'){
            
            if(!hasWhere){
                query+=' WHERE Accepting_New_Patients__c=:aNP';
                hasWhere=true;
            }else{
                query+=' AND Accepting_New_Patients__c=:aNP';
            }
            
        }
        System.debug(query);
        
        //Query the database and obtain a list of doctors
        List<Doctor__c> dlist = Database.query(query);
        
        
        //If a valid mile radius and zip code are specified, remove doctors who are outside the radius from the list (this is done in the closeDoctors method)
        if(mile!=NULL){
            //the isZip method is explained later in the code
            if(mile.isNumeric()&&((isZip(zip)&&distanceFilter=='zipcode')||distanceFilter=='currentLocation')){
                dlist = closeDoctors(dlist,Integer.valueOf(mile));
            }
        }
        
        
        
        //Give the filtered list of doctors to the VF page
        return dlist;
    }
    
    
    //Method that calls the API for each doctor in the list, and returns only the doctors within the specified mile radius
    private List<Doctor__c> closeDoctors(List<Doctor__c> fullList, Integer radius){
        //list to be returned
        List<Doctor__c> closeList = new List<Doctor__c>();
        
        //for each doctor
        for(Integer i=0;i<fullList.size();i++){
            
            //do some http shenanigans to call the API
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse resp;
            req.setMethod('GET');
            //This URL calls the api with the specified zip code values. In order for this to work, you have to add https://maps.googleapis.com to your org's Remote Sites (type Remote Site in Quick Find Box)
            if(distanceFilter=='zipcode'){
            	req.setEndpoint('https://maps.googleapis.com/maps/api/distancematrix/json?origins='+zip+'&destinations='+fullList[i].Zip_Code__c+'&language=en&units=imperial&sensor=false&key=AIzaSyBUcAx046byoKwvtNMpxbTNkz-F0PwA7ao');
            }else if(distanceFilter=='currentLocation'){
                req.setEndpoint('https://maps.googleapis.com/maps/api/distancematrix/json?origins='+lat+','+lon+'&destinations='+fullList[i].Zip_Code__c+'&language=en&units=imperial&sensor=false&key=AIzaSyBUcAx046byoKwvtNMpxbTNkz-F0PwA7ao');
                System.debug('https://maps.googleapis.com/maps/api/distancematrix/json?origins='+lat+','+lon+'&destinations='+fullList[i].Zip_Code__c+'&language=en&units=imperial&sensor=false&key=AIzaSyBUcAx046byoKwvtNMpxbTNkz-F0PwA7ao');

            }
            resp = http.send(req);
            //System.debug('------resp-----------'+resp.getBody());
            
            //the API returns the results in JSON, so we have to extract the info using a parser
            JSONParser parser = JSON.createParser(resp.getBody());
            
            //variable where the distance between the two zip codes is stored
            String distance;
            
            //iterate through the JSON tokens (I don't understand how this works either)
            while(parser.nextToken()!=NULL){
                //find the first value
                if(parser.getText()=='value'){
                    //jump to the value(a number representing distance in meters)
                    parser.nextToken();
                    //set distance equal to that value
                    distance = parser.gettext();
                    
                    //System.debug(distance);
                    //break out of the loop so that we ignore other values
                    break;
                }
            }
            
            //if the API could not find one of the zip codes, distance is still null.
            if(distance==NULL){
                //If this is the case, set distance to some large number so that this doctor is removed from the list
                
                distance = '99999999999';
                //print out the zip code that failed so that we can ask the BAs about it
                System.debug(fullList[i].Zip_Code__c);
            }
            //compare the distance(after we convert it to miles) to the specified mile radius
            if((Decimal.valueOf(distance)/1609.344)<=radius){
                //add close doctors to the filtered list
                closeList.add(fullList[i]);
            }
        }
        
        //pass back the list of close doctors
        return closeList;
    }
    
    //this method executes when the user clicks 'Search'. It doesn't do anything other than rerender the doctor list(then getDoctors does the rest)
    public void search(){
        
    }
    
    //Method that checks if the zip code entered by the user is 5 digits long and composed only of numbers
    private Boolean isZip(String z){
        if(z!=NULL){
            if(z.length()==5&&z.isNumeric()){
                return true;
            }
        }
        return false;
    }
    
    
    //Method that provides the VF page with the list of options for the 'Accepting New Patients' filter
    public List<SelectOption> getNewPatients(){
        
        //list of options to return
        List<SelectOption> options = new List<SelectOption>();
        //list of avalable picklist values from the Accepting New Doctors field
        List<PicklistEntry> pick = Doctor__c.Accepting_New_Patients__c.getDescribe().getPicklistValues();
        //Additional 'All' option
        options.add(new SelectOption('BOTH','Both'));
        //Add them to the list
        for(Integer i=0;i<pick.size();i++){
            options.add(new SelectOption(pick[i].getValue(),pick[i].getValue()));
        }
        
        return options;
    }
    
    //Same as above, but this time for the Languages filter
    public List<SelectOption> getLanguages(){
        
        List<SelectOption> options = new List<SelectOption>();
        List<PicklistEntry> pick = Doctor__c.Languages__c.getDescribe().getPicklistValues();
        options.add(new SelectOption('ALL','All'));
        for(Integer i=0;i<pick.size();i++){
            options.add(new SelectOption(pick[i].getValue(),pick[i].getValue()));
        }
        
        return options;
    }
    
    //Same as above, but this time for the Plans filter
    public List<SelectOption> getPlans(){
        
        List<SelectOption> options = new List<SelectOption>();
        List<PicklistEntry> pick = Doctor__c.Plan_Network__c.getDescribe().getPicklistValues();
        options.add(new SelectOption('BOTH','Both'));
        for(Integer i=0;i<pick.size();i++){
            options.add(new SelectOption(pick[i].getValue(),pick[i].getValue()));
        }
        
        return options;
    }
    
    //Same as above, but this time for the Specialties filter
    public List<SelectOption> getSpecialties(){
        
        List<SelectOption> options = new List<SelectOption>();
        List<PicklistEntry> pick = Doctor__c.Specialty__c.getDescribe().getPicklistValues();
        options.add(new SelectOption('ALL','All'));
        for(Integer i=0;i<pick.size();i++){
            options.add(new SelectOption(pick[i].getValue(),pick[i].getValue()));
        }
        
        return options;
    }
    
    //ID of the doctor the user is about to click on(updated onmouseover)
    public String docID{get;set;}
    
    //Method called when user clicks a doctor's name
    public PageReference doctorD(){
        
		//link to DoctorDetail page with specified doctor's ID
        PageReference Page = new PageReference('/apex/DoctorDetail?id='+docID);
		
    	Page.setRedirect(true);

   		return Page;
    }
    

}