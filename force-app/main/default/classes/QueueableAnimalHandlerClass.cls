public class QueueableAnimalHandlerClass implements Queueable, Database.AllowsCallouts {
    private static final String URL = 'https://th-apex-http-callout.herokuapp.com/animals';
    List<Animal__c> animals = new List<Animal__c>();
    List<Animal__c> cuttedList = new List<Animal__c>();

    public QueueableAnimalHandlerClass(List<Animal__c> animals) {
        this.animals = [Select Id__c,Name,Eats__c,Says__c From Animal__c Where Id In :animals];
    }

    private void controllerOfSizeList() {
        if (this.animals.size() > 50) {
            List<Animal__c> temp = new List<Animal__c>();
            Integer iterator = 0;
            for (Animal__c animal : this.animals) {
                if (iterator < 50) {
                    temp.add(animal);
                } else {
                    this.cuttedList.add(animal);
                }
                
                iterator++;
            }
            this.animals.clear();
            this.animals.addAll(temp);
        } 
    }

    public void execute(QueueableContext context) {
        controllerOfSizeList();
        List<Animal__c> updatedAnimal = new List<Animal__c>();
        Map<Decimal,AnimalParsing> requestedAnimals = getListOfAnimalsBySendingRequest(this.animals);
        for (Animal__c animal : this.animals) {
            animal.Name = requestedAnimals.get(animal.Id__c).Animal.Name;
            animal.Eats__c = requestedAnimals.get(animal.Id__c).Animal.eats;
            animal.Says__c = requestedAnimals.get(animal.Id__c).Animal.says;
            updatedAnimal.add(animal);
        }
        update updatedAnimal;
        if (this.cuttedList.size() != 0 && !Test.isRunningTest()) {
            System.enqueueJob(new QueueableAnimalHandlerClass(cuttedList));
        }
    }
   
       private Map<Decimal,AnimalParsing> getListOfAnimalsBySendingRequest(List<Animal__c> animals) {
         Map<Decimal,AnimalParsing> requestedAnimals = new Map<Decimal,AnimalParsing>();
         for (Animal__c animal : animals) {
             if (!requestedAnimals.containsKey(animal.Id__c)) {
                requestedAnimals.put(animal.Id__c, AnimalHandlerClass.sendRequest(animal.Id__c));
             }
         }
         return requestedAnimals;
       }
}