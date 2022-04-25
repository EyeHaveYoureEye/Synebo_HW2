trigger ChildTrigger on Child__c (after update, after insert, after delete) {
    if (Trigger.isUpdate) {
    update ChildUpdateParent.updateNumberOfChildAndDateInParentWhenChildIsUpdate(Trigger.new, Trigger.oldMap);
    }
    else if (Trigger.isInsert) {
        update ChildUpdateParent.updateNumberOfChildInParentWhenChildIsInsert(Trigger.new);
    } 
    else if (Trigger.isDelete) {
        update ChildUpdateParent.updateNumberOfChildInParentWhenIsDelete(Trigger.old);
    }
}