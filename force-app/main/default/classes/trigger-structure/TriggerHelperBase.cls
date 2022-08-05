/**
 *
 * @format
 * @description :  Case Trigger Helper Base
 * This base creates mechanizm for single threading of records and thereby simpler code in actual Helpers.
 * note: if logic requires something different execution of non threading (bulk) and then single threading you can override the trigger state
 * and develop your own logic for that specific state.  You should try to keep to single threading which will lead more readable code in the long rund
 *
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-04-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-04-2022   david@experancepartners.com   Initial Version
 *
 */
public virtual class TriggerHelperBase implements iTriggerHelper {
    protected Map<Id, SObject> recordsToUpdateMap = new Map<Id, SObject>();
    protected List<SObject> recordsToCreate = new List<SObject>();

    public virtual void bulkBefore() {
    }

    public virtual void bulkAfter() {
    }

    public virtual void beforeInsert(TriggerParameters tp) {
        this.beforeInsertBulk(tp);
        for (SObject record : tp.newList) {
            this.beforeInsertThreading(record);
        }
    }

    public virtual void beforeInsertBulk(TriggerParameters tp) {
    }

    public virtual void beforeInsertThreading(SObject record) {
    }

    public virtual void beforeUpdate(TriggerParameters tp) {
        this.beforeUpdateBulk(tp);
        for (SObject record : tp.newList) {
            this.beforeUpdateThreading(record);
        }
    }

    public virtual void beforeUpdateBulk(TriggerParameters tp) {
    }

    public virtual void beforeUpdateThreading(SObject record) {
    }

    public virtual void beforeDelete(TriggerParameters tp) {
        this.beforeDeleteBulk(tp);
        for (SObject record : tp.oldMap.values()) {
            this.beforeDeleteThreading(record);
        }
    }

    public virtual void beforeDeleteBulk(TriggerParameters tp) {
    }
    public virtual void beforeDeleteThreading(SObject record) {
    }

    public virtual void afterInsert(TriggerParameters tp) {
        this.afterInsertBulk(tp);
        for (SObject record : tp.newList) {
            this.afterInsertThreading(record);
        }
    }

    public virtual void afterInsertBulk(TriggerParameters tp) {
    }
    public virtual void afterInsertThreading(SObject record) {
    }

    public virtual void afterUpdate(TriggerParameters tp) {
        this.afterUpdateBulk(tp);
        for (SObject record : tp.newList) {
            this.afterUpdateThreading(record);
        }
    }

    public virtual void afterUpdateBulk(TriggerParameters tp) {
    }
    public virtual void afterUpdateThreading(SObject record) {
    }

    public virtual void afterDelete(TriggerParameters tp) {
        this.afterDeleteBulk(tp);
        for (SObject record : tp.oldMap.values()) {
            this.afterDeleteThreading(record);
        }
    }
    public virtual void afterDeleteBulk(TriggerParameters tp) {
    }
    public virtual void afterDeleteThreading(SObject record) {
    }

    public virtual void afterUndelete(TriggerParameters tp) {
        this.afterUndeleteBulk(tp);
        for (SObject record : tp.newList) {
            this.afterUndeleteThreading(record);
        }
    }

    public virtual void afterUndeleteBulk(TriggerParameters tp) {
    }
    public virtual void afterUndeleteThreading(SObject record) {
    }

    public virtual void andFinally() {
        sortAndUpsert();
    }

    /**
     * @description Combine the new and updated records, sort them based upon type to reduce DML types
     * Note: there really should not be any mixed types, this is included for belts and suspenders.
     * Each SObjectType which will be inserted or updated should have its own helper, not really for you
     * dear coder, but those that follow your fine work
     * @author david@experancepartners.com | 08-04-2022
     * @return virtual
     **/
    public virtual void sortAndUpsert() {
        //combine the list of new and updated records, sort them to reduce DML charges if it is a mixed list
        List<SObject> recordsToUpsert = new List<SObject>();
        recordsToUpsert.addAll(recordsToCreate);
        recordsToUpsert.addAll(recordsToUpdateMap.values());
        recordsToUpsert = Util.sortSObjects(recordsToUpsert);

        upsert recordsToUpsert;

        //consider error handling here

        recordsToCreate.clear();
        recordsToUpdateMap.clear();
    }
}
