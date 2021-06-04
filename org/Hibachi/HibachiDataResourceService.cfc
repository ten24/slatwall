component accessors="true" output="false" extends="HibachiService" {

	
	public any function processDataResource_sync(required any dataResource) {
		if(!isNull(arguments.dataResource.getIntegration())){
			var dataIntegrationCFC = getService("integrationService").getDataIntegrationCFC(dataResource.getIntegration());
			var integrationService = dataIntegrationCFC.syncDataByDataResource(arguments.dataResource);
			
		}

		return arguments.dataResource;
	}
	
}