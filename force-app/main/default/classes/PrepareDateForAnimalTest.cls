public with sharing class PrepareDateForAnimalTest {
    
    public static void createOneHunredAnimals() {
        List<Animal__c> animals = new List<Animal__c>();
        for(Integer iterator = 0; iterator < 152; iterator++){
            animals.add(new Animal__c(Name = String.valueOf(iterator) , Id__c = Integer.valueOf((Math.random()*5))));
        }
        insert animals;
    }
}