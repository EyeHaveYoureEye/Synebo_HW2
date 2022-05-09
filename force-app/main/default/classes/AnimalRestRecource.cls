@RestResource(urlMapping = '/getAnimal/*')
global without sharing class AnimalRestRecource {
    private static String URL_FOR_OTHER_ANIMAL_SITE = 'https://th-apex-http-callout.herokuapp.com/animals/';

    @HttpGet
    global static void getAnimalById(){
        RestRequest request = RestContext.request;
        String caseId = request.requestURI.substring(
          request.requestURI.lastIndexOf('/')+1);
        String myJson =  getJsonByList([Select Id__c,Name,Eats__c,Says__c From Animal__c Where Id__c = :Decimal.valueOf(caseId)]);
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(myJson);
    }

    @HttpPost
    global static String createCase(Decimal id) {
        AnimalParsing parsedAnimal = AnimalParsing.parse(ReadyToUseRequests.sendGet(URL_FOR_OTHER_ANIMAL_SITE + Integer.valueOf(id)).getBody());
        Animal__c animal = new Animal__c(Id__c = id, Name = parsedAnimal.Animal.Name, Eats__c = parsedAnimal.Animal.eats, Says__c = parsedAnimal.Animal.says);
        insert animal;
        return animal.ID;
    }

    public static String getJsonByList (List<Animal__c> animals){
        List<String> myJson = new List<String>();
        for (Animal__c animal : animals) {
            myJson.add(JSON.serialize(new AnimalWrapper(animal.Id__c, animal.name, animal.eats__c, animal.says__c)));
        }
        return myJson.toString();
    }
}