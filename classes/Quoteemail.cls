public class Quoteemail {
    public static void SendEmail(Id quoteID, String emailAddress, Id contactID, Id quotedocID) {
        
        EmailTemplate EmailTemplateID = [SELECT ID , NAME from EmailTemplate WHERE ID = '00X5h000000qvduEAA' limit 1]; 
        
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTargetObjectId(contactID);
        System.debug('contactID:--'+contactID);
        message.setSenderDisplayName('Company Support');
        message.setreplyto('no-reply@company.com');
        message.setUseSignature(false);
        message.setBccSender(false);
        message.setSaveAsActivity(false);
        message.setSaveAsActivity(true);
        message.setTemplateId('00X5h000000qvduEAA');
        message.setWhatId(quoteID); //This is important for the merge fields in template to work
        system.debug('quoteID:--'+quoteID);
        message.toAddresses = new String[]{emailAddress};

        Document doc = [SELECT Id, Name, Body FROM Document WHERE Id =: quotedocID];  
        System.debug('doc:---'+doc);
        // List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        
        // Retrieve the content of the PDF
        Blob pdfBlob = doc.Body;
        
        //for (SBQQ__QuoteDocument__c QD: QDs) {
        // Attach the PDF as an attachment
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName(doc.Name);
        //attachment.setContentType(pdf);
        attachment.setBody(pdfBlob);
        message.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
        system.debug('attachment:--'+ attachment);
        system.debug('message:--'+message);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{message});
        
        system.debug('Messaging.sendEmail(new Messaging.SingleEmailMessage[]{message});:--'+ Messaging.sendEmail(new Messaging.SingleEmailMessage[]{message}));
        
    }  
}