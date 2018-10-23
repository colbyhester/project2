public class DoctorControllerExtension {
	private final Doctor__c doc;
    public Appointment__c app{get;set;}
    
    //initialize doctor and appointment
    public DoctorControllerExtension(ApexPages.StandardController std){
        doc = (Doctor__c)std.getRecord();
        app = new Appointment__c();
    }
    
    //method that links to Book Appointment Page
    public PageReference bookApp(){
        PageReference Page = new PageReference('/apex/BookAppointment?id='+doc.ID);
        return Page;
    }
    
    //Method that creates a new Appointment based on user's input
    public PageReference book(){
        
        app.Doctor__c = doc.ID;
        //bob is temporary
        Patient__c bob = [SELECT ID FROM Patient__c WHERE Name='Bob'];
        app.Patient__c = bob.ID;
        insert app;
        
        //this page will link to the Application page in the future. Right now it links to the appointment detail page
        PageReference Page = new PageReference('/'+app.ID);
        return Page;
    }
}