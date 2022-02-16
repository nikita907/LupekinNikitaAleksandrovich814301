import { LightningElement,api } from 'lwc';
import sendEmail from '@salesforce/apex/EmailSenderController.sendEmail'

export default class SendEmailComponent extends LightningElement {
    @api recordId;
    @api emailSubject;
    @api emailText;

    handleConfirmation(){
        console.log(this.recordId);
        this.emailSubject = this.template.querySelector('[data-id="Subject"]').value;
        this.emailText = this.template.querySelector('[data-id="Text"]').value;
        if(this.emailText!=undefined){
            sendEmail({
                userId : this.recordId,
                emailSubject : this.emailSubject,
                emailText : this.emailText
            })
            .then(result => {
                alert('Письмо было отправлено');
            });
        }
        else {
            alert('Заполните текст письма');
        }
    }
}