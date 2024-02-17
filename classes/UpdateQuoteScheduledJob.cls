global class UpdateQuoteScheduledJob implements Schedulable {
    private string QuoteId;
    
    global UpdateQuoteScheduledJob(String quoteId){
        this.QuoteId = quoteId;
    }
    
    global void execute(SchedulableContext  ctx){
        QuoteModels QuoteRead = QuoteReader.read(QuoteId);
        System.debug('QuoteRead :- ' + JSON.serialize(QuoteRead));
        //return JSON.serialize(QuoteRead);
    }
}