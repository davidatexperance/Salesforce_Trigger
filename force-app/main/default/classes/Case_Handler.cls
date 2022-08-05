/**
 *
 * @format
 * @description :  Case Trigger Handler
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-04-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-03-2022   david@experancepartners.com   Initial Version
 *
 */
public without sharing class Case_Handler extends TriggerHandlerBase {
    iTriggerHelper caseHandler {
        get {
            if (caseHandler == null) {
                caseHandler = new Case_Case();
            }
            return caseHandler;
        }
        set;
    }

    public override void beforeInsert(TriggerParameters tp) {
        caseHandler.beforeInsert(tp);
    }

    public override void beforeUpdate(TriggerParameters tp) {
        caseHandler.beforeUpdate(tp);
    }
}
