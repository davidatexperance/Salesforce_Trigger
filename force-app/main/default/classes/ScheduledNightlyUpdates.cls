/**
 *
 * @format
 * @description :  Nightly updates scheduled job
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-04-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-03-2022   david@experancepartners.com   Initial Version
 *
 */
public class ScheduledNightlyUpdates implements Schedulable {
    public void execute(SchedulableContext sc) {
        //initialize batchUpdates here
        CaseUpdateBatch caseUpdates = new CaseUpdateBatch();

        //queue batch execution here
        Database.executeBatch(caseUpdates);
    }
}
