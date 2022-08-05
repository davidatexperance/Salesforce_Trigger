/**
 *
 * @format
 * @description :  Trigger Handler Tests
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-04-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-04-2022   david@experancepartners.com   Initial Version
 *
 */
@isTest
public with sharing class TriggerFactory_Test {
    private static String OLD_NAME = 'First Name';
    private static String NEW_NAME = 'Second Name';

    @IsTest
    static void Test_ItShouldTriggerStuff() {
        Account account = (Account) TestFactory.createSObject(
            new Account(Name = OLD_NAME),
            false
        );

        insert account;
        Account resultAccount = [
            SELECT Id, Name
            FROM Account
            WHERE Id = :account.Id
            LIMIT 1
        ];

        System.assertEquals(OLD_NAME, resultAccount.Name);

        account.Name = NEW_NAME;
        update account;

        resultAccount = [
            SELECT Id, Name
            FROM Account
            WHERE Id = :account.Id
            LIMIT 1
        ];
        System.assertEquals(NEW_NAME, resultAccount.Name);

        delete account;
        List<Account> resultAccounts = [
            SELECT Id, Name
            FROM Account
            WHERE Id = :account.Id
        ];
        System.assertEquals(0, resultAccounts.size());

        undelete account;

        resultAccount = [
            SELECT Id, Name
            FROM Account
            WHERE Id = :account.Id
            LIMIT 1
        ];
        System.assertEquals(NEW_NAME, resultAccount.Name);
    }
}
