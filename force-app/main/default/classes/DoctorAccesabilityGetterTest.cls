@IsTest
public with sharing class DoctorAccesabilityGetterTest {
    @IsTest
    public static void testDoctorsTime() {

        Doctor__c doc = new Doctor__c(
            Doctor_Surnane__c='Tester',
            Name='Test',
            Doctor_Last_Name__c='Testerovich',
            Speciality__c='Hirurg'
        );

        insert doc;

        Apply__c apply= new Apply__c(
            requestedTime__c = '9:00',
            Doctor__c = doc.Id,
            RequestDate__c = Date.valueOf(Datetime.now())
        );

        insert apply;


        System.assertEquals(11, DoctorAccesabilityGetter.getAccessOnInputedDate(Date.valueOf(Datetime.now()),'Test Tester Testerovich').size());
    }
    @IsTest
    public static void testDoctorsTimeNegative() {

        Doctor__c doc = new Doctor__c(
            Doctor_Surnane__c='Tester',
            Name='Test',
            Doctor_Last_Name__c='Testerovich',
            Speciality__c='Hirurg'
        );

        insert doc;

        Apply__c apply= new Apply__c(
            requestedTime__c = '9:00',
            Doctor__c = doc.Id,
            RequestDate__c = Date.valueOf(Datetime.now())
        );

        insert apply;


        System.assertEquals(0, DoctorAccesabilityGetter.getAccessOnInputedDate(Date.valueOf(Datetime.now()),'Test TesterInvalid Testerovich').size());
    }
}