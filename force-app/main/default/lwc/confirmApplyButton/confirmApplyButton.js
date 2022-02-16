import { LightningElement,api } from 'lwc';
import confirmApply from '@salesforce/apex/EntryConfirmation.confirmEntry';
import { NavigationMixin } from 'lightning/navigation';

export default class ConfirmApplyButton extends NavigationMixin(LightningElement) {
    @api recordId;

    handleConfirmation(){
        console.log(this.recordId);
        confirmApply({
            requestId : this.recordId
        })
        .then(result => {
            if(result=='Redirect'){
                window.location.reload();
                window.location.reload();
            }
        });
    }
}