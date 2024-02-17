public class QuoteSaver {

    public QuoteModels save(QuoteModels quote) {
        String quoteJSON = SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', JSON.serialize(quote));
        return (QuoteModels) JSON.deserialize(quoteJSON, QuoteModels.class);
    }
    
}