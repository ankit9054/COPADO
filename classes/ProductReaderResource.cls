@RestResource(urlMapping='/sendProductConfig/*')
global with sharing class ProductReaderResource {

    @HttpPost
    global static String readProduct(String productId, String pricebookId, String currencyCode) {
        System.debug('productId' + productId + 'pricebookId' +pricebookId + 'currencyCode' + currencyCode );
        // Convert input parameters to Salesforce Id and handle potential errors
        Id productIdAsId;
        Id pricebookIdAsId;

        try {
            productIdAsId = (Id) productId;
            pricebookIdAsId = (Id) pricebookId;
        } catch (Exception e) {
            return 'Invalid input parameters. Please provide valid Salesforce Ids.';
        }

        // Call the existing logic in the ProductReader class
        ProductModel productModel = ProductReader.read(productIdAsId, pricebookIdAsId, currencyCode);

        // Serialize the ProductModel to JSON and return
        if (productModel != null) {
            return JSON.serialize(productModel);
        } else {
            return 'Error retrieving product information.';
        }
    }
}