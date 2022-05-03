global class AnimalHandlerClass {
    private static String URL = 'https://th-apex-http-callout.herokuapp.com/animals';


    public static void getListOfAnimalsAndStartUpdateAnimalByRequest(List<Animal__c> animals) {
      List<Decimal> listId = new List<Decimal>();
      List<Decimal> listIdForRequest = new List<Decimal>();
      for (Animal__c animal : animals) {
        listId.add(animal.Id__c);
        if (!listIdForRequest.contains(animal.Id__c)) {
          listIdForRequest.add(animal.Id__c);
        }
      }
      updateAnimalUsingRequest(listId,listIdForRequest);
    }

    @future(callout=true)
    public static void updateAnimalUsingRequest(List<Decimal> myId, List<Decimal> idForRequest){
     List<Animal__c> animals = [SELECT Id__c,Eats__c, Says__c, Name FROM Animal__c WHERE Id__c in :myId];
     List<Animal__c> updatedAnimal = new List<Animal__c>();
     Map<Decimal,AnimalParsing> requestedAnimals = getListOfAnimalsBySendingRequest(idForRequest);
     for (Animal__c animal : animals) {
       animal.Name = requestedAnimals.get(animal.Id__c).Animal.Name;
       animal.Eats__c = requestedAnimals.get(animal.Id__c).Animal.eats;
       animal.Says__c = requestedAnimals.get(animal.Id__c).Animal.says;
       updatedAnimal.add(animal);
     }
     update updatedAnimal;
    }

    public static Map<Decimal,AnimalParsing> getListOfAnimalsBySendingRequest(List<Decimal> ids) {
      Map<Decimal,AnimalParsing> requestedAnimals = new Map<Decimal,AnimalParsing>();
      for (Decimal id : ids) {
        requestedAnimals.put(id, sendRequest(id));
      }
      return requestedAnimals;
    }

    public static AnimalParsing sendRequest(Decimal id) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(URL + '/' + String.valueOf(Integer.valueOf(id)));
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
          AnimalParsing parsedResponse = AnimalParsing.parse(response.getBody());
          return parsedResponse;
        }
        return null;
    }


}