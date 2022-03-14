@IsTest
public with sharing class EntryConfirmationTest {
    @IsTest
    public static void EntryConfirmationTest() {
        Client__c client = new Client__c(
            Client_Surname__c = 'Tester',
            ClientName__c='Test',
            ClientLastName__c='Testerovich',
            Email__c='email@test.com'
        );

        insert client;

        Apply__c apply= new Apply__c(
            requestedTime__c = '9:00',
            Client__c = client.Id,
            RequestDate__c = Date.valueOf(Datetime.now())
        );

        insert apply;

        EntryConfirmation.confirmEntry(apply.id);

        List <Apply__c> applys = [
            SELECT Id
            FROM Apply__c
            WHERE Client__c =: client.Id
            AND Confirm__c = true
        ];

        System.assertEquals(1,applys.size());

    }
    @IsTest
    public static void EntryConfirmationTestNegative() {
        Client__c client = new Client__c(
            Client_Surname__c = 'Tester',
            ClientName__c='Test',
            ClientLastName__c='Testerovich',
            Email__c='email@test.com'
        );

        insert client;

        Apply__c apply= new Apply__c(
            requestedTime__c = '9:00',
            Client__c = client.Id,
            RequestDate__c = Date.valueOf(Datetime.now())
        );

        insert apply;

        EntryConfirmation.confirmEntry(apply.id);

        List <Apply__c> applys = [
            SELECT Id
            FROM Apply__c
            WHERE Client__c =: client.Id
            AND Confirm__c = false
        ];

        System.assertEquals(0,applys.size());

    }
}
