/**
 *
 * @format
 * @description :  Trigger Helper Interface
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-04-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-03-2022   david@experancepartners.com   Initial Version
 *
 */
public interface iTriggerHelper {
  void bulkBefore();
  void bulkAfter();
  void andFinally();

  void beforeInsert(TriggerParameters tp);
  void beforeUpdate(TriggerParameters tp);
  void beforeDelete(TriggerParameters tp);
  void afterInsert(TriggerParameters tp);
  void afterUpdate(TriggerParameters tp);
  void afterDelete(TriggerParameters tp);
  void afterUndelete(TriggerParameters tp);
}
