import { LightningElement } from 'lwc';
import apexMethodName from '@salesforce/apex/AnimalBackForFront.getJsonByList';

const columns = [
    { label: 'Id', fieldName: 'id' },
    { label: 'Name', fieldName: 'name' },
    { label: 'Eats', fieldName: 'eats'},
    { label: 'Says', fieldName: 'says'},
];

export default class BasicDatatable extends LightningElement {
    data = [];
    columns = columns;

    async connectedCallback() {
        var myJson = await apexMethodName();
        myJson = myJson.replace(/\(/g, '[');
        myJson = myJson.replace(/\)/g, ']');
        this.data = JSON.parse(myJson);  
    }
}

