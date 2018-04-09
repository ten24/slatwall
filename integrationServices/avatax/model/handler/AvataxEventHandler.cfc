component extends="Slatwall.org.Hibachi.HibachiEventHandler" {
	
	public void function afterOrderProcess_placeOrderSuccess(required any slatwallScope, required any order){
		
		//First get integration and make sure the commit tax document flag is set
		var integration = arguments.slatwallScope.getService('IntegrationService').getIntegrationByIntegrationPackage('avatax');
				
		if (integration.setting('commitTaxDocumentFlag')){
			//Create the request scope for the account
			var taxRatesRequestBean = arguments.slatwallScope.getService('TaxService').generateTaxRatesRequestBeanForIntegration(arguments.order, integration);
			var integrationTaxAPI = integration.getIntegrationCFC("tax");
			
			// Call the API and store the responseBean by integrationID
			try{
				integrationTaxAPI.commitTaxDocument( taxRatesRequestBean );
			}catch (any e){
				logHibachi('An error occured with the Avatax integration when trying to call commitTaxDocument()', true);
				logHibachiException(e);
			}
		}
	}

}
