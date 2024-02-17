@RestResource(urlMapping='/getProduct/*')
global class sendProducts{
    @HttpGet
    global static List<Product2> doGet() {
        List<Product2> lstProduct = [SELECT Banner_Image__c,Id, Name, ProductCode, Family, Product_Image_Link__c, Description FROM Product2 WHERE Family LIKE :'Tata Car'];
        System.debug(lstProduct.size());
        System.debug('Serialized JSON:- ' + JSON.serialize(lstProduct));
        return lstProduct;
        //return JSON.serialize(lstProduct);
    }
    
    
    @HttpPost
    //List<Map<String, String>> jsonDataList,String productName,String productId,String pricebookId,String currencyCode,String userName,String email
    global static String sendproductViaProductCode	(String productName,String productId, String pricebookId, String currencyCode,String userName, String email,String requestBody){
        if ((productName != null && productName != '') && (productId == null && pricebookId == null) && (userName == null && email == null && requestBody == null )) {
            try {
                // Use a list to store the result
                Map<String, String> stringMap = new Map<String, String>();
                // Query products
                List<Product2> lstProduct = [SELECT Id, Name, ProductCode, Family, Product_Image_Link__c,CurrencyIsoCode, Banner_Image__c, Description,
                                             (SELECT Product2Id, Pricebook2Id, CurrencyIsoCode FROM PricebookEntries) 
                                             FROM Product2 
                                             WHERE Name LIKE :productName AND CurrencyIsoCode='INR'];
                Map<String, Object> productMap = new Map<String, Object>();
                Map<String, Object> entryMap = new Map<String, Object>();
                // Iterate through the products and extract relevant information
                for (Product2 product : lstProduct) {
                    if(product.Family == 'Tata Car'){
                        productMap.put('Id', product.Id);
                        productMap.put('Name', product.Name);
                        productMap.put('ProductCode', product.ProductCode);
                        productMap.put('Family', product.Family);
                        productMap.put('Product_Image_Link__c', product.Product_Image_Link__c);
                        productMap.put('Banner_Image__c', product.Banner_Image__c);
                        productMap.put('CurrencyIsoCode',product.CurrencyIsoCode);
                        productMap.Put('PricebookId',product.PricebookEntries[0].Pricebook2Id);
                        
                    }else if(product.Family == 'Tata Rent Car'){
                        productMap.put('RentId', product.Id);
                        productMap.put('RentName', product.Name);
                        productMap.put('RentProductCode', product.ProductCode);
                        productMap.put('RentFamily', product.Family);
                        productMap.put('RentProduct_Image_Link__c', product.Product_Image_Link__c);
                        productMap.put('RentBanner_Image__c', product.Banner_Image__c);                        
                        productMap.put('RentCurrencyIsoCode',product.CurrencyIsoCode);
                        productMap.Put('RentPricebookId',product.PricebookEntries[0].Pricebook2Id);
                    }    
                }
                // Return the JSON representation of the result list
                System.debug(productMap);
                return JSON.serialize(productMap);
                
            } 
            catch (Exception e) {
                // Handle exceptions appropriately
                return 'Error: ' + e.getMessage();
            }
        }else if(productId != null && productId != ''){
            // Convert input parameters to Salesforce Id and handle potential errors
            Id productIdAsId;
            Id pricebookIdAsId;
            System.debug('Hello In side the Standar api');
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
                System.debug(JSON.serialize(productModel));
                return JSON.serialize(productModel);
            } else {
                return 'Error retrieving product information.';
            } 
        }else if(userName != null && email != null && requestBody != null ){
            System.debug(requestBody);
            
            return 'Data Received Successfully';
            
            //System.debug('jsonFromUser---'+jsonData);
            //createQuote.createOpportunity('himanshu','himanshuvirnai1233333@gmail.com',jsonData);
            //return 'test';
            
        }else{
            return 'error';
        }
    }
}