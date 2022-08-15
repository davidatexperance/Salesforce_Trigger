/**
 *
 * @format
 * @description :  Trigger Handler Interface
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-15-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-03-2022   david@experancepartners.com   Initial Version
 *
 */
public virtual class TriggerHandlerBase implements iTriggerHandler {
    protected String triggerHandlerName;
    protected TriggerStateBase state = new TriggerStateBase();

    public virtual void bulkBefore() {
        //example for a run once trigger, this can also be implemented with individual helpers
        Integer runCount = this.state.countAt('bulkBefore');
        if (runCount > 1) {
            System.debug(
                'Existing bulkAfter. This state has been called ' +
                runCount +
                ' times '
            );
            return;
        }
    }

    public virtual void bulkAfter() {
        this.state.countAt('bulkAfter');
    }

    public virtual void beforeInsert(TriggerParameters tp) {
        //note in your override you need to include state incrementer
        this.state.countAt('beforeInsert');
    }

    public virtual void beforeUpdate(TriggerParameters tp) {
        //note in your override you need to include state incrementer
        this.state.countAt('beforeUpdate');
    }

    public virtual void beforeDelete(TriggerParameters tp) {
        //note in your override you need to include state incrementer
        this.state.countAt('beforeDelete');
    }

    public virtual void afterInsert(TriggerParameters tp) {
        //note in your override you need to include state incrementer
        this.state.countAt('afterInsert');
    }

    public virtual void afterUpdate(TriggerParameters tp) {
        //note in your override you need to include state incrementer
        this.state.countAt('afterUpdate');
    }

    public virtual void afterDelete(TriggerParameters tp) {
        //note in your override you need to include state incrementer
        this.state.countAt('afterDelete');
    }

    public virtual void afterUndelete(TriggerParameters tp) {
        //note in your override you need to include state incrementer
        this.state.countAt('afterUndelete');
    }

    public virtual void andFinally() {
        //note in your override you need to include state incrementer
        this.state.countAt('andFinally');
    }

    public virtual Boolean isDisabled() {
        Boolean isDisabled = false;
        //TODO: Implement Trigger Setup MetaDataClass and move to TriggerState
        // if (
        //     Trigger_Setup__mdt.getInstance(triggerHandlerName)?.isDisabled__c !=
        //     null
        // ) {
        //     isDisabled = Trigger_Setup__mdt.getInstance(triggerHandlerName)
        //         .isDisabled__c;
        // }
        return isDisabled;
    }

    public void setTriggerHandlerName(String name) {
        this.triggerHandlerName = name;
    }

    public virtual void debugTriggerRun() {
        String charactersForBox = '*+';
        Integer size = 80;
        System.LoggingLevel logLevel = System.LoggingLevel.INFO;
        if (!Trigger.isAfter) {
            return;
        }

        System.debug(logLevel, Util.boxTopBottom(charactersForBox, size));
        System.debug(logLevel, Util.boxSpace(charactersForBox, size));
        System.debug(
            logLevel,
            Util.boxEntryCentered(charactersForBox, size, 'Trigger Call Report')
        );
        System.debug(logLevel, Util.boxSpace(charactersForBox, size));
        for (String tState : this.state.countMap.keySet()) {
            System.debug(
                logLevel,
                Util.boxEntryLeft(
                    charactersForBox,
                    size,
                    tState +
                    ': ' +
                    this.state.countMap.get(tState) +
                    'calls'
                )
            );
        }
        System.debug(logLevel, Util.boxSpace(charactersForBox, size));
        System.debug(logLevel, Util.boxTopBottom(charactersForBox, size));
    }
}
