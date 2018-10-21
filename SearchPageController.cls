public class SearchPageController {
    
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
    
    public List<Doctor__c> getDoctors(){
        String query = 'SELECT Name, Accepting_New_Patients__c,Plan_Network__c ,Languages__c ,Specialty__c, Office_Address__c, City__c, Zip_Code__c FROM Doctor__c';
        Boolean hasWhere = false;
        if(spec!='All'){
            if(!hasWhere){
                query+=' WHERE Specialty__c=:spec';
                hasWhere=true;
            }else{
                query+=' AND Specialty__c=:spec';
            }
            
        }
        if(isZip(zip)){
            z = Integer.valueOf(zip);
            if(!hasWhere){
                query+=' WHERE Zip_Code__c = :z';
                hasWhere=true;
            }else{
                query+=' AND Zip_Code__c = :z';
            }
            
        }
        if(lang!='All'){
            
            if(!hasWhere){
                query+=' WHERE Languages__c INCLUDES(:lang)';
                hasWhere=true;
            }else{
                query+=' AND Languages__c INCLUDES(:lang)';
            }
            
        }
        if(plan!='Both'){
            
            if(!hasWhere){
                query+=' WHERE Plan_Network__c INCLUDES(:plan)';
                hasWhere=true;
            }else{
                query+=' AND Plan_Network__c INCLUDES(:plan)';
            }
            
        }
        if(aNP!='Both'){
            
            if(!hasWhere){
                query+=' WHERE Accepting_New_Patients__c=:aNP';
                hasWhere=true;
            }else{
                query+=' AND Accepting_New_Patients__c=:aNP';
            }
            
        }
        System.debug(query);
        List<Doctor__c> dlist = Database.query(query);
        List<Doctor__c> filterList = new List<Doctor__c>();
        for(Doctor__c d : dlist){
           // if(getDistance(z,d.Zip_Code__c)<=mile){
             //   filterList.add(d);
            //}
        }
        
        return dlist;
    }
    
    
    
    public void search(){
        //System.debug(zip);
    }
    
    
    private Boolean isZip(String z){
        if(z!=NULL){
            if(z.length()==5&&z.isNumeric()){
                return true;
            }
        }
        return false;
    }
    
    public List<SelectOption> getNewPatients(){
        
        List<SelectOption> options = new List<SelectOption>();
        List<PicklistEntry> pick = Doctor__c.Accepting_New_Patients__c.getDescribe().getPicklistValues();
        options.add(new SelectOption('BOTH','Both'));
        for(Integer i=0;i<pick.size();i++){
            options.add(new SelectOption(pick[i].getValue(),pick[i].getValue()));
        }
        
        return options;
    }
    
    
    public List<SelectOption> getLanguages(){
        
        List<SelectOption> options = new List<SelectOption>();
        List<PicklistEntry> pick = Doctor__c.Languages__c.getDescribe().getPicklistValues();
        options.add(new SelectOption('ALL','All'));
        for(Integer i=0;i<pick.size();i++){
            options.add(new SelectOption(pick[i].getValue(),pick[i].getValue()));
        }
        
        return options;
    }
    
    public List<SelectOption> getPlans(){
        
        List<SelectOption> options = new List<SelectOption>();
        List<PicklistEntry> pick = Doctor__c.Plan_Network__c.getDescribe().getPicklistValues();
        options.add(new SelectOption('BOTH','Both'));
        for(Integer i=0;i<pick.size();i++){
            options.add(new SelectOption(pick[i].getValue(),pick[i].getValue()));
        }
        
        return options;
    }
    
    public List<SelectOption> getSpecialties(){
        
        List<SelectOption> options = new List<SelectOption>();
        List<PicklistEntry> pick = Doctor__c.Specialty__c.getDescribe().getPicklistValues();
        options.add(new SelectOption('ALL','All'));
        for(Integer i=0;i<pick.size();i++){
            options.add(new SelectOption(pick[i].getValue(),pick[i].getValue()));
        }
        
        return options;
    }
}