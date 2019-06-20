component extends="Slatwall.model.service.IntegrationService" accessors="true" {
    property name="accountDAO" type="any";

    public any function processIntegration_deleteStalePaymentTokens(required any integration, struct any data) { 
        
        if(arguments.integration.getIntegrationPackage() == "nexio"){
            var accountPaymentMethodCollection = getService('hibachiCollectionService').getCollectionByCollectionCode('staleAccountPaymentMethods');
            var orderPaymentMethodCollection = getService('hibachiCollectionService').getCollectionByCollectionCode('staleOrderPaymentMethods');
            
            var tokens = [];
            
    		if(isNull(accountPaymentMethodCollection)){
    		    throw("The process to deleteStalePaymentTokens from Nexio requires a collection to be configured with collectionCode: 'accountPaymentMethodCollection'") 
    		} else {
                accountPaymentMethodCollection.setDisplayProperties('providerToken');
    		    var accountPaymentRecords = accountPaymentMethodCollection.getRecords(); 
                
                for(var accountPaymentRecord in accountPaymentRecords) {
    		        if(len(accountPaymentRecord.providerToken)){
    		            arrayAppend(tokens,accountPaymentRecord.providerToken);
    		        }
    		    }
            }
    		    
    		if(isNull(orderPaymentMethodCollection)){
    		    throw("The process to deleteStalePaymentTokens from Nexio requires a collection to be configured with collectionCode: 'orderPaymentMethodCollection'") 
    		} else {
    		    orderPaymentMethodCollection.setDisplayProperties('providerToken');
    		    var orderPaymentRecords = orderPaymentMethodCollection.getRecords(); 
                
                for(var orderPaymentRecord in orderPaymentRecords) {
    		        if(len(orderPaymentRecord.providerToken)){
    		            arrayAppend(tokens,orderPaymentRecord.providerToken);
    		        }
    		    }
            }

            var responseBean = arguments.integration.getIntegrationCFC('payment').sendRequestToDeleteTokens(tokens);
            
            if (!responseBean.hasErrors()){
                getAccountDAO().removeStalePaymentProviderTokens(tokens);
            }
            
        	return arguments.integration;

        } else {
            throw('IntegrationPackage for Nexio is not setup.');
        }
    }
}