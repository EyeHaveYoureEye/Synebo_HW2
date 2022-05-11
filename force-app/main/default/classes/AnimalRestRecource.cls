@RestResource(urlMapping = '/getAnimal/*')
global without sharing class AnimalRestRecource {
    private static String URL_FOR_OTHER_ANIMAL_SITE = 'https://th-apex-http-callout.herokuapp.com/animals/';

    @HttpGet
    global static void getAnimalById(){
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response;
        String caseId = request.requestURI.substring(
          request.requestURI.lastIndexOf('/')+1);
        try {
            String myJson =  getJsonByList([Select Id__c,Name,Eats__c,Says__c From Animal__c Where Id__c = :Decimal.valueOf(caseId)]);
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(myJson);
        } catch (Exception e) {
            System.debug(e);
            res.statusCode = 400;
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf('Error');
        }  
        
    }

    @HttpPost
    global static String createCase(Decimal id) {
        try {
            AnimalParsing parsedAnimal = AnimalParsing.parse(ReadyToUseRequests.sendGet(URL_FOR_OTHER_ANIMAL_SITE + Integer.valueOf(id)).getBody());
            Animal__c animal = new Animal__c(Id__c = id, Name = parsedAnimal.Animal.Name, Eats__c = parsedAnimal.Animal.eats, Says__c = parsedAnimal.Animal.says);
            insert animal;
            return animal.ID; 
        } catch (Exception e) {
            System.debug(e);
        }
        return 'Error';
    }

    public static String getJsonByList (List<Animal__c> animals){
        List<String> myJson = new List<String>();
        for (Animal__c animal : animals) {
            myJson.add(JSON.serialize(new AnimalWrapper(animal)));
        }
        return myJson.toString();
    }
}