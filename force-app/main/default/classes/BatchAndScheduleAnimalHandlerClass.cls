public with sharing class BatchAndScheduleAnimalHandlerClass implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts  {
    private static String URL = 'https://th-apex-http-callout.herokuapp.com/animals/';

    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select Id__c, Name, Eats__c, Says__c From Animal__c' + (Test.isRunningTest()?' LIMIT 200':' ');
        System.debug('start');
        return Database.getQueryLocator(query);
     }

     public Set<Decimal> getFilteredId (List<Animal__c> animals){
      Set<Decimal> setUnrepetitiveIdForRequest = new Set<Decimal>();
        for (Animal__c animal : animals) {
          setUnrepetitiveIdForRequest.add(animal.Id__c);          
        }
        return setUnrepetitiveIdForRequest;
     }

     private Map<Decimal,AnimalParsing> getMapOfUnrepetitiveAnimalsBySendingRequest(List<Animal__c> animals) {
      Map<Decimal,AnimalParsing> requestedAnimals = new Map<Decimal,AnimalParsing>();
      for (Animal__c animal : animals) {
          if (!requestedAnimals.containsKey(animal.Id__c)) {
             requestedAnimals.put(animal.Id__c, AnimalParsing.parse(ReadyToUseRequests.sendGet(Url + Integer.valueOf(animal.Id__c)).getBody()));
          }
      }
      return requestedAnimals;
    }
  
     public void execute(Database.BatchableContext BC,  List<Animal__c> scope){
        Map<Decimal,AnimalParsing> requestedAnimals = getMapOfUnrepetitiveAnimalsBySendingRequest(scope);
        for(Animal__c s : scope){
            s.Name = requestedAnimals.get(s.Id__c).Animal.Name;
            s.Eats__c = requestedAnimals.get(s.Id__c).Animal.eats;
            s.Says__c = requestedAnimals.get(s.Id__c).Animal.says;
            System.debug(s);
        }     
        System.debug('exec');
         update scope;
     }

    public void finish(Database.BatchableContext BC){}
    
   public void execute(SchedulableContext SC) {
        System.debug('Schedule');
      Database.executeBatch(new BatchAndScheduleAnimalHandlerClass());
   }

}