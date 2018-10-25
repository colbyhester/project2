public class AppointmentExtension {
    private final Appointment__c app;
    public Application__c a{get;set;}
    
    
    public AppointmentExtension(ApexPages.StandardController std){
        Appointment__c app = (Appointment__c)std.getRecord();
        app = [SELECT ID, appointment_date_and_time__c, patient_phone_number__c, patient_email__c FROM Appointment__c WHERE ID=:app.ID];
        
        a = new Application__c();
    }
    
    
    public PageReference saveApp(){
        //system.debug(app.ID);
        a.Appointment__c = apexpages.currentpage().getparameters().get('id');
        
        insert a;
        PageReference Page = new PageReference('/apex/SearchPage');
        return Page;
    }
    
    
}