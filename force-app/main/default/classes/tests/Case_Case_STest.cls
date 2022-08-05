@isTest
/**
 *
 * @format
 * @description :  Case_Case System Tests
 * This class is created to show that with my trigger you can do both system and unit level
 * In production this class would run slower and could be used for comprehensive test runs,
 * but not part of a developer test runs
 * Not this test includes load testing, which would have to be modified in production because
 * CPU Limit issues
 *
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-04-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-03-2022   david@experancepartners.com   Initial Version
 *
 */
public with sharing class Case_Case_STest {
    private static final Date OLD_SOLVE_DATE = System.today().addDays(-5);
    // below can be added to metadata to limit test execution time
    private static final Boolean RUN_STRESS_TEST = true;

    @TestSetup
    static void makeData() {
        TestFactory.createSObject(new Case(), true);
        TestFactory.createSObject(
            new Case(
                Status = Case_Constants.STATUS_SOLVED,
                Solved_Date__c = OLD_SOLVE_DATE
            ),
            true
        );
    }

    @IsTest
    static void Test_ItShouldSetSolvedDateOnInsert() {
        Case caseInsert = (Case) TestFactory.createSObject(
            new Case(Status = Case_Constants.STATUS_SOLVED)
        );
        Test.startTest();

        insert caseInsert;

        Test.stopTest();

        Case caseResult = [
            SELECT Solved_Date__c
            FROM Case
            WHERE Id = :caseInsert.Id
            LIMIT 1
        ];

        System.assertEquals(
            System.today(),
            caseResult.Solved_Date__c,
            'Solved Date not set correctly'
        );
    }

    @IsTest
    static void Test_ItShouldSetSolvedDateOnUpdate() {
        Case caseResultSolved;
        Case caseResultClosed;
        Case caseResultWorking;

        Case caseUpdate = [
            SELECT Status, Solved_Date__c
            FROM Case
            WHERE Solved_Date__c = NULL
            LIMIT 1
        ];

        Test.startTest();
        caseUpdate.Status = Case_Constants.STATUS_SOLVED;
        update caseUpdate;

        caseResultSolved = [
            SELECT Solved_Date__c
            FROM Case
            WHERE Id = :caseUpdate.Id
            LIMIT 1
        ];

        caseUpdate.Status = Case_Constants.STATUS_CLOSED;
        update caseUpdate;

        caseResultClosed = [
            SELECT Solved_Date__c
            FROM Case
            WHERE Id = :caseUpdate.Id
            LIMIT 1
        ];

        caseUpdate.Status = Case_Constants.STATUS_WORKING;
        update caseUpdate;

        caseResultWorking = [
            SELECT Solved_Date__c
            FROM Case
            WHERE Id = :caseUpdate.Id
            LIMIT 1
        ];

        Test.stopTest();

        System.assertEquals(
            System.today(),
            caseResultSolved.Solved_Date__c,
            'Solved Date not set correctly'
        );

        System.assertEquals(
            System.today(),
            caseResultClosed.Solved_Date__c,
            'Solved Date not set correctly'
        );

        System.assertEquals(
            null,
            caseResultWorking.Solved_Date__c,
            'Solved Date not set correctly'
        );
    }

    @IsTest
    static void Test_ItShouldNotSetSolvedDateOnInsert() {
        Case caseInsert = (Case) TestFactory.createSObject(
            new Case(Status = Case_Constants.STATUS_WORKING)
        );

        Test.startTest();

        insert caseInsert;

        Test.stopTest();

        Case caseResult = [
            SELECT Solved_Date__c
            FROM Case
            WHERE Id = :caseInsert.Id
            LIMIT 1
        ];

        System.assertEquals(
            null,
            caseResult.Solved_Date__c,
            'Solved Date not set correctly'
        );
    }

    @IsTest
    static void Test_ItShouldNotSetSolvedDateOnUpdate() {
        Case caseSolved = [
            SELECT Status, Solved_Date__c
            FROM Case
            WHERE Status = :Case_Constants.STATUS_SOLVED
            LIMIT 1
        ];
        Case caseResultSolved;
        Case caseResultClosed;

        Test.startTest();

        caseSolved.Description = 'Something good';
        update caseSolved;

        caseResultSolved = [
            SELECT Solved_Date__c
            FROM Case
            WHERE Id = :caseSolved.Id
            LIMIT 1
        ];

        caseSolved.Status = Case_Constants.STATUS_CLOSED;
        update caseSolved;

        caseResultClosed = [
            SELECT Solved_Date__c
            FROM Case
            WHERE Id = :caseSolved.Id
            LIMIT 1
        ];

        Test.stopTest();

        System.assertEquals(
            OLD_SOLVE_DATE,
            caseResultSolved.Solved_Date__c,
            'Solved Date not set correctly'
        );

        System.assertEquals(
            OLD_SOLVE_DATE,
            caseResultClosed.Solved_Date__c,
            'Solved Date not set correctly'
        );
    }

    @IsTest
    static void Test_ItShouldBeAbleToInsertLargeNumbersOfRecords() {
        if (!RUN_STRESS_TEST) {
            return;
        }
        List<Case> cases = TestFactory.createSObjectList(new Case(), 250);
        Map<Id, Case> resultsInsert;
        Map<Id, Case> resultsUpdate;

        for (Integer i = 0; i < 100; i++) {
            if (i < 50) {
                cases[i].Status = Case_Constants.STATUS_SOLVED;
            } else {
                cases[i].Status = Case_Constants.STATUS_SOLVED;
                cases[i].Solved_Date__c = OLD_SOLVE_DATE;
            }
        }

        Test.startTest();
        insert cases;

        resultsInsert = new Map<Id, Case>(
            [SELECT Status, Solved_Date__c FROM Case]
        );

        for (Integer i = 0; i < 50; i++) {
            if (i < 25) {
                cases[i].Status = Case_Constants.STATUS_WORKING;
            } else if (i >= 50 && i < 75) {
                cases[i].Status = Case_Constants.STATUS_CLOSED;
            }
        }

        upsert cases;

        resultsUpdate = new Map<Id, Case>(
            [SELECT Status, Solved_Date__c FROM Case]
        );

        Test.stopTest();

        System.assertEquals(
            System.today(),
            resultsInsert.get(cases[5].Id).Solved_Date__c,
            'Solve Date not set correctly on insert'
        );
        System.assertEquals(
            OLD_SOLVE_DATE,
            resultsInsert.get(cases[75].Id).Solved_Date__c,
            'Solve Date not set correctly on insert'
        );
        System.assertEquals(
            null,
            resultsInsert.get(cases[105].Id).Solved_Date__c,
            'Solve Date not set correctly on insert'
        );
        System.assertEquals(
            null,
            resultsUpdate.get(cases[5].Id).Solved_Date__c,
            'Solve Date not set correctly on update'
        );
        System.assertEquals(
            System.today(),
            resultsUpdate.get(cases[45].Id).Solved_Date__c,
            'Solve Date not set correctly on update'
        );
        System.assertEquals(
            OLD_SOLVE_DATE,
            resultsUpdate.get(cases[75].Id).Solved_Date__c,
            'Solve Date not set correctly on update'
        );
        System.assertEquals(
            null,
            resultsUpdate.get(cases[105].Id).Solved_Date__c,
            'Solve Date not set correctly on update'
        );
    }
}
