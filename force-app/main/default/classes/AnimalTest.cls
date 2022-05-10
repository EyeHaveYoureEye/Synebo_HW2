@isTest
public with sharing class AnimalTest {
    private static String URL = 'https://th-apex-http-callout.herokuapp.com/animals/';

    //Before use this tests, u must switch classes with comments in AnimalTrigger!!!!!!!!!!! 

   @isTest
   static void checkAsyncMethodsOnTrigger(){
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForAnimalTest());

    Test.startTest();
    PrepareDateForAnimalTest.createOneHunredAnimals();
    Test.stopTest();

    List<Animal__c> animals = [Select Id__c,Name,Eats__c,Says__c From Animal__c];

    Animal__c animalWithFirstId = [Select Id__c,Name,Eats__c,Says__c From Animal__c Where Id__c = 1 LIMIT 1];
    Animal__c animalWithSecondId = [Select Id__c,Name,Eats__c,Says__c From Animal__c Where Id__c = 2 LIMIT 1];
    Animal__c animalWithOtherId = [Select Id__c,Name,Eats__c,Says__c From Animal__c Where Id__c = 3 LIMIT 1];
    
    System.assertEquals(1, animalWithFirstId.Id__c);
    System.assertEquals('chicken', animalWithFirstId.Name);
    System.assertEquals('chicken food', animalWithFirstId.Eats__c);
    System.assertEquals('cluck cluck', animalWithFirstId.Says__c);

    System.assertEquals(2, animalWithSecondId.Id__c);
    System.assertEquals('bear', animalWithSecondId.Name);
    System.assertEquals('berries, campers, adam seligman', animalWithSecondId.Eats__c);
    System.assertEquals('yum yum', animalWithSecondId.Says__c);

    System.assertEquals(3, animalWithOtherId.Id__c);
    System.assertEquals('null', animalWithOtherId.Name);
    System.assertEquals('null', animalWithOtherId.Eats__c);
    System.assertEquals('null', animalWithOtherId.Says__c);
   }

}