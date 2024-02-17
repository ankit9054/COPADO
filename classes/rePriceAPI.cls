@restResource(urlMapping = '/AddproductToQuote/*')
global class rePriceAPI {
    @httpPost 
    global static map<String,String> rePriceQuote( string userName, String email, List<Map<String, String>> jsonFromUser/*,String QuoteId,String ProductName*/) {
        try {
            Account acc = [SELECT Id, Name, Email__c FROM Account WHERE Name =:userName  AND Email__c =:email LIMIT 1];
            system.debug(acc);
            if (acc == null) {
                return null;
            }
            
            Contact con = [SELECT Id, LastName, AccountId, MailingStreet, MailingCountry, MailingState, MailingPostalCode, MailingCity, OtherStreet, OtherCity, OtherPostalCode, OtherState, OtherCountry FROM Contact WHERE AccountId = :acc.Id LIMIT 1];
            system.debug(con);
            if (con == null) {
                return null;
            }
            
            SBQQ__Quote__c QuoteRecord;
            SBQQ__Quote__c NewQuoteRecord = new SBQQ__Quote__c();
            Map<String,String> returnQuoteMap = new Map<String,String>();
            //List<SBQQ__Quote__c> QuoteRead = new List<SBQQ__Quote__c>();
            Opportunity lstoppo;
            try {
                lstoppo = [SELECT Id, Account.Email__c FROM Opportunity WHERE Account.Email__c =:email AND AccountId =:acc.Id AND StageName	!= 'Closed Won' LIMIT 1];
            } catch (QueryException e) {
                System.debug('No Opportunity found for the given email: ' + e.getMessage());
                lstoppo = null;
            }
            if (lstoppo != null) {            
                
                System.debug('Inside If Oppo Available then create Quote');
                
                NewQuoteRecord.SBQQ__Account__c = acc.Id;
                NewQuoteRecord.SBQQ__Opportunity2__c = lstoppo.Id;
                NewQuoteRecord.SBQQ__PrimaryContact__c = con.Id;
                NewQuoteRecord.SBQQ__StartDate__c = Date.today();
                NewQuoteRecord.SBQQ__ExpirationDate__c = Date.today().addDays(30);
                NewQuoteRecord.SBQQ__Primary__c = true;
                NewQuoteRecord.SBQQ__BillingStreet__c = con.MailingStreet;
                NewQuoteRecord.SBQQ__BillingCity__c = con.MailingCity;
                NewQuoteRecord.SBQQ__BillingPostalCode__c = con.MailingPostalCode;
                NewQuoteRecord.SBQQ__BillingState__c = con.MailingState;
                NewQuoteRecord.SBQQ__BillingCountry__c = con.MailingCountry;
                NewQuoteRecord.SBQQ__ShippingStreet__c = con.OtherStreet;
                NewQuoteRecord.SBQQ__ShippingCity__c = con.OtherCity;
                NewQuoteRecord.SBQQ__ShippingPostalCode__c = con.OtherPostalCode;
                NewQuoteRecord.SBQQ__ShippingState__c = con.OtherState;
                NewQuoteRecord.SBQQ__ShippingCountry__c = con.OtherCountry;
                NewQuoteRecord.SBQQ__QuoteTemplateId__c = 'a0x5h00000WASl5AAH';
                NewQuoteRecord.SBQQ__PriceBook__c = '01s5h00000RI556AAD';
                NewQuoteRecord.SBQQ__PricebookId__c = '01s5h00000RI556AAD';
                insert NewQuoteRecord;
                
                List<SBQQ__QuoteLine__c> QLlist = new List<SBQQ__QuoteLine__c>();
                for(Map<String,String> productoptData : jsonFromUser){
                    SBQQ__QuoteLine__c QL = new SBQQ__QuoteLine__c();
                    QL.SBQQ__Quote__c = NewQuoteRecord.Id;
                    if(productoptData.get('prodOptionId') == '0'){
                        QL.SBQQ__Product__c = productoptData.get('prodId');
                    }
                    else{
                        QL.SBQQ__Product__c = productoptData.get('prodId');
                        QL.SBQQ__ProductOption__c =  productoptData.get('prodOptionId');
                        QL.SBQQ__Bundled__c = (Boolean) JSON.deserialize(productoptData.get('bundle'), Boolean.class);
                        QL.SBQQ__OptionType__c = productoptData.get('type');
                    }
                    QLlist.add(QL);  
                }
                insert QLlist; 
                NewQuoteRecord.ReCalculateQuote__c  = true;
                update NewQuoteRecord;  
                System.debug('quote:- ' + NewQuoteRecord);
                 
                List<SBQQ__Quote__c> QuoteUpdatedRec = [SELECT ID ,SBQQ__CustomerAmount__c From SBQQ__Quote__c Where Id=: NewQuoteRecord.Id];
                for(SBQQ__Quote__c QuoteObj : QuoteUpdatedRec){
                    returnQuoteMap.put('QuoteId' ,QuoteObj.Id);
                    returnQuoteMap.put('SBQQ__CustomerAmount__c',String.ValueOf(QuoteObj.SBQQ__CustomerAmount__c));
                }
                System.debug('JSon' + JSON.serialize(returnQuoteMap));
                return returnQuoteMap;
                /*QuoteModels QuoteRead = QuoteReader.read(NewQuoteRecord.Id);
                System.debug('QuoteRead :- ' + QuoteRead);
                return JSON.serialize(QuoteRead);*/
                
            }else {
                // Create new Opportunity and Quote
                Opportunity oppo = new Opportunity();
                oppo.Name = acc.Name; 
                oppo.AccountId = acc.Id;
                oppo.CloseDate = Date.today().addDays(30);
                oppo.StageName = 'Prospecting';
                insert oppo;
                System.debug('oppo:- '+ oppo );
                System.debug('con' + con);
                System.debug('acc' + acc);
                //SBQQ__Quote__c quote = new SBQQ__Quote__c();
                NewQuoteRecord.SBQQ__Account__c = acc.Id;
                NewQuoteRecord.SBQQ__Opportunity2__c = oppo.Id;
                NewQuoteRecord.SBQQ__PrimaryContact__c = con.Id;
                NewQuoteRecord.SBQQ__StartDate__c = Date.today();
                NewQuoteRecord.SBQQ__ExpirationDate__c = Date.today().addDays(30);
                NewQuoteRecord.SBQQ__Primary__c = true;
                NewQuoteRecord.SBQQ__BillingStreet__c = con.MailingStreet;
                NewQuoteRecord.SBQQ__BillingCity__c = con.MailingCity;
                NewQuoteRecord.SBQQ__BillingPostalCode__c = con.MailingPostalCode;
                NewQuoteRecord.SBQQ__BillingState__c = con.MailingState;
                NewQuoteRecord.SBQQ__BillingCountry__c = con.MailingCountry;
                NewQuoteRecord.SBQQ__ShippingStreet__c = con.OtherStreet;
                NewQuoteRecord.SBQQ__ShippingCity__c = con.OtherCity;
                NewQuoteRecord.SBQQ__ShippingPostalCode__c = con.OtherPostalCode;
                NewQuoteRecord.SBQQ__ShippingState__c = con.OtherState;
                NewQuoteRecord.SBQQ__ShippingCountry__c = con.OtherCountry;
                NewQuoteRecord.SBQQ__QuoteTemplateId__c = 'a0x5h00000WASl5AAH';
                NewQuoteRecord.SBQQ__PriceBook__c = '01s5h00000RI556AAD';
                NewQuoteRecord.SBQQ__PricebookId__c = '01s5h00000RI556AAD';
                insert NewQuoteRecord;
                
                List<SBQQ__QuoteLine__c> QLlist = new List<SBQQ__QuoteLine__c>();
                for(Map<String,String> productoptData : jsonFromUser){
                    SBQQ__QuoteLine__c QL = new SBQQ__QuoteLine__c();
                    QL.SBQQ__Quote__c = NewQuoteRecord.Id;
                    if(productoptData.get('prodOptionId') == '0' || productoptData.get('prodOptionId') == null){
                        QL.SBQQ__Product__c = productoptData.get('prodId');
                    }
                    else{
                        QL.SBQQ__Product__c = productoptData.get('prodId');
                        QL.SBQQ__ProductOption__c =  productoptData.get('prodOptionId');
                        QL.SBQQ__Bundled__c = (Boolean) JSON.deserialize(productoptData.get('bundle'), Boolean.class);
                        QL.SBQQ__OptionType__c = productoptData.get('type');
                    }
                    QLlist.add(QL);  
                }
                insert QLlist; 
                NewQuoteRecord.ReCalculateQuote__c  = true;
                update NewQuoteRecord;
                //Datetime start = system.now();
                //While(System.Now() < start.addSeconds(10)){}
                //System.debug('Wait start time' + Start);
                //System.debug('Wait End Time' + start.addSeconds(10));
                //System.debug('quote:- ' + NewQuoteRecord);
                //System.sleep(10);
                
                List<SBQQ__Quote__c> QuoteUpdatedRec = [SELECT ID ,SBQQ__CustomerAmount__c From SBQQ__Quote__c Where Id=: NewQuoteRecord.Id];
                for(SBQQ__Quote__c QuoteObj : QuoteUpdatedRec){
                    returnQuoteMap.put('QuoteId' ,QuoteObj.Id);
                    returnQuoteMap.put('SBQQ__CustomerAmount__c',String.ValueOf(QuoteObj.SBQQ__CustomerAmount__c));
                }		
                return  returnQuoteMap;/*JSON.serialize(returnQuoteMap);*/
                
                /*QuoteModels QuoteRead = QuoteReader.read(NewQuoteRecord.Id);
                System.debug('QuoteRead :- ' + QuoteRead);
                return JSON.serialize(QuoteRead);*/
            }
            // Return the modified or created QuoteRecord
        } catch (Exception e) {
            // Handle exceptions gracefully
            System.debug('Exception: ' + e.getMessage());
            return null;
        }
    }
}