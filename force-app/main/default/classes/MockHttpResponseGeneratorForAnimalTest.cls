global class MockHttpResponseGeneratorForAnimalTest implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        if (req.getEndpoint() == 'https://th-apex-http-callout.herokuapp.com/animals/1') {
            System.debug('Worked');
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"animal":{"id":1,"name":"chicken","eats":"chicken food","says":"cluck cluck"}}');
            res.setStatusCode(200);
            return res;
        } else if (req.getEndpoint() == 'https://th-apex-http-callout.herokuapp.com/animals/2'){
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"animal":{"id":2,"name":"bear","eats":"berries, campers, adam seligman","says":"yum yum"}}');
            res.setStatusCode(200);
            return res;
        } else {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"animal":{"id":0,"name":"null","eats":"null","says":"null"}}');
            res.setStatusCode(200);
            return res;
        }
        
    }
}