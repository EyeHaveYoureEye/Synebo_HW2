public with sharing class BatchAndScheduleAnimalHandlerClass implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts  {
    private static String URL = 'https://th-apex-http-callout.herokuapp.com/animals/';

    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select Id__c, Name, Eats__c, Says__c From Animal__c' + (Test.isRunningTest()?' LIMIT 200':' ');
        System.debug('start');
        return Database.getQueryLocator(query);
     }

     public List<Decimal> getFilteredId (List<Animal__c> animals){
        List<Decimal> listIdForRequest = new List<Decimal>();
        for (Animal__c animal : animals) {
          if (!listIdForRequest.contains(animal.Id__c)) {
            listIdForRequest.add(animal.Id__c);
          }
        }
        return listIdForRequest;
     }

     public static Map<Decimal,AnimalParsing> getListOfAnimalsBySendingRequest(List<Decimal> ids) {
        Map<Decimal,AnimalParsing> requestedAnimals = new Map<Decimal,AnimalParsing>();
        for (Decimal id : ids) {
          requestedAnimals.put(id,  AnimalParsing.parse(ReadyToUseRequests.sendGet(Url + Integer.valueof(id)).getBody()));
        }
        System.debug(requestedAnimals);
        return requestedAnimals;
      }
  
     public void execute(Database.BatchableContext BC,  List<Animal__c> scope){
        Map<Decimal,AnimalParsing> requestedAnimals = getListOfAnimalsBySendingRequest(getFilteredId(scope));
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