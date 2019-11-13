<cfscript>
    var requestBean = request.slatwallScope.getTransient('externalTransactionRequestBean');
    requestBean.setTransactionType('externalHTML');
    
    var account = request.slatwallScope.getBean('accountService').getAccount('2c9180846d25c254016d25c3aeb8000d');
    requestBean.setAccount(account);
    //Mock Payload
	var values = {
		currencyCode = 'USD',
		amount = 1.00
	};
	requestBean.setTransactionAmount(values.amount);
	requestBean.setTransactionCurrencyCode(values.currencyCode);
	
	var integrationCFC = request.slatwallScope.getBean("IntegrationService").getIntegrationByIntegrationPackage('braintree');
	var paymentIntegrationCFC = request.slatwallScope.getBean("IntegrationService").getPaymentIntegrationCFC(integrationCFC);
    var responseBean = paymentIntegrationCFC.processExternal(requestBean);
    if(isObject(responseBean) && responseBean.hasErrors())
    {
        dump(responseBean.getErrors()); abort;
    }
    else{
        var externalHTML = responseBean;
    }
    
    //Use $.slatwall on payment.cfm
</cfscript>
<cfoutput>#externalHTML#</cfoutput>