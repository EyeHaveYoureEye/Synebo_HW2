@isTest
public with sharing class ChildUpateParentTest {

   @TestSetup
   static void makeData(){
       PrepareData.makeParentByName('lupa');
       PrepareData.makeParentByName('pupa');
       PrepareData.makeChildByNameWithLookup('lupaCh1','lupa');
       PrepareData.makeChildByNameWithLookup('lupaCh2','lupa');
       PrepareData.makeChildByNameWithLookup('pupaCh1','pupa');
       PrepareData.makeChildByNameWithLookup('pupaCh2','pupa');
       PrepareData.makeChildByNameWithoutLookup('Orphan child1');
       PrepareData.makeChildByNameWithoutLookup('Orphan child2');
   }

   @isTest static void assertNotEqualForCompleteChangeDateByCheckingVersionsOfParent() {
    Parent__c parentBeforeUpdateChild = [SELECT DateAndTime__c FROM Parent__c WHERE Name = 'lupa' LIMIT 1];

    Child__c parentChild = [SELECT Field_For_Change__c FROM Child__c WHERE Name = 'lupaCh1'];
    parentChild.Field_For_Change__c = 1;
    update parentChild;

    Parent__c updatedParentByChild = [SELECT DateAndTime__c FROM Parent__c WHERE Name = 'lupa' LIMIT 1];

    System.debug( 'parentBeforeUpdateChild = ' + parentBeforeUpdateChild.DateAndTime__c + ' updatedParentByChild =' + updatedParentByChild.DateAndTime__c);

    //Risky waiting method
    Datetime wait = System.now();
    while (System.now() < wait.addSeconds(2)) {} 

    parentChild.Field_For_Change__c = 2;
    update parentChild;

    Parent__c updatedParentByChildTwice = [SELECT DateAndTime__c FROM Parent__c WHERE Name = 'lupa' LIMIT 1];

    System.debug( 'parentBeforeUpdateChild =' + parentBeforeUpdateChild.DateAndTime__c + ' updatedParentByChild =' + updatedParentByChild.DateAndTime__c + ' updatedParentByChildTwice =' + updatedParentByChildTwice.DateAndTime__c);
    
    System.assertNotEquals(updatedParentByChild.DateAndTime__c, updatedParentByChildTwice.DateAndTime__c);
   }

   @isTest static void assertEqualForCompleteChangeDateBySavingTimeWhenTriggerIsCalled() {
    Child__c parentChild = [SELECT Field_For_Change__c FROM Child__c WHERE Name = 'pupaCh1'];
    parentChild.Field_For_Change__c = 1;
    Datetime saveTime = System.now();
    update parentChild;

    Parent__c updatedParentByChild = [SELECT DateAndTime__c FROM Parent__c WHERE Name = 'pupa' LIMIT 1];

    System.debug('MySavedTime = ' + saveTime + ' updatedParentByChild = ' + updatedParentByChild.DateAndTime__c);
    System.assertEquals(saveTime, updatedParentByChild.DateAndTime__c);
   }
   
   @isTest static void checkNumbersOfChildInParent() {
       Parent__c firstParent = [SELECT Id,Number_Of_Child__c FROM Parent__c WHERE Name = 'lupa'];
       Parent__c secondParent = [SELECT Id,Number_Of_Child__c FROM Parent__c WHERE Name = 'pupa'];
       System.assertEquals(2, firstParent.Number_Of_Child__c);
       System.assertEquals(2, secondParent.Number_Of_Child__c);
   }

   @isTest static void checkNumberOfChildInParentWhenChildIsChangingHisParent(){
        Child__c firstChildOfFirstParent = [SELECT ID, Parent_Lookup__c FROM Child__c WHERE Name = 'lupaCh1'];
        Child__c secondChildOfFirstParent = [SELECT ID, Parent_Lookup__c FROM Child__c WHERE Name = 'lupaCh2'];
        firstChildOfFirstParent.Parent_Lookup__c = PrepareData.getIdOfParentByName('pupa');
        secondChildOfFirstParent.Parent_Lookup__c = PrepareData.getIdOfParentByName('pupa');
        update firstChildOfFirstParent;
        update secondChildOfFirstParent;
        Parent__c firstParent = [SELECT Id,Number_Of_Child__c FROM Parent__c WHERE Name = 'lupa'];
        Parent__c secondParent = [SELECT Id,Number_Of_Child__c FROM Parent__c WHERE Name = 'pupa'];
        System.assertEquals(0, firstParent.Number_Of_Child__c);
        System.assertEquals(4, secondParent.Number_Of_Child__c);

   }

   @isTest static void giveParentToOrphanChildAndMakeHimOrphanAgain() {
        Child__c firstOrphanChild = [SELECT ID, Parent_Lookup__c FROM Child__c WHERE Name = 'Orphan child1'];
        Child__c secondOrphanChild = [SELECT ID, Parent_Lookup__c FROM Child__c WHERE Name = 'Orphan child2'];
        firstOrphanChild.Parent_Lookup__c = PrepareData.getIdOfParentByName('lupa');
        secondOrphanChild.Parent_Lookup__c = PrepareData.getIdOfParentByName('lupa');
        update firstOrphanChild;
        update secondOrphanChild;
        Parent__c firstParent = [SELECT Id,Number_Of_Child__c FROM Parent__c WHERE Name = 'lupa'];
        System.assertEquals(4, firstParent.Number_Of_Child__c);
        firstOrphanChild.Parent_Lookup__c = null;
        secondOrphanChild.Parent_Lookup__c = null;
        update firstOrphanChild;
        update secondOrphanChild;
        firstParent = [SELECT Id,Number_Of_Child__c FROM Parent__c WHERE Name = 'lupa'];
        System.assertEquals(2, firstParent.Number_Of_Child__c);
   }

   @isTest static void checkNumberOfChildInParentWhenChildIsDeleting(){
    Child__c firstChildOfFirstParent = [SELECT ID, Parent_Lookup__c FROM Child__c WHERE Name = 'lupaCh1'];
    Child__c secondChildOfFirstParent = [SELECT ID, Parent_Lookup__c FROM Child__c WHERE Name = 'lupaCh2'];
    delete firstChildOfFirstParent;
    delete secondChildOfFirstParent;
    Parent__c firstParent = [SELECT Id,Number_Of_Child__c FROM Parent__c WHERE Name = 'lupa'];
    System.assertEquals(0,firstParent.Number_Of_Child__c);
   }
   
   
}