public with sharing class PrepareDataForChildUpdateTest {
    
    public static void makeParentByName(String name) {
        Parent__c insertRecord = new Parent__c(Name = name);
        insert insertRecord;
    }

    public static void makeChildByNameWithoutLookup(String name) {
        Child__c insertRecord = new Child__c (Name = name);
        insert insertRecord;
    }

    public static void makeChildByNameWithLookup(String name, String parentName) {
        Child__c insertRecord = new Child__c (Name = name, Parent_Lookup__c = getIdOfParentByName(parentName));
        insert insertRecord;
    }
    
    public static String getIdOfParentByName(String name) {
        return [SELECT Id FROM Parent__c WHERE Name = :name].Id;
    }
}