component extends="Slatwall.model.service.InventoryService" {
    
	public any function processInventory_importInventoryUpdates() {
		
		getHibachiScope()
			.getService('integrationService')
			.getIntegrationByIntegrationPackage('monat')
			.getIntegrationCFC("data")
			.importInventoryUpdates({});

		return arguments.inventory;
	}

}
