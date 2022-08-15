/**
 *
 * @format
 * @description :  Case Trigger Helper for Case changes
 * note does not require andFinally method since DML is handled by Trigger
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-15-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-03-2022   david@experancepartners.com   Initial Version
 *
 */
public without sharing class Case_Case extends TriggerHelperBase {
    public override void beforeInsertThreading(SObject sRecord) {
        Case record = (Case) sRecord;
        //do something
    }

    public override void beforeUpdateThreading(SObject sRecord) {
        Case record = (Case) sRecord;
        //do something

        //if the record is not solved or it is not closed, make sure that there is no solved date.
        //do something else
    }
}
