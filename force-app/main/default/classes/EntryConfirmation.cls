public with sharing class EntryConfirmation {
    @AuraEnabled
    public static string confirmEntry(Id requestId){
        try {
            List <Apply__c> currentApply = [
                SELECT Id,Confirm__c,RequestDate__c,requestedTime__c,Client__c
                FROM Apply__c
                WHERE Id=: requestId
            ];

            if(!currentApply.isEmpty()){
                currentApply[0].Confirm__c = true;
            }

            Client__c currentClient = [
                SELECT Id,Email__c,ClientName__c,Client_Surname__c
                FROM Client__c
                WHERE Id=: currentApply[0].Client__c
            ];

            List <User> currentUser = [
                SELECT Id
                FROM User
                WHERE Email=: currentClient.Email__c
            ];

            if(!currentApply.isEmpty()){
                if(currentClient != null || currentUser != null){

                   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                    //String[] toAddresses = new String[] {currentClient.Email__c}; 

                    mail.setTargetObjectId(currentUser[0].Id);
                    //mail.setToAddresses(toAddresses);
                    mail.setSenderDisplayName('Медицинский Центр');
                    mail.setSubject('Ваша запись подтверждена');
                    mail.setUseSignature(false);
                    mail.setSaveAsActivity(false);
                    mail.setHtmlBody('Уважаемый '+currentClient.ClientName__c + ' ' + currentClient.Client_Surname__c + '</br>'+
                        'Ваша запись на '+ Date.valueOf(currentApply[0].RequestDate__c) + ' в '+ currentApply[0].requestedTime__c + ' подтверждена ');
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

                }
            }
            

        update currentApply;

        return 'Redirect';

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}