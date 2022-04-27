public with sharing class AnimalParsing {
    
	public AnimalWrapper Animal;

	public class AnimalWrapper {
		public String id;
		public String name;
		public String eats;
		public String says;
	}

	
	public static AnimalParsing parse(String json) {
		return (AnimalParsing) System.JSON.deserialize(json, AnimalParsing.class);
	}

}
