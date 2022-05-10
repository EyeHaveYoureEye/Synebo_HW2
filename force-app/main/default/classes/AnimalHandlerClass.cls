global class AnimalHandlerClass {
    private static String URL = 'https://th-apex-http-callout.herokuapp.com/animals/';


    public static void getListOfAnimalsAndStartUpdateAnimalByRequest(List<Animal__c> animals) {
      List<Decimal> listId = new List<Decimal>();
      Set<Decimal> setUnrepetitiveIdForRequest = new Set<Decimal>();
      for (Animal__c animal : animals) {
        listId.add(animal.Id__c);
        setUnrepetitiveIdForRequest.add(animal.Id__c);
      }
      updateAnimalUsingRequest(listId, setUnrepetitiveIdForRequest);
    }

    @future(callout=true)
    public static void updateAnimalUsingRequest(List<Decimal> myId, Set<Decimal> idForRequest){
     List<Animal__c> animals = [SELECT Id__c,Eats__c, Says__c, Name FROM Animal__c WHERE Id__c in :myId];
     Map<Decimal,AnimalParsing> requestedAnimals = getListOfAnimalsBySendingRequest(idForRequest);
     for (Animal__c animal : animals) {
       animal.Name = requestedAnimals.get(animal.Id__c).Animal.Name;
       animal.Eats__c = requestedAnimals.get(animal.Id__c).Animal.eats;
       animal.Says__c = requestedAnimals.get(animal.Id__c).Animal.says;
     }
     update animals;
    }

    public static Map<Decimal,AnimalParsing> getListOfAnimalsBySendingRequest(Set<Decimal> ids) {
      Map<Decimal,AnimalParsing> requestedAnimals = new Map<Decimal,AnimalParsing>();
      for (Decimal id : ids) {
        requestedAnimals.put(id,  AnimalParsing.parse(ReadyToUseRequests.sendGet(Url + id).getBody()));
      }
      return requestedAnimals;
    }
}