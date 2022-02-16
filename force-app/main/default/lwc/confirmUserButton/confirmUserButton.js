import { LightningElement,api } from 'lwc';
import confirmUser from '@salesforce/apex/UserConfirmation.confirmUser'


export default class ConfirmUserButton extends LightningElement {
    @api recordId;

    handleConfirmation(){
        console.log(this.recordId);
        confirmUser({
            userId : this.recordId
        })
        window.location.reload();
        window.location.reload();
    }
}