@isTest
global with sharing class MockHttpResponseForAnimalRestTest implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        if (req.getEndpoint() == 'https://lapuntomentodelanochia-developer-edition.eu44.force.com/Animals/services/apexrest/getAnimal/1' && req.getMethod() == 'GET') {
            res.setHeader('Content-Type', 'application/json');
            Blob responseBlob = Blob.valueOf(AnimalRestRecource.getJsonByList([Select Id__c, Name, Eats__c, Says__c From Animal__c WHERE Id__c = 1]));
            res.setBody(responseBlob.toString());
            res.setStatusCode(200);
            return res;
        } else if (req.getEndpoint() == 'https://lapuntomentodelanochia-developer-edition.eu44.force.com/Animals/services/apexrest/getAnimal/2' && req.getMethod() == 'GET'){
            res.setHeader('Content-Type', 'application/json');
            Blob responseBlob = Blob.valueOf(AnimalRestRecource.getJsonByList([Select Id__c, Name, Eats__c, Says__c From Animal__c WHERE Id__c = 2]));
            res.setBody(responseBlob.toString());
            res.setStatusCode(200);
            return res;
        } else if (req.getEndpoint() == 'https://lapuntomentodelanochia-developer-edition.eu44.force.com/Animals/services/apexrest/getAnimal/' 
        && req.getMethod() == 'POST' && req.getBody() == '{"id":1}') {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForAnimalTest());
            res.setHeader('Content-Type', 'application/json');
            res.setBody(AnimalRestRecource.createCase(1));
            res.setStatusCode(200);
            return res;
        } else if(req.getEndpoint() == 'https://lapuntomentodelanochia-developer-edition.eu44.force.com/Animals/services/apexrest/getAnimal/' 
        && req.getMethod() == 'POST' && req.getBody() == '{"id":2}') {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForAnimalTest());
            res.setHeader('Content-Type', 'application/json');
            res.setBody(AnimalRestRecource.createCase(2));
            res.setStatusCode(200);
            return res;
        } else {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{}');
            res.setStatusCode(404);
            return res;
        }
    }
}
