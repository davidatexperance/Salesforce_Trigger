/**
 *
 * @format
 * @description :  ScheduledNightlyUpdates Test Class
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-04-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-04-2022   david@experancepartners.com   Initial Version
 *
 */
@isTest
public with sharing class ScheduledNightlyUpdates_Test {
    private static String CRON_EXP = '0 0 0 15 3 ? 2024';
    private static final Integer UPDATED_CASES = 50;

    @TestSetup
    static void makeData() {
        List<Case> cases = TestFactory.createSObjectList(
            new Case(Status = Case_Constants.STATUS_SOLVED),
            250,
            false
        );
        for (Integer i = 0; i < UPDATED_CASES; i++) {
            cases[i].Solved_Date__c = System.today().addDays(-45);
        }
        insert cases;
    }

    @IsTest
    static void Test_ItShouldRunScheduledJobandUpdateCases() {
        Test.startTest();
        ScheduledNightlyUpdates snu = new ScheduledNightlyUpdates();
        String jobId = System.schedule('Nightly update', CRON_EXP, snu);
        snu.execute(null);
        Test.stopTest();

        List<Case> updatedCases = [
            SELECT Status, Solved_Date__c
            FROM Case
            WHERE Status = :Case_Constants.STATUS_CLOSED
        ];

        System.assertEquals(
            50,
            updatedCases.size(),
            'Incorrect number of cases updated'
        );
    }
}
