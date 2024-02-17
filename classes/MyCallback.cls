global with sharing class MyCallback implements SBQQ.CalculateCallback {
    global void callback(String quoteJSON){
        if (quoteJSON != null && String.isEmpty(quoteJSON)) {
            SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', quoteJSON);
        } else {
            System.debug('Received null or empty quoteJSON. Skipping callback.');
        }
    }
}