public with sharing class ReadyToUseRequests {

    public static HttpResponse sendGet(String Url) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(URL);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        try {
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
          return response;
        }
        } catch (Exception e) {
            System.debug('Darn it! Something went wrong: '
            + e.getMessage());
        }
        return null;
    }

    //Must implement here other REST methods, but for now, i don`t need it
}
