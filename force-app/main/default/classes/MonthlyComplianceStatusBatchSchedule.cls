public with sharing class MonthlyComplianceStatusBatchSchedule implements Schedulable{
    public void execute(SchedulableContext sc) {
        MonthlyComplianceStatusBatch batch = new MonthlyComplianceStatusBatch();
        database.executebatch(batch,20);
    }
}