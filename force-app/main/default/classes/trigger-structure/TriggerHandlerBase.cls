/**
 *
 * @format
 * @description :  Trigger Handler Interface
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-04-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-03-2022   david@experancepartners.com   Initial Version
 *
 */
public virtual class TriggerHandlerBase implements iTriggerHandler {
    protected String triggerHandlerName;

    public virtual void bulkBefore() {
    }

    public virtual void bulkAfter() {
    }

    public virtual void beforeInsert(TriggerParameters tp) {
    }

    public virtual void beforeUpdate(TriggerParameters tp) {
    }

    public virtual void beforeDelete(TriggerParameters tp) {
    }

    public virtual void afterInsert(TriggerParameters tp) {
    }

    public virtual void afterUpdate(TriggerParameters tp) {
    }

    public virtual void afterDelete(TriggerParameters tp) {
    }

    public virtual void afterUndelete(TriggerParameters tp) {
    }

    public virtual void andFinally() {
    }

    public virtual Boolean isDisabled() {
        Boolean isDisabled = false;
        if (
            Trigger_Setup__mdt.getInstance(triggerHandlerName)?.isDisabled__c !=
            null
        ) {
            isDisabled = Trigger_Setup__mdt.getInstance(triggerHandlerName)
                .isDisabled__c;
        }
        return isDisabled;
    }

    public void setTriggerHandlerName(String name) {
        this.triggerHandlerName = name;
    }
}
