/**
 *
 * @format
 * @description :  Trigger Query Class
 * this class reduces SOQL calls
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-04-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-03-2022   david@experancepartners.com   Initial Version
 *
 */
public with sharing class EmailMessage_Query {
    private static final String FIRST_RESPONSE = 'First Response';

    /*
     *
     * BROAD MAPS TO REDUCE SOQL
     *
     */

    /**
     * @description Creates a set of caseIds for EmailMessages
     * @author david@experancepartners.com | 08-04-2022
     * @return Set<Id>
     **/
    public static Set<Id> caseIds {
        get {
            if (caseIds == null) {
                caseIds = new Set<Id>();

                for (EmailMessage email : (List<EmailMessage>) Trigger.new) {
                    caseIds.add(email.ParentId);
                }
                caseIds.remove(null);
            }
            return caseIds;
        }
        set;
    }

    /**
     * @description Base CaseMilestone Map.  Add fields, filter eslewhere
     * @author david@experancepartners.com | 08-04-2022
     * @return Map<Id, CaseMilestone>
     **/
    public static Map<Id, CaseMilestone> caseMilestoneMap {
        get {
            if (caseMilestoneMap == null) {
                caseMilestoneMap = new Map<Id, CaseMilestone>(
                    [
                        SELECT
                            CompletionDate,
                            CaseId,
                            MilestoneType.Name,
                            Case.Status,
                            Case.Contact.Email
                        FROM CaseMilestone
                        WHERE CaseId IN :caseIds
                    ]
                );
            }
            return caseMilestoneMap;
        }
        set;
    }

    /*
     *
     * SPECIFIC MAPS BASED OFF OF BROAD MAPS to effect easy single threading
     *
     */

    /**
     * @description Map of CaseMilestones By Case
     * @author david@experancepartners.com | 08-04-2022
     * @return Map<Id, CaseMilestone>
     **/
    public static Map<Id, CaseMilestone> caseFirstResponseMilestoneByCaseIdMap {
        get {
            if (caseFirstResponseMilestoneByCaseIdMap == null) {
                caseFirstResponseMilestoneByCaseIdMap = new Map<Id, CaseMilestone>();
                System.debug('map ' + caseMilestoneMap);
                for (CaseMilestone cm : caseMilestoneMap.values()) {
                    if (cm.MilestoneType.Name == FIRST_RESPONSE) {
                        caseFirstResponseMilestoneByCaseIdMap.put(
                            cm.CaseId,
                            cm
                        );
                    }
                }
            }
            return caseFirstResponseMilestoneByCaseIdMap;
        }
        set;
    }
}
