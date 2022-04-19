public class ChildUpdateParent {
    public static List<Parent__c> makeChildUpdateParent(List<Child__c> child){
        	List<Parent__c> parentUpdated = new List<Parent__c>();
    
    		for(Child__c c : child){
        		List<Parent__c> p = [SELECT Id FROM Parent__c WHERE Id = :c.Parent_Lookup__c];
        		p[0].DateAndTime__c = c.LastModifiedDate;
        		parentUpdated.add(p.get(0));
    		}
        return parentUpdated;
    }
}