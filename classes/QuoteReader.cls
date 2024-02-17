public with sharing class QuoteReader {
    
    public Static QuoteModels read(String quoteId) {
        String quoteJSON = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId);
        System.debug('(QuoteModels) JSON.deserialize(quoteJSON, QuoteModels.class)' + (QuoteModels) JSON.deserialize(quoteJSON, QuoteModels.class));
        return (QuoteModels) JSON.deserialize(quoteJSON, QuoteModels.class);
    }
}