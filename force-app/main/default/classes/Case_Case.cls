/**
 *
 * @format
 * @description :  Case Trigger Helper for Case changes
 * note does not require andFinally method since DML is handled by Trigger
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-04-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-03-2022   david@experancepartners.com   Initial Version
 *
 */
public without sharing class Case_Case extends TriggerHelperBase {
    public override void beforeInsertThreading(SObject sRecord) {
        Case record = (Case) sRecord;
        if (record.Status == 'Solved' && record.Solved_Date__c == null) {
            record.Solved_Date__c = System.today();
        }
    }

    public override void beforeUpdateThreading(SObject sRecord) {
        Case record = (Case) sRecord;
        //if the record has status of Solved and the Solve Date has not been set it.
        if (record.Status == 'Solved' && record.Solved_Date__c == null) {
            record.Solved_Date__c = System.today();
        }

        //if the record is not solved or it is not closed, make sure that there is no solved date.
        if (record.Status != 'Solved' && record.Status != 'Closed') {
            record.Solved_Date__c = null;
        }
    }
}
