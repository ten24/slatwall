component accessors="true" extends="Slatwall.model.process.Order_CreateReturn" {
    
    // Lazy / Injected Objects

    // New Properties
    
    // Data Properties (ID's)
    
    // Data Properties (Inputs)
    property name="orderPayments" type="array" hb_populateArray="true";
    // Data Properties (Related Entity Populate)
    property name="secondaryReturnReasonType" cfc="Type" fieldtype="many-to-one" fkcolumn="secondaryReturnReasonTypeID";
    
    // Option Properties
    
    // Helper Properties
    property name="orderTypeName";
    // ======================== START: Defaults ============================
    variables.orderPayments = [];
    
    public any function getOrderTypeName(){
        var type= getService('TypeService').getTypeBySystemCode(getOrderTypeCode());
        if(!isNull(type)){
            return type.getTypeName();
        }
    }
    
    // ========================  END: Defaults =============================
    
    // ====================== START: Data Options ==========================
    
    public array function getReturnReasonTypeOptions() {
        if (!structKeyExists(variables, 'returnReasonTypeOptions')) {
            var typeCollection = getService('typeService').getTypeCollectionList();
		    typeCollection.setDisplayProperties('typeName|name,typeID|value');
		    typeCollection.addFilter('parentType.systemCode','orderReturnReasonType');
            typeCollection.addOrderBy('sortOrder|ASC');
            
            // The type filters could be moved into a Slatwall setting
            
            // Return
            if (getOrderTypeCode() == 'otReturnOrder') {
		        typeCollection.addFilter('systemCode', 'orrtDissatisfied,orrtTooExpensive,orrtAllergy,orrtItemDamaged,orrtItemDefective,orrtItemMissing,orrtNonReceivedReturnToSender,orrtNonReceivedDelivered,orrtItemIncorrect,orrtIncorrectOrderDelivered,orrtAddressCorrection,orrtAccountCancellation,orrtSystemIssue,orrtRefundEarlyTermination,orrtRefundVIPRegistration,orrtRefundMPRenewal,orrtRefundShipping', 'IN');
		        
		    // Exchange
            } else if (getOrderTypeCode() == 'otExchangeOrder') {
                typeCollection.addFilter('systemCode', 'orrtItemDefective', 'IN');
                
            // Replacement
            } else if (getOrderTypeCode() == 'otReplacementOrder') {
                typeCollection.addFilter('systemCode', 'orrtItemDamaged,orrtItemDefective,orrtItemMissing,orrtItemIncorrect,orrtIncorrectOrderDelivered,orrtNonReceivedDelivered,orrtNonReceivedReturnToSender', 'IN');
                
            // Refund?
            }
            
            /*
            typeName="Address Correction" systemCode="orrtAddressCorrection"
    		typeName="Missing Item(s)" systemCode="orrtItemMissing"
    		typeName="Dissatisfied - Buyer's Remorse" systemCode="orrtDissatisfied"
    		typeName="Annual MP Renewal Fee Refund" systemCode="orrtRefundMPRenewal"
    		typeName="Non-Received - Delivered" systemCode="orrtNonReceivedDelivered"
    		typeName="Wrong/Incorrect Order Received" systemCode="orrtIncorrectOrderDelivered"
    		typeName="Account Cancellation" systemCode="orrtAccountCancellation"
    		typeName="Returned Without RMA" systemCode="orrtNoRMA"
    		typeName="Order Refused" systemCode="orrtOrderRefused"
    		typeName="System Issues" systemCode="orrtSystemIssue"
    		typeName="Chargeback" systemCode="orrtChargeback"
    		typeName="Damaged Item(s)" systemCode="orrtItemDamaged"
    		typeName="Shipping SKU Refund" systemCode="orrtRefundShipping"
    		typeName="Defective Item(s)" systemCode="orrtItemDefective"
    		typeName="Early Termination Fee Refund" systemCode="orrtRefundEarlyTermination"
    		typeName="MP Upgrade Credit (VIP Registration Refund)" systemCode="orrtRefundVIPRegistration"
    		typeName="Too expensive" systemCode="orrtTooExpensive"
    		typeName="None" systemCode="orrtNone"
    		typeName="Warehouse Cancellation Request" systemCode="orrtWarehouse"
    		typeName="Fraudulent Order" systemCode="orrtFraudulent"
    		typeName="Wrong/Incorrect Item(s)" systemCode="orrtItemIncorrect"
    		typeName="Allergic Reaction" systemCode="orrtAllergy"
    		typeName="Non-Received - Return to Sender" systemCode="orrtNonReceivedReturnToSender"
    		*/

            variables.returnReasonTypeOptions = typeCollection.getRecords();
            arrayPrepend(variables.returnReasonTypeOptions, {name=rbKey('define.select'), value=""});
        }

        return variables.returnReasonTypeOptions;
    }
    
    public array function getSecondaryReturnReasonTypeOptions() {
        if (!structKeyExists(variables, 'secondaryReturnReasonTypeOptions')) {
            var typeCollection = getService('typeService').getTypeCollectionList();
		    typeCollection.setDisplayProperties('typeName|name,typeID|value');
		    typeCollection.addFilter('parentType.systemCode','orderReturnReasonType');
            typeCollection.addOrderBy('sortOrder|ASC');
            
            // This could be moved into a setting
		    typeCollection.addFilter('systemCode', 'orrtOrderRefused,orrtNoRMA,orrtWarehouse,orrtFraudulent,orrtChargeback', 'IN');

            variables.secondaryReturnReasonTypeOptions = typeCollection.getRecords();
            arrayPrepend(variables.secondaryReturnReasonTypeOptions, {name=rbKey('define.select'), value=""});
        }

        return variables.secondaryReturnReasonTypeOptions;
    }
    
    // ======================  END: Data Options ===========================
    
    // ================== START: New Property Helpers ======================
    
    // ==================  END: New Property Helpers =======================
    
    // ===================== START: Helper Methods =========================
    
    // =====================  END: Helper Methods ==========================
    
    // =============== START: Custom Validation Methods ====================
    
    // ===============  END: Custom Validation Methods =====================
    
}