@RestResource(urlMapping='/Product/*')
global class sendProductData{
	@httpPost
    global static List<Product2> fatchAndSendData(){
        return null;
    }
}