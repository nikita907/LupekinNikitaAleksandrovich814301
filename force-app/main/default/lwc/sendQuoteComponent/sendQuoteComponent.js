import { LightningElement,api } from 'lwc';
import sendQuote from '@salesforce/apex/QuoteSendController.sendQuote';

export default class SendQuoteComponent extends LightningElement {
    @api recordId;

    handleConfirmation(){
        console.log(this.recordId);
        sendQuote({
            quoteId : this.recordId
        })
        .then(result => {
            if(result=='Redirect'){
                window.location.reload();
                window.location.reload();
            }
        });
    }
}