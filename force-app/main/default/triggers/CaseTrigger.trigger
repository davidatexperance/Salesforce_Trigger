/**
 *
 * @format
 * @description :  Case Trigger
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-04-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-03-2022   david@experancepartners.com   Initial Version
 *
 */
trigger CaseTrigger on Case(
  before insert,
  after insert,
  before update,
  after update,
  before delete,
  after delete,
  after undelete
) {
  TriggerFactory.createTriggerHandler(Case.getSObjectType());
}
