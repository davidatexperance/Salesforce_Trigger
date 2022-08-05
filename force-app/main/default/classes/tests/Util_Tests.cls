@istest
public with sharing class Util_Tests {
    static final List<SObjectType> orderedTypes = new List<SObjectType>{
        Account.SObjectType,
        Contact.SObjectType,
        Opportunity.SObjectType,
        Case.SObjectType
    };
    static final List<SObject> orderedObjects = new List<SObject>{
        TestFactory.createSObject(new Account(), false),
        TestFactory.createSObject(new Contact(), false),
        TestFactory.createSObject(new Opportunity(), false),
        TestFactory.createSObject(new Case(), false)
    };
    static final List<SObjectType> outOfOrderedTypes = new List<SObjectType>{
        Opportunity.SObjectType,
        Contact.SObjectType,
        Account.SObjectType,
        Case.SObjectType
    };
    static final List<SObject> outOfOrderedObjects = new List<SObject>{
        TestFactory.createSObject(new Opportunity(), false),
        TestFactory.createSObject(new Contact(), false),
        TestFactory.createSObject(new Account(), false),
        TestFactory.createSObject(new Case(), false)
    };
    static final List<SObjectType> missingAndDuplicateTypes = new List<SObjectType>{
        Account.SObjectType,
        Contact.SObjectType,
        Opportunity.SObjectType,
        Account.SObjectType
    };
    static final List<SObject> missingAndDuplicateObjects = new List<SObject>{
        TestFactory.createSObject(new Account(), false),
        TestFactory.createSObject(new Contact(), false),
        TestFactory.createSObject(new Opportunity(), false),
        TestFactory.createSObject(new Account(), false)
    };
    static final List<SObjectType> missingAndDuplicateTypesORDERWithorderedTypes = new List<SObjectType>{
        Account.SObjectType,
        Account.SObjectType,
        Contact.SObjectType,
        Opportunity.SObjectType
    };
    static final List<SObjectType> extraTypes = new List<SObjectType>{
        Account.SObjectType,
        Opportunity.SObjectType,
        Account.SObjectType,
        Contact.SObjectType,
        EmailMessage.SObjectType
    };
    static final List<SObject> extraObjects = new List<SObject>{
        TestFactory.createSObject(new Account(), false),
        TestFactory.createSObject(new Opportunity(), false),
        TestFactory.createSObject(new Account(), false),
        TestFactory.createSObject(new Contact(), false),
        TestFactory.createSObject(new EmailMessage(), false)
    };
    static final List<SObjectType> extraTypesORDERWithorderedTypes = new List<SObjectType>{
        Account.SObjectType,
        Account.SObjectType,
        Contact.SObjectType,
        Opportunity.SObjectType,
        EmailMessage.SObjectType
    };

    @IsTest
    static void Test_ItShouldSortSObjectsWithOutASortList() {
        Test.startTest();

        Test.stopTest();
    }

    @IsTest
    static void Test_ItShouldSortSObjectsWithASortList() {
        List<SObject> returnList = new List<SObject>();
        returnList = Util.sortSObjects(orderedObjects, orderedTypes);

        System.assertEquals('ok', returnedRightOrder(returnList, orderedTypes));

        returnList = Util.sortSObjects(outOfOrderedObjects, orderedTypes);

        System.assertEquals('ok', returnedRightOrder(returnList, orderedTypes));

        returnList = Util.sortSObjects(outOfOrderedObjects);

        System.assertEquals(
            4,
            returnList.size(),
            'Incorrect Number of Objects returned'
        );
    }

    @IsTest
    static void Test_ItShouldSortSObjectsWithAnIncompleteSortList() {
        List<SObject> returnList = new List<SObject>();
        returnList = Util.sortSObjects(
            missingAndDuplicateObjects,
            orderedTypes
        );

        System.assertEquals(
            'ok',
            returnedRightOrder(
                returnList,
                missingAndDuplicateTypesORDERWithorderedTypes
            )
        );
    }

    @IsTest
    static void Test_ItShouldSortSObjectsWithAnTooCompleteSortList() {
        List<SObject> returnList = new List<SObject>();
        returnList = Util.sortSObjects(extraObjects, orderedTypes);

        System.assertEquals(
            'ok',
            returnedRightOrder(returnList, extraTypesORDERWithorderedTypes)
        );
    }

    @IsTest
    static void Test_sortSObjectsShouldHandleNullCases() {
        List<SObject> returnList = new List<SObject>();

        returnList = Util.sortSObjects(null, orderedTypes);
        System.assertEquals(0, returnList.size());

        returnList = Util.sortSObjects(new List<SObject>(), orderedTypes);
        System.assertEquals(0, returnList.size());

        returnList = Util.sortSObjects(new List<SObject>(), null);
        System.assertEquals(0, returnList.size());

        returnList = Util.sortSObjects(
            new List<SObject>(),
            new List<SObjectType>()
        );
        System.assertEquals(0, returnList.size());

        returnList = Util.sortSObjects(orderedObjects, null);
        System.assertEquals(orderedObjects.size(), returnList.size());

        returnList = Util.sortSObjects(orderedObjects, new List<SObjectType>());
        System.assertEquals(orderedObjects.size(), returnList.size());
    }

    @IsTest
    static void Test_verifySortOrderListShouldSortSObjectsWithOutASortList() {
        List<SObjectType> returnList;

        returnList = Util.verifySortOrderList(
            null,
            new Set<SObjectType>(orderedTypes)
        );

        System.assertEquals('ok', returnedRightOrder(returnList, orderedTypes));

        returnList = Util.verifySortOrderList(
            new List<SObjectType>(),
            new Set<SObjectType>(outOfOrderedTypes)
        );

        System.assertEquals(
            'ok',
            returnedRightOrder(returnList, outOfOrderedTypes)
        );
    }

    @IsTest
    static void Test_verifySortOrderListShouldSortSObjectsWithASortList() {
        List<SObjectType> returnList;

        returnList = Util.verifySortOrderList(
            orderedTypes,
            new Set<SObjectType>(orderedTypes)
        );

        System.assertEquals('ok', returnedRightOrder(returnList, orderedTypes));

        returnList = Util.verifySortOrderList(
            orderedTypes,
            new Set<SObjectType>(outOfOrderedTypes)
        );

        System.assertEquals('ok', returnedRightOrder(returnList, orderedTypes));

        //check the order
    }

    @IsTest
    static void Test_verifySortOrderListShouldSortSObjectsWithVariousSitations() {
        List<SObjectType> returnList;

        returnList = Util.verifySortOrderList(
            orderedTypes,
            new Set<SObjectType>(missingAndDuplicateTypes)
        );

        System.assertEquals(
            'ok',
            returnedRightOrder(returnList, orderedTypes),
            'Failed missingAndDuplicateTypesORDERWithorderedTypes'
        );

        returnList = Util.verifySortOrderList(
            orderedTypes,
            new Set<SObjectType>(extraTypes)
        );

        List<SObjectType> extraOrderTypes = new List<SObjectType>(orderedTypes);
        extraOrderTypes.add(EmailMessage.SObjectType);

        System.assertEquals(
            'ok',
            returnedRightOrder(returnList, extraOrderTypes),
            'Failed extraTypesORDERWithorderedTypes'
        );
    }

    @isTest
    static void Test_verifySortOrderListShouldHandleNullOrEmptyAllTypeList() {
        List<SObjectType> returnList = new List<SObjectType>();
        List<SObjectType> proposedSortOrder;

        //check with null
        returnList = Util.verifySortOrderList(
            proposedSortOrder,
            new Set<SObjectType>()
        );

        System.assertEquals(
            0,
            returnList.size(),
            'Did not return correct number of SObjectTypes'
        );

        returnList = Util.verifySortOrderList(
            proposedSortOrder,
            new Set<SObjectType>()
        );

        System.assertEquals(
            0,
            returnList.size(),
            'Did not return correct number of SObjectTypes'
        );

        returnList = Util.verifySortOrderList(
            new List<SObjectType>(),
            new Set<SObjectType>()
        );

        System.assertEquals(
            0,
            returnList.size(),
            'Did not return correct number of SObjectTypes'
        );

        returnList = Util.verifySortOrderList(null, new Set<SObjectType>());

        System.assertEquals(
            0,
            returnList.size(),
            'Did not return correct number of SObjectTypes'
        );
    }

    private static String returnedRightOrder(
        List<SObjectType> returnedOrder,
        List<SObjectType> correctOrder
    ) {
        System.debug('returnedOrder: ' + returnedOrder);
        System.debug('correctOrder: ' + correctOrder);
        if (returnedOrder.size() != correctOrder.size()) {
            return 'Size Mismatch';
        }

        for (Integer i = 0; i < returnedOrder.size(); i++) {
            if (returnedOrder[i] != correctOrder[i]) {
                return 'Order Incorrect at ' +
                    i +
                    ' expected: ' +
                    correctOrder[i] +
                    ', returned: ' +
                    returnedOrder[i];
            }
        }

        return 'ok';
    }

    private static String returnedRightOrder(
        List<SObject> returnedOrder,
        List<SObjectType> correctOrder
    ) {
        System.debug('returnedOrder: ' + returnedOrder);
        System.debug('correctOrder: ' + correctOrder);
        if (returnedOrder.size() != correctOrder.size()) {
            return 'Size Mismatch' +
                ' expected: ' +
                correctOrder +
                ', returned: ' +
                returnedOrder;
        }

        for (Integer i = 0; i < returnedOrder.size(); i++) {
            if (returnedOrder[i].getSObjectType() != correctOrder[i]) {
                return 'Order Incorrect at ' +
                    i +
                    ' expected: ' +
                    correctOrder[i] +
                    ', returned: ' +
                    returnedOrder[i].getSObjectType();
            }
        }

        return 'ok';
    }
}
