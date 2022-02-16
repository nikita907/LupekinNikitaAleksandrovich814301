public with sharing class QuoteSendController {
    @AuraEnabled
    public static void sendQuote(Id quoteId){
        try {

            Quote currentQuote = [
                SELECT Id,Client__c
                FROM Quote
                WHERE Id=:quoteId
            ];

            Client__c currentClient = [
                SELECT Id,Email__c,ClientName__c,Client_Surname__c
                FROM Client__c
                WHERE Id=: currentQuote.Client__c
            ];

            User currentUser = [
                SELECT Id
                FROM User
                WHERE Email=: currentClient.Email__c
            ];

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            Messaging.Emailfileattachment efa1 = new Messaging.Emailfileattachment();
            List<id> ContentDocumentids = new List<id>();

            for(contentDocumentLink CDLink : [
                SELECT LinkedEntityid, ContentDocumentid 
                FROM contentDocumentLink 
                WHERE LinkedEntityid=:quoteId
                ])
                
                {
                    ContentDocumentids.add(CDLink.ContentDocumentid);  
                }
            
                ContentVersion cv = [
                    SELECT title,PathOnClient, FileType,versiondata 
                    FROM contentversion 
                    WHERE ContentDocumentId IN :ContentDocumentids 
                    LIMIT 1 
                ];

                Blob Data = cv.VersionData;
                
                if(Data.size()>0)
                {

                    mail.setTargetObjectId(currentUser.Id);
                    mail.setSenderDisplayName('Медецинский Центр');
                    mail.setSubject('Ваша квота на оплату');
                    mail.setUseSignature(false);
                    mail.setHtmlBody('Уважаемый '+currentClient.ClientName__c + ' ' + currentClient.Client_Surname__c + '</br>'+
                        'Ваша квота на оплату');
                    efa1.setBody(Data);
                    efa1.setFileName('Квота на оплату.pdf');
                    efa1.setContentType('application/pdf');
                    mail.setSaveAsActivity(false);
                    mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
                    
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}