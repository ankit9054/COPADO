@RestResource(urlMapping='/sentAllQuote/*')
global class getAllQuote {
    @httpPost
    global static List<Map<String,String>> getAllQuoteUsingNameorEmail(String userName,String email){
        List<Map<String,String>> lstOfMap = new List<Map<String,String>>();
        
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
        
        Opportunity lstoppo;
        try {
            lstoppo = [SELECT Id, Account.Email__c FROM Opportunity WHERE Account.Email__c =:email AND AccountId =:acc.Id AND StageName	!= 'Closed Won' LIMIT 1];
        } catch (QueryException e) {
            System.debug('No Opportunity found for the given email: ' + e.getMessage());
            lstoppo = null;
        }
        
        List<SBQQ__Quote__c> lstQuote =[SELECT Id,Name, SBQQ__CustomerAmount__c,(SELECT Id,SBQQ__Product__r.Name, SBQQ__Product__r.Product_Image_Link__c FROM SBQQ__LineItems__r where SBQQ__Number__c = 1 LIMIT 1) FROM SBQQ__Quote__c where SBQQ__Opportunity2__c=:lstoppo.Id];
        for(SBQQ__Quote__c QuoteObj : lstQuote){
            Map<String,String> mapStr = new Map<String,String>();
            mapStr.put('QuoteId',QuoteObj.Id);
            mapStr.put('CustomerAmmount',String.ValueOf(QuoteObj.SBQQ__CustomerAmount__c));
            mapStr.put('QuoteName',QuoteObj.Name); 
            mapStr.put('ProductName',QuoteObj.SBQQ__LineItems__r[0].SBQQ__Product__r.Name);
            mapStr.put('ProductImg',QuoteObj.SBQQ__LineItems__r[0].SBQQ__Product__r.Product_Image_Link__c);
            lstOfMap.add(mapStr);
        }
        System.debug('lstOfMap Stringify' + JSON.serialize(lstOfMap));
  		System.debug('lstOfMap' + lstOfMap);
        return lstOfMap;
    }	
}