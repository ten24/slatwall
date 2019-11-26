component accessors="true" extends="Slatwall.model.process.Order_AddOrderPayment" {
    public array function getPaymentMethodIDOptions() {
		var paymentMethodIDOptions = [];
		if(!structKeyExists(variables, "paymentMethodIDOptions")) {
			variables.paymentMethodIDOptions = [];
			var epmDetails = getService('paymentService').getEligiblePaymentMethodDetailsForOrder( getOrder() );
			
			for(var paymentDetail in epmDetails) {
			    
			    //Restrict backend to add any external gateway as payment method
				if(paymentDetail.paymentMethod.getPaymentMethodType()=="external")
				{
					continue;
				}
				arrayAppend(variables.paymentMethodIDOptions, {
					name = paymentDetail.paymentMethod.getPaymentMethodName(),
					value = paymentDetail.paymentMethod.getPaymentMethodID(),
					paymentmethodtype = paymentDetail.paymentMethod.getPaymentMethodType(),
					allowsaveflag = paymentDetail.paymentMethod.getAllowSaveFlag()
					});
			}
		}
		if(getHibachiScope().getAccount().getAdminAccountFlag()){
			paymentMethodIDOptions = duplicate(variables.paymentMethodIDOptions);
			arrayPrepend(paymentMethodIDOptions, {
				name = 'None',
				value = 'none',
				paymentmethodtype = 'none',
				allowsaveflag = false
			});
		}else{
			paymentMethodIDOptions = variables.paymentMethodIDOptions;
		}
		return paymentMethodIDOptions;
	}
}