component accessors="true" extends="Slatwall.model.process.Order_Create" {
    
    // Lazy / Injected Objects
    
    // New Properties
    
    // Data Properties (ID's)
    
    // Data Properties (Inputs)
    
    // Data Properties (Related Entity Populate)
    
    // Option Properties
    
    // Helper Properties
    
    // ======================== START: Defaults ============================
    
    // ========================  END: Defaults =============================
    
    // ====================== START: Data Options ==========================
    
    public array function getOrderTypeIDOptions() {
		if(!structKeyExists(variables, "orderTypeIDOptions")) {
		    var collection = getService('typeService').getTypeCollectionList();
			collection.setDisplayProperties('typeName|name,typeID|value'); 
			collection.addFilter('parentType.systemCode','orderType');
			collection.addFilter('systemCode','otSalesOrder');

			variables.orderTypeIDOptions = collection.getRecords();
		}
		return variables.orderTypeIDOptions;
	}
    
    // ======================  END: Data Options ===========================
    
    // ================== START: New Property Helpers ======================
    
    // ==================  END: New Property Helpers =======================
    
    // ===================== START: Helper Methods =========================
    
    // =====================  END: Helper Methods ==========================
    
    // =============== START: Custom Validation Methods ====================
    
    // ===============  END: Custom Validation Methods =====================
    
}