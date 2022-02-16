public with sharing class EmailSenderController {
   @AuraEnabled
   public static string sendEmail(Id userId, String emailSubject, String emailText){
       try {

            Client__c currentClient = [
                SELECT Id,Email__c,ClientName__c,Client_Surname__c
                FROM Client__c
                WHERE Id=: userId
            ];

            List<User> currentUser = [
                SELECT Id
                FROM User
                WHERE Email=: currentClient.Email__c
            ];

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            List <String> mailToSent = new List <String>();
            mailToSent.add(currentClient.Email__c);
            //mail.setTargetObjectId(currentUser[0].Id);
            mail.setToAddresses(mailToSent);
            mail.setSenderDisplayName('Медицинский Центр');
            mail.setSubject(emailSubject);
            mail.setUseSignature(false);
            mail.setHtmlBody(emailText);
            mail.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

            return 'success';

       } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
       }
   }
}