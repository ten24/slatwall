component extends="Slatwall.org.Hibachi.HibachiEventHandler" {
	
	public void function afterOrderProcess_updateStatusSuccess(required any slatwallScope, required any order){
		
		//Only commit the tax document after the order has been closed
		if (arguments.order.getOrderStatusType().getSystemCode() == 'ostClosed'){
			//First get integration and make sure the commit tax document flag is set
			var integration = arguments.slatwallScope.getService('IntegrationService').getIntegrationByIntegrationPackage('avatax');
					
			if (integration.setting('commitTaxDocumentFlag')){
				//Create the request scope for the account
				var taxRatesRequestBean = arguments.slatwallScope.getService('TaxService').generateTaxRatesRequestBeanForIntegration(arguments.order, integration);
				var integrationTaxAPI = integration.getIntegrationCFC("tax");
				
				// Call the API and store the responseBean by integrationID
				try{
					integrationTaxAPI.getTaxRates( taxRatesRequestBean );
				}catch (any e){
					logHibachi('An error occured with the Avatax integration when trying to call commitTaxDocument()', true);
					logHibachiException(e);
				}
			}
		}
	}
	
	public void function afterOrderProcess_placeOrderSuccess(required any slatwallScope, required any order){
		
		//Once the order has been placed we need to re-sync the tax rates to update the transaction to be a SalesInvoice instead of a SalesOrder
		var integration = arguments.slatwallScope.getService('IntegrationService').getIntegrationByIntegrationPackage('avatax');
				
		//Create the request scope for the account
		var taxRatesRequestBean = arguments.slatwallScope.getService('TaxService').generateTaxRatesRequestBeanForIntegration(arguments.order, integration);
		var integrationTaxAPI = integration.getIntegrationCFC("tax");
		
		// Call the API and store the responseBean by integrationID
		try{
			integrationTaxAPI.getTaxRates( taxRatesRequestBean );
		}catch (any e){
			logHibachi('An error occured with the Avatax integration when trying to call update docType', true);
			logHibachiException(e);
		}
	}

	public void function afterOrderProcess_cancelOrderSuccess(required any slatwallScope, required any order){
		//First get integration and make sure the commit tax document flag is set
		var integration = arguments.slatwallScope.getService('IntegrationService').getIntegrationByIntegrationPackage('avatax');
		
		if (integration.setting('commitTaxDocumentFlag')){
			//Create the request scope for the account
			var taxRatesRequestBean = arguments.slatwallScope.getService('TaxService').generateTaxRatesRequestBeanForIntegration(arguments.order, integration);
			var integrationTaxAPI = integration.getIntegrationCFC("tax");
			
			// Call the API and store the responseBean by integrationID
			try{
				integrationTaxAPI.voidTaxDocument( taxRatesRequestBean );
			}catch (any e){
				logHibachi('An error occured with the Avatax integration when trying to vaoid TaxDocument)', true);
				logHibachiException(e);
			}
			
		}	
		
	}
}
