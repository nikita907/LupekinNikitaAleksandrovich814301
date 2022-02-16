public with sharing class DoctorAccesabilityGetter {
    @AuraEnabled
    public static List <String> getAccessOnInputedDate(Date inputedDate, String doctorName){
        //List<String> devidedDate = inputedDate.split('-');
        //String year = devidedDate[0];
        //String month = devidedDate[1];
        //String day = devidedDate[2];
        //String validDate = year + '-' + month + '-' + day;
        List <String> times = new List <String>();
        List <String> timeToReturn = new List <String>();
        List <String> doctorInfo = doctorName.split(' ');
        String doctorsName = doctorInfo[0];
        String doctorSurName = doctorInfo[1];
        String doctorLastName = doctorInfo[2];
        try {
            
            List <Doctor__c> doc = [
                SELECT Id,Name
                FROM Doctor__c
                WHERE Name=: doctorsName
                AND Doctor_Last_Name__c =: doctorLastName
                AND Doctor_Surnane__c =: doctorSurName
            ];

            if(doc.size() != 0){
                Doctor__c inputedDoctor = doc[0];
                //Datetime dt = d.format('yyyy-MM-dd');
               /// System.debug(d);
               // System.debug(inputedDoctor.Id);
                //Date dt = (Date)JSON.deserialize('"' + inputedDate + '"', Date.class);
                //Date d = Date.parse(inputedDate);
                //String test = inputedDate.format('yyyy-MM-dd');
                Date value = Date.valueOf(inputedDate);
                List <Apply__c> requests = [
                    SELECT 	requestedTime__c
                    FROM Apply__c
                    WHERE RequestDate__c =: value
                    AND Doctor__c =: inputedDoctor.Id
                ];

                for (Apply__c currentRequest : requests){
                    System.debug('-----------------------------------'+currentRequest.requestedTime__c);
                    times.add(currentRequest.requestedTime__c);
                }

                for (Integer i=9; i<20; i++){
                    String timeString =  i+':00';
                    if(!(times.contains(timeString))){
                        timeToReturn.add(timeString);
                    }
                }
 
            }
            
            return timeToReturn;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}