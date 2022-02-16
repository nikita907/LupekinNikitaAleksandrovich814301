public with sharing class UserConfirmation {
    @AuraEnabled
    public static void confirmUser(Id userId){
        try {
            List <Client__c> currentClient = [
                SELECT Id,IsConfirmed__c
                FROM Client__c
                WHERE Id=: userId
            ];

            if(!currentClient.isEmpty()){
                currentClient[0].IsConfirmed__c = true;
            }

            update currentClient;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}