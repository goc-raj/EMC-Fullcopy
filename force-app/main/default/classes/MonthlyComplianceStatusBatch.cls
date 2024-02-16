/**
 * @Author: GetonCRM Solutions LLP
 * @Description: this batch will update the value of monthly compliance status on contact based on the previous month approved mileage.
 * @Modification logs
 * ========================================================================================================================
 * @Date: 31 January 2024 | Khuman Singh Bhadoriya
 */
public with sharing class MonthlyComplianceStatusBatch  implements Database.Batchable<sObject>{
    public List<Contact> start(Database.BatchableContext bc){
        // List<Contact> conList = [SELECT Id,name,Role__c,Activation_Date__c,monthly_compliance_status__c,Insurance__c,Vehicle_Age__c,Vehicle_Value_Check__c FROM contact  WHERE Deactivated_Date__c = NULL  AND Account.isUsingTriplog__c = true AND Activation_Date__c != null AND (Role__c = 'Driver' or Role__c = 'Driver/Manager' or Role__c = 'Driver/Admin')];
        List<Contact> conList = [SELECT Id,name,Role__c,Activation_Date__c,monthly_compliance_status__c,Insurance__c,Vehicle_Age__c,Vehicle_Value_Check__c FROM contact  WHERE Id='0030Z00003RI524'];
        return conList;
    }
    public void execute(Database.BatchableContext bc, List<Contact> conList) {
        List<String> conIdList = new List<String>();
        List<Contact> updatedContacts=new List<Contact>();
        Map<String,Decimal> approvedReimMap= new Map<String,Decimal>();
        List<String> MonthsList=new List<String>();

        Date todaysDate= System.today().addMonths(-1);
        Integer MonthVal= todaysDate.month();
        MonthsList.add('12-'+String.valueOf(System.today().addYears(-1).year()));
        System.debug('december value-->'+'12-'+String.valueOf(System.today().addYears(-1).year()));
        for(Integer i=1;i<=MonthVal;i++){
            String month = (i < 10 ? '0' : '') + i;
            String MonthYear = month +'-'+String.ValueOF(todaysDate.Year());
            MonthsList.add(MonthYear);
            System.debug('month__c'+ MonthYear);
        }
        Decimal average = 0;
        Integer numberOfReimbursementPeriod =0;
        for(Contact con: conList){
            average = 0;
            for(Employee_Reimbursement__c reim : [Select id,Contact_Id__c,Total_Approved__c from Employee_Reimbursement__c  where Contact_Id__c =: con.Id AND Month__c IN : MonthsList]){
                average += reim.Total_Approved__c;
                numberOfReimbursementPeriod++;
            }
            if (average>0 && numberOfReimbursementPeriod>0){
                average = average/numberOfReimbursementPeriod;
                System.debug('average-->'+average);
            }
            if(average >=416.66){
                if(con.Insurance__c == 'Yes'){
                    if(con.Vehicle_Age__c == 'Yes'){
                        if(con.Vehicle_Value_Check__c == 'Yes'){
                            con.monthly_compliance_status__c='Yes';
                        }else if(con.Vehicle_Value_Check__c=='No'){
                            con.monthly_compliance_status__c='No – Vehicle Value';
                        }else {
                            con.monthly_compliance_status__c='No – Vehicle Value';
                        }
                    }else if(con.Vehicle_Age__c=='No'){
                        con.monthly_compliance_status__c='No – Vehicle Age';
                    }else{
                        con.monthly_compliance_status__c='No – Vehicle Age';
                    }
                }else if(con.Insurance__c=='Not Submitted'){
                    con.monthly_compliance_status__c='No - Insurance Not Provided';
                }else if(con.Insurance__c=='Insurance Card'){
                    con.monthly_compliance_status__c='No – Insurance Card';
                }else if(con.Insurance__c=='Not Meeting Plan Minimum'){
                    con.monthly_compliance_status__c='No – Insurance Not Meeting Minimum';
                }else if(con.Insurance__c=='Expired'){
                    con.monthly_compliance_status__c='Expired Insurance';
                }else if(con.Insurance__c=='No Expiration Date'){
                    con.monthly_compliance_status__c='No - Missing Coverage Dates';
                }else if(con.Insurance__c=='Missing Umbrella Policy'){
                    con.monthly_compliance_status__c='No - Umbrella Policy';
                }else if(con.Insurance__c=='Missing Insurance Dec Page'){
                    con.monthly_compliance_status__c='No - Insurance Dec Page';
                }else{
                    con.monthly_compliance_status__c='No - Insurance Not Provided';
                }
            }else {
                if(con.Insurance__c=='Yes'){
                    if(con.Vehicle_Age__c=='Yes'){
                        if(con.Vehicle_Value_Check__c=='Yes'){
                            con.monthly_compliance_status__c='No - Mileage';
                        }else if(con.Vehicle_Value_Check__c=='No'){
                            con.monthly_compliance_status__c='No - Mileage & Vehicle Value';
                        }else {
                            con.monthly_compliance_status__c='No - Mileage & Vehicle Value';
                        }
                    }else if(con.Vehicle_Age__c=='No'){
                        con.monthly_compliance_status__c='No - Mileage & Vehicle Age';
                    }else{
                        con.monthly_compliance_status__c='No - Mileage & Vehicle Age';
                    }
                }else{
                    con.monthly_compliance_status__c='No - Mileage & Insurance';
                }
            }
            updatedContacts.add(con);
        }
        
        
        
        if(Schema.sObjectType.Contact.fields.monthly_compliance_status__c.isUpdateable() && updatedContacts.size() > 0){
            update updatedContacts;
        }
    }
    public void finish(Database.BatchableContext bc){
        System.debug('this is Finish Method');
    }
}