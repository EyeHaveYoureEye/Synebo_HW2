trigger AnimalTrigger on Animal__c (after insert) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            // AnimalHandlerClass.getListOfAnimalsAndStartUpdateAnimalByRequest(Trigger.new);
            // System.enqueueJob(new QueueableAnimalHandlerClass(Trigger.new));
            // Database.executeBatch(new BatchAndScheduleAnimalHandlerClass());
        }
    }
}