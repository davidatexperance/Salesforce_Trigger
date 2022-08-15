/**
 *
 * @format
 * @description :  Account Account Trigger Helper
 * NOTE FOR TEST COVERAGE
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-15-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-05-2022   david@experancepartners.com   Initial Version
 *
 */
public without sharing class Account_Handler extends TriggerHandlerBase {
    iTriggerHelper accountHandler {
        get {
            if (accountHandler == null) {
                accountHandler = new Account_Account();
            }
            return accountHandler;
        }
        set;
    }

    public override void bulkBefore() {
        //common implementation, you only want to run the bulk before once!
        Integer runCount = state.atBulkBefore();
        if (state.atBulkBefore() > 1) {
            System.debug(
                'Exiting Account.BulkBefore, state has been called ' +
                runCount +
                ' times.'
            );
            return;
        }
        accountHandler.bulkBefore();
    }
    public override void bulkAfter() {
        accountHandler.bulkAfter();
    }
    public override void beforeInsert(TriggerParameters tp) {
        accountHandler.beforeInsert(tp);
    }

    public override void beforeUpdate(TriggerParameters tp) {
        accountHandler.beforeUpdate(tp);
    }

    public override void beforeDelete(TriggerParameters tp) {
        accountHandler.beforeDelete(tp);
    }

    public override void afterInsert(TriggerParameters tp) {
        accountHandler.afterInsert(tp);
    }

    public override void afterUpdate(TriggerParameters tp) {
        accountHandler.afterUpdate(tp);
    }

    public override void afterDelete(TriggerParameters tp) {
        accountHandler.afterDelete(tp);
    }

    public override void afterUndelete(TriggerParameters tp) {
        accountHandler.afterUndelete(tp);
    }
}
