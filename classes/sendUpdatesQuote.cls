@restResource(urlMapping = '/sendUpdateQuote/*')
global class sendUpdatesQuote {
    @httpPost
    global static List<Map<String,String>> sendQuoteback(String QuoteId){
	    // Perform SOQL Query
        List<SBQQ__QuoteLine__c> quoteLines = [SELECT 
                                               SBQQ__Product__r.Name, 
                                               SBQQ__Product__r.Banner_Image__c,
                                               SBQQ__ProductOption__r.SBQQ__Feature__r.Name, 
                                               SBQQ__CustomerTotal__c, 
                                               SBQQ__CustomerPrice__c, 
                                               SBQQ__ListTotal__c, 
                                               SBQQ__ListPrice__c, 
                                               SBQQ__Quote__r.SBQQ__ListAmount__c, 
                                               SBQQ__Quote__r.SBQQ__CustomerDiscount__c, 
                                               SBQQ__Quote__r.SBQQ__CustomerAmount__c, 
                                               SBQQ__Quote__r.Id 
                                               FROM 
                                               SBQQ__QuoteLine__c 
                                               WHERE 
                                               SBQQ__Quote__r.Id =: QuoteId];
        System.debug('quoteLines'+JSON.serialize(quoteLines));
        List<Map<String,String>> mapObj = new List<Map<String,String>>();
        // Populate data into the map
		Map<String, String> QuotePriceMap = new Map<String, String>();
		QuotePriceMap.put('QuoteListPrice',String.ValueOf(quoteLines[0].SBQQ__Quote__r.SBQQ__ListAmount__c));
        QuotePriceMap.put('QuoteCustomerDiscount', String.ValueOf(quoteLines[0].SBQQ__Quote__r.SBQQ__ListAmount__c));
        QuotePriceMap.put('QuoteCutomerAmmount' ,String.ValueOf(quoteLines[0].SBQQ__Quote__r.SBQQ__CustomerAmount__c));
        System.debug(QuotePriceMap);
		mapObj.add(QuotePriceMap);        
        for(SBQQ__QuoteLine__c line : quoteLines) {
            Map<String, String> lineMap = new Map<String, String>();
            lineMap.put('Name', line.SBQQ__Product__r.Name);
            lineMap.put('Banner_Image__c', line.SBQQ__Product__r.Banner_Image__c);
            lineMap.put('Feature_Name', line.SBQQ__ProductOption__r.SBQQ__Feature__r.Name);
            lineMap.put('CustomerTotal__c', String.ValueOf(line.SBQQ__CustomerTotal__c));
            lineMap.put('CustomerPrice__c', String.ValueOf(line.SBQQ__CustomerPrice__c));
            lineMap.put('ListTotal__c', String.ValueOf(line.SBQQ__ListTotal__c));
            lineMap.put('ListPrice__c', String.ValueOf(line.SBQQ__ListPrice__c));
            lineMap.put('Quote_Id', line.SBQQ__Quote__r.Id);
            mapObj.add(lineMap); // Assuming line.Id is unique
        }
        System.debug('mapObj'+mapObj);
        System.debug('dataMap' + JSON.serialize(mapObj));
 
        return mapObj; 
               
    }
}