import { LightningElement,api } from 'lwc';
import inputEntry from '@salesforce/apex/EntryCreationController.inputEntry';
import { NavigationMixin } from 'lightning/navigation';

export default class SendEmailComponent extends NavigationMixin(LightningElement) {
    @api recordId;
    @api emailSubject;
    @api suggestion;

    handleConfirmation(){
        console.log(this.recordId);
        this.diagnoz = this.template.querySelector('[data-id="diagnoz"]').value;
        this.suggestion = this.template.querySelector('[data-id="suggestion"]').value;
        inputEntry({
                applyId : this.recordId,
                diagnoz : this.diagnoz,
                suggestion : this.suggestion
            })
            .then(result => {
                alert('Данные внесены');
                window.location.reload();
                window.location.reload();
            });
    }
}