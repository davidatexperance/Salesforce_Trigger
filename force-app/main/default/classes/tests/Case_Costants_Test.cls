@isTest
public with sharing class Case_Costants_Test {
    @IsTest
    static void Test_ItShouldGetConstants() {
        System.assertNotEquals(null, Case_Constants.STATUS_CLOSED);
        System.assertNotEquals(null, Case_Constants.STATUS_SOLVED);
        System.assertNotEquals(null, Case_Constants.STATUS_WORKING);
        System.assertEquals('OK', Case_Constants.test);
    }
}
