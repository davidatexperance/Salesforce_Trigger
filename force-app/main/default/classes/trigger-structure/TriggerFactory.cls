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
public with sharing class TriggerFactory {
    private static final String CUSTOM_OBJECT_SUFFIX = '__c';
    private static final String HANDLER_SUFFIX = '_Handler';

    /**
     * @description Gets the right Trigger Handler and executes it
     * @author david@experancepartners.com | 08-03-2022
     * @param Schema.sObjectType soType
     **/
    public static void createTriggerHandler(Schema.sObjectType soType) {
        iTriggerHandler handler = getTriggerHandler(soType);
        if (handler == null) {
            throw new TriggerException(
                'No Trigger Handler registered for Object Type: ' + soType
            );
        }
        if (!handler.isDisabled()) {
            execute(handler);
        } else {
            System.debug(soType + ' Trigger is disabled, skipping execution');
        }
    }

    /**
     * @description Executes the Trigger Stages for the given handler
     * @author david@experancepartners.com | 08-03-2022
     * @param iTriggerHandler handler
     **/
    private static void execute(iTriggerHandler handler) {
        TriggerParameters tp = new TriggerParameters(
            Trigger.new,
            Trigger.newMap,
            Trigger.oldMap
        );
        // Handle before trigger events
        if (Trigger.isBefore) {
            handler.bulkBefore();

            if (Trigger.isInsert) {
                handler.beforeInsert(tp);
            }
            if (Trigger.isUpdate) {
                handler.beforeUpdate(tp);
            }
            if (Trigger.isDelete) {
                handler.beforeDelete(tp);
            }
        }

        // Handle after trigger events
        if (Trigger.isAfter) {
            handler.bulkAfter();

            if (Trigger.isInsert) {
                handler.afterInsert(tp);
            }
            if (Trigger.isUpdate) {
                handler.afterUpdate(tp);
            }
            if (Trigger.isDelete) {
                handler.afterDelete(tp);
            }
            if (Trigger.isUndelete) {
                handler.afterUndelete(tp);
            }
        }

        handler.andFinally();
    }

    /**
     * @description Gets the trigger handler based upon name note should be <ObjectName>_Handler
     * @author david@experancepartners.com | 08-03-2022
     * @param Schema.sObjectType soType
     * @return iTriggerHandler
     **/
    private static iTriggerHandler getTriggerHandler(
        Schema.sObjectType soType
    ) {
        iTriggerHandler handler;
        String triggerHandlerName = soType.getDescribe().getName();
        triggerHandlerName =
            triggerHandlerName.removeEndIgnoreCase(CUSTOM_OBJECT_SUFFIX) +
            HANDLER_SUFFIX;

        Type obType = Type.forName(triggerHandlerName);
        handler = (iTriggerHandler) obType.newInstance();
        handler.setTriggerHandlerName(triggerHandlerName);
        return handler;
    }
}
