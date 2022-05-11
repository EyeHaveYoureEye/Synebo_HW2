public with sharing class AnimalWrapper {

    public AnimalWrapper(Animal__c animal) {
        this.id = animal.Id__c;
        this.name = animal.Name;
        this.eats = animal.Eats__c;
        this.says = animal.Says__c;
    }
        public Decimal id;
		public String name;
		public String eats;
		public String says;
    
}