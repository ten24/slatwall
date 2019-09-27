component output="false" accessors="true" extends="Slatwall.model.process.HibachiProcess" {
    
    // Injected Entity
    property name="orderDelivery";

    // Data Properties
    property name="remoteID";
    property name="undeliverableOrderReason" hb_formFieldType="select";
    property name="markUndeliverable" hb_formFieldType="yesno" default=1;
    
    public array function getUndeliverableOrderReasonOptions() {
        if (!structKeyExists(variables, 'undeliverableOrderReason')) {
            
            variables.undeliverableOrderReason = [{value ="", name="Please select a reason"}];
            
            var typeCollectionList = getService('integrationService').getTypeCollectionList();
            typeCollectionList.setDisplayProperties('typeCode|value,typeName|name');
            
            typeCollectionList.addFilter('typeCode', 'undeliverable%', 'like');
            arrayAppend(variables.undeliverableOrderReason, typeCollectionList.getRecords(), true);
            
        }
        
        return variables.undeliverableOrderReason;
    }

}