trigger QuoteTrigger on SBQQ__Quote__c (before insert, after update) {
    /*if(Trigger.isAfter){
        if(trigger.isUpdate){
            List<SBQQ__Quote__c> lstQuote = new List<SBQQ__Quote__c>();
            for(SBQQ__Quote__c Qobj : Trigger.new){
                if(Qobj.ReCalculateQuote__c == true){
                    Qobj.ReCalculateQuote__c = false;
                    lstQuote.add(Qobj);
                }
            }
            update lstQuote;
        }
    }*/
}