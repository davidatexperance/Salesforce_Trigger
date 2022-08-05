/**
 *
 * @format
 * @description :  Trigger Handler for EmailMessages
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-04-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-03-2022   david@experancepartners.com   Initial Version
 *
 */
public without sharing class EmailMessage_Handler extends TriggerHandlerBase {
    iTriggerHelper caseMilestoneHandler {
        get {
            if (caseMilestoneHandler == null) {
                caseMilestoneHandler = new EmailMessage_CaseMilestone();
            }
            return caseMilestoneHandler;
        }
        set;
    }

    public override void afterInsert(TriggerParameters tp) {
        CaseMilestoneHandler.afterInsert(tp);
    }

    public override void andFinally() {
        CaseMilestoneHandler.andFinally();
    }
}
