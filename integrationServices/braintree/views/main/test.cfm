<cfscript>
    var order = request.slatwallScope.getService('OrderService').getOrder(orderID="2c9380846b4b73ea016b4bc2e6f50011");
	 	var integrationCFC = request.slatwallScope.getBean("IntegrationService").getIntegrationByIntegrationPackage('braintree');
 		var paymentIntegrationCFC = request.slatwallScope.getBean("IntegrationService").getPaymentIntegrationCFC(integrationCFC);
 		
        var paymentMethod = request.slatwallScope.getBean("PaymentService").getPaymentMethod(paymentMethodID = "2c9580846bfaeee2016bfaf16f440006");
        
        var sdkHTML = paymentIntegrationCFC.getExternalPaymentHTML(paymentMethod, order);
</cfscript>
<cfoutput>#sdkHTML#</cfoutput>