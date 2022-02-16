import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getUserInitial from '@salesforce/apex/InitialUserInfoGetter.getUserInfo'
import createRequest from '@salesforce/apex/RequestCreation.createRequestToAnalysis'

export default class TicketNotToDoctorCreation  extends NavigationMixin(LightningElement) {
    @api loginPageLink;
    @api buttonClicked = false;
    @api speciality;
    @api returnedValue;
    @api userName;
    @api userLastname;
    @api userSurname;
    @api userPhone;
    @api requestDateTime;
    @api date;
    @api doctor;
    @api email ;
    @api phone;
    @api time;

    TIME_OPTIONS = [
        {label: '9:00', value: '9:00'},
        {label: '10:00', value: '10:00'},
        {label: '11:00', value: '11:00'}
    ];

    PROJECT_OPTIONS = [
        {label: 'ЭКГ', value: 'ЭКГ'},
        {label: 'Анализ крови', value: 'Анализ крови'},
        {label: 'Анализ мочи', value: 'Анализ мочи'},
        {label: 'Узи Сердца', value: 'Узи сердца'},
        {label: 'Узи Брюшной Полости', value: 'Узи брюшной полости'},
    ];
    
    connectedCallback(){
        getUserInitial({})
        .then(result => {
            if(result != null){
                let myMap = {};
                myMap = JSON.parse(result);
                this.userName = myMap['userName'];
                this.userEmail = myMap['userEmail'];
                this.userLastname = myMap['userLastname'];
                this.userSurname  = myMap['userSurname'];
                this.userPhone = myMap['userPhone'];
            }
        });
        this.loginPageLink='https://clinicminsk-developer-edition.ap27.force.com/minskClinic/s/login';
    }

    handleNewTicket(){
        this.buttonClicked = true;
        var element = {};
        console.log(this.PROJECT_OPTIONS);
    }
    handleClickBack() {
        this.buttonClicked = false;
    }
    handleFinishClick(){
        var map1 = new Map();
        map1.set('userName',this.template.querySelector('[data-id="ContactName"]').value);
        map1.set('date',this.template.querySelector('[data-id="date"]').value);
        map1.set('userSurname',this.template.querySelector('[data-id="ContactSurname"]').value);
        map1.set('userLastName',this.template.querySelector('[data-id="ContactLastName"]').value);
        map1.set('analyze',this.template.querySelector('[data-id="analyze"]').value);
        map1.set('userEmail',this.template.querySelector('[data-id="ContactEmail"]').value);
        map1.set('userPhone',this.template.querySelector('[data-id="ContactPhone"]').value);
        map1.set('time',this.template.querySelector('[data-id="time"]').value);   
        const objFromMap = Object.fromEntries(map1);
        var mapString = JSON.stringify(objFromMap);
        createRequest({inputData : mapString})
        .then(result => {
            this.buttonClicked = false;
            alert("Ваша запись сделана, работник регистратуры свяжется с Вами в ближайшее время");
        });
    }
    handleGoToLoginPage(){
        this.isModalOpen = false;
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: 'login'
            }
        });
    }
    handleGoToLoginPage(){
        this.isModalOpen = false;
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: 'login'
            }
        });
    }
}