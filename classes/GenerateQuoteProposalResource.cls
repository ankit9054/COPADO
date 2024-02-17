@RestResource(urlMapping='/generateQuoteProposal/*')
global class GenerateQuoteProposalResource {
    
    @HttpPost
    global static String saveQuoteProposal(String quoteId) {
        try {
            System.debug('quoteId' + quoteId); 
            // Ensure quoteId is not null or empty
            if (String.isNotBlank(quoteId)) {
                // Retrieve templateId from custom settings or metadata
                String templateId = LABEL.QuoteTemplateId; 
                
                // Create a QuoteProposalModel instance
                QuoteProposalModel model = new QuoteProposalModel();
                model.quoteId = quoteId;
                model.templateId = templateId;
                
                // Instantiate GenerateQuoteProposal class and save the proposal
                GenerateQuoteProposal proposalGenerator = new GenerateQuoteProposal();
                String jobId = proposalGenerator.save(model);
                
                System.debug('jobId' + jobId);
                return jobId; // Return job ID
            } else {
                // Handle scenario where quoteId is null or empty
                System.debug('Error: Quote ID is required.');
                return 'Error: Quote ID is required.';
            }
        } catch (Exception e) {
            // Handle any exceptions
            System.debug('Error: ' + e.getMessage());
            return 'Error: ' + e.getMessage();
        }
    }
}