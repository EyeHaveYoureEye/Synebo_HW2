trigger HW2_2 on Child__c (after update) {
    update ChildUpdateParent.makeChildUpdateParent(Trigger.New);
}