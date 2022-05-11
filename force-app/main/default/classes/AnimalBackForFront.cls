public with sharing class AnimalBackForFront {
    @AuraEnabled(cacheable=true)
    public static String getJsonByList (){
        List<String> myJson = new List<String>();
        for (Animal__c animal : [Select Id__c,Name,Eats__c,Says__c From Animal__c]) {
            myJson.add(JSON.serialize(new AnimalWrapper(animal)));
        }
        return myJson.toString();
    }
}
