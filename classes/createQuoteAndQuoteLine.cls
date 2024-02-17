@RestResource(urlMapping='/genrateQuote/*')
global class createQuoteAndQuoteLine{
    
    @HttpPost
    global static String genrateQuoteAndOppo(String Email) {
        Account obJAccount = [Select Id,(Select Id From Opportunities) From Account where Email__c =:Email];
		return null;		
    } 
}