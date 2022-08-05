/**
 *
 * @format
 * @description :  Case Update Batch
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-04-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-04-2022   david@experancepartners.com   Initial Version
 *
 */
public class CaseUpdateBatch implements Database.Batchable<sObject> {
    Integer DAYS_TO_CLOSE = 30;
    String QUERY = 'SELECT Id, Status, Solved_Date__c FROM Case WHERE Status = \'Solved\' AND Solved_Date__c <= N_DAYS_AGO:30';

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(QUERY);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Case> casesToUpdate = new List<Case>();

        for (Case c : (List<Case>) scope) {
            //implementing filter in case later the query is expanded for other case updates
            if (
                System.today() - DAYS_TO_CLOSE > c.Solved_Date__c &&
                c.Status == Case_Constants.STATUS_SOLVED
            ) {
                c.Status = Case_Constants.STATUS_CLOSED;
                casesToUpdate.add(c);
            }
        }
        update casesToUpdate;
    }

    public void finish(Database.BatchableContext BC) {
    }
}
