component extends="Slatwall.org.Hibachi.HibachiEventHandler" {
    property name="OrderService";
    property name="AccountService";

    public any function afterAccountProcess_loginFailure(required any slatwallScope, required any account ,required struct data){
        param name="arguments.data.emailAddressOrUsername" default="";
        param name="arguments.data.emailAddress" default="";
        param name="arguments.data.password" default="";

        var accountAuthCollection = arguments.slatwallScope.getService('AccountService').getAccountAuthenticationCollectionList();
        accountAuthCollection.setDisplayProperties("accountAuthenticationID,password,account.accountID,account.primaryEmailAddress.emailAddress,legacyPassword,activeFlag");
        accountAuthCollection.addFilter("account.primaryEmailAddress.emailAddress", arguments.data.emailAddress);
        accountAuthCollection.addFilter("legacyPassword", "NULL", "IS NOT");
        accountAuthCollection.addFilter("activeFlag", "true");
        var accountAuthentications = accountAuthCollection.getRecords();

        for (var accountAuthentication in accountAuthentications) {
            var accountAuthEntity = arguments.slatwallScope.getService('AccountService').getAccountAuthentication(accountAuthentication['accountAuthenticationID']);

            if(!isNull(accountAuthEntity) && 
                len(accountAuthentication['legacyPassword']) > 29 && 
                accountAuthentication['legacyPassword'] == legacyPasswordHashed(arguments.data.password, left(accountAuthentication['legacyPassword'], 29))){

                accountAuthEntity.setPassword(arguments.slatwallScope.getService('AccountService').getHashedAndSaltedPassword(arguments.data.password, accountAuthentication['accountAuthenticationID']));
                accountAuthEntity.setLegacyPassword(javacast("null", ""));
                accountAuthEntity = arguments.slatwallScope.getService('AccountService').saveAccountAuthentication(accountAuthEntity);                
            } else {
                continue;
            }

            if(!accountAuthEntity.hasErrors()){
                arguments.slatwallScope.getService("hibachiSessionService").loginAccount( accountAuthEntity.getAccount(), accountAuthEntity );
            }
        }
    }

    private string function legacyPasswordHashed(required string password, required string salt){
        var BCrypt = CreateObject( 'java', 'org.mindrot.jbcrypt.BCrypt', '/Slatwall/integrationServices/monat/jBCrypt-0.4.jar' ).init();
        var password = BCrypt.hashpw(arguments.password, arguments.salt);
        return password;
    }

	public any function afterOrderProcess_placeOrderSuccess(required any slatwallScope, required any order, required any data){

		var account = arguments.order.getAccount();
		
		if(!isNull(arguments.data.orderTemplateID)){

			var orderService = getService('orderService');
			
			var orderTemplate = orderService.getOrderTemplate(arguments.data.orderTemplateID);
			
			//shipping method 
			var shippingMethod = arguments.order.getorderFulfillments()[1].getShippingMethod();
			//shipping address
			var shippingAddress = arguments.order.getShippingAddress();
			// shipping account address 
			var shippingAccountAddress = arguments.order.getShippingAccountAddress();
			// account payment method 
			var accountPaymentMethod = arguments.order.getOrderPayments()[1].getAccountPaymentMethod();
			// billing account address 
			var billingAccountAddress = arguments.order.getBillingAccountAddress();
			
			//setting the above on order template and activating
			//NULL check on account address because this is optional in checkout 
			if(!isNull(shippingAccountAddress)) orderTemplate.setShippingAccountAddress(shippingAccountAddress);
			orderTemplate.setShippingAddress(shippingAddress);
			orderTemplate.setShippingMethod(shippingMethod);
			orderTemplate.setBillingAccountAddress(billingAccountAddress);
			orderTemplate.setAccountPaymentMethod(accountPaymentMethod);
			orderTemplate.setOrderTemplateStatusType(getService('typeService').getTypeBySystemCode('otstActive'))
			orderService.saveOrderTemplate(orderTemplate);

		}
		
		
		//snapshot the pricegroups on the order.
		if (!isNull(account) && !isNull(account.getPriceGroups()) && arrayLen(account.getPriceGroups())){
            var firstPriceGroup = account.getPriceGroups()[1];
            order.setPriceGroup(firstPriceGroup);
        }
        
		if( 
			!isNull(account.getAccountStatusType()) 
			&& ListContains('astEnrollmentPending,astGoodStanding', account.getAccountStatusType().getSystemCode() ) 
		) {
			
			if(account.getAccountStatusType().getSystemCode() == 'astEnrollmentPending') {
				
				account.setActiveFlag(true);
				account.setAccountStatusType(getService('typeService').getTypeBySystemCodeOnly('astGoodStanding'));
				account.getAccountNumber();
				
				if( CompareNoCase(account.getAccountType(), 'marketPartner')  == 0  ) {
					//set renewal-date to one-year-from-enrolmentdate
					if(IsNull(account.getEnrollmentDate())) {
						account.setEnrollmentDate(now());
					}
					var renewalDate = DateAdd('yyyy', 1, account.getEnrollmentDate());
					account.setRenewalDate(renewalDate);
				}
				
			} else if ( 
				account.getAccountStatusType().getSystemCode() == 'astGoodStanding' 
				&& CompareNoCase(account.getAccountType(), 'marketPartner')  == 0 
				&& arguments.order.hasMPRenewalFee()
			) {
				
				//set renewal-date to one-year-from-OrderOpenDateTime
				var orderOpenDateTime = ParseDateTime(arguments.order.getOrderOpenDateTime());
				var renewalDate = DateAdd('yyyy', 1, orderOpenDateTime);
				account.setRenewalDate(renewalDate);
			}
			
			getService("accountService").saveAccount(account);
			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = account.getAccountID(),
				baseObject      = 'Account',
				processMethod   = 'push',
				entityQueueData = { 'event' = 'afterAccountSaveSuccess' },
				integrationID   = getService('integrationService').getIntegrationByIntegrationPackage('infotrax').getIntegrationID()
			);
		}
		
		

		//set the commissionPeriod - this is wrapped in a try catch so nothing causes a place order to fail.
		try{
			var commissionDate = dateFormat( now(), "mm/yyyy" );
			order.setCommissionPeriod(commissionDate);
			getService("orderService").saveOrder(order);
		}catch(any dateError){
			logHibachi("afterOrderProcess_placeOrderSuccess failed @ setCommissionPeriod using #commissionDate#");	
		}
	}
}
