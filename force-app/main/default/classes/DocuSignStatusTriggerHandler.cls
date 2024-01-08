public class DocuSignStatusTriggerHandler{
    public static void handleOrderComplete(final Id contactId) {
        // Call the SendEnvelopeFromTriggerController class sendEnvelope method to invoke the DocuSign API's for sending envelope
        System.debug('inside handler');
        //SendEnvelopeFromTriggerController.ChangeOwner(contactId);
        SendEnvelopeFromTriggerController.voidEnvelope(contactId);
        SendEnvelopeFromTriggerController.sendEnvelope(contactId);
       // System.debug('envelope response'+response);
    }
}