public class QuoteHandler {
    public class QuoteModel {
        public SBQQ__Quote__c record;
        public QuoteLineModel[] lineItems;
        public QuoteLineGroupModel[] lineItemGroups;
        public Integer nextKey;
        public Boolean applyAdditionalDiscountLast;
        public Boolean applyPartnerDiscountFirst;
        public Boolean channelDiscountsOffList;
        public Decimal customerTotal;
        public Decimal netTotal;
        public Decimal netNonSegmentTotal;
    }

    public class QuoteLineModel {
        public String name;
        public Decimal quantity;
        public Decimal unitPrice;

        public QuoteLineModel(String name, Decimal quantity, Decimal unitPrice) {
            this.name = name;
            this.quantity = quantity;
            this.unitPrice = unitPrice;
        }
    }

    public class QuoteLineGroupModel {
        public String groupName;
        public QuoteLineModel[] groupLineItems;

        public QuoteLineGroupModel(String groupName, QuoteLineModel[] groupLineItems) {
            this.groupName = groupName;
            this.groupLineItems = groupLineItems;
        }
    }

    public class QuoteSaver {

        public QuoteModel save(QuoteModel quote) {
            // In a real-world scenario, you would use the actual Salesforce CPQ API to save the quote.
            // For now, let's simulate a successful save and return the same quote.
            // Replace this with actual Salesforce CPQ API calls.

            System.debug('Quote saved: ' + JSON.serialize(quote));

            return quote;
        }

        public QuoteModel createTempData() {
            QuoteModel tempQuote = new QuoteModel();

            // Create a sample Quote
            tempQuote.record = new SBQQ__Quote__c();
            //tempQuote.record.Name = 'Test Quote';
            tempQuote.record.SBQQ__Opportunity2__c = 'Opportunity123';

            // Create sample line items
            tempQuote.lineItems = new QuoteLineModel[]{
                new QuoteLineModel('Product A', 2, 50),
                new QuoteLineModel('Product B', 1, 75)
            };

            // Create sample line item groups
            tempQuote.lineItemGroups = new QuoteLineGroupModel[]{
                new QuoteLineGroupModel('Group 1', new QuoteLineModel[]{
                    new QuoteLineModel('Product C', 3, 30),
                    new QuoteLineModel('Product D', 1, 40)
                }),
                new QuoteLineGroupModel('Group 2', new QuoteLineModel[]{
                    new QuoteLineModel('Product E', 2, 60)
                })
            };

            // Set other properties
            tempQuote.nextKey = 123;
            tempQuote.applyAdditionalDiscountLast = true;
            tempQuote.applyPartnerDiscountFirst = false;
            tempQuote.channelDiscountsOffList = true;
            tempQuote.customerTotal = 400;
            tempQuote.netTotal = 350;
            tempQuote.netNonSegmentTotal = 320;

            return tempQuote;
        }
    }

    // Usage example
}