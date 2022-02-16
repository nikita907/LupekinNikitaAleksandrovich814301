public with sharing class RequestCreation {
    @AuraEnabled
    public static String createRequestToDoctor(String inputData){
        try {

            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(inputData);
            System.debug('----------------------------------'+m);
            String userName = m.get('userName').toString();
            String userSurname = m.get('userSurname').toString();
            String userLastname = m.get('userLastName').toString();
            String userPhone = m.get('userPhone').toString();
            String doctorName='';
            try{
                doctorName = m.get('doctorName').toString();
            }
            catch (Exception e){
                System.debug(e);
            }
            String userEmail = m.get('userEmail').toString();
            String inputedTime = m.get('time').toString();
            String inputedDate = m.get('date').toString();
            Date userDate=date.valueOf(inputedDate);
            Date d1 = Date.today();
            if(d1 > userDate){
                System.debug('I am in if');
                return 'DateError';
            }
            String doctorsName;
            String doctorSurName;
            String doctorLastName;
            

            if(doctorName!=''){
                List <String> doctorInfo = doctorName.split(' ');
                doctorsName = doctorInfo[0];
                doctorSurName = doctorInfo[1];
                doctorLastName = doctorInfo[2];
            }
            
            List <Client__c > currentUser = [
                SELECT Id
                FROM Client__c 
                WHERE Email__c =: userEmail
            ];

            List <Doctor__c> doc = new List<Doctor__c>();

            if(doctorName!=''){
                    doc = [
                    SELECT Id,Name
                    FROM Doctor__c
                    WHERE Name=: doctorsName
                    AND Doctor_Last_Name__c =: doctorLastName
                    AND Doctor_Surnane__c =: doctorSurName
                ];
            }

           //Doctor__c usedDoctor = doc[0].id;

            Apply__c apply = new Apply__c();
            if(!doc.isEmpty()){
                apply.Doctor__c = doc[0].id;
            }
            apply.requestedTime__c = inputedTime;
            apply.RequestDate__c = userDate;
            apply.RecordTypeId = '0125j000001DQZpAAO';
            //apply.Doctor_Account__c = '0015j00000Cyj0CAAR';

            if(currentUser.isEmpty()){
                Client__c  con= new Client__c();
                con.ClientName__c = userName;
                con.Client_Surname__c = userSurname;
                con.ClientLastName__c = userLastname;
                con.Email__c = userEmail;
                con.Phone__c = userPhone;
                //con.AccountId = '0015j00000BeuZAAAZ2';

                insert con;


                apply.Client2__c = con.Id;
            }
            else{
                apply.Client__c = currentUser[0].id;
            }

            insert apply;

            return 'Success';


        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string createRequestToAnalysis(String inputData){
        try {

            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(inputData);
            System.debug('----------------------------------'+m);
            String userName = m.get('userName').toString();
            String userSurname = m.get('userSurname').toString();
            String userLastname = m.get('userLastName').toString();
            String userPhone = m.get('userPhone').toString();
            String doctorName='';
            String userEmail = m.get('userEmail').toString();
            String inputedTime = m.get('time').toString();
            String inputedDate = m.get('date').toString();
            Date userDate=date.valueOf(inputedDate);
            String inputedAnalyse = m.get('analyze').toString();

            
            List <Client__c > currentUser = [
                SELECT Id
                FROM Client__c 
                WHERE Email__c =: userEmail
            ];


           //Doctor__c usedDoctor = doc[0].id;

            Apply__c apply = new Apply__c();
            apply.requestedTime__c = inputedTime;
            apply.RequestDate__c = userDate;
            apply.RecordTypeId = '0125j000001DQZuAAO';
            apply.AnalyseType__c=inputedAnalyse;

            if(currentUser.isEmpty()){
                Client__c  con= new Client__c();
                con.ClientName__c = userName;
                con.Client_Surname__c = userSurname;
                con.ClientLastName__c = userLastname;
                con.Email__c = userEmail;
                con.Phone__c = userPhone;
                //con.AccountId = '0015j00000BeuZAAAZ2';

                insert con;


                apply.Client2__c = con.Id;
            }
            else{
                apply.Client__c = currentUser[0].id;
            }

            insert apply;

            return 'Success';


        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
}
}