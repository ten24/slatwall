component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiEventHandler" {
    property name="OrderService";
    property name="AccountService";
    property name="HibachiEventService";

    public any function afterAccountProcess_loginFailure(required any slatwallScope, required any account ,required struct data){
        param name="arguments.data.emailAddressOrUsername" default="";
        param name="arguments.data.emailAddress" default="";
        param name="arguments.data.password" default="";
		
        var accountAuthCollection = arguments.slatwallScope.getService('AccountService').getAccountAuthenticationCollectionList();
        accountAuthCollection.setDisplayProperties("accountAuthenticationID,password,account.accountID,account.primaryEmailAddress.emailAddress,legacyPassword,activeFlag");
        
        if( len(arguments.data.emailAddressOrUsername) && REFind("^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$", arguments.data.emailAddressOrUsername) ){
        	accountAuthCollection.addFilter("account.primaryEmailAddress.emailAddress", arguments.data.emailAddressOrUsername);
        } else if( len(arguments.data.emailAddressOrUsername) ){
        	accountAuthCollection.addFilter("account.username", arguments.data.emailAddressOrUsername);
        } else {
        	accountAuthCollection.addFilter("account.primaryEmailAddress.emailAddress", arguments.data.emailAddress);
        }
        
        accountAuthCollection.addFilter("legacyPassword", "NULL", "IS NOT");
        accountAuthCollection.addFilter("activeFlag", "true");
        var accountAuthentications = accountAuthCollection.getRecords();
		
        for (var accountAuthentication in accountAuthentications) {
            var accountAuthEntity = getAccountService().getAccountAuthentication(accountAuthentication['accountAuthenticationID']);
			
            if( !isNull(accountAuthEntity) && 
                len(accountAuthentication['legacyPassword']) > 29 && 
                accountAuthentication['legacyPassword'] == legacyPasswordHashed(arguments.data.password, left(accountAuthentication['legacyPassword'], 29)) && 
                accountAuthEntity.getAccount().getActiveFlag()
                ){
				
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
    
    public void function afterInfotraxAccountCreateSuccess(any slatwallScope, any entity, any eventData) {

		//Clear the encrypted govt-id-NUMBER 
		if( arguments.entity.getAccountGovernmentIdentificationsCount() ){
			//in current specs, there can be only one govt-ID per account
			arguments.entity.getAccountGovernmentIdentifications()[1]
				.setGovernmentIdentificationNumberEncrypted(javaCast("null", ""));
		}
	}

	public any function afterOrderProcess_placeOrderSuccess(required any slatwallScope, required any order, required any data){

		var account = arguments.order.getAccount();
		arguments.slatwallScope.setSessionValue('currentFlexshipID', '');
	
		// Snapshot the pricegroups on the order.
		if ( !isNull(account) && arrayLen(account.getPriceGroups()) ) {
            arguments.order.setPriceGroup(account.getPriceGroups()[1]);
        }
        
        // Set the Product Pack Purchased Flag
        if( account.getAccountType() == 'marketPartner' && arguments.order.hasProductPack() ) {
			account.setProductPackPurchasedFlag(true);
        }
    	
		// Snapshot the account type to the order. This is placed before the upgrade logic
		// so that we can capture that this account was still another account type at this time.
		// on the users next order, they will be the upgraded type.
		if (!isNull(account)){
			if (!isNull(account.getAccountType())){
				arguments.order.setAccountType(account.getAccountType());
			}else{
				logHibachi("afterOrderProcess_placeOrderSuccess Account Type should NEVER be empty on place order.", true);
			}
		}
	
    	// Set the AccountType and PriceGroup IF this is an upgrade flow.
    	if(arguments.order.getUpgradeFlag() == true){
    		arguments.order.setOrderOrigin(getService('orderService').getOrderOriginByOrderOriginName('Web Upgrades'));
    		if(arguments.order.getMonatOrderType().getTypeCode() == 'motVipEnrollment'){
    			account.setAccountType('VIP');
    			account.setPriceGroups([getService('PriceGroupService').getPriceGroupByPriceGroupCode(3)]);
				
				getHibachiEventService().announceEvent('afterVIPUpgradeSuccess', {'order':arguments.order, 'entity':arguments.order}); 
    		
			}else if(arguments.order.getMonatOrderType().getTypeCode() == 'motMpEnrollment'){
    			account.setAccountType('marketPartner');	
    			account.setPriceGroups([getService('PriceGroupService').getPriceGroupByPriceGroupCode(1)]);
				
				getHibachiEventService().announceEvent('afterMarketPartnerUpgradeSuccess', {'order':arguments.order, 'entity':arguments.order}); 
    		}
			
			getHibachiEventService().announceEvent('afterAccountUpgradeSuccess', {'order':arguments.order, 'entity':arguments.order}); 
			
			if(!isNull(account.getOwnerAccount())){
				getHibachiEventService().announceEvent('afterAccountSponsorUpgradeSuccess', {'account':account.getOwnerAccount(), 'entity':account.getOwnerAccount()}); 
			} 
    	}
    	
    	
		
		// Sets the account status type, activeFlag and accountNumber
		if( 
			!isNull(account.getAccountStatusType()) 
			&& ListContains('astEnrollmentPending,astGoodStanding', account.getAccountStatusType().getSystemCode() ) 
		) {
			
			if(account.getAccountStatusType().getSystemCode() == 'astEnrollmentPending') {
	    		arguments.order.setOrderOrigin(getService('orderService').getOrderOriginByOrderOriginName('Web Enrollment'));
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
				
				//TODO: Move this logic to account save
				// // Email opt-in when finishing enrollment
				// if ( !isNull(account.getAllowCorporateEmailsFlag()) && account.getAllowCorporateEmailsFlag() ) {
				// 	try{
				// 		getService('MailchimpAPIService').addMemberToListByAccount( account );
				// 	}catch(any e){
				// 		logHibachi("afterOrderProcess_placeOrderSuccess failed @ addMemberToListByAccount for #account.getAccountID()#");
				// 	}
				// }
			
				getHibachiEventService().announceEvent('afterAccountEnrollmentSuccess', {'account':account, 'entity':account}); 

				if(!isNull(account.getOwnerAccount())){
					getHibachiEventService().announceEvent('afterAccountSponsorEnrollmentSuccess', {'account':account.getOwnerAccount(), 'entity':account.getOwnerAccount()}); 
				} 
	
			} else if ( 
				account.getAccountStatusType().getSystemCode() == 'astGoodStanding' 
				&& CompareNoCase(account.getAccountType(), 'marketPartner')  == 0 
				&& arguments.order.hasMPRenewalFee()
			) {
				
				//set renewal-date to one year from current renewal date
				var currentRenewalDate = ParseDateTime(arguments.order.getAccount().getRenewalDate());
				var renewalDate = DateAdd('yyyy', 1, currentRenewalDate);
				account.setRenewalDate(renewalDate);
			}else{
    			arguments.order.setOrderOrigin(getService('orderService').getOrderOriginByOrderOriginName('Internet Order'));
			}
			getAccountService().saveAccount(account);
			
			getDAO('HibachiDAO').flushORMSession();

			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = account.getAccountID(),
				baseObject      = 'Account',
				processMethod   = 'push',
				entityQueueData = { 'event' = 'afterAccountSaveSuccess' },
				integrationID   = getService('integrationService').getIntegrationByIntegrationPackage('infotrax').getIntegrationID()
			);
		}
		
		
		//Set the commissionPeriod - this is wrapped in a try catch so nothing causes a place order to fail.
		//Set the initial order flag if needed.
		try{
			
			//Commission Date
			var commissionDate = dateFormat( now(), "mm/yyyy" );
			//adding shipping and billing to flexship and activating
			if(!isNull(arguments.data.orderTemplateID)){
				
				var orderTemplate = getOrderService().getOrderTemplate(arguments.data.orderTemplateID);
				var orderFulFillment = arguments.order.getOrderFulfillments()[1];
				
				//NOTE: there's only one shipping method allowed for flexship
				var shippingMethod = getService('ShippingService').getShippingMethod(
					ListFirst( orderTemplate.setting('orderTemplateEligibleShippingMethods') )
				);
				
				var accountPaymentMethod = arguments.order.getOrderPayments()[1].getAccountPaymentMethod();
				var orderTemplateStatusType = getService('typeService').getTypeBySystemCode('otstActive');
				
				orderTemplate.setShippingMethod(shippingMethod);
				
				if( !IsNull(orderFulFillment.getAccountAddress() ) ){
					orderTemplate.setShippingAccountAddress(orderFulFillment.getAccountAddress() );
				} else {
					
					//If the user chose not to save the address, we'll create a new-accountAddress for flexship, as flexship's frontend UI relies on that; User can always change/remove the address at the frontend
					var newAccountAddress = getAccountService().newAccountAddress();
					newAccountAddress.setAddress( orderFulFillment.getShippingAddress() );
					newAccountAddress.setAccount( arguments.order.getAccount() );
					newAccountAddress.setAccountAddressName( orderFulFillment.getShippingAddress().getName());
					
					orderTemplate.setShippingAccountAddress(newAccountAddress);
				}
				
				orderTemplate.setAccountPaymentMethod(accountPaymentMethod);
				orderTemplate.setOrderTemplateStatusType(orderTemplateStatusType);
				
				if(isNull(orderTemplate.getAccount())){
					orderTemplate.setAccount(arguments.order.getAccount());
				}
				orderTemplate = getOrderService().saveOrderTemplate(orderTemplate,{},'upgradeFlow');
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
		}catch(any dateError){
			logHibachi("afterOrderProcess_placeOrderSuccess failed @ setCommissionPeriod using #commissionDate# OR to set initialOrderFlag #serializeJson(dateError)#");	
		}
		
	}

	/** Any time we place and order from a flexship we want to recalculate all properties at the flexship level.
	  *
      */
	public any function afterOrderTemplateProcess_createAndPlaceOrderSuccess(required any slatwallScope, required any orderTemplate, any data={}){

		getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = arguments.orderTemplate.getOrderTemplateID(),
				baseObject      = 'OrderTemplate',
				processMethod   = 'updateCalculatedProperties',
				entityQueueData = {} //no data needed 
		); 	
	}
	
	public any function afterOrderItemCreateSuccess(required any slatwallScope, required any orderItem, required any data){ 
		// Flush so the item is there when we need it. 
		if (!arguments.orderItem.getOrder().hasErrors()){
			ormFlush();
		}
		
		try{
			this.createOrderItemSkuBundle( arguments.orderItem );
		}catch(bundleError){
			logHibachi("afterOrderItemProcessCreateSuccess failed @ create bundle items for orderitem #orderItem.getOrderItemID()# ");
		}
	}
	
	/**
	 * Adds the calculated bundled order items
	 * For each orderitem, create new orderItemSkuBundles for each sku that is 
	 * a bundle.
	 **/
	 public any function createOrderItemSkuBundle(required any orderItem){
	 	
	 	var bundledSkus = orderItem.getSku().getBundledSkus();
	 	
	 	if (isNull(bundledSkus) || !arrayLen(bundledSkus)){
	 		return;	
	 	}
	 	
 		//create
 		var insertSQL = "INSERT INTO SwOrderItemSkuBundle (orderItemSkuBundleID, createdDateTime, modifiedDateTime, skuID, orderItemID, quantity) VALUES ";
		
		//VALUES (100, 1), (100, 2), (100, 3)
		var valueList = "";
		for (var skuBundle in bundledSkus){ 
			valueList = listAppend(valueList, "('#replace(lcase(createUUID()), '-', '', 'all')#', #now()#, #now()#, '#skuBundle.getBundledSku().getSkuID()#', '#orderItem.getOrderItemID()#', #skuBundle.getBundledQuantity()#)");
		}
		insertSQL = insertSQL & valueList;
		
 		QueryExecute(insertSQL);
	}
}
