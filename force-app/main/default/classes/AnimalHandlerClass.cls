global class AnimalHandlerClass {
    private static String URL = 'https://th-apex-http-callout.herokuapp.com/animals';


    public static void getListOfAnimalsAndStartUpdateAnimalByRequest(List<Animal__c> animals) {
      List<Decimal> listId = new List<Decimal>();
      for (Animal__c animal : animals) {
        listId.add(animal.Id__c);
      }
      updateAnimalUsingRequest(listId);
    }

    @future(callout=true)
    public static void updateAnimalUsingRequest(List<Decimal> myId){
     List<Animal__c> animals = [SELECT Id__c,Eats__c, Says__c, Name FROM Animal__c WHERE Id__c in :myId];
     List<Animal__c> updatedAnimal = new List<Animal__c>();
     for (Animal__c animal : animals) {
       AnimalParsing requestedAnimal = sendRequest(animal.Id__c);
       animal.Name = requestedAnimal.Animal.name;
       animal.Eats__c = requestedAnimal.Animal.eats;
       animal.Says__c = requestedAnimal.Animal.says;
       updatedAnimal.add(animal);
     }
     update updatedAnimal;
    }


    public static AnimalParsing sendRequest(Decimal id) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(URL + '/' + String.valueOf(id));
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
          if(response.getStatusCode() == 200) {
        // Deserialize the JSON string into collections of primitive data types.
          AnimalParsing test = AnimalParsing.parse(response.getBody());
          System.debug(test.Animal);
          return test;
        }
        return null;
    }


}