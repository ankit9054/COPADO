trigger contactTrigger on Contact (before insert, after insert) {
    if (Trigger.isBefore) {
        createAccount.createAccountWithContact(Trigger.New);
    }
}