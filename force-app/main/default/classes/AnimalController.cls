public with sharing class AnimalController {
    private static String URL_FOR_OTHER_ANIMAL_SITE = 'https://th-apex-http-callout.herokuapp.com/animals/';

    // @AuraEnabled(cacheable=true)
    // public static String getJsonWithAnimals (){
    //     List<String> myJson = new List<String>();
    //     for (Animal__c animal : [Select Id__c,Name,Eats__c,Says__c From Animal__c]) {
    //         myJson.add(JSON.serialize(new AnimalWrapper(animal)));
    //     }
    //     return myJson.toString();
    // }

    @AuraEnabled(cacheable=true)
    public static String getJsonWithAnimals (){
        List<AnimalWrapper> myJson = new List<AnimalWrapper>();
        for (Animal__c animal : [Select Id__c,Name,Eats__c,Says__c From Animal__c]) {
            myJson.add(new AnimalWrapper(animal));
        }
        return JSON.serialize(myJson);
    }

    @AuraEnabled
    public static Integer createAnimalById(Integer id){
        try {
            AnimalParsing parsedAnimal = AnimalParsing.parse(ReadyToUseRequests.sendGet(URL_FOR_OTHER_ANIMAL_SITE + id).getBody());
            if (parsedAnimal.Animal.Id != '0') {
                Animal__c animal = new Animal__c(Id__c = id, Name = parsedAnimal.Animal.Name, Eats__c = parsedAnimal.Animal.eats, Says__c = parsedAnimal.Animal.says);
                insert animal;
            }
            return Integer.valueOf(parsedAnimal.Animal.id);
        } catch (Exception e) {
            System.debug(e);
        }
        return -1;
    }

    @AuraEnabled
    public static Boolean createAnimalByFields(Integer id, String name, String eats, String says){
        try {
        insert new Animal__c(Id__c = id, Name = name, Eats__c = eats, Says__c = says);
        return true;
        } catch (DmlException e) {
            System.debug(e);
        }
        return false;
    }
    
}
