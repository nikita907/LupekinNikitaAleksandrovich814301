trigger ApplyCreationTrigger on Opportunity (before insert) {
    Id doctorId;
    List <Opportunity> oppToUpdate = new List <Opportunity>();

    String userEmail = UserInfo.getUserEmail();

    List <User> currentUser = [
        SELECT Id,Name
        FROM User
        WHERE Email =: userEmail
    ];


    String docName = currentUser[0].Name;
    List <String> docNameWords = docName.split(' ');
    String docFirstName = docNameWords[0];
    String docSurName = docNameWords[1];

        if(currentUser != null){
            Doctor__c doctorToInclude = [
                SELECT Id
                FROM Doctor__c
                WHERE Name=: docFirstName
                AND Doctor_Surnane__c =: docSurName
            ];

        for(Opportunity currentApply : Trigger.new ){
            currentApply.Doctor__c = doctorToInclude.Id;
        }   
    }
}