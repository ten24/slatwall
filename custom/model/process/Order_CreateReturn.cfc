component accessors="true" extends="Slatwall.model.process.Order_CreateReturn" {
    
    // Lazy / Injected Objects
    
    // New Properties
    
    // Data Properties (ID's)
    
    // Data Properties (Inputs)
    
    // Data Properties (Related Entity Populate)
    property name="returnReasonType" cfc="Type" fieldtype="many-to-one" fkcolumn="returnReasonTypeID";
    
    // Option Properties
    property name="returnReasonTypeOptions";
    
    // Helper Properties
    
    // ======================== START: Defaults ============================
    
    // ========================  END: Defaults =============================
    
    // ====================== START: Data Options ==========================

    public array function getReturnReasonTypeOptions() {
        if (!structKeyExists(variables, 'returnReasonTypeOptions')) {
            var typeCollection = getService('typeService').getTypeCollectionList();
		    typeCollection.setDisplayProperties('typeName|name,typeID|value');
		    typeCollection.addFilter('parentType.systemCode','orderReturnReasonType');
            typeCollection.addOrderBy('sortOrder|ASC');

            variables.returnReasonTypeOptions = typeCollection.getRecords();
            arrayPrepend(variables.returnReasonTypeOptions, {name=rbKey('define.select'), value=""});
        }

        return variables.returnReasonTypeOptions;
    }
    
    // ======================  END: Data Options ===========================
    
    // ================== START: New Property Helpers ======================
    
    // ==================  END: New Property Helpers =======================
    
    // ===================== START: Helper Methods =========================
    
    // =====================  END: Helper Methods ==========================
    
    // =============== START: Custom Validation Methods ====================
    
    // ===============  END: Custom Validation Methods =====================
    
}