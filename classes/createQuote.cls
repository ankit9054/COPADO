@restResource(urlMapping='/createQuoteFromUser/*')
global class createQuote {
    global class CreateQuoteResponse {
        public String status;
        public String message;
        public QuoteModels quoteData;
    }
    
    @httpPost
    global static  /*List<Map<String, String>>*/ String  createOpportunity(String userName, String email, List<Map<String, String>> jsonFromUser) {
  
		System.debug('jsonFromUser =' + jsonFromUser);      
        Account acc = [SELECT Id, Name, Email__c FROM Account WHERE Name =: userName  AND Email__c =:email];
        Contact con = [SELECT Id, Name, AccountId,MailingStreet,MailingCountry,MailingState,MailingPostalCode,MailingCity,OtherStreet,OtherCity,OtherPostalCode,OtherState,OtherCountry FROM Contact WHERE AccountId = :acc.Id];      
        List<Opportunity> newlstoppo = new List<Opportunity>();
        List<SBQQ__Quote__c> lstquote = new list<SBQQ__Quote__c>();
        
        Opportunity oppo = new Opportunity();
        oppo.Name = acc.Name;
        oppo.AccountId = acc.Id;
        oppo.CloseDate = Date.today().addDays(30);
        oppo.StageName = 'Prospecting';
        insert  oppo;
        System.debug('oppo '+ oppo);
        
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__Account__c = acc.Id;
        quote.SBQQ__Opportunity2__c = oppo.Id;
        quote.SBQQ__PrimaryContact__c = con.Id;
        quote.SBQQ__StartDate__c = Date.today();
        quote.SBQQ__ExpirationDate__c = Date.today().addDays(30);
        quote.SBQQ__Primary__c = true;
        quote.SBQQ__BillingStreet__c = con.MailingStreet;
        quote.SBQQ__BillingCity__c = con.MailingCity;
        quote.SBQQ__BillingPostalCode__c = con.MailingPostalCode;
        quote.SBQQ__BillingState__c = con.MailingState;
        quote.SBQQ__BillingCountry__c = con.MailingCountry;
        quote.SBQQ__ShippingStreet__c = con.OtherStreet;
        quote.SBQQ__ShippingCity__c = con.OtherCity;
        quote.SBQQ__ShippingPostalCode__c = con.OtherPostalCode;
        quote.SBQQ__ShippingState__c = con.OtherState;
        quote.SBQQ__ShippingCountry__c = con.OtherCountry;
        quote.SBQQ__QuoteTemplateId__c = 'a0x5h00000WASl5AAH';
        quote.SBQQ__PriceBook__c = '01s5h00000RI556AAD';
        quote.SBQQ__PricebookId__c = '01s5h00000RI556AAD';
        insert quote;
        
        List<SBQQ__QuoteLine__c> QLlist = new List<SBQQ__QuoteLine__c>();
        for(Map<String,String> productoptData : jsonFromUser){
            System.debug('Product Option Id:- ' + productoptData.get('prodOptionId'));
            System.debug('Product Id :- ' + productoptData.get('prodId'));
          
            SBQQ__QuoteLine__c QL = new SBQQ__QuoteLine__c();
            QL.SBQQ__Quote__c = quote.Id;
            if(productoptData.get('prodOptionId') == '0'){
                QL.SBQQ__Product__c = productoptData.get('prodId');
            }else{
                QL.SBQQ__Product__c = productoptData.get('prodId');
                QL.SBQQ__ProductOption__c =  productoptData.get('prodOptionId');
                
            }
            QuoteLineModel quoteLineModel = new QuoteLineModel();
            quoteLineModel.record = QL;
            quoteLineModel.amountDiscountProrated = true;  // Set additional properties as needed
            QLlist.add(QL);  
        }
        String quoteJSON = JSON.serialize(quote);
        MyCallback callback = new MyCallback();
        callback.callback(quoteJSON);
        insert QLlist;
        QuoteProposalModel.generateQuoteDocument(quote);
        return 'jsonFromUser';
    }
}