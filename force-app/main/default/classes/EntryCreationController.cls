public without sharing class EntryCreationController {
    @AuraEnabled
    public static String inputEntry(Id applyId, String diagnoz, String suggestion){
        try {

            Apply__c currentApply = [
                SELECT Id,Client__c,Doctor__c
                FROM Apply__c
                WHERE Id =: applyId
            ];


            if(currentApply != null){
                Entry__c newEntry= new Entry__c();
                newEntry.Diagnoz__c = diagnoz;
                newEntry.DoctorSuggestion__c = suggestion;
                newEntry.Client__c = currentApply.Client__c;
                newEntry.Doctor__c = currentApply.Doctor__c;
                newEntry.EntryTime__c=datetime.now().time();
                newEntry.Date__c = datetime.now().date();
                newEntry.Name = 'Посещение от' + datetime.now().date() +' в ' + datetime.now().time();

                insert newEntry;

                Messaging.CustomNotification notification = new Messaging.CustomNotification();
                Set<String> recipientsIds = new Set <String>();
                recipientsIds.add('0055j000002XMUyAAO');
                notification.setTitle('Оформлено новое посещение');
                notification.setBody('Вам необходимо внести отправить клиенту квоту на оплату');

                notification.setNotificationTypeId('0ML5j000000bljUGAQ');
                notification.setTargetId(newEntry.Id);
                notification.send(recipientsIds);
            }
        
            delete currentApply;
            return 'Success';


        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}