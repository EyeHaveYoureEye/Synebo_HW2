/* eslint-disable @lwc/lwc/no-api-reassignments */
import { LightningElement, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getJsonWithAnimals from '@salesforce/apex/AnimalController.getJsonWithAnimals';
import createAnimalById from '@salesforce/apex/AnimalController.createAnimalById';
import createAnimalByFields from '@salesforce/apex/AnimalController.createAnimalByFields';


const columns = [
    { label: 'Id', fieldName: 'id' },
    { label: 'Name', fieldName: 'name' },
    { label: 'Eats', fieldName: 'eats'},
    { label: 'Says', fieldName: 'says'},
];

export default class BasicDatatable extends NavigationMixin(LightningElement) {
    data = [];
    columns = columns;
    valueIdForCheckAndCreate;
    valueIdForCreateByUser;
    valueName;
    valueEats;
    valueSays;
    @track isModalOpen = false;
    @track isModalOpenOnId = false;
    @track isModalOpenOnCreateAnimal = false;

    openModal() {
        this.isModalOpen = true;
        this.isModalOpenOnId = true;
    }
    closeModal() {
        this.isModalOpen = false;
        this.isModalOpenOnId = false;
        this.isModalOpenOnCreateAnimal = false;
    }
    async submitDetails() {
        if(this.valueIdForCheckAndCreate){
            let returnedId;  
            await createAnimalById({id:this.valueIdForCheckAndCreate})
            .then(result => {returnedId = result});
            if(returnedId > 0){
                this.showNotification("Yay", "You created an animal by prepared id in webservice","success");
                this.closeModal();
            } else {
                this.showNotification("Ooops", "We don`t found prepared animal, by your id in webservice. Please, enter animal data by your own","warning");
                this.valueIdForCheckAndCreate = undefined;
                this.isModalOpenOnId = false;
                this.isModalOpenOnCreateAnimal = true;
            }
        } else if (this.valueIdForCreateByUser && this.valueName && this.valueEats && this.valueSays){
                let myResult;
                await createAnimalByFields({id:this.valueIdForCreateByUser,name:this.valueName,
                eats:this.valueEats,says:this.valueSays})
                .then(result => {myResult = result});
                if(myResult === true){
                    this.showNotification("Yay", "You created an animal by your fields","success");
                    this.closeModal();
                } else {
                    this.showNotification("Ooops", "Unexpected error","error");
                    this.closeModal();
                }
        } else {
            this.showNotification("Error", "Before submit, you need to insert all fields properly","error");
        }
    }

    

    handleIdFieldChange(event){
        if(!isNaN(event.target.value)){
        this.valueIdForCheckAndCreate = event.target.value;
        } else {
            event.target.value = undefined;
            event.target.placeholder = "Type number !";
            this.showNotification("Error", "To insert id, you must enter number","error");
        } 
    }

    handleAnimalFieldsChange(event){
        if(event.target.label === "External id"){
            if(!isNaN(event.target.value)){
            this.valueIdForCreateByUser = event.target.value;
            } else {
                event.target.value = undefined;
                event.target.placeholder = "Type number !";
                this.showNotification("Error", "To insert id, you must enter number","error");
            } 
        }
        if(event.target.label === "Name"){
            this.valueName = event.target.value;
        }
        if(event.target.label === "Eats"){
            this.valueEats = event.target.value;
        }
        if(event.target.label === "Says"){
            this.valueSays = event.target.value;
        }
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    openNewByNM(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Animal__c',
                actionName: 'new'
            }
        });
    }

    async connectedCallback() {
        let myJson = await getJsonWithAnimals();
        this.data = JSON.parse(myJson);  
    }
}

