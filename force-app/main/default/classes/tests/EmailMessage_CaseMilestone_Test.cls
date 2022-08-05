/**
 *
 * @format
 * @description :  EmailMessage Trigger Helper Tests
 * Note: Please view Contact Tests for Complete Test Coverage (Positive, Negative and Bulk)
 * This is written to obtain code coverage for the assessment
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-04-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-03-2022   david@experancepartners.com   Initial Version
 *
 */
@isTest
public with sharing class EmailMessage_CaseMilestone_Test {
    private static final String GOOD_EMAIL = 'good@email.com';
    private static final String BAD_EMAIL = 'bad@email.com';
    private static final String SUBJECT_WITH_ENTITLEMENT = 'Good Subject';
    private static final String SUBJECT_WITHOUT_ENTITLEMENT = 'Bad Subject';
    private static final String FIRST_RESPONSE = 'First Response';
    private static final String ENTITLEMENT_PROCESS = 'Standard Case';

    @TestSetup
    static void makeData() {
        SlaProcess sla = [
            SELECT Id, Name
            FROM SlaProcess
            WHERE Name = :ENTITLEMENT_PROCESS
            LIMIT 1
        ];
        Account account = (Account) TestFactory.createSObject(
            new Account(),
            true
        );
        Contact contact = (Contact) TestFactory.createSObject(
            new Contact(AccountId = account.Id, Email = GOOD_EMAIL),
            true
        );

        // MilestoneType mType = (MilestoneType) TestFactory.createSObject(
        //     new MilestoneType(Name = FIRST_RESPONSE, RecurrenceType = 'none'),
        //     true
        // );

        // ServiceContract sContract = (ServiceContract) TestFactory.createSObject(
        //     new ServiceContract(
        //         AccountId = account.Id,
        //         StartDate = System.today()
        //     ),
        //     true
        // );

        // EntityMilestone eMilestone = (EntityMilestone) TestFactory.createSObject(
        //     new EntityMilestone(
        //         MilestoneTypeId = mType.Id,
        //         TargetResponseInHrs = 8,
        //         SlaProcessId = sla.Id,
        //         StartDate = System.today(),
        //         Status = 'Active'
        //     ),
        //     true
        // );

        Entitlement ent = (Entitlement) TestFactory.createSObject(
            new Entitlement(
                Name = 'Sample Entitlement',
                SlaProcessId = sla.Id,
                //ServiceContractId = sContract.Id,
                AccountId = account.Id,
                StartDate = System.today()
            ),
            true
        );
        Case c = (Case) TestFactory.createSObject(
            new Case(
                Subject = SUBJECT_WITH_ENTITLEMENT,
                ContactId = contact.Id,
                EntitlementId = ent.Id
            ),
            true
        );
    }

    @IsTest
    static void Test_ItShouldUpdateStatusOnEmailSend() {
        Case c = [
            SELECT Id
            FROM Case
            WHERE Subject = :SUBJECT_WITH_ENTITLEMENT
            LIMIT 1
        ];
        EmailMessage email = (EmailMessage) TestFactory.createSObject(
            new EmailMessage(
                ParentId = c.Id,
                ToAddress = GOOD_EMAIL,
                Incoming = false
            )
        );

        Test.startTest();

        insert email;

        Test.stopTest();

        CaseMilestone resultCM = [
            SELECT CompletionDate
            FROM CaseMilestone
            WHERE CaseId = :c.Id AND MilestoneType.Name = :FIRST_RESPONSE
            LIMIT 1
        ];

        System.assert(resultCM.CompletionDate != null);
    }
}
