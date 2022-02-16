public without sharing class InitialUserInfoGetter {
    @AuraEnabled
    public static String getUserInfo(){
        try {
            Map <String,String> values = new Map<String,String>();

            String userName = UserInfo.getName();
            String userEmail = UserInfo.getUserEmail();

            Contact currentUser = [
                SELECT Id,ClientName__c,ClientLastName__c,ClientSurname__c,MobilePhone,Email
                FROM Contact
                WHERE Email =: userEmail
            ];

            if(currentUser != null){
                values.put('userName', currentUser.ClientName__c);
                values.put('userEmail',currentUser.Email);
                values.put('userLastname', currentUser.ClientLastName__c);
                values.put('userSurname', currentUser.ClientSurname__c);
                values.put('userPhone', currentUser.MobilePhone);
            }

            String result = JSON.serialize(values);
            return result;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}