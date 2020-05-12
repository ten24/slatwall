component accessors="true" extends="Slatwall.model.process.Order_CreateReturn" {
    
    // Lazy / Injected Objects

    // New Properties
    
    // Data Properties (ID's)
    
    // Data Properties (Inputs)
    property name="orderPayments" type="array" hb_populateArray="true";
    property name="allocatedOrderPVDiscountAmountTotal";
    property name="allocatedOrderCVDiscountAmountTotal";
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
    
    
    public array function getSecondaryReturnReasonTypeOptions() {
        if (!structKeyExists(variables, 'secondaryReturnReasonTypeOptions')) {
            var typeCollection = getService('typeService').getTypeCollectionList();
		    typeCollection.setDisplayProperties('typeName|name,typeID|value');
		    typeCollection.addFilter('parentType.systemCode','orderReturnReasonType');
            typeCollection.addOrderBy('sortOrder|ASC');
            
            // This could be moved into a setting
		    typeCollection.addFilter('typeID', getService('SettingService').getSettingValue('orderSecondaryReturnReasonTypeOptions'), 'IN');

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
    
    public boolean function hasAtLeastOneReturnReasonType(){
        if(isNull(getReturnReasonType()) && isNull(getSecondaryReturnReasonType())){
            return false;
        }
        return true;
    }
    
    public boolean function hasReturnItems(){
        var hasItems = false;
        
        for(var item in this.getOrderItems()){
            if(item.quantity > 0){
                hasItems = true;
                break;
            }
        }
        return hasItems;
    }
    
    // ===============  END: Custom Validation Methods =====================
    
}