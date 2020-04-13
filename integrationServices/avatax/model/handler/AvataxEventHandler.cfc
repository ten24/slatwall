component extends="Slatwall.org.Hibachi.HibachiEventHandler" {
	
	public void function afterOrderProcess_placeInProcessingOneSuccess(required any slatwallScope,required any order){
		return this.afterOrderProcess_updateStatusSuccess(argumentCollection=arguments);
	}
	public void function afterOrderProcess_updateStatusSuccess(required any slatwallScope, required any order){
		
		//Only commit the tax document after the order has been closed
		var orderStatusType = arguments.order.getOrderStatusType();
		var orderType = arguments.order.getOrderType();
		if ( 
			( orderStatusType.getSystemCode() == 'ostClosed' && orderType.getSystemCode() != 'otSalesOrder' )
			|| orderStatusType.getTypeCode() == 'processing1'
		){
			//First get integration and make sure the commit tax document flag is set
			var integration = arguments.slatwallScope.getService('IntegrationService').getIntegrationByIntegrationPackage('avatax');
					
			if (integration.setting('commitTaxDocumentFlag')){
				//Create the request scope for the account
				var taxRatesRequestBean = arguments.slatwallScope.getService('TaxService').generateTaxRatesRequestBeanForIntegration(arguments.order, integration);
				taxRatesRequestBean.setCommitTaxDocFlag(true);
								
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
	
	
	public void function afterOrderProcess_cancelOrderSuccess(required any slatwallScope, required any order){
		//First get integration and make sure the commit tax document flag is set
		var integration = arguments.slatwallScope.getService('IntegrationService').getIntegrationByIntegrationPackage('avatax');
		
		if ( integration.setting('commitTaxDocumentFlag') ){
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
	
	public void function afterOrderReturnProcess_receiveSuccess(required any slatwallScope, required any orderReturn){
		//First get integration and make sure the commit tax document flag is set
		var integration = arguments.slatwallScope.getService('IntegrationService').getIntegrationByIntegrationPackage('avatax');
	
		if (integration.setting('commitTaxDocumentFlag') && integration.setting('taxDocumentCommitType') == 'commitOnDelivery'){
			//Create the request scope for the account
			
			var taxRatesRequestBean = arguments.slatwallScope.getService('TaxService').generateTaxRatesRequestBeanForIntegration(arguments.orderReturn, integration);
			
			if ( arguments.orderReturn.getQuantityUnReceived() == 0 ){
				taxRatesRequestBean.setCommitTaxDocFlag(true);
			}
			
			var integrationTaxAPI = integration.getIntegrationCFC("tax");
			
			// Call the API and store the responseBean by integrationID
			try{
				integrationTaxAPI.getTaxRates( requestBean=taxRatesRequestBean );
			}catch (any e){
				logHibachi('An error occured with the Avatax integration when trying to call commitTaxDocument()', true);
				logHibachiException(e);
			}
	 	}
		
	}
}