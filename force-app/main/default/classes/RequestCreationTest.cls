@IsTest
public with sharing class RequestCreationTest {
    @IsTest
    public static void RequestCreationTest() {


        /*Client__c client = new Client__c(
            ClientName__c = 'Test',
            ClientLastName__c = 'Testerovich',
            Client_Surname__c = 'Tester',
            Email__c = 'nikita907official@gmail.com',
            Phone__c = '+375336389822'
        );*/

        //insert client;

        Map <String,String> testDate= new Map <String,String>();
        testDate.put('userName','Test');
        testDate.put('userLastName','Testerovich');
        testDate.put('userSurname','Tester');
        testDate.put('userPhone','+375336389822');
        testDate.put('userEmail','nikita907official@gmail.com');
        testDate.put('time','9:00');
        testDate.put('date',String.valueOf(Date.valueOf(Datetime.now())));
        
        /*Apply__c apply = [
            SELECT Id
            FROM Apply__c
            WHERE Client__c =: client.Id
        ];*/

        String data = JSON.serialize(testDate);
        RequestCreation.createRequestToAnalysis(data);
        System.assertEquals('Success', RequestCreation.createRequestToDoctor(data));
        //Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(inputData);
    }
    @IsTest
    public static void RequestCreationTestNegative() {


        /*Client__c client = new Client__c(
            ClientName__c = 'Test',
            ClientLastName__c = 'Testerovich',
            Client_Surname__c = 'Tester',
            Email__c = 'nikita907official@gmail.com',
            Phone__c = '+375336389822'
        );*/

        //insert client;

        Map <String,String> testDate= new Map <String,String>();
        testDate.put('userName','Test');
        testDate.put('userLastName','Testerovich');
        testDate.put('userSurname','Tester');
        testDate.put('userPhone','+375336389822');
        testDate.put('userEmail','nikita907official@gmail.com');
        testDate.put('doctorName','Test Test Test');
        testDate.put('time','9:00');
        testDate.put('date',String.valueOf(Date.valueOf(Datetime.now().addDays(-18))));
        
        /*Apply__c apply = [
            SELECT Id
            FROM Apply__c
            WHERE Client__c =: client.Id
        ];*/

        String data = JSON.serialize(testDate);
        System.assertEquals('DateError', RequestCreation.createRequestToDoctor(data));
        //Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(inputData);
    }
}