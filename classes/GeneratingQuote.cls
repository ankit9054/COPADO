public with sharing class GeneratingQuote {
    public static void createOtherObj(String Name, String Phone, String Email, String BillingAddress, String ShippingAddress, String Password, String ConfirmPassword) {
        
        //List<Contact> lstcon = new List<Contact>();

        Account acc = new Account();
        acc.Name = Name;
        acc.Phone = Phone;
        acc.Email__c = Email;
        acc.BillingStreet = BillingAddress;
        insert acc;

        Contact con = new Contact();
        con.LastName = acc.Name;
        con.AccountId = acc.Id;
        con.Phone = acc.Phone;
        con.Email = acc.Email__c;
        insert con;
        
        
    }
}