@isTest
public with sharing class PrepareDateForAnimalTest {
    
    @isTest
    public static void createOneHunredAnimals() {
        List<Animal__c> animals = new List<Animal__c>();
        for(Integer iterator = 0; iterator < 152; iterator++){
            animals.add(new Animal__c(Name = String.valueOf(iterator) , Id__c = Integer.valueOf((Math.random()*5))));
        }
        insert animals;
    }

    @isTest
    public static void createTenAnimalsByIdAndUpdate() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForAnimalTest());
        Integer id = 1;
        List<Animal__c> animals = new List<Animal__c>();
        for(Integer iterator = 0; iterator < 10; iterator++){
            animals.add(new Animal__c(Name = String.valueOf(iterator) , Id__c = id));
        }
        insert animals;
        Test.startTest();
        AnimalHandlerClass.getListOfAnimalsAndStartUpdateAnimalByRequest(animals);
        Test.stopTest();
    }
}