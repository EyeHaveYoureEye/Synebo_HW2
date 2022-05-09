@isTest
public with sharing class AnimalRestRecourceTest {
    @isTest 
   static void checkHttpGetRequest(){
       PrepareDateForAnimalTest.createTenAnimalsByIdAndUpdate();
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseForAnimalRestTest());
       Integer idForRequest = 1;
       String urlForRequest = 'https://lapuntomentodelanochia-developer-edition.eu44.force.com/Animals/services/apexrest/getAnimal/';
       Blob myBlob = Blob.valueOf(AnimalRestRecource.getJsonByList([Select Id__c,Name,Says__c,Eats__c From Animal__c WHERE Id__c = :idForRequest]));
       System.debug(myBlob.toString());
       Http http = new Http();
       HttpRequest request = new HttpRequest();
       request.setEndpoint(urlForRequest + String.valueOf(idForRequest));
       request.setMethod('GET');
       HttpResponse response = http.send(request);
       if(response.getStatusCode() == 200) {
        System.assertEquals(myBlob.toString(), response.getBody());
      } else {
          System.assertEquals(2*2,22); //^_^
      }
   }

   @isTest 
   static void checkHttpPostRequest(){
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseForAnimalRestTest());
    Integer idForRequest = 2;
    String urlForRequest = 'https://lapuntomentodelanochia-developer-edition.eu44.force.com/Animals/services/apexrest/getAnimal/';
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(urlForRequest);
    request.setMethod('POST');
    request.setBody('{"id":' + idForRequest + '}');
    HttpResponse response = http.send(request);
    System.debug(response.getBody());
    if(response.getStatusCode() == 200) {
    System.assertEquals([Select Id From Animal__c].ID, response.getBody());
    } else {
    System.assertEquals(2*2,22); //^_^
    }
  }
}