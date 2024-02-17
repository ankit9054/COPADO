@RestResource(urlMapping='/myRestEndpoint/*')
global with sharing class MyRestEndpoint {

    @HttpPost
    global static String sendData(String data) {
        String endpoint = 'callout:QtechPortalApiApp/services/apexrest/myRestEndpoint';
        
        HttpRequest sendrequest = new HttpRequest();
        sendrequest.setEndpoint(endpoint);
        sendrequest.setMethod('POST');
        sendrequest.setHeader('Content-Type', 'application/json');

        // Deserialize the incoming JSON string
        Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(data);

        // Perform any necessary processing on the data if needed

        // Set the body of the HTTP request
        sendrequest.setBody(JSON.serialize(requestBody));

        Http http = new Http();
        HttpResponse getresponse = http.send(sendrequest);

        System.debug('Response Body: ' + getresponse.getBody());

        if (getresponse.getStatusCode() == 200) {
            return 'success';
        } else {
            System.debug('HTTP Callout Error: ' + getresponse.getStatusCode() + ' ' + getresponse.getStatus());
            return null;
        }
    }
}