public with sharing class ProductReader { 
    
    public static ProductModel read(Id productId, Id pricebookId, String currencyCode) {
        ProductReaderContext ctx = new ProductReaderContext(pricebookId, currencyCode);
        String productJSON = SBQQ.ServiceRouter.load('SBQQ.ProductAPI.ProductLoader', productId, JSON.serialize(ctx));
        Product2 objProduct = [Select Banner_Image__c From Product2 Where Id=:productId];
        ProductModel prodmodel = (ProductModel) JSON.deserialize(productJSON, ProductModel.class);
        prodmodel.bannerImage = objProduct.Banner_Image__c;
		System.debug('@@@prodmodel:-' +prodmodel);
        return prodmodel;
    }
    
    private class ProductReaderContext {
        private Id pricebookId;
        private String currencyCode;
        
        private ProductReaderContext(Id pricebookId, String currencyCode) {
            this.pricebookId = pricebookId;
            this.currencyCode = currencyCode;
        }
    } 
}