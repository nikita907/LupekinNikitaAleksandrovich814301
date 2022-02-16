public with sharing class DoctorBySpecialityGetter {
    @AuraEnabled
    public static List<String> getDoctorBySpeciality(String speciality) {

        List <String> returnedDoctors = new List <String>();
        List <Doctor__c> doctors = [
            SELECT Name,Doctor_Last_Name__c,Doctor_Surnane__c
            FROM Doctor__c
            WHERE Speciality__c =: speciality
        ];

        for(Doctor__c doctor : doctors){
            String name = doctor.Name;
            String surname = doctor.Doctor_Surnane__c;
            String lastName = doctor.Doctor_Last_Name__c;
            returnedDoctors.add(name+' '+surname+' '+lastName);
        }
        if(returnedDoctors.isEmpty()){
            returnedDoctors.add('На данный момет докторов данной специальности нет');
        }
        return returnedDoctors;
    }
}