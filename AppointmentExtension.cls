public class AppointmentExtension {
    //private final Appointment__c app;
    public Application__c a{get;set;}

    
    public AppointmentExtension(ApexPages.StandardController std){
        //Appointment__c app = (Appointment__c)std.getRecord();
        //app = [SELECT ID, appointment_date_and_time__c, patient_phone_number__c, patient_email__c FROM Appointment__c WHERE ID=:app.ID];
        ID you = UserInfo.getUserId();
        a = new Application__c();
        Application__c past;
        try{
            past = [SELECT Zip_Code__c,Subscriber_Name__c,State__c,SSN__c,Sign_Date__c,Secondary_Subscriber_Name__c,Secondary_Phone__c,Secondary_Insurance_Carrier__c,Relative__c,Relationship__c,Relation_to_Subscriber__c,Relation_to_Second_Subscriber__c,Race__c,Primary_Phone__c,Primary_Care_Physician__c,Phone__c,Pharmacy_Zip_Code__c,Pharmacy_Address__c,Pharmacy__c,Patient_Signature__c,PatientName__c,PatientDOB__c,Other__c,	Ongoing_Medical_Issues__c,Occupation__c,Number_of_Children__c,None__c,Nickname_Preferred_Name__c,Name__c,List_Surgeries_or_Hospitalizations__c,Is_it_a_problem__c,Insurance_Carrier__c,If_Not_Primary_Physician__c,Hobbies__c,Gender__c,Former_Smoker__c,Family_and_Personal_History__c,Emergency_Contact__c,Email__c,Do_you_Exercise__c,Do_you_drink_Alcohol__c,Date_of_Birth__c,DateSign__c,City__c,Are_you_the_Subscriber__c,Chewing_Tobacco__c,Current_Smoker__c,Apt__c,Name,Any_allergies_to_Medication__c,Any_Allergies__c,Age__c,Address__c,SigPatientName__c FROM Application__c WHERE CreatedById=:you LIMIT 1];
			
        }catch(Exception e){
            past = new Application__c();
        }
        a=past;
        a.ID=null;
    }
    
    
    public PageReference saveApp(){
        //system.debug(app.ID);
        //Id appoID = apexpages.currentpage().getparameters().get('id');
        //Appointment__c appo = [SELECT (SELECT ID FROM Applications__r LIMIT 1) FROM Appointment__c WHERE ID=:appoID];
        //delete appo.Applications__r;
        Appointment__c appo = new Appointment__c();
        System.debug(DateTime.parse(System.currentPageReference().getParameters().get('adt')));
        appo.Appointment_Date_and_Time__c=DateTime.parse(System.currentPageReference().getParameters().get('adt'));
        appo.Patient_Phone_Number__c=System.currentPageReference().getParameters().get('ph');
        appo.Patient_Email__c=System.currentPageReference().getParameters().get('em');
        appo.Doctor__c=System.currentPageReference().getParameters().get('did');
        insert appo;
        a.Appointment__c = appo.ID;
        
        insert a;
        
        PageReference Page = new PageReference('/apex/SearchPage');
        return Page;
    }
    
    
}