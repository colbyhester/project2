public class DoctorControllerExtension {
	private final Doctor__c doc;
    public Appointment__c app{get;set;}
    public String zip{get;set;}
    
    //initialize doctor and appointment
    public DoctorControllerExtension(ApexPages.StandardController std){
        Doctor__c d = (Doctor__c)std.getRecord();
        doc = [SELECT Zip_Code__c,name,Office_Address__c,City__c,State__c,Office_Phone_Number__c,Languages__c,Gender__c,Accepting_New_Patients__c,Specialty__c,Plan_Network__c FROM Doctor__c WHERE ID=:d.ID];
        //turn zip code into a String so that it shows up right
        zip = String.valueOf(doc.Zip_Code__c);
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

        insert app;
        //create a child Application(temporary until application is done)
        Application__c a = new Application__c();
        a.Appointment__c = app.ID;
        insert a;
        
        //this page will link to the Application page in the future. Right now it links to the appointment detail page
        PageReference Page = new PageReference('/'+app.ID);
        return Page;
    }
}