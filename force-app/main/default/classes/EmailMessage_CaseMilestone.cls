/**
 *
 * @format
 * @description :  EmailMessage Trigger Helper
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-04-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-03-2022   david@experancepartners.com   Initial Version
 *
 */
public with sharing class EmailMessage_CaseMilestone extends TriggerHelperBase {
    public override void afterInsertThreading(SObject sRecord) {
        EmailMessage record = (EmailMessage) sRecord;

        CaseMilestone cm = EmailMessage_Query.caseFirstResponseMilestoneByCaseIdMap.get(
            record.ParentId
        );

        if (cm != null && cm.Case.Contact.Email == record.ToAddress) {
            cm.CompletionDate = System.now();
            recordsToUpdateMap.put(cm.Id, cm);
        }
    }
}
