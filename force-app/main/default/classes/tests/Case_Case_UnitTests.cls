@istest
public with sharing class Case_Case_UnitTests {
    private static final Date OLD_SOLVE_DATE = System.today().addDays(-5);

    @IsTest
    static void Test_ItShouldSetSolvedDateBeforeInsert() {
        SObject cSObject = TestFactory.createSObject(
            new Case(Status = Case_Constants.STATUS_SOLVED)
        );
        Case cCase = (Case) cSObject;
        Case_Case cc = new Case_Case();

        cc.beforeInsertThreading(cSObject);

        System.assertEquals(
            System.today(),
            cCase.Solved_Date__c,
            'Solved Date not set correctly'
        );
    }

    @IsTest
    static void Test_ItShouldNOTSetSolvedDateBeforeInsert() {
        SObject cSObject = TestFactory.createSObject(
            new Case(Status = Case_Constants.STATUS_WORKING)
        );
        Case cCase = (Case) cSObject;
        Case_Case cc = new Case_Case();

        cc.beforeInsertThreading(cSObject);

        System.assertEquals(
            null,
            cCase.Solved_Date__c,
            'Solved Date not set correctly'
        );
    }

    @isTest
    static void Test_ItShouldSetSolvedDateBeforeUpdate() {
        SObject cSObject = TestFactory.createSObject(
            new Case(Status = Case_Constants.STATUS_SOLVED)
        );
        Case cCase = (Case) cSObject;
        Case_Case cc = new Case_Case();

        cc.beforeUpdateThreading(cSObject);

        System.assertEquals(
            System.today(),
            cCase.Solved_Date__c,
            'Solved Date not set correctly'
        );

        cCase.Status = Case_Constants.STATUS_WORKING;
        cc.beforeUpdateThreading(cSObject);

        System.assertEquals(
            null,
            cCase.Solved_Date__c,
            'Solved Date not set correctly'
        );
    }

    @isTest
    static void Test_ItShouldNOTSetSolvedDateBeforeUpdate() {
        SObject cSObject = TestFactory.createSObject(
            new Case(
                Status = Case_Constants.STATUS_SOLVED,
                Solved_Date__c = OLD_SOLVE_DATE
            )
        );
        Case cCase = (Case) cSObject;
        Case_Case cc = new Case_Case();

        cc.beforeUpdateThreading(cSObject);

        System.assertEquals(
            OLD_SOLVE_DATE,
            cCase.Solved_Date__c,
            'Solved Date not set correctly'
        );

        cCase.Status = Case_Constants.STATUS_CLOSED;
        cc.beforeUpdateThreading(cSObject);

        cCase.Status = Case_Constants.STATUS_WORKING;
        cc.beforeUpdateThreading(cSObject);

        System.assertEquals(
            null,
            cCase.Solved_Date__c,
            'Solved Date not set correctly'
        );
    }
}
