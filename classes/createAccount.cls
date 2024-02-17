public class createAccount {
    public static void createAccountWithContact(List<Contact> conList) {
        List<Account> accList = new List<Account>();
        
        for (Contact con : conList) {
            if (String.isBlank(con.AccountId)) {
                // Create a new Account based on Contact's last name
                String accountName = con.LastName;
                Account acc = new Account();
                acc.Name = accountName;
                acc.Phone = con.Phone;
                acc.Email__c = con.Email;
                acc.BillingStreet = con.MailingStreet;
                acc.BillingCity = con.MailingCity;
                acc.BillingPostalCode = con.MailingPostalCode;
                acc.BillingState = con.MailingState;
                acc.BillingCountry = con.MailingCountry;
                acc.ShippingStreet = con.OtherStreet;
                acc.ShippingCity = con.OtherCity;
                acc.ShippingPostalCode = con.OtherPostalCode;
                acc.ShippingState = con.OtherState;
                acc.ShippingCountry = con.OtherCountry;
                accList.add(acc);
            }
        }
        
        // Insert the new Accounts
        if (!accList.isEmpty()) {
            System.debug('Before Insert - New Accounts: ' + accList);
            insert accList;
            
            // Update the Contacts with the new AccountId
            for (Integer i = 0; i < accList.size(); i++) {
                conList[i].AccountId = accList[i].Id;
            }
            
            System.debug('Before Insert - Updated Contacts: ' + conList);
        }
    }
}