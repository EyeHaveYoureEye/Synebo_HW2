public class ChildUpdateParent {
	 public static List<Parent__c> updateNumberOfChildAndDateInParentWhenChildIsUpdate(List<Child__c> newChildList, Map<Id,Child__c> oldMapChild){
		List<Parent__c> parentUpdated = new List<Parent__c>();
		List<Parent__c> oldParentOfChild = getParentsByChild(oldMapChild.values());
		List<Parent__c> newParentOfChild = getParentsByChild(newChildList);
		List <AggregateResult> numberOfChildInNewParent = getNumberOfChildsByParents(newParentOfChild);
		List <AggregateResult> numberOfChildInOldParent = getNumberOfChildsByParents(oldParentOfChild);
		Integer iteratorForParents = 0;
		for (Child__c newChild : newChildList) {
			if (newChild.Parent_Lookup__c == null && oldMapChild.get(newChild.Id).Parent_Lookup__c != null) {
				parentUpdated.add(updateParentNumberOfChildAndDate(oldParentOfChild[iteratorForParents], numberOfChildInOldParent[iteratorForParents]));
			} else if(newChild.Parent_Lookup__c != null && oldMapChild.get(newChild.Id).Parent_Lookup__c == null) {
				parentUpdated.add(updateParentNumberOfChildAndDate(newParentOfChild[iteratorForParents], numberOfChildInNewParent[iteratorForParents]));
			} else if (newChild.Parent_Lookup__c != oldMapChild.get(newChild.ID).Parent_Lookup__c) {
				parentUpdated.add(updateParentNumberOfChildAndDate(oldParentOfChild[iteratorForParents], numberOfChildInOldParent[iteratorForParents]));
				parentUpdated.add(updateParentNumberOfChildAndDate(newParentOfChild[iteratorForParents], numberOfChildInNewParent[iteratorForParents]));
			} else {
				newParentOfChild[iteratorForParents].DateAndTime__c = System.now();
				parentUpdated.add(newParentOfChild[iteratorForParents]);
			}
			iteratorForParents++;
		}
		return parentUpdated;
 	}

	 public static Parent__c updateParentNumberOfChildAndDate(Parent__c parent, AggregateResult numberOfChild ) {
		 parent.Number_Of_Child__c = (Decimal) numberOfChild.get('cnt');
		 parent.DateAndTime__c = System.now();
		 return parent;
	 }

	 public static List<AggregateResult> getNumberOfChildsByParents(List<Parent__c> listOfParents){
		List<AggregateResult> returnedNumberInList = [Select Count(Id)cnt From Child__c Where Parent_Lookup__c In (Select Id From Parent__c Where Id In :listOfParents)];
		return returnedNumberInList;
	}

	public static List<String> createListOfLookup(List<Child__c> childs) {
		List<String> lookups = new List<String>();
		for (Child__c child : childs) {
			lookups.add(child.Parent_Lookup__c);
		}
		return lookups;
	}
	
	public static List<Parent__c> getParentsByChild(List<Child__c> childs){
		List<Parent__c> parents = [Select Id, Number_Of_Child__c, DateAndTime__c From Parent__c Where Id In :createListOfLookup(childs)];
		return parents;
	}

	public static List<Parent__c> updateNumberOfChildInParentWhenChildIsInsert(List<Child__c> child) {
		List<Parent__c> parentUpdated = new List<Parent__c>();
		List<Parent__c> parentsByUpdatedChild = [SELECT Id, Number_Of_Child__c FROM Parent__c WHERE ID In (SELECT Parent_Lookup__c From Child__c WHERE Id In :child)];
		List<AggregateResult> numberOfChildInParents = getNumberOfChildsByParents(parentsByUpdatedChild);
		Integer iterator = 0;
		for(Parent__c parentByUpdatedChild : parentsByUpdatedChild){
        		parentUpdated.add(updateParentNumberOfChildAndDate(parentByUpdatedChild, numberOfChildInParents[iterator]));
				iterator++;
    		}
		return parentUpdated;
	}

	public static List<Parent__c> updateNumberOfChildInParentWhenIsDelete(List<Child__c> child) {
		List<Parent__c> parentUpdated = new List<Parent__c>();
		List<Parent__c> parentsByUpdatedChild = [SELECT Id, Number_Of_Child__c FROM Parent__c WHERE ID In (SELECT Parent_Lookup__c From Child__c WHERE IsDeleted = TRUE AND Id In :child)ALL ROWS];
		List<AggregateResult> numberOfChildInParents = getNumberOfChildsByParents(parentsByUpdatedChild);
		Integer iterator = 0;
		for(Parent__c parentByUpdatedChild : parentsByUpdatedChild)
			{
        		parentUpdated.add(updateParentNumberOfChildAndDate(parentByUpdatedChild, numberOfChildInParents[iterator]));
				iterator++;
    		}
		return parentUpdated;
	}

}