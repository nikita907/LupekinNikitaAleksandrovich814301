import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getDoctor from '@salesforce/apex/DoctorBySpecialityGetter.getDoctorBySpeciality'
import getUserInitial from '@salesforce/apex/InitialUserInfoGetter.getUserInfo'
import getTime from '@salesforce/apex/DoctorAccesabilityGetter.getAccessOnInputedDate'
import createRequest from '@salesforce/apex/RequestCreation.createRequestToDoctor'


export default class TicketCreation  extends NavigationMixin(LightningElement) {
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

    PROJECT_OPTIONS = [
        {label: 'Окулист', value: 'Okulist'},
        {label: 'Хирур', value: 'Хирург'},
        {label: 'Терапевт', value: 'Terapevt'},
        {label: 'Лор', value: 'Lor'},
        {label: 'Гинеколог', value: 'Ginicolog'},
        {label: 'Уролог', value: 'Urolog'},
        {label: 'Ортопед', value: 'Ортопед'}
    ];
    TIME_OPTIONS = [
    ];
    DOCTOR_OPTIONS = [
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
    handleChangeSpeciality(event) {
        this.speciality = event.detail.value;
        getDoctor({speciality : this.speciality})
        .then(result => {
            this.DOCTOR_OPTIONS = [];
            this.returnedValue = result[0];
            this.DOCTOR_OPTIONS.push({label: this.returnedValue, value: this.returnedValue});
            console.log(this.returnedValue);
        });
    }
    handleClickBack() {
        this.buttonClicked = false;
    }
    handleChangeDoctor(){
        getDoctor({speciality : this.speciality})
    }
    handleDoctorAssability(event){
        this.requestDateTime = event.detail.value;
        var mydate = new Date(this.requestDateTime).toISOString().slice(0,-14);
        getTime({
            inputedDate : mydate,
            doctorName : this.DOCTOR_OPTIONS[0].label
        })
        .then(result => {
            this.TIME_OPTIONS = [];
            for (let index = 0; index < result.length; index++) {
                    this.returnedValue = result[index];    
                    this.TIME_OPTIONS.push({label: this.returnedValue, value: this.returnedValue}); 
            }
            console.log(this.returnedValue);
        });
        
    }
    handleFinishClick(){
        if(this.template.querySelector('[data-id="doctorName"]').value != 'На данный момет докторов данной специальности нет'){
            var map1 = new Map();
            map1.set('userName',this.template.querySelector('[data-id="ContactName"]').value);
            map1.set('date',this.template.querySelector('[data-id="date"]').value);
            map1.set('userSurname',this.template.querySelector('[data-id="ContactSurname"]').value);
            map1.set('userLastName',this.template.querySelector('[data-id="ContactLastName"]').value);
            map1.set('doctorName',this.template.querySelector('[data-id="doctorName"]').value);
            map1.set('userEmail',this.template.querySelector('[data-id="ContactEmail"]').value);
            map1.set('userPhone',this.template.querySelector('[data-id="ContactPhone"]').value);
            map1.set('time',this.template.querySelector('[data-id="time"]').value);   
            const objFromMap = Object.fromEntries(map1);
            var mapString = JSON.stringify(objFromMap);
            createRequest({inputData : mapString})
            .then(result => {
                if(result =='Success'){
                    this.buttonClicked = false;
                    alert("Ваша запись сделана, работник регистратуры свяжется с Вами в ближайшее время");
                }
                else{
                    alert("Вы не можете сделать запись на прошедшедшее время,выберите,пожалуйста,другую дату");
                }
            });
        }
        else {
            alert("Извините,На данный момент докторов данной специальности нет, поэтому Ваша запись не может быть создана");
        }
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