public class ChildUpdateParent {
	public static List<Parent__c> updateNumberOfChildAndDateInParentWhenChildIsUpdate(List<Child__c> newChildList, Map<Id,Child__c> oldMapChild){
		List<Parent__c> parentUpdated = new List<Parent__c>();
		
		for (Child__c newChild : newChildList) {
			if (newChild.Parent_Lookup__c != null) {
			Parent__c newChildParent = findParentByChildLookup(newChild.Parent_Lookup__c);
			if (newChild.Parent_Lookup__c != oldMapChild.get(newChild.ID).Parent_Lookup__c) {
				if (oldMapChild.get(newChild.ID).Parent_Lookup__c != null) {
				Parent__c oldChildParent = findParentByChildLookup(oldMapChild.get(newChild.ID).Parent_Lookup__c);
				oldChildParent.Number_Of_Child__c--;
				oldChildParent.DateAndTime__c = System.now();
				parentUpdated.add(oldChildParent);
				}
				newChildParent.Number_Of_Child__c++;
			}
			newChildParent.DateAndTime__c = System.now();
			parentUpdated.add(newChildParent);
		}else if (newChild.Parent_Lookup__c == null && oldMapChild.get(newChild.Id).Parent_Lookup__c != null){
			Parent__c oldChildParent = findParentByChildLookup(oldMapChild.get(newChild.id).Parent_Lookup__c);
			oldChildParent.Number_Of_Child__c--;
			oldChildParent.DateAndTime__c = System.now();
			parentUpdated.add(oldChildParent);
		}
		}

		return parentUpdated;
 	}

	 public static Parent__c findParentByChildLookup(String lookup) {
		 return [Select Id, Number_Of_Child__c, DateAndTime__c FROM Parent__c WHERE Id = :lookup];
	 }

	

	public static List<Parent__c> updateNumberOfChildInParentWhenChildIsInsert(List<Child__c> child) {
		List<Parent__c> parentUpdated = new List<Parent__c>();
		for(Parent__c parentByUpdatedChild : [SELECT Id, Number_Of_Child__c FROM Parent__c WHERE ID In (SELECT Parent_Lookup__c From Child__c WHERE Id In :child)])
			{
        		parentByUpdatedChild.Number_Of_Child__c++;
				parentByUpdatedChild.DateAndTime__c = System.now();
        		parentUpdated.add(parentByUpdatedChild);
    		}
		return parentUpdated;
	}

	public static List<Parent__c> updateNumberOfChildInParentWhenIsDelete(List<Child__c> child) {
		List<Parent__c> parentUpdated = new List<Parent__c>();
		for(Parent__c parentByUpdatedChild : [SELECT Id, Number_Of_Child__c FROM Parent__c WHERE ID In (SELECT Parent_Lookup__c From Child__c WHERE IsDeleted = TRUE AND Id In :child)ALL ROWS])
			{
        		parentByUpdatedChild.Number_Of_Child__c--;
				parentByUpdatedChild.DateAndTime__c = System.now();
        		parentUpdated.add(parentByUpdatedChild);
    		}
		return parentUpdated;
	}

}