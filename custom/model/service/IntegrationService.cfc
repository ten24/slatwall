component extends="Slatwall.model.service.IntegrationService" {
    public any function processIntegration_deleteStalePaymentTokens(required any integration, struct any data) { 
        
        if(arguments.integration.getIntegrationPackage() == "nexio"){
            var accountPaymentMethodCollection = getService('hibachiCollectionService').getCollectionByCollectionCode('staleAccountPaymentMethods');
            var orderPaymentMethodCollection = getService('hibachiCollectionService').getCollectionByCollectionCode('staleOrderPaymentMethods');
            
            var paymentToken = "";
            var tokens = [];
            
    		if(len(accountPaymentMethodCollection)){
    		    accountPaymentMethodCollection.setDisplayProperties('providerToken');
    		    var accountPaymentRecords = accountPaymentMethodCollection.getRecords(); 
                
                for(var accountPaymentRecord in accountPaymentRecords) {
    		        if(len(accountPaymentRecord.providerToken)){
    		            arrayAppend(tokens,accountPaymentRecord.providerToken);
    		        }
    		    }
    		} else {
                throw('The accountPaymentMethodCollection is empty.') 
            }
    		    
    		if(len(orderPaymentMethodCollection)){
    		    orderPaymentMethodCollection.setDisplayProperties('providerToken');
    		    var orderPaymentRecords = orderPaymentMethodCollection.getRecords(); 
                
                for(var orderPaymentRecord in orderPaymentRecords) {
    		        if(len(orderPaymentRecord.providerToken)){
    		            arrayAppend(tokens,orderPaymentRecord.providerToken);
    		        }
    		    }
    		} else {
                throw('The orderPaymentMethodCollection is empty.') 
            }

            arguments.integration.getIntegrationCFC('payment').sendRequestToDeleteTokens(tokens);
        	
        // 	writeDump(var=arguments.integration.getIntegrationCFC('payment').sendRequestToDeleteTokens(tokens));
        	
        	return arguments.integration;

        } else {
            throw('IntegrationPackage for Nexio is not setup.');
        }
    }
}