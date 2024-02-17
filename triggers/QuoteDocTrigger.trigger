trigger QuoteDocTrigger on SBQQ__QuoteDocument__c (after insert) {
    if (Trigger.isAfter) {
        Set<Id> quoteIds = new Set<Id>();
        Map<Id, Id> quoteEmailMap = new Map<Id, Id>();

        for (SBQQ__QuoteDocument__c quoteDoc : Trigger.new) {
            quoteIds.add(quoteDoc.SBQQ__Quote__c);
            quoteEmailMap.put(quoteDoc.SBQQ__Quote__c,quoteDoc.SBQQ__DocumentId__c);
        }
        System.debug('quoteEmailMap'+ quoteEmailMap);

        Map<Id, SBQQ__Quote__c> quoteMap = new Map<Id, SBQQ__Quote__c>([SELECT Id, SBQQ__PrimaryContact__c, SBQQ__PrimaryContact__r.Email FROM SBQQ__Quote__c WHERE Id IN :quoteIds]);
		System.debug('quoteMap :- ' + quoteMap );
        
        for (SBQQ__Quote__c quote : quoteMap.values()) {
			Quoteemail.SendEmail(quote.Id, quote.SBQQ__PrimaryContact__r.Email, quote.SBQQ__PrimaryContact__c, quoteEmailMap.get(quote.Id));
        }
		System.debug('quoteEmailMap' +quoteEmailMap);
    }
}