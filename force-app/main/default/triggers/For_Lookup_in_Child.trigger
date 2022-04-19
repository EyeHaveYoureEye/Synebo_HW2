trigger For_Lookup_in_Child on Parent__c (after insert) {
	
    List<Child__C> listChild = new List<Child__C>();
    for(Parent__c p : Trigger.New){
        listChild.add(new Child__c(Name = p.Name,
                                 Parent_Lookup__c = p.Id));
        
    }
    insert listChild;
}