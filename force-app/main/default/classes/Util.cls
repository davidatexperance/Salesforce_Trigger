/**
 * @format
 * @description       : Utilities for my work
 *                      @copywrite 2022 Experance Partners, LLC
 * @author            : david@experancepartners.com
 * @group             :
 * @last modified on  : 04-11-2022
 * @last modified by  : david@experancepartners.com
 **/
public with sharing class Util {
    /**
     * @description Sorts Records Based upon sortOrder (if given)
     * @author david@experancepartners.com | 08-04-2022
     * @param List<SObject> unsortedSObjects
     * @param List<SObjectType> sortOrder
     * @return List<SObject>
     **/
    public static List<SObject> sortSObjects(
        List<SObject> unsortedSObjects,
        List<SObjectType> sortOrder
    ) {
        Map<SObjectType, List<SObject>> sObjectMap = new Map<SObjectType, List<SObject>>();
        List<SObject> sortedSObjects = new List<SObject>();

        //check if there is anyuthing to sort
        if (unsortedSObjects == null || unsortedSObjects.isEmpty()) {
            return new List<SObject>();
        }

        //create a map of lists of sobjects by sobjecttype
        for (SObject record : unsortedSObjects) {
            if (sObjectMap.containsKey(record.getSObjectType())) {
                sObjectMap.get(record.getSObjectType()).add(record);
            } else {
                sObjectMap.put(
                    record.getSObjectType(),
                    new List<SObject>{ record }
                );
            }
        }

        //sort the map into a list of itmes in the right order
        for (
            SObjectType type : verifySortOrderList(
                sortOrder,
                sObjectMap.keySet()
            )
        ) {
            List<SObject> groupSObjects = sObjectMap.get(type);
            if (groupSObjects != null && !groupSObjects.isEmpty()) {
                sortedSObjects.addAll(groupSObjects);
            }
        }

        return sortedSObjects;
    }

    /**
     * @description Overload for sortSObjects with no sort order given
     * @author david@experancepartners.com | 08-04-2022
     * @param List<SObject> unsortedSObjects
     * @return List<SObject>
     **/
    public static List<SObject> sortSObjects(List<SObject> unsortedSObjects) {
        return sortSObjects(unsortedSObjects, null);
    }

    /**
     * @description Verifies Sort Order and Adds any missing ones to the list
     * Generally you don't need a sort order if you create your DML SObject correctly,
     * but sometimes it is nice to order the sobjects
     *
     * @author david@experancepartners.com | 08-04-2022
     * @param List<SObjectType> sortList
     * @param Set<SObjectType> allSObjectTypeSet
     * @return List<SObjectType>
     **/
    @testvisible
    private static List<SObjectType> verifySortOrderList(
        List<SObjectType> proposedSortList,
        Set<SObjectType> allTypeSet
    ) {
        Set<SObjectType> checkSet = new Set<SObjectType>();
        Set<SObjectType> grossList = new Set<SObjectType>(allTypeSet);
        List<SObjectType> returnList = new List<SObjectType>();

        if (allTypeSet == null || allTypeSet.isEmpty()) {
            return returnList;
        }

        if (proposedSortList == null || proposedSortList.isEmpty()) {
            return new List<SObjectType>(allTypeSet);
        }

        //this is to preserve order of the proposedSortList
        for (SObjectType type : proposedSortList) {
            if (checkSet.add(type)) {
                returnList.add(type);
                grossList.remove(type);
            }
        }

        //add what is left to the end of the list and log it
        if (!grossList.isEmpty()) {
            System.debug(
                LoggingLevel.WARN,
                'Notice not all SObjectTypes were on Sort List, adding them to the end'
            );

            returnList.addAll(grossList);
        }

        return returnList;
    }
}
