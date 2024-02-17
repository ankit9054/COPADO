public class QuoteLineItemUpdater {
    public static void updateQuoteLineItems(String jsonString) {
        // Step 1: Parse JSON string
        Map<String, List<Map<String, String>>> jsonData = (Map<String, List<Map<String, String>>>)JSON.deserializeUntyped(jsonString);
        
        // Step 2: Create or update main product (Configured SKU) as Quote Line Item

		String mainProductId = new List<String>(jsonData.keySet())[0];
        List<Map<String, String>> mainProductData = jsonData.get(mainProductId);
        System.debug('mainProductData' + mainProductData);
        String mainProductSku = mainProductData[0].get('SBQQ__ConfiguredSKU__c');
        
        // Perform logic to find or create Quote Line Item for the main product
        createOrUpdateQuoteLineItem(mainProductSku);
        
        // Step 3: Create or update selected options as Quote Line Items
        List<Map<String, String>> selectedOptions = jsonData.get(mainProductId);
        for (Map<String, String> optionData : selectedOptions) {
            String optionSku = optionData.get('SBQQ__ConfiguredSKU__c');
            
            // Perform logic to find or create Quote Line Item for each selected option
            createOrUpdateQuoteLineItem(optionSku);
        }
    }

    private static void createOrUpdateQuoteLineItem(String sku) {
        // Perform logic to create or update Quote Line Item based on SKU
        // This may involve querying existing Quote Line Items, creating new ones, or updating existing ones.
        // Example:
        // QuoteLineItem newQuoteLineItem = new QuoteLineItem();
        // newQuoteLineItem.Product2Id = [Logic to get Product Id from SKU];
        // newQuoteLineItem.QuoteId = [Quote Id];
        // newQuoteLineItem.Quantity = 1; // Set quantity as needed
        // insert newQuoteLineItem; // Create new Quote Line Item
        // Update existing Quote Line Item if needed
    }
}