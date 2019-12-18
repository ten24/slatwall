component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiEventHandler" {
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
            var accountAuthEntity = getAccountService().getAccountAuthentication(accountAuthentication['accountAuthenticationID']);

            if(!isNull(accountAuthEntity) && 
                len(accountAuthentication['legacyPassword']) > 29 && 
                accountAuthentication['legacyPassword'] == legacyPasswordHashed(arguments.data.password, left(accountAuthentication['legacyPassword'], 29))){

                accountAuthEntity.setPassword(getAccountService().getHashedAndSaltedPassword(arguments.data.password, accountAuthentication['accountAuthenticationID']));
                accountAuthEntity.setLegacyPassword(javacast("null", ""));
                accountAuthEntity = getAccountService().saveAccountAuthentication(accountAuthEntity);
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
		
		//snapshot the pricegroups on the order.
		if ( !isNull(account) && arrayLen(account.getPriceGroups()) ) {
            arguments.order.setPriceGroup(account.getPriceGroups()[1]);
        }
        
        if( account.getAccountType() == 'marketPartner' && arguments.order.hasStarterKit() ) {
			account.setStarterKitPurchasedFlag(true);
        }
      
		if( 
			!isNull(account.getAccountStatusType()) 
			&& ListContains('astEnrollmentPending,astGoodStanding', account.getAccountStatusType().getSystemCode() ) 
		) {
			
			if(account.getAccountStatusType().getSystemCode() == 'astEnrollmentPending') {
				
				account.setActiveFlag(true);
				account.setAccountStatusType(getService('typeService').getTypeBySystemCodeOnly('astGoodStanding'));
				account.getAccountNumber();
				
				if(isNull(account.getEnrollmentDate())) {
					account.setEnrollmentDate(now());
				}
				
				if( CompareNoCase(account.getAccountType(), 'marketPartner')  == 0  ) {
					//set renewal-date to one-year-from-enrolmentdate
					var renewalDate = DateAdd('yyyy', 1, account.getEnrollmentDate());
					account.setRenewalDate(DateAdd('yyyy', 1, account.getEnrollmentDate()));
				}
				
				// Email opt-in when finishing enrollment
				if ( account.getAllowCorporateEmailsFlag() ) {
					try{
						getService('MailchimpAPIService').addMemberToListByAccount( account );
					}catch(any e){
						logHibachi("afterOrderProcess_placeOrderSuccess failed @ addMemberToListByAccount for #account.getAccountID()#");
					}
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
			
			getAccountService().saveAccount(account);
			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = account.getAccountID(),
				baseObject      = 'Account',
				processMethod   = 'push',
				entityQueueData = { 'event' = 'afterAccountSaveSuccess' },
				integrationID   = getService('integrationService').getIntegrationByIntegrationPackage('infotrax').getIntegrationID()
			);
		}
		

		//set the commissionPeriod - this is wrapped in a try catch so nothing causes a place order to fail.
		//set the initial order flag if needed.
		try{
			
			//Commission Date
			var commissionDate = dateFormat( now(), "mm/yyyy" );
			//adding shipping and billing to flexship and activating
			if(!isNull(arguments.data.orderTemplateID)){
				
				var orderTemplate = getOrderService().getOrderTemplate(arguments.data.orderTemplateID);
				var orderFulFillment = arguments.order.getOrderFulfillments()[1];
				
				var shippingMethod = orderFulFillment.getShippingMethod();
				var shippingAddress = orderFulFillment.getShippingAddress();
				var accountPaymentMethod = arguments.order.getOrderPayments()[1].getAccountPaymentMethod();
				var billingAccountAddress = arguments.order.getBillingAccountAddress();
				
				orderTemplate.setShippingAddress(shippingAddress);
				orderTemplate.setShippingMethod(shippingMethod);
				orderTemplate.setBillingAccountAddress(billingAccountAddress);
				orderTemplate.setAccountPaymentMethod(accountPaymentMethod);
				orderTemplate.setOrderTemplateStatusType(getService('typeService').getTypeBySystemCode('otstActive'))
				getOrderService().saveOrderTemplate(orderTemplate);
			}
			arguments.order.setCommissionPeriod(commissionDate);
			
			//Initial Order Flag
			//Set the Initial Order Flag as needed
			var previousOrdersCollection = getOrderService().getOrderCollectionList();
			//Find if they have any previous Sales Orders that are not this one that just purchased.
			previousOrdersCollection.addFilter("account.accountID", arguments.order.getAccount().getAccountID());
			previousOrdersCollection.addFilter("orderType.systemCode", "otSalesOrder");
			previousOrdersCollection.addFilter("orderID", arguments.order.getOrderID(), "!=");
			
			var previousInitialOrderCount = previousOrdersCollection.getRecordsCount();
			
			if (!previousInitialOrderCount){
				//this is the first order for this account
				arguments.order.setInitialOrderFlag(true);
			}
			
			getOrderService().saveOrder(arguments.order);
		}catch(any dateError){
			logHibachi("afterOrderProcess_placeOrderSuccess failed @ setCommissionPeriod using #commissionDate# OR to set initialOrderFlag");	
		}
	}
}
