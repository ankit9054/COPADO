global class QuoteData {
    
   /* public static void createOpportunity(String UserName, String Email) {
        Account acc = [SELECT Id, Name, Email__c FROM Account WHERE Name = :UserName AND Email__c = :Email];
        System.debug('acc'+acc);
        Contact con = [SELECT Id, Name, AccountId, MailingStreet, MailingCountry, MailingState, MailingPostalCode, MailingCity, OtherStreet, OtherCity, OtherPostalCode, OtherState, OtherCountry FROM Contact WHERE AccountId = :acc.Id];
        System.debug('con'+con);
        List<Opportunity> lstoppo = [SELECT Id, Account.Email__c FROM Opportunity WHERE Account.Email__c = :Email];
        List<Opportunity> newlstoppo = new List<Opportunity>();
        List<SBQQ__Quote__c> lstquote = new List<SBQQ__Quote__c>();
        System.debug('lstquote'+lstquote);
        
        if (lstoppo.size() != 0) {
            for (Opportunity opp : lstoppo) {
                SBQQ__Quote__c quote = new SBQQ__Quote__c();
                quote.SBQQ__Account__c = acc.Id;
                quote.SBQQ__Opportunity2__c = opp.Id;
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
                lstquote.add(quote);
                
                // Generate document for the quote
                generateQuoteDocument(quote);
            }
        } else {
            Opportunity oppo = new Opportunity();
            oppo.Name = acc.Name;
            oppo.AccountId = acc.Id;
            oppo.CloseDate = Date.today().addDays(30);
            oppo.StageName = 'Prospecting';
            newlstoppo.add(oppo);
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
            lstquote.add(quote);
            
            // Generate document for the quote
            generateQuoteDocument(quote);
        }
        System.debug('quote'+lstquote);
        insert lstquote;
        
    }
    
    // Method to generate a document for the given quote
    private static void generateQuoteDocument(SBQQ__Quote__c quote) {
        // Create a new Document record
        SBQQ__QuoteDocument__c newDocument = new SBQQ__QuoteDocument__c();
        newDocument.Name = 'Quote Document - ' + quote.Name;
        newDocument.SBQQ__Quote__c = quote.Id;
        newDocument.SBQQ__Version__c = 1;
        // newDocument.Document_Type__c = 'Quote';  // Set the document type as needed
        
        insert newDocument;
        
        // Use the Document API to generate the document content (sample content)
        String documentContent = 'This is the content of the quote document for ' + quote.Name;
        
    }*/
    
    @InvocableMethod   
    public static void CreateQuote(List<Id> quoteIds)  
    { 
        createQuoteFutureMethod(quoteIds);
        System.debug('quoteIds:--'+quoteIds);

    }
    
    @future(callout=true)
    public static void createQuoteFutureMethod (List<Id> quoteIds) {
        //Initialize the quote url
        String quoteUrl = '/quote/quoteTemplateDataViewer.apexp?';
         
        SBQQ__Quote__c quote = [SELECT ID,SBQQ__QuoteTemplateId__c FROM SBQQ__Quote__c WHERE ID =: quoteIds];
         System.debug('quote:--'+quote);
        //Get the Quote Template Id from Custom Settings
        String quoteTemplateId = quote.SBQQ__QuoteTemplateId__c;
        
        //List variable to get all the Quote Documents
        List<SBQQ__QuoteDocument__c> lstQuoteDoc = new List<SBQQ__QuoteDocument__c>();
        
        if(!quoteIds.isEmpty() && quoteIds.size() > 0) {
            
            for(Id quoteId :quoteIds) {
                //Construct the quote URL to generate PDF
                quoteUrl += 'id=' + quoteId;
                quoteUrl += '&headerHeight=197&footerHeight=10';
                quoteUrl += '&summlid=' + quoteTemplateId;
                
                //call the quote url
                PageReference pageRef = new PageReference(quoteUrl);
                
                //get the quotePdf
                Blob quoteBlob;

                if(Test.isRunningTest()) {
                    quoteBlob = Blob.valueOf('Generate Pdf');
                     System.debug('quoteBlob1:--'+quoteBlob);
                } else {
                    quoteBlob = pageRef.getContentAsPDF();
                     System.debug('quoteBlob1:--'+quoteBlob);
                }
                
                //initialze the QuoteDocument to hold the quote pdf for insertion
                SBQQ__QuoteDocument__c quoteDoc = new SBQQ__QuoteDocument__c();
                quoteDoc.SBQQ__DocumentId__c = quoteBlob.toString();
                quoteDoc.SBQQ__Quote__c = quoteId;
                lstQuoteDoc.add(quoteDoc);
                System.debug('quoteDoc:--'+quoteDoc);

                
                if(!lstQuoteDoc.isEmpty() && lstQuoteDoc.size() > 0) {
                    Database.insert(lstQuoteDoc);
                    System.debug('lstQuoteDoc:--'+lstQuoteDoc);
                    
                }
                
            }
        }
    }
}